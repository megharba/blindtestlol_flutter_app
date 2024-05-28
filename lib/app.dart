import 'dart:convert';
import 'dart:async';
import 'package:blindtestlol_flutter_app/component/answerPage.dart';
import 'package:blindtestlol_flutter_app/component/loadingPage.dart';
import 'package:blindtestlol_flutter_app/component/loginPage.dart';
import 'package:blindtestlol_flutter_app/services/userServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
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
      title: AppText.Title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: AppColors.colorBackground,
      ),
      home: LoadingPage(),
    );
  }
}



