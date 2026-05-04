import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Full-screen flash effect triggered on goal or save.
class Flash extends Component with HasGameRef {
  Color _color = Colors.transparent;
  double _alpha = 0;

  void trigger(Color color) {
    _color = color;
    _alpha = 1.0;
  }

  @override
  void update(double dt) {
    if (_alpha > 0) _alpha = (_alpha - dt * 3.5).clamp(0.0, 1.0);
  }

  @override
  void render(Canvas canvas) {
    if (_alpha <= 0) return;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      Paint()..color = _color.withValues(alpha: _alpha * 0.45),
    );
  }
}
