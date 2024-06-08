import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/component/answerPage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

class AccueilPage extends StatefulWidget {
  final User user;

  const AccueilPage({Key? key, required this.user}) : super(key: key);

  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final GameService gameService = GameService('http://localhost:8080');
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentGameId;

  void _playMusic(String musicId) {
    final filePath = 'song/$musicId.mp3';
    _audioPlayer.play(AssetSource(filePath));
  }

  void _showCountdownAndPlayMusic(String musicId) {
    // Navigate to AnswerPhasePage directly without showing the dialog
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnswerPhasePage(
          gameId: currentGameId ?? '',
          currentRound: 1, // Assuming always starting from round 1
          totalRounds: 0, // No rounds
          initialMusicId: musicId,
        ),
      ),
    );
  }

  void _startNewGame() async {
    final GameResponse gameResponse =
        await gameService.createGame(widget.user.uid, 0); // No rounds
    currentGameId = gameResponse.gameId;

    final String? initialMusicId = await gameService.playRound(currentGameId!);
    if (initialMusicId != null) {
      _showCountdownAndPlayMusic(initialMusicId);
    } else {
      print('Aucun ID de musique initial reçu.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              ImageAssets.imageBackground,
              fit: BoxFit.cover,
            ),
          ),
          // GIF en haut à droite
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, right: 8.0),
              /*child: SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  ImageAssets.caitlynGif,
                  fit: BoxFit.cover,
                ),
              ),
              */
            ),
          ),
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with logo and profile image
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8.0,
                      left: 8.0,
                      right: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                ),
              ),
              // Main page content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 200.0, top: 8.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _startNewGame,
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(620, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ), // Fond noir
                            foregroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorTextTitle,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: BorderSide(
                                  color: AppColors
                                      .colorTextTitle, // Couleur de la bordure extérieure
                                  width:
                                      1, // Épaisseur de la bordure extérieure
                                ),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Démarrer la partie',
                            style: TextStyle(
                              fontSize: 22,
                            ), // Taille du texte modifiée
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Image KDA
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 300,
              width: 300,
              child: Image.asset(
                ImageAssets.imageKda,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
