import 'package:flutter/material.dart';

import 'package:penalty_game/school/models/school.dart';
import 'package:penalty_game/school/school_layout.dart';
import 'package:penalty_game/school/school_repository.dart';
import 'package:penalty_game/school/widgets/school_card.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  final _repository = SchoolRepository();
  List<School>? _schools;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final schools = await _repository.load();
      if (mounted) setState(() => _schools = schools);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SchoolLayout.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SchoolLayout.headerGradientStart,
            SchoolLayout.headerGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SchoolLayout.pagePadding,
            vertical: 20,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Сургуулиуд',
                    style: TextStyle(
                      fontSize: SchoolLayout.headerTitleSize,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Хэлний сургалтын байгуулллагуудыг харах',
                    style: TextStyle(
                      fontSize: SchoolLayout.headerSubtitleSize,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: SchoolLayout.accent),
            const SizedBox(height: 12),
            Text(
              'Мэдээлэл ачаалахад алдаа гарлаа\n$_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: SchoolLayout.textMuted),
            ),
          ],
        ),
      );
    }

    if (_schools == null) {
      return const Center(
        child: CircularProgressIndicator(color: SchoolLayout.accent),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoCol = constraints.maxWidth >= SchoolLayout.twoColumnBreakpoint;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(SchoolLayout.pagePadding),
          child: twoCol
              ? _buildTwoColumnGrid(_schools!)
              : _buildSingleColumn(_schools!),
        );
      },
    );
  }

  Widget _buildSingleColumn(List<School> schools) {
    return Column(
      children: [
        for (final school in schools) ...[
          SchoolCard(school: school),
          const SizedBox(height: SchoolLayout.gridGap),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTwoColumnGrid(List<School> schools) {
    final rows = <Widget>[];
    for (var i = 0; i < schools.length; i += 2) {
      final left = schools[i];
      final right = i + 1 < schools.length ? schools[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: SchoolCard(school: left)),
              const SizedBox(width: SchoolLayout.gridGap),
              Expanded(
                child: right != null
                    ? SchoolCard(school: right)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
      rows.add(const SizedBox(height: SchoolLayout.gridGap));
    }
    rows.add(const SizedBox(height: 8));
    return Column(children: rows);
  }
}
