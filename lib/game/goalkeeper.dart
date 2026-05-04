import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:penalty_game/game/penalty_game.dart';

class Goalkeeper extends SpriteComponent
    with HasGameReference<PenaltyGame>, CollisionCallbacks {
  double speed = 260;
  int direction = 1;

 Goalkeeper(Vector2 position)
    : super(size: Vector2(320, 250), position: position, anchor: Anchor.center);


 @override
Future<void> onLoad() async {
  await super.onLoad();
  sprite = await Sprite.load('goalkeeper.png');
  add(RectangleHitbox(size: Vector2(310, 180), position: Vector2(5, 70)));
}

  @override
  void update(double dt) {
    super.update(dt);

    final halfW = size.x / 2;
    position.x += direction * speed * dt;

    if (position.x <= halfW + 10) {
      position.x = halfW + 10;
      direction = 1;
    } else if (position.x >= game.size.x - halfW - 10) {
      position.x = game.size.x - halfW - 10;
      direction = -1;
    }

    if (direction < 0 && !isFlippedHorizontally) {
      flipHorizontallyAroundCenter();
    } else if (direction > 0 && isFlippedHorizontally) {
      flipHorizontallyAroundCenter();
    }
  }

  void updateDifficulty(int level) {
    speed = 260 + level * 45.0 + (level >= 5 ? 80 : 0);
  }
}
