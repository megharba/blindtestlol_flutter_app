import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/accueilPage.dart';
import 'package:blindtestlol_flutter_app/component/classementPage.dart';
import 'package:blindtestlol_flutter_app/component/modesDeJeuPage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/component/profil.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  static late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      AccueilPage(user: widget.user),
      ModesDeJeuPage(user: widget.user),
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            Profil(user: widget.user),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
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
              ImageAssets.imageBackground,
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Column(
            children: [
              // Header with logo and profile image
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 4),
                          Image.asset(
                            ImageAssets.imageProfil,
                            width: 0,
                            height: 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.user.name,
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: 'CustomFont1',
                                fontWeight: FontWeight.bold,
                                color: AppColors.colorTextTitle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Row(
                              children: [
                                Text(
                                  'Points: 0',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'CustomFont2',
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Image.asset(
                                  ImageAssets.imageEssenceBleue,
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToProfile,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.colorTextTitle,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            ImageAssets.imageLegende1,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              // Main page content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.colorTextTitle, width: 2),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(ImageAssets.imageAccueil), size: 30),
              label: 'ACCUEIL',
            ),
            BottomNavigationBarItem(
              icon:
                  ImageIcon(AssetImage(ImageAssets.imageModesDejeu), size: 30),
              label: 'MODES DE JEU',
            ),
            BottomNavigationBarItem(
              icon:
                  ImageIcon(AssetImage(ImageAssets.imageClassement), size: 30),
              label: 'CLASSEMENT',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.colorTextTitle,
          onTap: _onItemTapped,
          selectedLabelStyle:
              const TextStyle(fontFamily: 'CustomFont1', fontSize: 14),
          unselectedLabelStyle:
              const TextStyle(fontFamily: 'CustomFont1', fontSize: 14),
          backgroundColor: Colors.black,
          selectedIconTheme: const IconThemeData(size: 40),
          unselectedIconTheme: const IconThemeData(size: 30),
        ),
      ),
    );
  }
}
