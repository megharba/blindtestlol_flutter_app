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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Image.asset(ImageAssets.esgiLogo,
                    width: 50, height: 50), // Chemin de l'image ESGI
                const SizedBox(width: 10),
                Image.asset(ImageAssets.logo,
                    width: 50, height: 50), // Chemin de l'image du logo
                const SizedBox(width: 10),
                Image.asset(
                  ImageAssets.Title, // Chemin de ton image unique
                  width: 300, // Ajuste la largeur selon tes besoins
                  height: 75, // Ajuste la hauteur selon tes besoins
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.colorBackground,
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
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
