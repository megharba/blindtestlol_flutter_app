import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final int combo;
  final String mastery;
  final User user;
  

  const GameOverScreen({
    Key? key,
    required this.score,
    required this.combo,
    required this.mastery,
    required this.user,
  }) : super(key: key);

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
            const SizedBox(height: 20),
            Text('Score: $score', style: Theme.of(context).textTheme.headline6),
            Text('Combo: $combo', style: Theme.of(context).textTheme.headline6),
            Text('Mastery: $mastery', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage(user: user)),
                  (route) => false,
                ); // Retourner à la page d'accueil
              },
              child: Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
