import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/component/answerPage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

class JouerPage extends StatefulWidget {
  final User user;

  JouerPage({required this.user});

  @override
  _JouerPageState createState() => _JouerPageState();
}

class _JouerPageState extends State<JouerPage> {
  final _formKey = GlobalKey<FormState>();
  int roundToPlay = 5; // Default value
  final GameService gameService = GameService('http://localhost:8080');
  final AudioPlayer _audioPlayer = AudioPlayer();

  String? currentGameId;
  int currentRound = 0;
  int totalRounds = 0;

  void _playMusic(String musicId) {
    final filePath = 'song/$musicId.mp3';
    _audioPlayer.play(AssetSource(filePath));
  }

  void _showCountdownAndPlayMusic(String musicId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Afficher un indicateur de progression au lieu d'un compte à rebours
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(); // Fermer le dialogue après 1 seconde
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AnswerPhasePage(
                gameId: currentGameId ?? '',
                currentRound: currentRound,
                totalRounds: totalRounds,
                initialMusicId: musicId,
              ),
            ),
          );
        });
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Préparation de la phase de réponse..."),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startNewGame() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nouvelle Partie'),
          content: Form(
            key: _formKey,
            child: DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Nombre de manches',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
              ),
              value: roundToPlay,
              items: <int>[5, 10, 15].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  roundToPlay = newValue ?? 5; // Default to 5 if null
                });
              },
              validator: (value) {
                return value != null && value > 0
                    ? null
                    : 'Veuillez sélectionner un nombre de manches valide';
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final GameResponse gameResponse = await gameService
                      .createGame(widget.user.uid, roundToPlay);
                  currentGameId = gameResponse.gameId;
                  currentRound = 1;
                  totalRounds = roundToPlay;

                  final String? initialMusicId =
                      await gameService.playRound(currentGameId!);
                  Navigator.of(context).pop();
                  if (initialMusicId != null) {
                    _showCountdownAndPlayMusic(initialMusicId);
                  } else {
                    print('Aucun ID de musique initial reçu.');
                  }
                }
              },
              child: Text('Lancer la partie'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: _startNewGame,
        child: Image.asset(
          ImageAssets.ImageButtonPlay,
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
