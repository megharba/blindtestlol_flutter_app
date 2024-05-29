import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final int combo;
  final String mastery;

  GameOverScreen(
      {required this.score, required this.combo, required this.mastery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Over'),
        backgroundColor: AppColors.colorNoirHextech,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Over', style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 20),
            Text('Score: $score', style: Theme.of(context).textTheme.headline6),
            Text('Combo: $combo', style: Theme.of(context).textTheme.headline6),
            Text('Mastery: $mastery',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Retour à l'écran précédent
              },
              child: Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
