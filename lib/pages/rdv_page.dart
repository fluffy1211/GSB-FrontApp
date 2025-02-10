import 'package:flutter/material.dart';
import '../components/praticiens.dart';
import '../components/symptoms.dart';

// COULEUR GSB
var primaryColor = const Color(0xFF5182BD);

class MyRdv extends StatelessWidget {
  const MyRdv({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prise de Rendez-vous',
      home: AppointmentScreen(
          praticien: Praticien(praticienId: 1, firstName: 'John', lastName: 'Doe', specialties: 'Cardiology')),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    _initializeTimeSlots();
  }

  void _initializeTimeSlots() {
    // Generate slots for next 7 days
    for (int i = 0; i < 999; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      // Remove time component for comparison
      date = DateTime(date.year, date.month, date.day);
      availableTimeSlots[date] = ['09h00', '10h00', '11h00', '12h00', '13h00', '14h00', '15h00', '16h00'];
    }
    setState(() {});
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
        // Remove time component for comparison
        selectedDate = DateTime(picked.year, picked.month, picked.day);
        selectedTimeSlot = null; // Reset time slot when date changes
      });
    }
  }

  void _confirmAppointment(BuildContext context) async {
    if (selectedTimeSlot == null) return;

    try {
      // Add API call here to save appointment
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
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la confirmation du rendez-vous')),
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
              padding: const EdgeInsets.all(30.0),
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
                      const SizedBox(height: 24),
                    ],
                  ),
                  const Text(
                    'Sélectionnez une date :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'Date sélectionnée: ${selectedDate.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Créneaux horaires disponibles :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 1),
                  slots.isNotEmpty
                      ? Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: slots.map((time) {
                            return ChoiceChip(
                              label: Text(time),
                              selected: selectedTimeSlot == time,
                              onSelected: (selected) {
                                setState(() {
                                  selectedTimeSlot = selected ? time : null;
                                });
                              },
                            );
                          }).toList(),
                        )
                      : const Text('Aucun créneau disponible pour cette date.'),
                  const SizedBox(height: 8),
                  SymptomsDropdown(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 260,
              height: 35,
              child: ElevatedButton(
                onPressed: selectedTimeSlot != null ? () => _confirmAppointment(context) : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return selectedTimeSlot != null ? primaryColor : Colors.grey[300]!;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return selectedTimeSlot != null ? Colors.white : Colors.grey[600]!;
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
