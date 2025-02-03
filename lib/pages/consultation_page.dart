import 'package:flutter/material.dart';

// COULEUR GSB
var primaryColor = const Color(0xFF5182BD);

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vos consultations",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
      ),
    );
  }
}
