import 'package:flutter/material.dart';
import '../components/praticiens.dart';
import '../services/auth/api.dart';
import 'rdv_page.dart';

class PraticiensPage extends StatefulWidget {
  const PraticiensPage({super.key});

  @override
  State<PraticiensPage> createState() => _PraticiensPageState();
}

class _PraticiensPageState extends State<PraticiensPage> {
  List<Praticien> praticiens = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPraticiens();
  }

  Future<void> _loadPraticiens() async {
    try {
      final response = await getPraticiens();
      setState(() {
        praticiens = (response as List)
            .map((item) => Praticien(
                  praticienId: item['praticien_id'],
                  firstName: item['first_name'],
                  lastName: item['last_name'],
                  specialties: item['specialties'],
                ))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des praticiens: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Praticiens', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5182BD),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : praticiens.isEmpty
              ? const Center(child: Text('Aucun praticien trouvé'))
              : ListView.builder(
                  itemCount: praticiens.length,
                  itemBuilder: (context, index) {
                    final praticien = praticiens[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          'Dr. ${praticien.firstName} ${praticien.lastName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Spécialité: ${praticien.specialties}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentScreen(
                                  praticien: praticien,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5182BD),
                          ),
                          child: const Text(
                            'Prendre RDV',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
