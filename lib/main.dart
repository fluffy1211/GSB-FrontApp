import 'package:flutter/material.dart';
import 'package:gsb/pages/login_page.dart';

// COULEUR GSB
var primaryColor = const Color(0xFF5182BD);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
