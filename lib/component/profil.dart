import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';

class Profil extends StatelessWidget {
  final User user;

  Profil({required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Contenu de la page Profil pour ${user.name}'),
    );
  }
}
