import 'package:blindtestlol_flutter_app/component/aProposPage.dart';
import 'package:blindtestlol_flutter_app/component/accueilPage.dart';
import 'package:blindtestlol_flutter_app/component/classementPage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      AccueilPage(user: widget.user),
      ClassementPage(),
      AProposPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.zero, // Pas de padding par défaut
        child: Stack(
          children: [
            // Le contenu principal de la page
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ),
            // Le logo en haut à gauche dans le coin de la page
            Positioned(
              top: 0.0, // Aucune marge en haut
              left: -100.0, // Aucune marge à gauche
              child: Image.asset(
                ImageAssets.Title, // Chemin de ton image unique
                width: 450, // Ajuste la largeur selon tes besoins
                height: 110, // Ajuste la hauteur selon tes besoins
              ),
            ),
            // L'image dans un cercle doré en haut à droite
            Positioned(
              top: 10.0, // Marge de 10 pixels en haut
              right: 10.0, // Marge de 10 pixels à droite
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber, // Couleur dorée
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        ImageAssets.ImageLegende1,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8), // Espacement entre l'image et le pseudo
                  Text(
                    widget.user.name, // Utilisation du pseudo de l'utilisateur
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Classement'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'À Propos'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.colorText,
        onTap: _onItemTapped,
      ),
    );
  }
}
