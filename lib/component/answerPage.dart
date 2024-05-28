import 'package:blindtestlol_flutter_app/component/gameOverScreen.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';

class AnswerPhasePage extends StatefulWidget {
  final String gameId;
  final int totalRounds;
  final int currentRound;
  final String initialMusicId;

  const AnswerPhasePage({
    Key? key,
    required this.gameId,
    required this.totalRounds,
    required this.currentRound,
    required this.initialMusicId,
  }) : super(key: key);

  @override
  _AnswerPhasePageState createState() => _AnswerPhasePageState();
}

class _AnswerPhasePageState extends State<AnswerPhasePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final GameService gameService = GameService('http://localhost:8080');
  final TextEditingController _propositionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? nextMusicId;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int currentRound = 1; // Initialisé à 1 comme prévu

  @override
  void initState() {
    super.initState();
    currentRound = widget.currentRound;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(
      begin: currentRound / widget.totalRounds, // Initialisé à 1
      end: currentRound / widget.totalRounds,
    ).animate(_animationController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showCountdownAndPlayMusic(widget.initialMusicId);
      }
    });
  }

  @override
  void dispose() {
    AudioManager.instance.stopMusic();
    _animationController.dispose();
    _propositionController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showCountdownAndPlayMusic(String musicId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: CountdownWidget(
            seconds: 5,
            onComplete: () {
              Navigator.of(context).pop();
              AudioManager.instance.playMusic(musicId);
            },
          ),
        );
      },
    );
  }

  void _submitResponse() async {
    if (!_formKey.currentState!.validate()) return;

    await AudioManager.instance
        .stopMusic(); // Stop current music before submitting

    try {
      final GameResponse apiResponse = await gameService.postPlayerResponse(
        gameId: widget.gameId,
        musicToken: widget.initialMusicId,
        proposition: _propositionController.text,
        type: _typeController.text,
        date: _dateController
            .text, // Ensure date is not null and is correctly formatted
      );

      _propositionController.clear();
      _typeController.clear();
      _dateController.clear();

      setState(() {
        currentRound = apiResponse.round + 1; // Mettre à jour le round actuel
        _animation = Tween<double>(
          begin: _animation.value,
          end: currentRound / widget.totalRounds,
        ).animate(_animationController);
        _animationController.forward(from: 0.0);
      });

      if (!apiResponse.over) {
        nextMusicId = await gameService.playRound(widget.gameId);
        if (nextMusicId != null) {
          _showCountdownAndPlayMusic(nextMusicId!);
        } else {
          print("Received null for the next music ID");
        }
      } else {
        // Handle game end scenario by navigating to GameOverScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameOverScreen(
              score: apiResponse.player.score,
              combo: apiResponse.player.combo,
              mastery: apiResponse.player.mastery,
            ),
          ),
        );
      }
    } catch (e) {
      print('Failed to submit response: $e');
    }
  }

  void _onCountdownComplete() {
    // Commencer le round suivant ici
    _submitResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Answer Phase',
          style: TextStyle(color: AppColors.colorText), // Couleur du texte
        ),
        backgroundColor: AppColors.colorBackground,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.colorBackground,
        child: Column(
          children: [
            // Barre de progression animée pour les rounds
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  height: 10,
                  child: LinearProgressIndicator(
                    value: _animation.value,
                    backgroundColor: Colors.grey[800],
                    color: AppColors.colorText,
                    minHeight: 10,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Round $currentRound of ${widget.totalRounds}',
              style: TextStyle(
                color: AppColors.colorText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: CountdownTimer(
                  duration: 30, // Durée totale du round en secondes
                  onComplete: _onCountdownComplete,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _propositionController,
                        style: TextStyle(color: AppColors.colorText),
                        decoration: InputDecoration(
                          labelText: 'Proposition',
                          labelStyle: TextStyle(color: AppColors.colorText),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.colorText),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.colorText),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a proposition' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _typeController,
                        style: TextStyle(color: AppColors.colorText),
                        decoration: InputDecoration(
                          labelText: 'Type',
                          labelStyle: TextStyle(color: AppColors.colorText),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.colorText),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.colorText),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a type' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _dateController,
                        style: TextStyle(color: AppColors.colorText),
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(color: AppColors.colorText),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.colorText),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.colorText),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a date' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitResponse,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.colorBackground,
                          backgroundColor: AppColors.colorText,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text('Envoyer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
