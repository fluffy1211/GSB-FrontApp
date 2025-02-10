import 'package:http/http.dart' as http;
import 'dart:convert';
import 'session_manager.dart';

// REQUETE DE LOGIN
Future<dynamic> loginUser(Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:3001/user/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    // Check for both 200 and 201 status codes
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      await storeToken(responseData['token']); // Store le token si on est bien login
      return responseData;
    } else {
      throw Exception('Failed to create data: ${response.statusCode}');
    }
  } catch (e) {
    print('API Error: $e');
    throw Exception('Failed to create data');
  }
}

// REQUETE DE REGISTER
Future<dynamic> createUser(Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:3001/user/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create data: ${response.statusCode}');
    }
  } catch (e) {
    print('API Error: $e');
    throw Exception('Failed to create data');
  }
}

// REQUETE POUR LES PRATICIENS

Future<dynamic> getPraticiens() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3001/praticiens'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch praticiens: ${response.statusCode}');
    }
  } catch (e) {
    print('API Error: $e');
    throw Exception('Failed to fetch praticiens');
  }
}

// REQUETE POUR RECUPERER UN PRATICIEN PAR ID 

Future<dynamic> getPraticienById(String id) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3001/praticiens/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create data: ${response.statusCode}');
    }
  } catch (e) {
    print('API Error: $e');
    throw Exception('Failed to create data');
  }
}

Future<dynamic> createAppointment(Map<String, dynamic> appointmentData) async {
  // Retrieve the stored token
  try {
    final response = await http.post(
      Uri.parse('http://localhost:3001/appointments/create'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(appointmentData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create appointment: ${response.statusCode}');
    }
  } catch (e) {
    print('API Error: $e');
    throw Exception('Failed to create appointment');
  }
}
