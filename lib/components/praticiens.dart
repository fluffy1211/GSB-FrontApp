import 'package:flutter/material.dart';
import 'package:gsb/pages/rdv_page.dart';

class Praticien {
  final String nom;
  final String prenom;
  final String specialite;

  Praticien(
      {required this.nom, required this.prenom, required this.specialite});
}

class PraticiensList extends StatelessWidget {
  final List<Praticien> praticiens = [
    Praticien(nom: 'Dupont', prenom: 'Jean', specialite: 'Cardiologue'),
    Praticien(nom: 'Martin', prenom: 'Marie', specialite: 'Dermatologue'),
    Praticien(nom: 'Durand', prenom: 'Pierre', specialite: 'Généraliste'),
    // Ajoutez d'autres praticiens ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Praticiens'),
      ),
      body: ListView.builder(
        itemCount: praticiens.length,
        itemBuilder: (context, index) {
          final praticien = praticiens[index];
          return Card(
            child: ListTile(
              title: Text('${praticien.prenom} ${praticien.nom}'),
              subtitle: Text(praticien.specialite),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentScreen(),
                  ),
                );
                
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PraticiensList(),
    
  ));
}
