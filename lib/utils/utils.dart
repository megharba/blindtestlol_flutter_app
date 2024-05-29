import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color colorBackground = Color.fromARGB(255, 0, 0, 0);
  static const Color colorText = Color(0xFFEAE4D8);
  static const Color colorTextTitle = Color(0xFFC8AA6E);
  static const Color colorTransparent = Colors.transparent;
  static const Color colorNoirHextech = Color(0xFF010A13);
}

class AppText {
  static const String Title = 'THEME OF LEGENDS';
  static const String labelIdentifiant = 'IDENTIFIANT';
  static const String labelInscription = 'INSCRIPTION';
  static const String labelConnexion = 'CONNEXION';
  static const String labelPassword = 'MOT DE PASSE';
  static const String labelEmail = 'EMAIL';
  static const String LabelLancer = 'LANCER';
}

class ImageAssets {
  static const String logo = 'assets/images/logo.png';
  static const String sonaGif = 'assets/images/sona.gif';
  static const String esgiLogo = 'assets/images/esgi2.png';
  static const String Soulignement = 'assets/images/decorator-hr-lg.png';
  static const String Title = 'assets/images/title.png';
  static const String ImageLegende1 = 'assets/images/legendes/default.jpeg';
  static const String ImageBackground =
      'assets/images/backgrounds/background.jpg';
  static const String ImageBackgroundHeader =
      'assets/images/backgrounds/header.jpg';
}

class Mp4Assets {
  static const VideoPlayerController = 'assets/images/Poro_base_AN_idle3.mp4';
}

class CountdownWidget extends StatefulWidget {
  final int seconds;
  final VoidCallback onComplete;

  const CountdownWidget({required this.seconds, required this.onComplete});

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  late int currentSecond;

  @override
  void initState() {
    super.initState();
    currentSecond = widget.seconds;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (currentSecond == 0) {
        timer.cancel();
        widget.onComplete();
      } else {
        setState(() {
          currentSecond--;
        });
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) => Container(
                decoration: BoxDecoration(
                  color: AppColors.colorText.withOpacity(1 - _animation.value),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Text(
            '$currentSecond',
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: AppColors.colorText,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: AppColors.colorNoirHextech,
                  offset: Offset(5.0, 5.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onComplete;

  const CountdownTimer({
    Key? key,
    required this.duration,
    required this.onComplete,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        timer.cancel();
        widget.onComplete();
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$remainingTime',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: remainingTime <= 5 ? Colors.red : AppColors.colorText,
      ),
    );
  }
}

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  AudioPlayer? _audioPlayer;

  AudioManager._internal();

  static AudioManager get instance => _instance;

  Future<void> playMusic(String musicId) async {
    // Always stop and dispose of the existing player before creating a new one
    if (_audioPlayer != null) {
      await _stopAndDisposeAudioPlayer();
    }
    _audioPlayer = AudioPlayer();
    final filePath = 'song/$musicId.mp3';
    await _audioPlayer!.play(AssetSource(filePath));
  }

  Future<void> stopMusic() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
    }
  }

  Future<void> _stopAndDisposeAudioPlayer() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      await _audioPlayer!.dispose();
      _audioPlayer = null;
    }
  }
}
