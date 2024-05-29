import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/accueilPage.dart';
import 'package:blindtestlol_flutter_app/component/classementPage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/component/profil.dart';

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
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profil(user: widget.user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              ImageAssets.ImageBackground,
              fit: BoxFit.fill,
            ),
          ),
          // Main content
          Column(
            children: [
              // Header avec le logo et l'image de profil (imagelegende1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Image.asset(
                      ImageAssets.logo,
                      width: 119,
                      height: 150,
                    ),
                    SizedBox(width: 8),
                    // Image de profil (imagelegende1)
                    GestureDetector(
                      onTap: _goToProfile,
                      child: Container(
                        width: 119,
                        height: 119,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            ImageAssets.ImageLegende1,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Nom de l'utilisateur
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'CustomFont1',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Contenu principal de la page
              Expanded(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Classement'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.colorTextTitle,
        onTap: _onItemTapped,
      ),
    );
  }
}
