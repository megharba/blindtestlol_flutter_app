import 'package:blindtestlol_flutter_app/services/gameServices.dart';
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
        scaffoldBackgroundColor: Color(0xFF1C1B1F),
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
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/Poro_base_AN_idle3.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0.0); // Démarrer en mode muet
        _controller.play();
        _controller.setLooping(true);
        setState(() {}); // Mettre à jour l'UI après l'initialisation
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
                      child: VideoPlayer(_controller), // Votre fond vidéo
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/esgi2.png',
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'BIENVENUE SUR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC89B3C), // Couleur dorée
                  ),
                ),
                Text(
                  'THEME OF LEGENDS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC89B3C), // Couleur dorée
                    fontSize: 20, // Taille de police à 20 pixels
                  ),
                ),
                Image.asset('assets/images/decorator-hr-lg.png', fit: BoxFit.fitWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AccueilPage(),
    ClassementPage(),
    AProposPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/esgi2.png',
              width: 30,
              height: 30,
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                'THEME OF LEGENDS',
                style: TextStyle(
                  color: Color(0xFFC89B3C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
            ),
          ],
        ),
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Classement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'À Propos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final _formKey = GlobalKey<FormState>();
  String playerName = '';
  int roundToPlay = 0;
  final GameService gameService = GameService('http://localhost:8080'); // Initialize the service

  void _startNewGame(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nouvelle partie'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nom du joueur'),
                  onChanged: (value) {
                    setState(() {
                      playerName = value;
                    });
                  },
                  validator: (value) {
                    return value != null && value.isNotEmpty ? null : 'Entrez un nom';
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre de tours'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      roundToPlay = int.tryParse(value) ?? 0;
                    });
                  },
                  validator: (value) {
                    final rounds = int.tryParse(value ?? '');
                    return rounds != null && rounds > 0 ? null : 'Entrez un nombre valide';
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // Call the createGame method from GameService
                    final gameResponse = await gameService.createGame(playerName, roundToPlay);
                    print('Game created with ID: ${gameResponse.gameId}');

                    // Play a round using the created game's ID
                    await gameService.playRound(gameResponse.gameId);

                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error: $e');
                  }
                }
              },
              child: Text('Commencer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Contenu de la page Accueil'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startNewGame(context),
              child: Text('Nouvelle partie'),
            ),
          ],
        ),
      ),
    );
  }
}

class ClassementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Contenu de la page de classement'),
    );
  }
}

class AProposPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Contenu de la page À Propos'),
    );
  }
}
