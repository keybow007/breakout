import 'dart:async';

import 'package:breakout/flame/components/ball.dart';
import 'package:breakout/flame/components/bat.dart';
import 'package:breakout/flame/components/brick.dart';
import 'package:breakout/flame/components/play_area.dart';
import 'package:breakout/flame/utils/config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PlayStatus { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;

  double get height => size.y;

  final rand = Random();

  late PlayStatus _playStatus;

  PlayStatus get playStatus => _playStatus;

  set playStatus(PlayStatus playStatus) {
    _playStatus = playStatus;
    switch (playStatus) {
      case PlayStatus.welcome:
      case PlayStatus.gameOver:
      case PlayStatus.won:
        overlays.add(playStatus.name);

      case PlayStatus.playing:
        overlays.remove(PlayStatus.welcome.name);
        overlays.remove(PlayStatus.gameOver.name);
        overlays.remove(PlayStatus.won.name);
    }
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    /*
    * TODO Camera#viewFinder.anchorは画面上の原点座標をどこにするかを決めるものだった！！
    *   ○ : PlayArea#anchor = center / camera.viewFinder.anchor = center
    *   ○ : PlayArea#anchor = topLeft / camera.viewFinder.anchor = topLeft
    *   => PlayAreaを画面全体に表示したいのであれば、PlayAreaのanchorとcamera.viewFinderのanchorを同じにする必要あり！
    * */
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());

    playStatus = PlayStatus.welcome;
  }

  void startGame() {
    if (_playStatus == PlayStatus.playing) return;
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playStatus = PlayStatus.playing;

    world.add(
      Ball(
        position: size / 2,
        radius: ballRadius,
        velocity: _createBallVelocity(),
        difficultyModifier: difficultyModifier,
      ),
    );

    world.add(
      Bat(
        cornerRadius: Radius.circular(ballRadius / 2),
        size: Vector2(batWidth, batHeight),
        position: Vector2(width / 2, height * 0.95),
      ),
    );

    addBricks();

    debugMode = true;
  }

  void addBricks() {
    var bricks = <Brick>[];
    for (int i = 0; i < brickColors.length; i++) {
      for (int j = 1; j <= 5; j++) {
        bricks.add(Brick(
          color: brickColors[i],
          position: Vector2((i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter),
        ));
      }
    }
    world.addAll(bricks);
  }

  Vector2 _createBallVelocity() {
    final x = (rand.nextDouble() - 0.5) * width;
    final y = height * 0.2;
    final tempVelocity = Vector2(x, y).normalized();
    return tempVelocity..scale(height / 4);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() {
    return Color(0xfff2e8cf);
  }
}
