import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/component/SignalerProblemePage.dart';
import 'package:blindtestlol_flutter_app/component/aProposPage.dart';
import 'package:blindtestlol_flutter_app/component/boutiquePage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/loginPage.dart'; // Importez la page de connexion

class ProfilPage extends StatelessWidget {
  final User user;

  const ProfilPage({required this.user});

  void _deconnexion(BuildContext context) {
    // Implémentez ici la logique de déconnexion
    // Par exemple, vous pouvez effacer les données utilisateur enregistrées localement
    // Puis vous naviguez vers la page de connexion
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageAssets.imageProfilPage, // Chemin de l'image de fond
            ),
            fit: BoxFit.cover, // Ajustement pour couvrir l'espace
            alignment: Alignment.topCenter, // Aligner l'image en haut
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20.0,
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              _customButton(
                text: 'Compte',
                onPressed: () {
                  // Navigation vers la page de compte
                },
              ),
              SizedBox(height: 8.0),
              _customButton(
                text: 'Avatar',
                onPressed: () {
                  // Navigation vers la page d'avatar
                },
              ),
              SizedBox(height: 16.0),
              Divider(),
              _customButton(
                text: 'Boutique',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BoutiquePage()),
                  );
                },
              ),
              SizedBox(height: 8.0),
              _customButton(
                text: 'À propos de nous',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AProposPage()),
                  );
                },
              ),
              SizedBox(height: 8.0),
              _customButton(
                text: 'Signaler un problème',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignalerProblemePage(),
                    ),
                  );
                },
              ),
              SizedBox(height: 8.0),
              _customButton(
                text: 'Déconnexion', // Bouton de déconnexion
                onPressed: () {
                  _deconnexion(context); // Appel de la méthode de déconnexion
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.colorNoirHextech,
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
