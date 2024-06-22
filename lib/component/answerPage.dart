import 'dart:convert';
import 'dart:math';

import 'package:blindtestlol_flutter_app/component/gameOverScreen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/responsePage.dart';
import 'package:flutter/services.dart';

class AnswerPhasePage extends StatefulWidget {
  final User user;
  final String gameId;
  final int totalRounds;
  final int currentRound;
  final String initialMusicId;
  final String initialMusicName;
  final String initialMusicType;
  final String initialMusicDate;

  const AnswerPhasePage({
    Key? key,
    required this.user,
    required this.gameId,
    required this.totalRounds,
    required this.currentRound,
    required this.initialMusicId,
    required this.initialMusicName,
    required this.initialMusicType,
    required this.initialMusicDate,
  }) : super(key: key);

  @override
  _AnswerPhasePageState createState() => _AnswerPhasePageState();
}

class _AnswerPhasePageState extends State<AnswerPhasePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final GameService gameService = GameService('http://localhost:8080');
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _propositionController =
      TextEditingController(text: "NOM DE LA MUSIQUE");
  final TextEditingController _typeController =
      TextEditingController(text: "TYPE DE LA MUSIQUE");
  final TextEditingController _dateController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;
  int currentRound = 1;
  int currentScore = 0;
  int currentCombo = 0;
  late String _randomImagePath = 'assets/images/gif/sticker_1.gif';
  bool showRoundCountdown = false;

  String? correctedName;
  String? correctedType;
  String? correctedDate;
  String? previousMusicId;
  String? previousMusicType;
  String? previousMusicDate;
  String? previousCorrectedName;
  String? previousMusicToken;

  @override
  void initState() {
    super.initState();
    _initRandomImagePath();

    currentRound = widget.currentRound;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(
      begin: widget.totalRounds > 0 ? currentRound / widget.totalRounds : 0,
      end: widget.totalRounds > 0 ? currentRound / widget.totalRounds : 0,
    ).animate(_animationController);
    _propositionController.text = "NOM DE LA MUSIQUE";
    _typeController.text = "TYPE DE LA MUSIQUE";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showInitialCountdownAndPlayMusic(widget.initialMusicId);
      }
    });
  }

  Future<void> _initRandomImagePath() async {
    final List<String> gifPaths = await _loadGifPaths();
    if (gifPaths.isNotEmpty) {
      final randomImagePath = gifPaths[Random().nextInt(gifPaths.length)];
      setState(() {
        _randomImagePath = randomImagePath;
      });
    } else {
      setState(() {
        _randomImagePath = 'assets/images/gif/sticker_1.gif';
      });
    }
  }

  Future<List<String>> _loadGifPaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    return manifestMap.keys
        .where((String key) => key.contains('assets/images/gif/'))
        .toList();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _animationController.dispose();
    _propositionController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showInitialCountdownAndPlayMusic(String musicId) {
    setState(() {
      showRoundCountdown = true;
    });
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
              _audioPlayer.play(AssetSource('song/$musicId.mp3'));
              _startRoundCountdown();
            },
          ),
        );
      },
    );
  }

  void _showNextCountdownAndPlayMusic(String musicId, int score, int combo) {
    setState(() {
      currentScore = score;
      currentCombo = combo;
      showRoundCountdown = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ScoreComboCountdownWidget(
            seconds: 5,
            onComplete: () {
              Navigator.of(context).pop();
              _audioPlayer.play(AssetSource('song/$musicId.mp3'));
              _startRoundCountdown();
            },
          ),
        );
      },
    );
  }

  void _startRoundCountdown() {
    setState(() {
      showRoundCountdown = true;
    });
  }

  Future<void> _submitResponse() async {
    if (!_formKey.currentState!.validate()) return;

    await _audioPlayer.stop();

    try {
      final GameResponse apiResponse = await gameService.postPlayerResponse(
        gameId: widget.gameId,
        musicToken: widget.initialMusicId,
        proposition: _propositionController.text,
        type: _typeController.text,
        date: _dateController.text,
      );

      final String userProposition = _propositionController.text;

      _propositionController.clear();
      _typeController.clear();
      _dateController.clear();

      // Fetch the corrected response immediately after submitting the player's response
      final playRoundResponse = await gameService.playRound(widget.gameId);

      setState(() {
        currentRound = apiResponse.round;
        currentScore = apiResponse.player.score;
        currentCombo = apiResponse.player.combo;
        _animation = Tween<double>(
          begin: _animation.value,
          end: widget.totalRounds > 0 ? currentRound / widget.totalRounds : 0,
        ).animate(_animationController);
        _animationController.forward(from: 0.0);
        showRoundCountdown = false;

        // Set corrected values from the previous playRoundResponse
        previousMusicType = apiResponse.musicPlayed[currentRound - 1].type;
        previousMusicDate = apiResponse.musicPlayed[currentRound - 1].date;
        previousCorrectedName = apiResponse.musicPlayed[currentRound - 1].name;
        previousMusicToken = apiResponse.musicPlayed[currentRound - 1].token;

        // Update the current music info for the next round
        correctedName = playRoundResponse?.name;
        correctedType = playRoundResponse?.type;
        correctedDate = playRoundResponse?.date;

        // Mettre à jour _randomImagePath pour le nouveau round
        _initRandomImagePath();
      });

      if (apiResponse.over) {
        // Afficher la ResponsePage pour le dernier round avant de naviguer vers GameOverScreen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResponsePage(
              user: widget.user,
              score: apiResponse.player.score,
              combo: apiResponse.player.combo,
              musicToken: previousMusicToken!,
              musicType: previousMusicType!,
              musicDate: previousMusicDate!,
              userProposition: userProposition,
              correctedName: previousCorrectedName!,
              onNextRound: () async {
                // Attendez une courte durée avant de naviguer vers GameOverScreen
                await Future.delayed(Duration(milliseconds: 300));
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GameOverScreen(
                      score: apiResponse.player.score,
                      combo: apiResponse.player.combo,
                      mastery: apiResponse.player.mastery,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResponsePage(
              user: widget.user,
              score: apiResponse.player.score,
              combo: apiResponse.player.combo,
              musicToken: previousMusicToken!,
              musicType: previousMusicType!,
              musicDate: previousMusicDate!,
              userProposition: userProposition,
              correctedName: previousCorrectedName!,
              onNextRound: () async {
                Navigator.of(context).pop();
                await Future.delayed(Duration(milliseconds: 300));
                if (playRoundResponse != null) {
                  _showNextCountdownAndPlayMusic(playRoundResponse.token,
                      apiResponse.player.score, apiResponse.player.combo);
                }
                // Mettre à jour _randomImagePath pour le nouveau round
                _initRandomImagePath();
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onCountdownComplete() {
    _submitResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.colorNoirHextech,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _audioPlayer.stop();
            Navigator.of(context).pop();
          },
        ),
        title: Image.asset(
          ImageAssets.title,
          width: 150,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: showRoundCountdown
                ? CountdownWidget(
                    seconds: 60,
                    onComplete: _onCountdownComplete,
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.colorNoirHextech,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizedBox(
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
              'Manche $currentRound sur ${widget.totalRounds}',
              style: const TextStyle(
                color: AppColors.colorText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Image.asset(
                      _randomImagePath,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
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
                        style: const TextStyle(color: AppColors.colorText),
                        decoration: InputDecoration(
                          labelText: 'Quel est le nom de cette musique',
                          labelStyle:
                              TextStyle(color: AppColors.colorTextTitle),
                          hintText: 'NOM DE LA MUSIQUE',
                          hintStyle: TextStyle(
                              color: AppColors.colorTextTitle.withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.colorTextTitle),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.colorTextTitle),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Ce champ est requis' : null,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _typeController.text.isNotEmpty
                            ? _typeController.text
                            : null,
                        items: [
                          DropdownMenuItem<String>(
                            value: "TYPE DE LA MUSIQUE",
                            child: Text("TYPE DE LA MUSIQUE"),
                          ),
                          DropdownMenuItem<String>(
                            value: "SKIN",
                            child: Text("SKIN"),
                          ),
                          DropdownMenuItem<String>(
                            value: "EVENT",
                            child: Text("EVENT"),
                          ),
                          DropdownMenuItem<String>(
                            value: "CHAMPION",
                            child: Text("CHAMPION"),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _typeController.text = newValue!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Quel est le type de cette musique ?',
                          labelStyle:
                              TextStyle(color: AppColors.colorTextTitle),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.colorTextTitle),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.colorTextTitle),
                          ),
                        ),
                        validator: (value) =>
                            value == null ? 'Ce champ est requis' : null,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        value: _dateController.text.isNotEmpty
                            ? int.tryParse(_dateController.text)
                            : null,
                        items: [
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text("DATE DE LA MUSIQUE"),
                          ),
                          ...List.generate(14, (index) => 2010 + index)
                              .map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ],
                        onChanged: (int? newValue) {
                          setState(() {
                            _dateController.text = newValue.toString();
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Quand est sortie cette musique ?',
                          labelStyle:
                              TextStyle(color: AppColors.colorTextTitle),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.colorTextTitle),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.colorTextTitle),
                          ),
                        ),
                        validator: (value) =>
                            value == null ? 'Ce champ est requis' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitResponse,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.colorNoirHextech,
                          backgroundColor: AppColors.colorTextTitle,
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
