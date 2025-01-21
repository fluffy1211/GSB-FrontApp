import 'package:flutter/material.dart';

var primaryColor = const Color(0xFF5182BD);

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    );
  }
}

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
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
            const Text(
              "Vous n'avez pas encore de compte ?",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 300,
            child: TextFormField(
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

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Si le form est valide
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
}
