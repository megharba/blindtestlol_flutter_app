import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/musicServices.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blind Test LOL',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.purple,
        ),
        primarySwatch: Colors.blue,
        hintColor: Colors.redAccent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          labelLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Animation
          Positioned.fill(
            child: MyBackgroundAnimation(),
          ),
          // Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/title.png', height: 100),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
final rd = Random();
// ignore: use_key_in_widget_constructors
class MyBackgroundAnimation extends StatefulWidget {
  @override
  State<MyBackgroundAnimation> createState() => _MyBackgroundAnimationState();
  MyBackgroundAnimation({super.key});
}

class _MyBackgroundAnimationState extends State<MyBackgroundAnimation> with TickerProviderStateMixin {
  ui.Image? img;
  late List<Offset> positions; // Liste des positions des notes de musique
  late AnimationController anim;
  late double canvasWidth;
  late double canvasHeight;

  @override
  void initState() {
    super.initState();
    // Initialize canvas dimensions
    canvasWidth = 844;
    canvasHeight = 844;

    // Initialize positions with 10 random positions
    positions = List.generate(
      10,
      (_) => Offset(rd.nextDouble() * canvasWidth, rd.nextDouble() * canvasHeight),
    );

    anim = AnimationController(vsync: this, duration: Duration(seconds:5))
      ..forward()
      ..repeat();

    anim.addListener(() {
      // Calculate new positions with linear movement for each note
      positions = positions.map((position) {
        return Offset(
          (position.dx + 3) % canvasWidth,
          (position.dy + 3) % canvasHeight,
        );
      }).toList();
      setState(() {});
    });

    loadImage();
  }

  @override
  void dispose() {
    // Stop and dispose of the animation
    anim.dispose();
    super.dispose();
  }

  Future<void> loadImage() async {
    final buffer = await rootBundle.loadBuffer('assets/images/notedemusique.png');

    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    ui.Codec codec = await descriptor.instantiateCodec(targetHeight: 100, targetWidth: 100);
    img = (await codec.getNextFrame()).image;
    print('past here ${buffer.length}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: img == null
          ? Center(child: CircularProgressIndicator())
          : CustomPaint(
              painter: _MultiMusicNotesPainter(img!, positions),
              size: Size(canvasWidth, canvasHeight),
            ),
    );
  }
}

class _MultiMusicNotesPainter extends CustomPainter {
  final ui.Image imgData;
  final List<Offset> positions; // Liste des positions des notes de musique

  _MultiMusicNotesPainter(this.imgData, this.positions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [Colors.blue, Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0);

    // Dessine chaque note de musique à sa position respective
    positions.forEach((position) {
      canvas.drawImage(imgData, Offset(position.dx, position.dy), paint);
    });
  }

  @override
  bool shouldRepaint(_MultiMusicNotesPainter oldDelegate) {
    return oldDelegate.positions != positions;
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'Blind Test',
        style: TextStyle(
          // Utilisation d'un dégradé de couleurs pour le texte
          // Vous pouvez définir les couleurs dans le dégradé selon vos besoins
          foreground: Paint()
            ..shader = LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)), // Taille du texte
        ),
      ),),
      body: Stack(
        children: [
          // Background Animation
          Positioned.fill(
            child: MyBackgroundAnimation(key: UniqueKey()),
          ),
          // Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PlayScreen()),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MusicListScreen()),
                    );
                  },
                  icon: const Icon(Icons.library_music),
                  label: const Text('Music List'),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ParametersScreen()),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Screen'),
      ),
      body: const Center(
        child: Text('Play Screen Content'),
      ),
    );
  }
}

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({Key? key}) : super(key: key);

  @override
  State<MusicListScreen> createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  MusicService musicService = MusicService('http://localhost:8080');
  late List<Music> allMusicList;
  late List<Music> displayedMusicList;
  int? selectedYear; // L'année sélectionnée par l'utilisateur
  late AudioPlayer audioPlayer;
  late bool isPlaying;
  late int? selectedIndex;

  @override
  void initState() {
    super.initState();
    allMusicList = [];
    displayedMusicList = [];
    isPlaying = false;
    selectedIndex = null;
    audioPlayer = AudioPlayer();
    fetchMusicList();
  }

  Future<void> fetchMusicList() async {
    try {
      List<Music> musicList = await musicService.getMusicList();
      
      setState(() {
        allMusicList = musicList;
        displayedMusicList = musicList;
      });
    } catch (e) {
      print('Erreur lors de la récupération de la liste de musique: $e');
    }
  }

  void filterMusicList(String query) {
    setState(() {
      displayedMusicList = allMusicList
          .where((music) =>
              music.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void filterByYear(int? year) {
    setState(() {
      selectedYear = year;
      if (year != null) {
        displayedMusicList = allMusicList
            .where((music) =>
                int.parse(music.date) == year) // Filtrer par année
            .toList();
      } else {
        displayedMusicList = allMusicList; // Afficher toutes les musiques si aucune année sélectionnée
      }
    });
  }

  // void playMusic(int index) async {
  //   String url = displayedMusicList[index].url;
  //   if (selectedIndex == index && isPlaying) {
  //     int result = await audioPlayer.pause();
  //     if (result == 1) {
  //       setState(() {
  //         isPlaying = false;
  //         selectedIndex = null;
  //       });
  //     }
  //   } else {
  //     int result = await audioPlayer.play(url);
  //     if (result == 1) {
  //       setState(() {
  //         isPlaying = true;
  //         selectedIndex = index;
  //       });
  //     }
  //   }
  // }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music List Screen'),
        actions: [
          IconButton(
            onPressed: () {
              // Afficher un sélecteur d'année
              _showYearFilterDialog(context);
            },
            icon: Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterMusicList(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search music...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedMusicList.length,
              itemBuilder: (context, index) {
                Music music = displayedMusicList[index];
                
                return ListTile(
                  title: Text(music.name),
                  subtitle: Text(music.type),
                  // trailing: IconButton(
                  //   icon: Icon(
                  //     selectedIndex == index && isPlaying
                  //         ? Icons.pause
                  //         : Icons.play_arrow,
                  //   ),
                  //   onPressed: () {
                  //     playMusic(index);
                  //   },
                  // ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showYearFilterDialog(BuildContext context) async {
    int? selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Year'),
          content: DropdownButtonFormField<int>(
            items: _buildYearDropdownItems(),
            hint: Text('Select a year'),
            onChanged: (int? year) {
              Navigator.of(context).pop(year);
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedYear != null) {
      filterByYear(selectedYear);
    }
  }

  List<DropdownMenuItem<int>> _buildYearDropdownItems() {
    Set<int> years = allMusicList
        .map((music) => int.parse(music.date))
        .toSet(); // Obtenir toutes les années uniques

    return years
        .map((year) => DropdownMenuItem<int>(
              value: year,
              child: Text(year.toString()),
            ))
        .toList();
  }
}




class ParametersScreen extends StatelessWidget {
  const ParametersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parameters Screen'),
      ),
      body: const Center(
        child: Text('Parameters Screen Content'),
      ),
    );
  }
}
