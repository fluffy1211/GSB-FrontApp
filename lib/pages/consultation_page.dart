import 'package:flutter/material.dart';

// COULEUR GSB
var primaryColor = const Color(0xFF5182BD);

class ConsultationPage extends StatefulWidget {
  final DateTime date;
  final String timeSlot;

  const ConsultationPage({super.key, required this.date, required this.timeSlot});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails de la consultation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Date : ${widget.date.toLocal()}'.split(' ')[0]),
            Text('Heure : ${widget.timeSlot}'),
          ],
        ),
      ),
    );
  }
}
