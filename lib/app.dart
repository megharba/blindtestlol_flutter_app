import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme of Legends',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
    late VideoPlayerController _controller; // Marked as late

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/Poro_base_AN_idle3.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
    
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
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
                      width: _controller.value.size?.width ?? 0,
                      height: _controller.value.size?.height ?? 0,
                      child: VideoPlayer(_controller), // Your video background
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 3),
                Image.asset('assets/images/logo.png', width: 116, height: 110),
                SizedBox(height: 100), // Adjust space as needed
                Text(
                  'BIENVENUE SUR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC89B3C), // Golden color
                  ),
                ),
                Text(
                  'THEME OF LEGENDS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC89B3C), // Golden color
                  ),
                ),
                Image.asset('assets/images/decorator-hr-lg.png', fit: BoxFit.fitWidth),
                Spacer(flex: 2),
                // Removed the CircularProgressIndicator since the video is used as a loader
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset('assets/images/top_section.png', fit: BoxFit.fitWidth),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      // Navigate to the game or next screen
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.blue, // Adjust color to match your design
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'JOUER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/footer_artwork.png', fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
