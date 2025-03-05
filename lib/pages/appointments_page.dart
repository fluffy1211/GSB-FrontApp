import 'package:flutter/material.dart';
import 'package:gsb/constants/styles.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Rendez-vous'),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false, // This will remove the back button
      ),
      body: const Center(
        child: Text('Liste des rendez-vous'),
      ),
    );
  }
}
