import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:blindtestlol_flutter_app/component/loginPage.dart';
import 'package:blindtestlol_flutter_app/services/userServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1013),
      body: Center(
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
                color: AppColors.colorText,
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
                      controller: _emailController,
                      labelText: AppText.labelEmail,
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
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0E1013),
                        side: BorderSide(color: AppColors.colorText),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 25),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  ImageAssets.logo,
                                  height: 50,
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  AppText.labelInscription,
                                  style: TextStyle(color: AppColors.colorText),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  AppText.labelConnexion,
                  style: TextStyle(color: AppColors.colorText),
                ),
              ),
              const SizedBox(height: 1),
              LayoutBuilder(
                builder: (context, constraints) {
                  double imageHeight = constraints.maxWidth *
                      0.75; // 75% de la largeur du parent
                  return Image.asset(
                    ImageAssets.logo, // Assurez-vous que ce chemin est correct
                    height: imageHeight,
                    width:
                        constraints.maxWidth, // S'adapte à la largeur du parent
                    fit: BoxFit.contain,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await UserService()
          .createUser(_nameController.text, _passwordController.text);
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
