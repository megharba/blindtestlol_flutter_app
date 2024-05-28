import 'dart:async';

import 'package:blindtestlol_flutter_app/component/loginPage.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(Mp4Assets.VideoPlayerController)
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
      }
    });
  }

  @override
  void dispose() {
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
                //ag - replace ici
                Image.asset(
                  ImageAssets.Title, // Chemin de ton image unique
                  width: 300, // Ajuste la largeur selon tes besoins
                  height: 75, // Ajuste la hauteur selon tes besoins
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Image.asset(ImageAssets.Soulignement,
                      fit: BoxFit.fitWidth),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
