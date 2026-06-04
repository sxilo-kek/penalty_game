import 'package:flutter/material.dart';

import 'package:penalty_game/asset_paths.dart';
import 'package:penalty_game/wheel/models/wheel_prize.dart';
import 'package:penalty_game/wheel/wheel_layout.dart';

class PrizeCard extends StatelessWidget {
  const PrizeCard({
    super.key,
    required this.prize,
    this.width,
    this.height,
  });

  final WheelPrize prize;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = width ?? constraints.maxWidth;
        final h = height ?? constraints.maxHeight;

        return Container(
          width: w.isFinite ? w : null,
          height: h.isFinite ? h : null,
          constraints: BoxConstraints(
            maxWidth: w.isFinite ? w : constraints.maxWidth,
            maxHeight: h.isFinite ? h : constraints.maxHeight,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(WheelLayout.cardBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 36,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          padding: const EdgeInsets.all(WheelLayout.cardPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  '${AssetPaths.wheelImages}${prize.image}',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                prize.title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: WheelLayout.cardTitleFontSize,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
