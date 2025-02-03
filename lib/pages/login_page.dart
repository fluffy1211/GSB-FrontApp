import 'package:flutter/material.dart';
import 'package:gsb/components/api.dart';
import 'package:gsb/components/navigation.dart';
import 'package:gsb/pages/register_page.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _loginFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // FONCTION DE LOGIN
  Future<void> _handleLogin() async {
    try {
      if (_loginFormKey.currentState!.validate()) {
        final response = await loginUser({
          'email': _usernameController.text,
          'password': _passwordController.text,
        });

        if (response != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainNavigation(
                )
              ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              "L'utilisateur n'existe pas",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            backgroundColor: const Color.fromARGB(255, 241, 16, 38)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Image(
                image: AssetImage('assets/gsb.png'),
                width: 200,
              ),
            ),
            const Text(
              "Bienvenue sur l'app GSB",
              style: TextStyle(fontSize: 19),
            ),
            const SizedBox(height: 50),
            _buildLoginForm(),
            const SizedBox(height: 70),
            _buildLoginButton(),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterForm()),
                );
              },
              child: const Text(
                "Vous n'avez pas encore de compte ?",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FORM DE LOGIN
  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: _usernameController,
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
        ],
      ),
    );
  }

  // BOUTON DE LOGIN
  Widget _buildLoginButton() {
    return TextButton(
      onPressed: () async {
        if (_loginFormKey.currentState!.validate()) {
          await _handleLogin();
        } else {
          return;
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
      ),
      child: const Text(
        'Se connecter',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
