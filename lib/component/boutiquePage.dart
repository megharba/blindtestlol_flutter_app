import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

class BoutiquePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boutique'),
        backgroundColor: AppColors.colorTextTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Nombre de colonnes
            crossAxisSpacing: 16.0, // Espacement entre les colonnes
            mainAxisSpacing: 16.0, // Espacement entre les lignes
            childAspectRatio: 1.0, // Ratio pour des cases carrées
          ),
          itemCount: 60, // Nombre total de cases
          itemBuilder: (context, index) {
            return _buildGridItem(context, index);
          },
        ),
      ),
      backgroundColor: AppColors.colorNoirHextech,
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // Action lors du clic sur une case
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorTextTitle.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: AppColors.colorTextTitle,
            width: 2.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                child: Image.asset(
                  ImageAssets
                      .imageLegende1, // Remplacez par le chemin de votre image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.colorTextTitle.withOpacity(0.8),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10.0)),
              ),
              child: Text(
                'Item ${index + 1}', // Légende pour chaque case
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

void main() {
  runApp(MaterialApp(
    home: BoutiquePage(),
  ));
}
