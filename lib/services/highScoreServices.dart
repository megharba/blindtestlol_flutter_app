import 'dart:convert';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:http/http.dart' as http;

class HighScoreService {
  Future<List<UserHighScore>> getHighScores(int round) async {
    final response = await http.get(Uri.parse('http://localhost:8080/high-score/list?round=$round'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print('API response: $body');
      return body.map((dynamic item) => UserHighScore.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load high scores');
    }
  }
}