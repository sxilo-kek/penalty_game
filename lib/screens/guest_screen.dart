import 'package:flutter/material.dart';

import 'package:penalty_game/asset_paths.dart';
import 'package:penalty_game/guest/guest_layout.dart';
import 'package:penalty_game/guest/guest_repository.dart';
import 'package:penalty_game/guest/widgets/guest_lookup_form.dart';
import 'package:penalty_game/guest/widgets/seating_chart.dart';
import 'package:penalty_game/kiosk_screen_size.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  final GuestRepository _repository = GuestRepository();

  String? _selectedCompany;
  int? _highlightedTable;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await _repository.load();
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  void _onCompanySelected(String company) {
    setState(() {
      _selectedCompany = company;
      _highlightedTable = null;
    });
  }

  void _onCompanyCleared() {
    setState(() {
      _selectedCompany = null;
      _highlightedTable = null;
    });
  }

  void _onNameSelected(String name) {
    final table = _repository.tableFor(_selectedCompany!, name);
    setState(() => _highlightedTable = table);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: KioskScreenSize.width,
        height: KioskScreenSize.height,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Text(
          'Failed to load guests: $_error',
          style: const TextStyle(color: Colors.white, fontSize: 48),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          '${AssetPaths.guestImages}guest_background.png',
          width: KioskScreenSize.width,
          height: KioskScreenSize.height,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: GuestLayout.formTop,
          left: 0,
          right: 0,
          child: Center(
            child: GuestLookupForm(
              repository: _repository,
              selectedCompany: _selectedCompany,
              onCompanySelected: _onCompanySelected,
              onNameSelected: _onNameSelected,
              onCompanyCleared: _onCompanyCleared,
            ),
          ),
        ),
        Positioned(
          top: GuestLayout.chartTop,
          left: 0,
          right: 0,
          child: Center(
            child: SeatingChart(highlightedTable: _highlightedTable),
          ),
        ),
      ],
    );
  }
}
