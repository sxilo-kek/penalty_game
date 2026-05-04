import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class GoalArea extends RectangleComponent {
  GoalArea(Vector2 position)
      : super(
          size: Vector2(1500, 60),
          position: position,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
