import 'package:flutter/material.dart';

import 'package:penalty_game/guest/guest_layout.dart';

class SeatingChart extends StatelessWidget {
  const SeatingChart({super.key, this.highlightedTable});

  final int? highlightedTable;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GuestLayout.chartWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StageBar(label: 'Main Stage'),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: GuestLayout.chartPadding,
              vertical: 36,
            ),
            child: Column(
              children: [
                for (final row in GuestLayout.seatingGrid)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (final table in row)
                          table == null
                              ? const SizedBox(
                                  width: GuestLayout.tableSize,
                                  height: GuestLayout.tableSize,
                                )
                              : _TableCircle(
                                  number: table,
                                  highlighted: table == highlightedTable,
                                ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const _EntryBar(),
        ],
      ),
    );
  }
}

class _StageBar extends StatelessWidget {
  const _StageBar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: GuestLayout.stageBarHeight,
      color: GuestLayout.stageRed,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: GuestLayout.stageFontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _EntryBar extends StatelessWidget {
  const _EntryBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: GuestLayout.entryBarHeight,
      color: GuestLayout.stageRed,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Entry A',
            style: TextStyle(
              color: Colors.white,
              fontSize: GuestLayout.entryFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Entry B',
            style: TextStyle(
              color: Colors.white,
              fontSize: GuestLayout.entryFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCircle extends StatelessWidget {
  const _TableCircle({
    required this.number,
    required this.highlighted,
  });

  final int number;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      width: highlighted ? GuestLayout.tableSize + 20 : GuestLayout.tableSize,
      height: highlighted ? GuestLayout.tableSize + 20 : GuestLayout.tableSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: GuestLayout.cocaRed,
        border: highlighted ? Border.all(color: const Color(0xFFFFD54F), width: 8) : null,
        boxShadow: highlighted
            ? [
                BoxShadow(
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.6),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          color: Colors.white,
          fontSize: highlighted ? GuestLayout.tableFontSize + 8 : GuestLayout.tableFontSize,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
