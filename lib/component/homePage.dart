import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/accueilPage.dart';
import 'package:blindtestlol_flutter_app/component/classementPage.dart';
import 'package:blindtestlol_flutter_app/component/modesDeJeuPage.dart';
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
      ModesDeJeuPage(),
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
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Column(
            children: [
              // Header with logo and profile image (imagelegende1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text column (username and points)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User's name
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.user.name,
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: 'CustomFont1',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Points count
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Text(
                              'Nombre de points: 0',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'CustomFont2',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Profile image (imagelegende1)
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
                    SizedBox(width: 8), // Adding space on the right
                  ],
                ),
              ),
              // Main page content
              Expanded(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(ImageAssets.ImageAccueil), size: 50),
            label: 'ACCUEIL',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(ImageAssets.ImageModesdejeu), size: 50),
            label: 'MODES DE JEU',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(ImageAssets.ImageClassement), size: 50),
            label: 'CLASSEMENT',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.colorTextTitle,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(fontFamily: 'CustomFont1', fontSize: 16),
        unselectedLabelStyle:
            TextStyle(fontFamily: 'CustomFont1', fontSize: 16),
      ),
    );
  }
}
