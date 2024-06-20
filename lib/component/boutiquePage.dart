import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import '../utils/utils.dart'; // Assurez-vous d'importer vos utilitaires personnalisés ici

class BoutiquePage extends StatefulWidget {
  @override
  _BoutiquePageState createState() => _BoutiquePageState();
}

class _BoutiquePageState extends State<BoutiquePage> {
  List<String> imagePaths = [];
  List<String> imageNames = []; // Liste pour stocker les noms des images

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    List<String> paths = await loadImagesFromAssets('assets/images/legendes/');
    setState(() {
      imagePaths = paths;
      imageNames = paths
          .map((path) => _getFileName(path))
          .toList(); // Récupérer les noms des fichiers
    });
  }

  String _getFileName(String path) {
    // Extraire le nom du fichier sans l'extension à partir du chemin complet
    String fileNameWithExtension = path.split('/').last;
    return fileNameWithExtension
        .split('.')
        .first; // Retourner le nom du fichier sans l'extension
  }

  Future<List<String>> loadImagesFromAssets(String path) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    return manifestMap.keys.where((String key) => key.contains(path)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boutique'),
        backgroundColor: AppColors.colorNoirHextech,
        foregroundColor: Colors.white,
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
              return _buildGridItem(context, index,
                  imageNames[index]); // Passer le nom de l'image à afficher
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index, String imageName) {
    String imagePath = imagePaths[index];
    return GestureDetector(
      onTap: () {
        // Action lors du clic sur une case
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
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
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
                imageName, // Afficher le nom de l'image ici
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily:
                      'CustomFont2', // Remplacez par votre police préférée
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BoutiquePage(),
  ));
}
