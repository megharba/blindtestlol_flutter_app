import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

class ResponsePage extends StatelessWidget {
  final int score;
  final int combo;
  final String musicToken; // Utiliser le token pour l'image
  final String musicType;
  final String musicDate;
  final String userProposition;
  final String correctedName;
  final VoidCallback onNextRound;

  const ResponsePage({
    Key? key,
    required this.score,
    required this.combo,
    required this.musicToken,
    required this.musicType,
    required this.musicDate,
    required this.userProposition,
    required this.correctedName,
    required this.onNextRound,
  }) : super(key: key);

  Widget _buildComboImage(int combo) {
    if (combo >= 0 && combo <= 5) {
      return Image.asset(
        'assets/images/combos/combo$combo.png',
        width: 120,
        height: 120,
      );
    }
    return Container(); // Return an empty container if combo is out of range
  }

  @override
  Widget build(BuildContext context) {
    final String musicImagePath =
        'assets/images/results/$musicToken.png'; // Utiliser le token pour l'image

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.colorNoirHextech,
        title: const Text('Response'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.colorNoirHextech,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Score: $score',
                        style: const TextStyle(
                          color: AppColors.colorText,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Combo: $combo',
                        style: const TextStyle(
                          color: AppColors.colorText,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Icône de profil à droite
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFCDFAFA),
                          blurRadius: 5,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.colorTextTitle,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        ImageAssets.imageLegende1,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildComboImage(combo),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  musicImagePath,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image,
                        size: 250, color: Colors.red);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Proposition: $userProposition',
                style: const TextStyle(
                  color: AppColors.colorText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Corrected Name: $correctedName',
                style: const TextStyle(
                  color: AppColors.colorText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Type: $musicType',
                style: const TextStyle(
                  color: AppColors.colorText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Date: $musicDate',
                style: const TextStyle(
                  color: AppColors.colorText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onNextRound,
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.colorNoirHextech,
                  backgroundColor: AppColors.colorTextTitle,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text('Continuer'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
