import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/userServices.dart';

import '../utils/utils.dart';

class BoutiquePage extends StatefulWidget {
  final User user;
  const BoutiquePage({required this.user});
  @override
  _BoutiquePageState createState() => _BoutiquePageState();
}

class _BoutiquePageState extends State<BoutiquePage> {
  List<String> imagePaths = [];
  List<String> imageNames = []; // List to store image names

  @override
  void initState() {
    super.initState();
    _loadAvatars();
  }

  Future<void> _loadAvatars() async {
    try {
      List<Avatar> fetchedAvatars =
          await UserService().getAllAvatars(widget.user.uid);

      setState(() {
        // Populate imagePaths and imageNames based on fetched avatars
        imagePaths = fetchedAvatars.map((avatar) {
          return 'assets/images/legendes/${avatar.token}.png';
        }).toList();

        imageNames = fetchedAvatars.map((avatar) => avatar.token).toList();
      });

      // Print avatar tokens for verification
      for (var avatar in fetchedAvatars) {
        print('${avatar.token}');
      }
    } catch (e) {
      print('Failed to load avatars: $e');
      // Handle error loading avatars
    }
  }

  Future<void> _handleBuyAvatar(String imageName, int avatarId) async {
    try {
      await UserService().buyAvatar(widget.user.uid, avatarId);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vous avez acheté $imageName avec succès !'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'achat de $imageName : $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boutique'),
        backgroundColor: AppColors.colorNoirHextech,
        foregroundColor: AppColors.colorTextTitle,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
            ),
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return _buildGridItem(context, index, imageNames[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index, String imageName) {
    String imagePath = imagePaths[index];
    int avatarId = index + 1;

    return GestureDetector(
      onTap: () {
        // Handle tap on avatar item
        _handleBuyAvatar(imageName, avatarId);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorNoirHextech,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.colorNoirHextech,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20.0)),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              ImageAssets.imageShop,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '200000',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              ImageAssets.imageEssenceBleue,
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.colorNoirHextech,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20.0)),
              ),
              child: Text(
                imageName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'CustomFont2',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
