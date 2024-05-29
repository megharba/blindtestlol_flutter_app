import 'package:blindtestlol_flutter_app/component/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late VideoPlayerController _controller;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/images/Poro_base_AN_idle3.mp4')
          ..initialize().then((_) {
            if (!_isDisposed) {
              setState(() {
                _controller.setVolume(0.0);
                _controller.play();
                _controller.setLooping(true);
              });
            }
          });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.pause();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
      }
    });
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
                      width: _controller.value.size?.width ?? 0,
                      height: _controller.value.size?.height ?? 0,
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
                    Image.asset('assets/images/esgi2.png',
                        width: 80, height: 80),
                    const SizedBox(width: 10),
                    Image.asset('assets/images/logo.png',
                        width: 80, height: 80),
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
                Image.asset('assets/images/decorator-hr-lg.png',
                    fit: BoxFit.fitWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
