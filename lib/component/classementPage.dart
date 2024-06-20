import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/highScoreServices.dart';

class ClassementPage extends StatefulWidget {
  const ClassementPage({super.key});

  @override
  _ClassementPageState createState() => _ClassementPageState();
}

class _ClassementPageState extends State<ClassementPage> {
  late Future<List<UserHighScore>> futureHighScores;
  int selectedRound = 5; // Default selected round

  @override
  void initState() {
    super.initState();
    futureHighScores = fetchHighScores(selectedRound);
  }

  Future<List<UserHighScore>> fetchHighScores(int round) async {
    try {
      final highScores = await HighScoreService().getHighScores(round);
      print('Fetched high scores: $highScores');
      return highScores;
    } catch (e) {
      print('Failed to load high scores: $e');
      throw Exception('Failed to load high scores: $e');
    }
  }

  void updateRound(int round) {
    setState(() {
      selectedRound = round;
      futureHighScores = fetchHighScores(selectedRound);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          buildRoundButtons(),
          SizedBox(height: 20),
          Expanded(
            child: buildHighScoreList(),
          ),
        ],
      ),
    );
  }

  Widget buildRoundButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => updateRound(5),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800], // background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text('Tour 5'),
        ),
        ElevatedButton(
          onPressed: () => updateRound(10),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800], // background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text('Tour 10'),
        ),
        ElevatedButton(
          onPressed: () => updateRound(15),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800], // background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text('Tour 15'),
        ),
      ],
    );
  }

  Widget buildHighScoreList() {
    return FutureBuilder<List<UserHighScore>>(
      future: futureHighScores,
      builder: (context, snapshot) {
        print('Snapshot state: ${snapshot.connectionState}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Snapshot error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun classement trouvé'));
        } else {
          final highScores = snapshot.data!;
          print('High scores length: ${highScores.length}');
          return SingleChildScrollView(
            child: Column(
              children: [
                buildPodium(highScores),
                buildHighScoreItems(highScores),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildPodium(List<UserHighScore> highScores) {
    if (highScores.length < 3) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildPodiumSpot(2, highScores[1]),
        buildPodiumSpot(1, highScores[0]),
        buildPodiumSpot(3, highScores[2]),
      ],
    );
  }

  Widget buildPodiumSpot(int place, UserHighScore userHighScore) {
    Color color;
    double height;

    switch (place) {
      case 1:
        color = Color(0xFFFFD700); // Gold color
        height = 120;
        break;
      case 2:
        color = Color(0xFFC0C0C0); // Silver color
        height = 100;
        break;
      case 3:
        color = Color(0xFFCD7F32); // Bronze color
        height = 80;
        break;
      default:
        color = Colors.grey;
        height = 60;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 80,
      height: height,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            place.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            userHighScore.userName,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Score: ${userHighScore.highScore.highScoreValue}',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Maîtrise: ${userHighScore.highScore.mastery}',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildHighScoreItems(List<UserHighScore> highScores) {
    final remainingItems = highScores.length > 3 ? highScores.length - 3 : 0;
    print('Remaining items: $remainingItems');
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: remainingItems,
      itemBuilder: (context, index) {
        final userHighScore = highScores[index + 3];
        print('Rendering high score for: ${userHighScore.userName}');
        return ListTile(
          title: Text(userHighScore.userName),
          subtitle: Text(
            'Score: ${userHighScore.highScore.highScoreValue}, Maîtrise: ${userHighScore.highScore.mastery}',
          ),
        );
      },
    );
  }
}
