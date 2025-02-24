import 'package:flutter/material.dart';
import '../pages/consultation_page.dart';
import '../pages/praticiens_page.dart';
import '../pages/profile_page.dart';
import '../constants/styles.dart'; // Ajouter l'import

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ConsultationPage(),
    PraticiensPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Rendez-vous',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Praticiens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor, // Utiliser primaryColor
        unselectedItemColor: Colors.grey, // Ajouter cette ligne
        type: BottomNavigationBarType.fixed, // Ajouter cette ligne
        onTap: _onItemTapped,
      ),
    );
  }
}
