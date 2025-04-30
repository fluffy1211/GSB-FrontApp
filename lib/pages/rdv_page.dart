import 'package:flutter/material.dart';
import '../components/praticiens.dart';
import '../components/symptoms.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'dart:async';
import '../services/auth/api.dart';
import '../constants/styles.dart';

// COULEUR GSB

class AppointmentScreen extends StatefulWidget {
  final Praticien praticien;

  const AppointmentScreen({
    super.key,
    required this.praticien,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  Map<DateTime, List<String>> availableTimeSlots = {};

  final MultiSelectController<String> symptomController = MultiSelectController<String>();

  bool get isFormValid => selectedTimeSlot != null && symptomController.selectedItems.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initializeTimeSlots();
  }

  @override
  void dispose() {
    symptomController.dispose();
    super.dispose();
  }

  void _initializeTimeSlots() {
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < 999; i++) {
        DateTime date = DateTime.now().add(Duration(days: i));
        date = DateTime(date.year, date.month, date.day);
        availableTimeSlots[date] = ['09h00', '10h00', '11h00', '12h00', '13h00', '14h00', '15h00', '16h00'];
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month, picked.day);
        selectedTimeSlot = null;
      });
    }
  }

  void _confirmAppointment(BuildContext context) async {
    if (selectedTimeSlot == null) return;

    try {
      // Extraire seulement les valeurs des symptômes
      final List<String> symptoms = symptomController.selectedItems
          .map((item) => item.value) // Récupérer seulement la valeur de chaque DropdownItem
          .toList();

      // Préparer les données pour l'API
      final appointmentData = {
        'praticienId': widget.praticien.praticienId,
        'date': selectedDate.toIso8601String().split('T')[0],
        'timeSlot': selectedTimeSlot,
        'symptoms': symptoms, // Envoyer la liste des valeurs
      };

      // Appeler l'API
      final result = await createAppointment(appointmentData);

      // Afficher la confirmation
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
            'Votre rendez-vous est confirmé pour le ${selectedDate.toLocal().toString().split(' ')[0]} à $selectedTimeSlot.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
                Navigator.pop(context); // Retourner à l'écran précédent
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur est survenue. Veuillez réessayer plus tard.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> slots = availableTimeSlots[selectedDate] ?? [];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Prendre un rendez-vous', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: widget.praticien.avatarPath != null
                              ? AssetImage(widget.praticien.avatarPath!)
                              : const AssetImage('assets/avatar.png'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              '${widget.praticien.firstName} ${widget.praticien.lastName}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.praticien.specialties,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Sélectionnez une date :',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'Date sélectionnée: ${selectedDate.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Créneaux horaires disponibles :',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      slots.isNotEmpty
                          ? Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: slots.map((time) {
                                return ChoiceChip(
                                  label: Text(time),
                                  selected: selectedTimeSlot == time,
                                  selectedColor: primaryColor,
                                  labelStyle: TextStyle(
                                    color: selectedTimeSlot == time ? Colors.white : Colors.black,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedTimeSlot = selected ? time : null;
                                    });
                                  },
                                );
                              }).toList(),
                            )
                          : Text(
                              'Aucun créneau disponible pour cette date.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Symptômes :',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SymptomsDropdown(
                        controller: symptomController,
                        onSelectionChange: (selectedItems) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!isFormValid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Veuillez sélectionner un horaire et au moins un symptôme',
                style: TextStyle(color: Colors.red[700], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 260,
              height: 35,
              child: ElevatedButton(
                onPressed: isFormValid ? () => _confirmAppointment(context) : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return isFormValid ? primaryColor : Colors.grey[300]!;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return isFormValid ? Colors.white : Colors.grey[600]!;
                  }),
                  animationDuration: const Duration(milliseconds: 500),
                ),
                child: const Text(
                  'Confirmer le rendez-vous',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
