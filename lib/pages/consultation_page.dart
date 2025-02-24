import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../services/auth/api.dart';
import '../constants/styles.dart'; // Ajouter l'import

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  List<Appointment> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      final response = await getAppointments();
      setState(() {
        appointments = (response as List).map((item) => Appointment.fromJson(item)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des rendez-vous: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _confirmCancelAppointment(Appointment appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Êtes-vous sûr de vouloir annuler ce rendez-vous ?'), // Amélioration du texte
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non, annuler'), // Plus explicite
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Oui, supprimer'), // Plus explicite
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await cancelAppointment(appointment.appointmentId);
        await _loadAppointments();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rendez-vous annulé avec succès'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2), // Ajouter cette ligne
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'annulation: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Rendez-vous', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor, // Utiliser primaryColor
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
              ? const Center(child: Text('Aucun rendez-vous trouvé'))
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          'Dr. ${appointment.praticienFirstName} ${appointment.praticienLastName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${appointment.date.toLocal().toString().split(' ')[0]}'),
                            Text('Heure: ${appointment.time}'),
                            Text('Spécialité: ${appointment.praticienSpecialties}'),
                            Text('Symptômes: ${appointment.symptoms.join(", ")}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmCancelAppointment(appointment),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
