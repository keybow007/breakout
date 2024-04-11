import 'dart:async';

import 'package:breakout/flame/brick_breaker.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayArea extends RectangleComponent with HasGameReference<BrickBreaker> {
  PlayArea()
      : super(
          paint: Paint()..color = Color(0xfff2e8cf),
          children: [
            RectangleHitbox(),
          ],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);



  }
}
