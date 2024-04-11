import 'dart:ui';

import 'package:breakout/flame/brick_breaker.dart';
import 'package:breakout/flame/utils/config.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'ball.dart';
import 'bat.dart';

class Brick extends RectangleComponent
    with HasGameReference<BrickBreaker>, CollisionCallbacks {
  Brick({
    required super.position,
    required Color color,
  }) : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    removeFromParent();

    //レンガを全部壊したらBallとBatも消す
    if (game.world.children.query<Brick>().length == 1) {
      game.playStatus = PlayStatus.won;
      game.world.removeAll(game.world.children.query<Ball>());
      game.world.removeAll(game.world.children.query<Bat>());
    }
  }
}
