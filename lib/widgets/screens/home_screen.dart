import 'package:breakout/flame/brick_breaker.dart';
import 'package:breakout/flame/utils/config.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FittedBox(
          child: SizedBox(
            width: gameWidth,
            height: gameHeight,
            child: GameWidget.controlled(
              gameFactory: BrickBreaker.new,
              overlayBuilderMap: {
                PlayStatus.welcome.name: (context, game) =>
                    _createWelcomeOverlay(context),
                PlayStatus.gameOver.name: (context, game) =>
                    _createGameOverOverlay(context),
                PlayStatus.won.name: (context, game) =>
                    _createWonOverlay(context),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _createWelcomeOverlay(BuildContext context) {
    return Center(
      child: Text(
        "TAP TO PLAY",
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  Widget _createGameOverOverlay(BuildContext context) {
    return Center(
      child: Text(
        "G A M E  O V E R",
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  Widget _createWonOverlay(BuildContext context) {
    return Center(
      child: Text(
        "YOU WON",
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
