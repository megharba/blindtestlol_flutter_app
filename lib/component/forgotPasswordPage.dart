import 'package:blindtestlol_flutter_app/component/loginPage.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mot de passe oublié"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                  color: Colors.amber, width: 2.0), // Bordures dorées
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    ImageAssets.abeilleMecontente,
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.amber, width: 2.0), // Bordures dorées
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.amber, width: 2.0), // Bordures dorées
                      ),
                      prefixIcon: const Icon(Icons.email, color: Colors.amber),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _sendPasswordResetEmail(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Bordures dorées
                        side: BorderSide(
                            color: Colors.amber, width: 2.0), // Bordures dorées
                      ),
                      backgroundColor: Colors.amber, // Couleur dorée du bouton
                    ),
                    child: Text(
                      "Envoyer",
                      style: TextStyle(
                        color: AppColors
                            .colorNoirHextech, // Texte blanc pour contraste
                        fontFamily: 'CustomFont1',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    ImageAssets.abeilleContente,
                    height: 100,
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendPasswordResetEmail(BuildContext context) {
    String email = _emailController.text;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Message envoyé"),
          content: Text(
              "Un email a été envoyé à $email pour réinitialiser votre mot de passe."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
