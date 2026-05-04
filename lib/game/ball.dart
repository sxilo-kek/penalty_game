import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:penalty_game/game/penalty_game.dart';
import 'package:penalty_game/game/goalkeeper.dart';
import 'package:penalty_game/game/goal_area.dart';
import 'package:penalty_game/game/blocker.dart';

class Ball extends SpriteComponent
    with CollisionCallbacks, HasGameReference<PenaltyGame> {
  Vector2 velocity = Vector2.zero();
  bool isShot = false;
  double shotTimer = 0;
  bool respawning = false;

 Ball(Vector2 position)
    : super(size: Vector2(120, 120), position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('ball.png');
   add(CircleHitbox(radius: 60));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isShot) {
      position += velocity * dt;
      velocity *= 0.992;
      angle += velocity.length * dt * 0.055;
      shotTimer += dt;

      final stopped = shotTimer > 0.4 && velocity.length < 25;
      final offBottom = position.y > game.size.y + 60;
      final offOther =
          position.y < -60 || position.x < -60 || position.x > game.size.x + 60;

      if (!respawning) {
        if (stopped || offBottom) {
          _registerSave();
        } else if (offOther) {
          _respawn();
        }
      }
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (respawning) return;

    if (other is Goalkeeper) {
      velocity.x *= -0.6;
      velocity.y = velocity.y.abs() * 0.8;
      if (velocity.length < 80) _registerSave();
    } else if (other is GoalArea) {
      _registerGoal();
    } else if (other is Blocker) {
      velocity.x *= -1.0;
      velocity.y *= -0.7;
      if (velocity.length < 80) velocity.y = -160;
    }
  }

  void _registerGoal() {
    if (respawning) return;
    game.addScore(1);
    game.flashGoal();
    game.notifyHud();
    _respawn();
  }

  void _registerSave() {
    if (respawning) return;
    respawning = true;
    game.saves++;
    game.flashSave();
    game.notifyHud();
    removeFromParent();
    if (game.saves >= PenaltyGame.maxSaves) {
      game.triggerGameOver();
    } else {
      Future.microtask(() => game.resetBall());
    }
  }

  void _respawn() {
    if (respawning) return;
    respawning = true;
    removeFromParent();
    Future.microtask(() => game.resetBall());
  }
}
