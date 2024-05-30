import 'dart:async';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/homePage.dart'; // Importez la page d'accueil
import 'package:blindtestlol_flutter_app/models/models.dart';

class ModesDeJeuPage extends StatefulWidget {
  final User user;

  ModesDeJeuPage({required this.user});

  @override
  _ModesDeJeuPageState createState() => _ModesDeJeuPageState();
}

class _ModesDeJeuPageState extends State<ModesDeJeuPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Les chemins des images des modes de jeu
  static const String Jeu1 = ImageAssets.Jeu1;
  static const String Jeu2 = ImageAssets.Jeu2;
  static const String Jeu3 = ImageAssets.Jeu3;
  static const String Jeu4 = ImageAssets.Jeu4;

  // Les descriptions des modes de jeu
  final List<Map<String, String>> modes = [
    {'image': Jeu1, 'description': 'Faille de l\'invocateur'},
    {'image': Jeu2, 'description': 'Aram'},
    {'image': Jeu3, 'description': 'Teamfight Tactics'},
    {'image': Jeu4, 'description': 'Arena'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modes de Jeu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: AppColors.colorNoirHextech, // Couleur de fond spécifique
          ),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8),
              ...modes.asMap().entries.map((entry) {
                final index = entry.key;
                final mode = entry.value;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(user: widget.user),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            // Animation de survol et ombre portée
                            Transform.scale(
                              scale: _animation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  mode['image']!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                mode['description']!,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index !=
                        modes.length -
                            1) // Ne pas ajouter de séparateur après le dernier élément
                      Container(
                        height: 1,
                        color: AppColors.colorTextTitle,
                      ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
