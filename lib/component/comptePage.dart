import 'package:blindtestlol_flutter_app/services/userServices.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/component/background_video.dart';

import 'AnimatedPulse.dart'; // Assurez-vous de remplacer le chemin par celui de votre fichier

class ComptePage extends StatefulWidget {
  final User user;

  const ComptePage({required this.user});

  @override
  _ComptePageState createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage>
    with SingleTickerProviderStateMixin {
  late TextEditingController nameController;
  late TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController =
        TextEditingController(text: widget.user.email); // Correction ici

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Compte'),
        backgroundColor: AppColors.colorNoirHextech,
        foregroundColor: AppColors.colorTextTitle,
      ),
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(-150,
                0), // Déplace le BackgroundVideo vers la gauche de 100 pixels
            child: const BackgroundVideo(
              videoPath: Mp4Assets.imageBackgroundProfil,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(
                0.5), // Couche transparente pour rendre le contenu plus lisible
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/images/legendes/" +
                            widget.user.avatarToken +
                            ".png"),
                      ),
                      Positioned(
                        right: -30,
                        bottom:
                            -20, // Décalage de 20 pixels vers le haut par rapport au bas de l'image de profil
                        child: AnimatedPulse(
                          child: GestureDetector(
                            onTap: () {
                              // Action lorsque l'utilisateur appuie sur l'icône pour modifier l'avatar
                              print('Modifier l\'avatar');
                              // Ajoutez ici la logique pour modifier l'avatar
                            },
                            child: Image.asset(
                              ImageAssets.imageCurseur,
                              width: 80, // Taille de l'image de l'icône
                              height: 80,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildEditableField('Nom d\'utilisateur', nameController,
                      isEditable: false),
                  SizedBox(height: 16),
                  _buildEditableField('Adresse e-mail', emailController,
                      isEditable: false),
                  SizedBox(height: 16),
                  _buildEditableField(
                      'Nouveau mot de passe', passwordController,
                      isPassword: true),
                  SizedBox(height: 16),
                  _buildEditableField(
                      'Confirmer le mot de passe', confirmPasswordController,
                      isPassword: true),
                  SizedBox(height: 24),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child:
                          _buildSaveButton(), // Utilisation du bouton personnalisé
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.colorNoirHextech,
    );
  }

  // Méthode pour construire le bouton personnalisé
  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        String newPassword = passwordController.text;
        String confirmPassword = confirmPasswordController.text;

        if (newPassword.isNotEmpty && newPassword == confirmPassword) {
          try {
            UserService userService = UserService();
            User updatedUser =
                await userService.updatePassword(widget.user.uid, newPassword);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mot de passe mis à jour avec succès.'),
              ),
            );
            setState(() {});
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Erreur lors de la mise à jour du mot de passe: $e'),
              ),
            );
          }
        } else if (newPassword.isNotEmpty && newPassword != confirmPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Les mots de passe ne correspondent pas.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Modifications sauvegardées avec succès.'),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.colorTextTitle,
        backgroundColor:
            AppColors.colorNoirHextech, // Couleur du texte du bouton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Bord arrondi
          side: BorderSide(
              color: AppColors.colorTextTitle, width: 2.0), // Bordure
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      ),
      child: Text(
        'Sauvegarder les modifications',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'CustomFont2',
        ),
      ),
    );
  }

  // Widget pour construire un champ éditable
  Widget _buildEditableField(String label, TextEditingController controller,
      {bool isPassword = false, bool isEditable = true}) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.colorNoirHextech.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: AppColors.colorTextTitle,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.colorTextTitle,
              fontFamily: 'CustomFont2',
            ),
          ),
          isEditable
              ? TextField(
                  controller: controller,
                  obscureText: isPassword,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'CustomFont2',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: isPassword
                        ? 'Modifier votre mot de passe'
                        : 'Modifier votre $label',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
              : SizedBox(
                  height:
                      48.0, // Ajustez cette hauteur pour correspondre à celle des TextFields
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'CustomFont2',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
