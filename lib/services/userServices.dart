// ignore: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class UserService {
  final String baseUrl = 'http://localhost:8080/';

  UserService();

  Future<User> createUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(
          '${baseUrl}user/create?name=$name&email=$email&password=$password'),
      headers: <String, String>{
        'accept': 'application/hal+json',
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
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to connect user. Status: ${response.statusCode}');
    }
  }

  Future<User> updatePassword(String userUid, String newPassword) async {
    final response = await http.put(
      Uri.parse(
          '${baseUrl}user/change-password?uid=$userUid&password=$newPassword'),
      headers: <String, String>{
        'accept': 'application/hal+json',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to update password. Status: ${response.statusCode}');
    }
  }

  Future<List<Avatar>> getAllAvatars(String userUid) async {
    final url = Uri.parse(
        '${baseUrl}user/avatars?uid=$userUid'); // Adjust endpoint as per your server

    final response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return List<Avatar>.from(list.map((model) => Avatar.fromJson(model)));
    } else {
      throw Exception('Failed to load avatars. Status: ${response.statusCode}');
    }
  }

  Future<void> buyAvatar(String userUid, int avatarId) async {
    final url =
        Uri.parse('${baseUrl}user/buy-avatar?uid=$userUid&avatar=$avatarId');

    final response = await http.put(url);

    if (response.statusCode == 200) {
      // Successful purchase
      print('Avatar purchased successfully');
    } else {
      // Purchase failed
      throw Exception('Failed to buy avatar. Status: ${response.statusCode}');
    }
  }
}
