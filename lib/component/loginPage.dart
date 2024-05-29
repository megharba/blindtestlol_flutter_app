import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:blindtestlol_flutter_app/component/registerPage.dart';
import 'package:blindtestlol_flutter_app/services/userServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/component/background_video.dart'; // Assurez-vous de remplacer le chemin par celui de votre fichier

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackgroundVideo(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    ImageAssets.logo, // Assurez-vous que ce chemin est correct
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    ImageAssets.Title, // Chemin de ton image unique
                    width: 300, // Ajuste la largeur selon tes besoins
                    height: 75, // Ajuste la hauteur selon tes besoins
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: AppColors.colorTextTitle,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          labelText: AppText.labelIdentifiant,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          labelText: AppText.labelPassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorNoirHextech,
                            side: BorderSide(color: AppColors.colorTextTitle),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      ImageAssets
                                          .logo, // Assurez-vous que ce chemin est correct
                                      height: 50,
                                    ),
                                    const SizedBox(width: 3),
                                    const Text(
                                      AppText.labelConnexion,
                                      style: TextStyle(
                                        color: AppColors.colorTextTitle,
                                        fontFamily: 'CustomFont2',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Image.asset(
                          ImageAssets.Soulignement,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: Text(
                          AppText.labelInscription,
                          style: TextStyle(
                            color: AppColors.colorText,
                            fontFamily: 'CustomFont1',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required bool obscureText}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: AppColors.colorText,
        fontFamily: 'CustomFont1',
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColors.colorTextTitle,
          fontFamily: 'CustomFont1',
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorTextTitle),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.colorTextTitle),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
      ),
      validator: (value) =>
          value!.isEmpty ? 'Please enter your $labelText' : null,
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await UserService()
          .connectUser(_nameController.text, _passwordController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage(user: user)),
      );
    } catch (e) {
      // Handle errors, possibly show an alert dialog
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
