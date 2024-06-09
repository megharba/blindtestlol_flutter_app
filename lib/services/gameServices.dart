// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart'; // Ensure this import path is correct

class GameService {
  String baseUrl = "http://localhost:8080/";

  GameService(this.baseUrl);

  Future<GameResponse> createGame(String userUid, int roundToPlay) async {
    final url = Uri.parse(
        '$baseUrl/game/create?userUid=$userUid&roundToPlay=$roundToPlay');
    final response =
        await http.post(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Failed to create game: ${response.statusCode}');
    }
    return GameResponse.fromJson(jsonDecode(response.body));
  }

// Method to post player responses
  Future<String?> playRound(String gameId) async {
    final url = Uri.parse('$baseUrl/game/play-round?gameId=$gameId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('token')) {
          // ignore: duplicate_ignore
          // ignore: avoid_print
          print('playRound response: $responseBody'); // Logging the response
          return responseBody['token'] as String?;
        } else {
          print('Token not found in the response body');
          return null;
        }
      } else {
        print('Error playing round with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to play round due to an error: $e');
      return null;
    }
  }

  Future<GameResponse> postPlayerResponse({
    required String gameId,
    required String musicToken,
    required String proposition,
    required String type,
    required String date,
  }) async {
    final url = Uri.parse('$baseUrl/game/player-response?gameId=$gameId');
    final body = jsonEncode({
      'musicToken': musicToken,
      'proposition': proposition,
      'type': type,
      'date': date,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/hal+json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print(
          'postPlayerResponse response: $responseJson'); // Logging the response
      return GameResponse.fromJson(responseJson);
    } else {
      print(
          'Failed to submit player response: ${response.statusCode} - ${response.body}');
      throw Exception(
          'Failed to submit player response: ${response.statusCode} - ${response.body}');
    }
  }
}
