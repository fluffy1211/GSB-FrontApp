import 'package:flutter/material.dart';

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
        title: const Text("Bienvenue"),
        backgroundColor: primaryColor,
      ),
    );
  }
}
