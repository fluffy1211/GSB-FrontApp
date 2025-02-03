import 'package:flutter/material.dart';
import 'package:gsb/components/praticiens.dart';

// COULEUR GSB
var primaryColor = const Color(0xFF5182BD);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Accueil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
      ),
      body: PraticiensList()
    );
  }
}