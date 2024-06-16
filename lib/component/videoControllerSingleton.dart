import 'package:video_player/video_player.dart';

class VideoControllerSingleton {
  static final VideoControllerSingleton _singleton =
      VideoControllerSingleton._internal();
  late VideoPlayerController _controller;

  factory VideoControllerSingleton() {
    return _singleton;
  }

  VideoControllerSingleton._internal() {
    _controller =
        VideoPlayerController.asset('assets/musicBackground/heartsteel.mp4');
    _controller.initialize().then((_) {
      _controller.setVolume(1.0);
      _controller.setLooping(true);
      _controller.play();
    });
  }

  VideoPlayerController get controller => _controller;

  void dispose() {
    _controller.dispose();
  }
}
