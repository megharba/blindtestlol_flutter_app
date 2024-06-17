import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

import 'loginPage.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late VideoPlayerController _controller;
  bool _isDisposed = false;
  bool _navigateToLogin = false; // Variable pour suivre l'état de la navigation

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  void _initializeVideoController() async {
    _controller = VideoPlayerController.asset(Mp4Assets.videoPlayerController);

    try {
      await _controller.initialize();
      if (!_isDisposed) {
        setState(() {
          _controller.setVolume(0.0);
          _controller.play();
          _controller.setLooping(true);
        });
      }

      Timer(const Duration(seconds: 3), () {
        if (mounted && !_navigateToLogin) {
          // Vérifier avant de naviguer
          _controller.pause();
          _controller.dispose(); // Libérer les ressources
          _navigateToLogin = true; // Mettre à jour l'état de la navigation
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      });
    } catch (e) {
      print('Erreur lors de l\'initialisation du contrôleur vidéo: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _controller.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ImageAssets.esgiLogo, width: 80, height: 80),
                    const SizedBox(width: 10),
                    Image.asset(ImageAssets.logo, width: 80, height: 80),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'BIENVENUE SUR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC89B3C),
                  ),
                ),
                const Text(
                  'THEME OF LEGENDS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC89B3C),
                    fontSize: 20,
                  ),
                ),
                Image.asset(ImageAssets.soulignement, fit: BoxFit.fitWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
