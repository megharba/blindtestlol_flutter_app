import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';

class GameService {
  String baseUrl ="http://localhost:8080/";

  GameService(this.baseUrl);

  Future<GameResponse> createGame(String playerName, int roundToPlay) async {
    final url = Uri.parse('$baseUrl/game/create');
    final Map<String, dynamic> requestBody = {
      'playerName': playerName,
      'roundToPlay': roundToPlay,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create game: ${response.statusCode}');
    }

    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    final GameResponse gameResponse = GameResponse.fromJson(responseBody);

    return gameResponse;
  }

  Future<void> postPlayerResponse(String gameId, PlayerResponse playerResponse) async {
    final url = Uri.parse('$baseUrl/game/player-response?gameId=$gameId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(playerResponse.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to post player response: ${response.statusCode}');
    }

    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    final GameResponse gameResponse = GameResponse.fromJson(responseBody);
    handleServerResponse(gameResponse);
  }

  Future<void> playRound(String gameId) async {
    final url = Uri.parse('$baseUrl/game/play-round?gameId=$gameId');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to play round: ${response.statusCode}');
    }

    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    final Music musicResponse = Music.fromJson(responseBody);
    handleMusicResponse(musicResponse);
  }

  Future<void> deleteGame(String gameId) async {
    final url = Uri.parse('$baseUrl/game?gameId=$gameId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete game: ${response.statusCode}');
    }

    print('Game with ID $gameId deleted successfully.');
  }

  void handleServerResponse(GameResponse gameResponse) {
    print('Received server response:');
    print('Game ID: ${gameResponse.gameId}');
    print('Player: ${gameResponse.player.name}, Score: ${gameResponse.player.score}');
    print('Round to play: ${gameResponse.roundToPlay}');
    print('Round: ${gameResponse.round}');
    print('Music played: ${gameResponse.musicPlayed}');
    print('Over: ${gameResponse.over}');
  }

  void handleMusicResponse(Music musicResponse) {
    print('Received server response:');
    print('Music ID: ${musicResponse.id}');
    print('Name: ${musicResponse.name}');
    print('Music date: ${musicResponse.date}');
    print('Music Type: ${musicResponse.type}');
    print('Music aliases: ${musicResponse.aliases}');
  }
}
