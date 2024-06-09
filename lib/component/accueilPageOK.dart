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
          // Bouton "Boutique" en haut à gauche
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.0,
            left: 16.0,
            child: GestureDetector(
              onTap: () {
                // TODO: Ajoutez la logique de redirection vers la boutique ici
              },
              child: Row(
                children: [
                  Image.asset(
                    ImageAssets.imageEssenceOrange,
                    width: 50.0,
                    height: 50.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'BOUTIQUE',
                    style: TextStyle(
                        color: AppColors.colorText,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                ],
              ),
            ),
          ),
          // Bouton "Jouer" en bas à droite
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ImageButtonPlay(
                onPressed: _startNewGame,
                imageUrl: ImageAssets.imageButtonPlay,
              ),
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
            ],
          ),
          // Image KDA
        ],
      ),
    );
  }
}

class ImageButtonPlay extends StatelessWidget {
  final VoidCallback onPressed;
  final String imageUrl;

  const ImageButtonPlay({
    Key? key,
    required this.onPressed,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        imageUrl,
        width: 250.0,
        height: 250.0,
      ),
    );
  }
}
