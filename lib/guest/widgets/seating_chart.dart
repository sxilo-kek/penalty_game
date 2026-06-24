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
        borderRadius: BorderRadius.circular(GuestLayout.chartBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _StageBar(label: 'Main Stage'),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: GuestLayout.chartPadding,
              vertical: GuestLayout.chartSectionPaddingV,
            ),
            child: Column(
              children: [
                for (final row in GuestLayout.seatingGrid)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: GuestLayout.chartRowGap,
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: GuestLayout.entryPaddingH),
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
    final grow = highlighted ? GuestLayout.tableHighlightGrow : 0.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      width: GuestLayout.tableSize + grow,
      height: GuestLayout.tableSize + grow,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: GuestLayout.cocaRed,
        border: highlighted
            ? Border.all(
                color: const Color(0xFFFFD54F),
                width: GuestLayout.tableHighlightBorder,
              )
            : null,
        boxShadow: highlighted
            ? [
                BoxShadow(
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.6),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          color: Colors.white,
          fontSize: highlighted
              ? GuestLayout.tableFontSize + 4
              : GuestLayout.tableFontSize,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
