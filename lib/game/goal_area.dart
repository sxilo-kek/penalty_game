import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GoalArea extends RectangleComponent {
  GoalArea(Vector2 position)
      : super(
          size: Vector2(1400, 60),
          position: position,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.red.withValues(alpha: 0.5),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
