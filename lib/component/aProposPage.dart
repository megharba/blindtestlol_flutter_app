import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

import 'background_video.dart';

class AProposPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'À propos de nous',
          style: TextStyle(
            fontFamily: 'CustomFont1',
            color: AppColors.colorTextTitle,
          ),
        ),
        backgroundColor: AppColors.colorNoirHextech,
        foregroundColor: AppColors.colorTextTitle,
      ),
      body: Stack(
        children: [
          // Background video widget with translation
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(350.0, 0.0), // Translate 200 pixels to the right
              child:
                  BackgroundVideo(videoPath: Mp4Assets.imageBackgroundProfil3),
            ),
          ),
          // Content overlay
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  _buildParagraph(
                    'Nous sommes une équipe de passionnés des célèbres jeux de Riot Games. Ce que nous aimons par-dessus tout, c\'est la musique qui accompagne nos aventures à travers ces univers. C\'est pourquoi nous avons décidé de créer cette application unique, qui mettra à l\'épreuve vos connaissances musicales sur les événements, les skins et les champions de League of Legends.',
                  ),
                  SizedBox(height: 16),
                  _buildParagraph(
                    'Que vous soyez un invocateur expérimenté, un aventurier de Runeterra, ou un stratège de Teamfight Tactics, notre application s\'adresse à vous. Plongez dans l\'univers musical de vos jeux favoris et testez vos compétences tout en vous amusant.',
                  ),
                  SizedBox(height: 24),
                  _buildParagraph(
                    'Cliquez sur le jeu correspondant pour en savoir plus sur les univers qui nous ont inspirés:',
                    isTitle: true,
                  ),
                  SizedBox(height: 16),
                  _buildGameLinks(context),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.colorNoirHextech,
    );
  }

  Widget _buildParagraph(String text, {bool isTitle = false}) {
    return Container(
      width: double
          .infinity, // Utiliser une largeur maximale pour le conteneur de texte
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.colorNoirHextech.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: AppColors.colorTextTitle,
          width: 2.0,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isTitle ? 20 : 16,
          fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
          color: Colors.white,
          fontFamily: isTitle ? 'CustomFont1' : 'CustomFont2',
        ),
      ),
    );
  }

  Widget _buildGameLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildGameLink(
          context,
          'League of Legends',
          'https://leagueoflegends.fandom.com/fr/wiki/League_of_Legends',
          AproposAssets.apropos1,
        ),
        SizedBox(height: 16),
        _buildGameLink(
          context,
          'Runeterra',
          'https://leagueoflegends.fandom.com/fr/wiki/Runeterra',
          AproposAssets.apropos2,
        ),
        SizedBox(height: 16),
        _buildGameLink(
          context,
          'Teamfight Tactics',
          'https://leagueoflegends.fandom.com/wiki/Teamfight_Tactics',
          AproposAssets.apropos3,
        ),
        SizedBox(height: 16),
        _buildGameLink(
          context,
          'Arcane',
          'https://leagueoflegends.fandom.com/fr/wiki/Arcane',
          AproposAssets.apropos4,
        ),
      ],
    );
  }

  Widget _buildGameLink(
      BuildContext context, String text, String url, String assetPath) {
    const double imageHeight = 150.0; // Define a constant height for images

    return GestureDetector(
      onTap: () => _launchURL(context, url),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.colorTextTitle.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: AppColors.colorTextTitle,
            width: 2.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: imageHeight, // Use the defined constant height
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover, // Adjust the fit as per your requirement
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.colorText,
                fontFamily: 'CustomFont2',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}
