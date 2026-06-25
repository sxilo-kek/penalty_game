import 'package:flutter/material.dart';

import 'package:penalty_game/kiosk_screen_size.dart';

/// Fixed 2160×3840 design canvas that scales to fit any screen (kiosk TV or mobile).
class KioskCanvas extends StatelessWidget {
  const KioskCanvas({
    super.key,
    required this.child,
    this.backgroundColor = Colors.black,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: KioskScreenSize.width,
                height: KioskScreenSize.height,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
