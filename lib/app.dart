import 'dart:convert';
import 'dart:async';
import 'package:blindtestlol_flutter_app/services/userServices.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'models/models.dart'; // Ensure this path is correct
import 'services/gameServices.dart'; // Ensure this path is correct

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme of Legends',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF1C1B1F),
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
    _controller =
        VideoPlayerController.asset('assets/images/Poro_base_AN_idle3.mp4')
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Image.asset('assets/images/decorator-hr-lg.png',
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


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1013),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',  // Assurez-vous que ce chemin est correct
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'BIENVENUE SUR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC89B3C),
                  fontSize: 16,
                ),
              ),
              const Text(
                'THEME OF LEGENDS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC89B3C),
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Color(0xFFC89B3C),
                thickness: 1,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      labelText: 'IDENTIFIANT',
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      labelText: 'MOT DE PASSE',
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0E1013),
                        side: BorderSide(color: Color(0xFFC89B3C)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',  // Assurez-vous que ce chemin est correct
                                  height: 50,
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  'CONNEXION',
                                  style: TextStyle(
                                    color: Color(0xFFC89B3C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  'INSCRIPTION',
                  style: TextStyle(color: Color(0xFFC89B3C)),
                ),
              ),
              const SizedBox(height: 1),
              LayoutBuilder(
                builder: (context, constraints) {
                  double imageHeight = constraints.maxWidth * 0.75;  // 50% de la largeur du parent
                  return Image.asset(
                    'assets/images/characters.png',  // Assurez-vous que ce chemin est correct
                    height: imageHeight,
                    width: constraints.maxWidth,  // S'adapte à la largeur du parent
                    fit: BoxFit.contain,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText, required bool obscureText}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Color(0xFFC89B3C)),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFFC89B3C)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC89B3C)),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC89B3C)),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter your $labelText' : null,
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await UserService()
          .connectUser(_nameController.text, _passwordController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(user: user)),
      );
    } catch (e) {
      // Handle errors, possibly show an alert dialog
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1013),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',  // Assurez-vous que ce chemin est correct
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'BIENVENUE SUR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC89B3C),
                  fontSize: 16,
                ),
              ),
              const Text(
                'THEME OF LEGENDS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC89B3C),
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Color(0xFFC89B3C),
                thickness: 1,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      labelText: 'IDENTIFIANT',
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      labelText: 'EMAIL',
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      labelText: 'MOT DE PASSE',
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0E1013),
                        side: BorderSide(color: Color(0xFFC89B3C)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',  // Assurez-vous que ce chemin est correct
                                  height: 50,
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  'INSCRIPTION',
                                  style: TextStyle(
                                    color: Color(0xFFC89B3C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  'CONNEXION',
                  style: TextStyle(color: Color(0xFFC89B3C)),
                ),
              ),
              const SizedBox(height: 1),
              LayoutBuilder(
                builder: (context, constraints) {
                  double imageHeight = constraints.maxWidth * 0.75;  // 75% de la largeur du parent
                  return Image.asset(
                    'assets/images/characters.png',  // Assurez-vous que ce chemin est correct
                    height: imageHeight,
                    width: constraints.maxWidth,  // S'adapte à la largeur du parent
                    fit: BoxFit.contain,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText, required bool obscureText}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Color(0xFFC89B3C)),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFFC89B3C)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC89B3C)),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC89B3C)),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter your $labelText' : null,
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await UserService()
          .createUser(_nameController.text, _passwordController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(user: user)),
      );
    } catch (e) {
      // Handle errors, possibly show an alert dialog
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class HomePage extends StatefulWidget {
  final User user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      AccueilPage(user: widget.user),
      ClassementPage(),
      AProposPage(),
    ];
  }

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Image.asset('assets/images/esgi2.png', width: 50, height: 50), // Chemin de l'image ESGI
                const SizedBox(width: 10),
                Image.asset('assets/images/logo.png', width: 50, height: 50), // Chemin de l'image du logo
                const SizedBox(width: 10),
                Text(
                  'THEME OF LEGENDS',
                  style: TextStyle(
                    color: Color(0xFFC89B3C),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Color(0xFF1C1B1F),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Classement'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'À Propos'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFC89B3C),
        onTap: _onItemTapped,
      ),
    );
  }
}

class ClassementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Contenu de la page de classement'),
    );
  }
}

class AProposPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Contenu de la page À Propos'),
    );
  }
}

// Assume other classes are here. Implement similar changes as described above for each.

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
        color: remainingTime <= 5 ? Colors.red : Colors.white,
      ),
    );
  }
}

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

    await AudioManager.instance.stopMusic(); // Stop current music before submitting

    try {
      final GameResponse apiResponse = await gameService.postPlayerResponse(
        gameId: widget.gameId,
        musicToken: widget.initialMusicId,
        proposition: _propositionController.text,
        type: _typeController.text,
        date: _dateController.text,  // Ensure date is not null and is correctly formatted
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
          style: TextStyle(color: Color(0xFFC89B3C)), // Couleur du texte
        ),
        backgroundColor: Color(0xFF1C1B1F),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF1C1B1F),
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
                    color: Color(0xFFC89B3C),
                    minHeight: 10,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Round $currentRound of ${widget.totalRounds}',
              style: TextStyle(
                color: Colors.white,
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
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Proposition',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFC89B3C)),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a proposition' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _typeController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Type',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? 'Enter a type' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _dateController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? 'Enter a date' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitResponse,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        child: const Text('Submit'),
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
                  color: Colors.amber.withOpacity(1 - _animation.value),
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
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
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

class GameOverScreen extends StatelessWidget {
  final int score;
  final int combo;
  final String mastery;

  GameOverScreen({required this.score, required this.combo, required this.mastery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Over'),
        backgroundColor: Color(0xFF1C1B1F),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Over', style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 20),
            Text('Score: $score', style: Theme.of(context).textTheme.headline6),
            Text('Combo: $combo', style: Theme.of(context).textTheme.headline6),
            Text('Mastery: $mastery', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Retour à l'écran précédent
              },
              child: Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}


class AccueilPage extends StatefulWidget {
  final User user;

  AccueilPage({required this.user});

  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final _formKey = GlobalKey<FormState>();
  int roundToPlay = 5; // Default value
  final GameService gameService = GameService('http://localhost:8080');
  final AudioPlayer _audioPlayer = AudioPlayer();

  String? currentGameId;
  int currentRound = 0;
  int totalRounds = 0;

  void _playMusic(String musicId) {
    final filePath = 'song/$musicId.mp3';
    _audioPlayer.play(AssetSource(filePath));
  }

  void _showCountdownAndPlayMusic(String musicId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Afficher un indicateur de progression au lieu d'un compte à rebours
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(); // Fermer le dialogue après 1 seconde
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AnswerPhasePage(
                gameId: currentGameId ?? '',
                currentRound: currentRound,
                totalRounds: totalRounds,
                initialMusicId: musicId,
              ),
            ),
          );
        });
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Préparation de la phase de réponse..."),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startNewGame() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Game for ${widget.user.name}'),
          content: Form(
            key: _formKey,
            child: DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Number of Rounds',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC89B3C)),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC89B3C)),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              value: roundToPlay,
              items: <int>[5, 10, 15].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  roundToPlay = newValue ?? 5; // Default to 5 if null
                });
              },
              validator: (value) {
                return value != null && value > 0 ? null : 'Please select a valid number of rounds';
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final GameResponse gameResponse =
                      await gameService.createGame(widget.user.uid, roundToPlay);
                  currentGameId = gameResponse.gameId;
                  currentRound = 1;
                  totalRounds = roundToPlay;

                  final String? initialMusicId =
                      await gameService.playRound(currentGameId!);
                  Navigator.of(context).pop();
                  if (initialMusicId != null) {
                    _showCountdownAndPlayMusic(initialMusicId);
                  } else {
                    print('No initialMusicId received.');
                  }
                }
              },
              child: Text('Start Game'),
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
            Text('Welcome, ${widget.user.name}!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('This is the home page content specific to you.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNewGame,
              child: const Text('Start New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
