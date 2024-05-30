import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/highScoreServices.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ClassementPage extends StatefulWidget {
  @override
  _ClassementPageState createState() => _ClassementPageState();
}

class _ClassementPageState extends State<ClassementPage> {
  late Future<List<HighScore>> futureHighScores;
  int selectedRound = 5; // Default selected round

  @override
  void initState() {
    super.initState();
    futureHighScores = fetchHighScores(selectedRound);
  }

  Future<List<HighScore>> fetchHighScores(int round) async {
    try {
      return await HighScoreService().getHighScores(round);
    } catch (e) {
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
      appBar: AppBar(
        title: Text('Classement'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'CLASSEMENT',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => updateRound(5),
                child: Text('Tour 5'),
              ),
              ElevatedButton(
                onPressed: () => updateRound(10),
                child: Text('Tour 10'),
              ),
              ElevatedButton(
                onPressed: () => updateRound(15),
                child: Text('Tour 15'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<HighScore>>(
              future: futureHighScores,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun classement trouvé'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final highScore = snapshot.data![index];
                      return ListTile(
                        subtitle: Text(
                            'Score: ${highScore.highScoreValue}, Maîtrise: ${highScore.mastery}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
