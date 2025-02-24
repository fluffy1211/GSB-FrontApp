import 'dart:convert';

class Appointment {
  final int appointmentId;
  final DateTime date;
  final String time;
  final List<String> symptoms;
  final String praticienFirstName;
  final String praticienLastName;
  final String praticienSpecialties;

  Appointment({
    required this.appointmentId,
    required this.date,
    required this.time,
    required this.symptoms,
    required this.praticienFirstName,
    required this.praticienLastName,
    required this.praticienSpecialties,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'],
      date: DateTime.parse(json['appointment_date']),
      time: json['appointment_time'],
      symptoms: List<String>.from(jsonDecode(json['symptoms'])),
      praticienFirstName: json['first_name'],
      praticienLastName: json['last_name'],
      praticienSpecialties: json['specialties'],
    );
  }
}
