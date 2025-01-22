import 'package:flutter/material.dart';
import 'package:gsb/api.dart';
import 'package:gsb/main.dart';
import 'package:gsb/navigation.dart';

// COULEUR GSB
var primaryColor = const Color(0xFF5182BD);

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // REGEX DU MAIL
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // FONCTION DE REGISTER
  Future<void> _handleRegister() async {
    try {
      if (_registerFormKey.currentState!.validate()) {

        // CHECK SI LE MAIL EST VALIDE
        if (!emailRegex.hasMatch(_emailController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 4),
              content: Text(
                'Veuillez entrer une adresse email valide',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // CHECK SI LES MDP MATCH
        if (_passwordController.text != _confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 4),
            content: Text(
              'Les mots de passe doivent correspondre',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
          ));
          return;
        }

        // SI TOUT EST VALIDE, ON CREE L'USER
        final response = await createUser({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'confirmPassword': _confirmPasswordController.text,
        });

        // REDIRECT SUR LA Home Page
        if (response != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainNavigation()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: Text(
            'Cet e-mail / utilisateur est déjà associé à un compte',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(30),
            child: Image(
              image: AssetImage('assets/gsb.png'),
              width: 200,
            ),
          ),
          const Text(
            "Veuillez créer un compte",
            style: TextStyle(fontSize: 19),
          ),
          const SizedBox(height: 50),
          _buildRegisterForm(),
          const SizedBox(height: 70),
          _buildRegisterButton(),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              print("button working");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Welcome()),
              );
            },
            child: Text(
              "Déjà inscrit ? Connectez-vous",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    )));
  }

  // FORM DE REGISTER
  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Nom',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: 'Adresse électronique',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Mot de passe',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: 300,
              child: TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Confirmer le mot de passe',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  return null;
                },
              ))
        ],
      ),
    );
  }

  // BOUTON DE REGISTER
  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () {
        if (_registerFormKey.currentState!.validate()) {
          _handleRegister();
        } else {
          return;
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
      ),
      child: const Text(
        "S'enregistrer",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
