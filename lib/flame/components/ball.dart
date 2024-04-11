import 'package:breakout/flame/brick_breaker.dart';
import 'package:breakout/flame/components/bat.dart';
import 'package:breakout/flame/components/brick.dart';
import 'package:breakout/flame/components/play_area.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  final Vector2 velocity;
  final double difficultyModifier;

  Ball({
    required super.position,
    required double radius,
    required this.velocity,
    required this.difficultyModifier,
  }) : super(
            anchor: Anchor.center,
            radius: radius,
            paint: Paint()
              ..color = Color(0xff1e6091)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]);

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    print("[衝突判定]$intersectionPoints / $other");
    super.onCollisionStart(intersectionPoints, other);
    //衝突相手がPlayAreaであるかどうか（Ball が PlayArea と衝突したかどうか）
    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        //上に衝突した場合
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        //左に衝突した場合
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        //右に衝突した場合
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        //下に衝突した場合
        add(
          RemoveEffect(
            delay: 0.35,
            onComplete: () {
              game.playStatus = PlayStatus.gameOver;
            }
          ),
        );
      }
    } else if (other is Bat) {
      //Batとの衝突判定
      velocity.y = -velocity.y;
      velocity.x =
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {
      //Brickとの衝突判定
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }
      velocity.setFrom(velocity * difficultyModifier);
    }
  }
}
