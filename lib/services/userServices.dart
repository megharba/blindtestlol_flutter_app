import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class UserService {
  final String baseUrl = 'http://localhost:8080/';

  UserService();

  Future<User> createUser(String name, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}user/create?name=$name&password=$password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> connectUser(String name, String password) async {
    final url =
        Uri.parse('${baseUrl}user/connect?name=$name&password=$password');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to connect user. Status: ${response.statusCode}');
    }
  }
}
