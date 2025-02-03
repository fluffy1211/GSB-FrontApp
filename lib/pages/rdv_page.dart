import 'package:flutter/material.dart';



class MyRdv extends StatelessWidget {
  const MyRdv({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prise de Rendez-vous',
      home: const AppointmentScreen(),
    );
  }
}

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  _Horaires createState() => _Horaires();
}

class _Horaires extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;

  // Exemple de créneaux horaires disponibles
  final Map<DateTime, List<String>> availableTimeSlots = {
    DateTime(2025, 1, 22): ['09:00', '10:00', '11:00', '14:00', '16:00'],
    DateTime(2025, 1, 23): ['10:00', '11:30', '15:00'],
  };

  @override
  Widget build(BuildContext context) {
    List<String> slots = availableTimeSlots[selectedDate] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Prendre un rendez-vous'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sélectionnez une date :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                'Choisir une date : ${selectedDate.toLocal()}'.split(' ')[0],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Créneaux horaires disponibles :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            slots.isNotEmpty
                ? Wrap(
                    spacing: 10,
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
                : Text('Aucun créneau disponible pour cette date.'),
            Spacer(),
            ElevatedButton(
              onPressed: selectedTimeSlot != null
                  ? () {
                      _confirmAppointment(context);
                    }
                  : null,
              child: Text('Confirmer le rendez-vous'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month, picked.day);
        selectedTimeSlot = null; // Réinitialiser le créneau sélectionné
      });
    }
  }

  void _confirmAppointment(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
            'Votre rendez-vous est confirmé pour le ${selectedDate.toLocal()} à $selectedTimeSlot.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}