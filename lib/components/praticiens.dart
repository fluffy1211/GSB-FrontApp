import 'package:flutter/material.dart';
import 'package:gsb/pages/rdv_page.dart';
import 'package:gsb/services/auth/api.dart';

class Praticien {
  final int praticienId;
  final String firstName;
  final String lastName;
  final String specialties;
  final String? avatarPath;

  Praticien({
    required this.praticienId,
    required this.firstName,
    required this.lastName,
    required this.specialties,
    this.avatarPath,
  });
}

class PraticiensList extends StatefulWidget {
  const PraticiensList({super.key});

  @override
  State<PraticiensList> createState() => _PraticiensListState();
}

class _PraticiensListState extends State<PraticiensList> {
  final _praticiensController = TextEditingController();
  List<Praticien> praticiens = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadPraticiens();
  }

  Future<void> _loadPraticiens() async {
    try {
      final response = await getPraticiens();
      debugPrint('API Response: $response');

      if (response is List<dynamic>) {
        setState(() {
          praticiens = response
              .map((item) => Praticien(
                    praticienId: item['praticien_id'],
                    firstName: item['first_name'],
                    lastName: item['last_name'],
                    specialties: item['specialties'],
                    avatarPath: item['avatarPath']?.toString(),
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Unexpected response format: $response');
      }
    } catch (e) {
      debugPrint('Error loading praticiens: $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des praticiens'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(child: Text('Erreur: $error'))
                    : ListView.builder(
                        itemCount: praticiens.length,
                        itemBuilder: (context, index) {
                          final praticien = praticiens[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: praticien.avatarPath != null
                                    ? AssetImage(praticien.avatarPath!)
                                    : const AssetImage('assets/avatar.png'),
                              ),
                              title: Text('${praticien.firstName} ${praticien.lastName}'),
                              subtitle: Text(praticien.specialties),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentScreen(
                                      praticien: praticien,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _praticiensController.dispose();
    super.dispose();
  }
}
