// ignore_for_file: empty_catches

import 'dart:convert';
import 'package:blindtestlol_flutter_app/component/gameOverScreen.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

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
  final TextEditingController _typeController =
      TextEditingController(text: "TYPE DE LA MUSIQUE");
  final TextEditingController _dateController = TextEditingController();

  String? nextMusicId;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int currentRound = 1; // Initialisé à 1 comme prévu
  late String _randomImagePath = 'assets/images/gif/sticker_1.gif';

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
      begin: currentRound / widget.totalRounds, // Initialisé à 1
      end: currentRound / widget.totalRounds,
    ).animate(_animationController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AudioManager.instance.playMusic(widget.initialMusicId);
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
        } else {}
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
    } catch (e) {}
  }

  void _onCountdownComplete() {
    // Commencer le round suivant ici
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
            AudioManager.instance.stopMusic();
            Navigator.of(context).pop();
          },
        ),
        title: Image.asset(
          ImageAssets.title, // Chemin de votre image
          width: 150, // Ajustez la largeur selon vos besoins
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CountdownTimer(
              duration: 25,
              onComplete: _onCountdownComplete,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.colorNoirHextech,
        child: Column(
          children: [
            // Barre de progression animée pour les rounds
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
                  // Image circulaire
                  Container(
                    margin: const EdgeInsets.only(
                        top: 50), // Décalage de 50 par rapport au haut
                    width: 300, // Taille de l'image circulaire
                    height: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors
                          .transparent, // Couleur de fond de l'image circulaire
                    ),
                    child: Image.asset(
                      _randomImagePath,
                      width: 250, // Taille de l'image circulaire
                      height: 250,
                      fit: BoxFit
                          .cover, // Ajuster la taille de l'image pour couvrir la zone donnée
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
                        style: const TextStyle(color: AppColors.colorTextTitle),
                        decoration: InputDecoration(
                          labelText: 'Proposition',
                          labelStyle:
                              TextStyle(color: AppColors.colorTextTitle),
                          hintText:
                              'NOM DE LA MUSIQUE', // Placeholder pour la proposition
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
                        validator: (value) => value!.isEmpty ? '' : null,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _typeController.text.isNotEmpty
                            ? _typeController.text
                            : null,
                        items: [
                          "TYPE DE LA MUSIQUE", "SKIN", "EVENT",
                          "CHAMPION",
                          // Ajoutez des options factices ici si nécessaire
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _typeController.text = newValue!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Type de la musique',
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
                        validator: (value) => value == null ? '' : null,
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
                            _dateController.text =
                                newValue.toString(); // Conversion en string
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Date',
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
                        validator: (value) => value == null ? '' : null,
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
