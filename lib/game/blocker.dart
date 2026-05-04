import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:math';

import 'package:penalty_game/game/penalty_game.dart';

class Blocker extends SpriteComponent with HasGameReference<PenaltyGame>, CollisionCallbacks {
  final double speed;
  int direction;

  Blocker({required Vector2 position, required this.speed})
      : direction = Random().nextBool() ? 1 : -1,
        super(size: Vector2(180, 200), position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('blocker.png');
    add(RectangleHitbox(size: Vector2(180, 150), position: Vector2(0, 50)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    final halfW = size.x / 2;
    position.x += direction * speed * dt;

    if (position.x <= halfW + 5) {
      position.x = halfW + 5;
      direction = 1;
    } else if (position.x >= game.size.x - halfW - 5) {
      position.x = game.size.x - halfW - 5;
      direction = -1;
    }
  }
}
