import 'dart:convert';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:http/http.dart' as http;

class HighScoreService {
  static const String baseUrl = 'https://your-api-endpoint.com';

  Future<List<HighScore>> getHighScores(int round) async {
    final response = await http.get(
      Uri.parse('$baseUrl/high-score/list?round=$round'),
      headers: {
        'Accept': 'application/hal+json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<HighScore> highScores =
          body.map((dynamic item) => HighScore.fromJson(item)).toList();
      return highScores;
    } else {
      throw Exception('Failed to load high scores');
    }
  }
}
