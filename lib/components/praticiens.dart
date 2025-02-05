import 'package:flutter/material.dart';
import 'package:gsb/pages/rdv_page.dart';

class Praticien {
  final String nom;
  final String prenom;
  final String specialite;
  final Image avatar;

  Praticien(
      {required this.nom,
      required this.prenom,
      required this.specialite,
      required this.avatar});
}

class PraticiensList extends StatelessWidget {
  final List<Praticien> praticiens = [
    Praticien(
        nom: 'le malicieux',
        prenom: 'Larry',
        specialite: 'terriblement malicieux',
        avatar: Image(image: AssetImage('assets/larry.webp'))),
    Praticien(
        nom: 'IA',
        prenom: 'OI',
        specialite: 'OIIA',
        avatar: Image(image: AssetImage('assets/oiia.webp'))),
    Praticien(
        nom: 'Goupi',
        prenom: 'Oupi',
        specialite: 'yeepi',
        avatar: Image(image: AssetImage('assets/oupi_goupi.webp'))),
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
              leading: CircleAvatar(
                backgroundImage: praticien.avatar.image,
              ),
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
