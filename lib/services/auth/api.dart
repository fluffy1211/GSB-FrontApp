import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'session_manager.dart';

// REQUETE DE LOGIN
Future<dynamic> loginUser(Map<String, dynamic> data) async {
  try {
    debugPrint('Sending login data: ${jsonEncode(data)}');
    final response = await http.post(
      Uri.parse('http://localhost:3001/user/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': data['email'],
        'password': data['password'],
      }),
    );

    debugPrint('Response status: ${response.statusCode}'); // Add debug log
    debugPrint('Response body: ${response.body}'); // Add debug log

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      await storeToken(responseData['token']);

      // Décoder le token pour obtenir le nom et le rôle
      final token = responseData['token'];
      final parts = token.split('.');
      final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      await storeUserName(payload['name']); // Utiliser le nom du token

      // Store user role if available
      if (payload['role'] != null) {
        await storeUserRole(payload['role']);
      }

      return responseData;
    } else {
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erreur de connexion');
      } catch (e) {
        // Si le jsonDecode échoue, utiliser la chaîne directement
        throw Exception(response.body);
      }
    }
  } catch (e) {
    debugPrint('API Error: $e');
    rethrow;
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
    debugPrint('API Error: $e');
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
    debugPrint('API Error: $e');
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
    debugPrint('API Error: $e');
    throw Exception('Failed to create data');
  }
}

Future<dynamic> createAppointment(Map<String, dynamic> appointmentData) async {
  try {
    final token = await getToken(); // Récupérer le token stocké
    if (token == null) throw Exception('No token found');

    final response = await http.post(
      Uri.parse('http://localhost:3001/appointment/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Ajouter le token dans les headers
      },
      body: jsonEncode(appointmentData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to create appointment');
    }
  } catch (e) {
    debugPrint('API Error: $e');
    rethrow;
  }
}

Future<dynamic> getAppointments() async {
  try {
    final token = await getToken(); // Récupérer le token stocké
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('http://localhost:3001/appointment/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Ajouter le token dans les headers
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch appointments: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('API Error: $e');
    throw Exception('Failed to fetch appointments');
  }
}

Future<dynamic> getAppointmentById(String id) async {
  try {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('http://localhost:3001/appointment/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Ajouter le token dans les headers
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch appointment: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('API Error: $e');
    throw Exception('Failed to fetch appointment');
  }
}

Future<dynamic> cancelAppointment(int appointmentId) async {
  try {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.delete(
      Uri.parse('http://localhost:3001/appointment/$appointmentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to cancel appointment');
    }
  } catch (e) {
    debugPrint('API Error: $e');
    rethrow;
  }
}

// REQUETE POUR AJOUTER UN PRATICIEN
Future<dynamic> addPraticien(Map<String, dynamic> data) async {
  try {
    debugPrint('Starting addPraticien function with data: ${jsonEncode(data)}');
    final token = await getToken();
    debugPrint('Retrieved token: ${token != null ? 'Token exists' : 'Token is null'}');

    if (token == null) throw Exception('No token found');

    final url = 'http://localhost:3001/admin/addPraticien';
    debugPrint('Sending POST request to: $url');

    final body = jsonEncode({
      'first_name': data['first_name'],
      'last_name': data['last_name'],
      'specialties': data['specialties'],
      'avatarPath': data['avatarPath'] ?? '',
    });
    debugPrint('Request body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    debugPrint('Response status code: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      debugPrint('Success: Practitioner added successfully');
      return responseData;
    } else {
      debugPrint('Error: Non-success status code received: ${response.statusCode}');
      try {
        final errorData = jsonDecode(response.body);
        debugPrint('Error data: $errorData');
        throw Exception(errorData['error'] ?? 'Failed to add praticien');
      } catch (e) {
        debugPrint('Error parsing error response: $e');
        throw Exception('Failed to add praticien: ${response.body}');
      }
    }
  } catch (e) {
    debugPrint('API Error in addPraticien: $e');
    rethrow;
  }
}

// REQUETE POUR SUPPRIMER UN PRATICIEN
Future<dynamic> removePraticien(int praticienId) async {
  try {
    debugPrint('Starting removePraticien function for ID: $praticienId');
    final token = await getToken();
    debugPrint('Retrieved token: ${token != null ? 'Token exists' : 'Token is null'}');

    if (token == null) throw Exception('No token found');

    final url = 'http://localhost:3001/admin/praticien/$praticienId';
    debugPrint('Sending DELETE request to: $url');

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('Response status code: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final appointmentsRemoved = responseData['appointmentsRemoved'] ?? 0;
      debugPrint('Success: Practitioner removed successfully with $appointmentsRemoved associated appointments');
      return responseData;
    } else if (response.statusCode == 404) {
      debugPrint('Error: Practitioner not found');
      throw Exception('Praticien non trouvé');
    } else {
      debugPrint('Error: Non-success status code received: ${response.statusCode}');
      try {
        final errorData = jsonDecode(response.body);
        debugPrint('Error data: $errorData');
        throw Exception(errorData['error'] ?? 'Failed to remove praticien');
      } catch (e) {
        debugPrint('Error parsing error response: $e');
        throw Exception('Failed to remove praticien: ${response.body}');
      }
    }
  } catch (e) {
    debugPrint('API Error in removePraticien: $e');
    rethrow;
  }
}
