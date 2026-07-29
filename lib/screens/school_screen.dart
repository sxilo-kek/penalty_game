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
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 16,
        left: SchoolLayout.pagePadding,
        right: SchoolLayout.pagePadding,
      ),
      decoration: const BoxDecoration(
        color: SchoolLayout.surface,
        boxShadow: [
          BoxShadow(
            color: SchoolLayout.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              SchoolLayout.logoPath,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NONA INSTITUTE',
                  style: TextStyle(
                    fontSize: SchoolLayout.headerTitleSize,
                    fontWeight: FontWeight.w800,
                    color: SchoolLayout.primary,
                    letterSpacing: 0.5,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Хэлний сургалтын байгууллагууд',
                  style: TextStyle(
                    fontSize: SchoolLayout.headerSubtitleSize,
                    color: SchoolLayout.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: SchoolLayout.primary),
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
        child: CircularProgressIndicator(color: SchoolLayout.primary),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cols = width >= SchoolLayout.threeColumnBreakpoint
            ? 3
            : width >= SchoolLayout.twoColumnBreakpoint
                ? 2
                : 1;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(SchoolLayout.pagePadding),
          child: _buildGrid(_schools!, cols),
        );
      },
    );
  }

  Widget _buildGrid(List<School> schools, int cols) {
    if (cols == 1) {
      return Column(
        children: [
          for (final school in schools) ...[
            SchoolCard(school: school),
            const SizedBox(height: SchoolLayout.gridGap),
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < schools.length; i += cols) {
      final children = <Widget>[];
      for (var j = 0; j < cols; j++) {
        if (j > 0) children.add(const SizedBox(width: SchoolLayout.gridGap));
        final idx = i + j;
        children.add(
          Expanded(
            child: idx < schools.length
                ? SchoolCard(school: schools[idx])
                : const SizedBox.shrink(),
          ),
        );
      }
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      );
      rows.add(const SizedBox(height: SchoolLayout.gridGap));
    }
    return Column(children: rows);
  }
}
