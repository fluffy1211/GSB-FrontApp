import 'package:http/http.dart' as http;
import 'dart:convert';
import 'session_manager.dart';

// REQUETE DE LOGIN
Future<dynamic> loginUser(Map<String, dynamic> data) async {
  try {
    print('Sending login data: ${jsonEncode(data)}'); // Add debug log
    final response = await http.post(
      Uri.parse('http://localhost:3001/user/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': data['email'], // Changed from 'username' to 'email'
        'password': data['password'],
      }),
    );

    print('Response status: ${response.statusCode}'); // Add debug log
    print('Response body: ${response.body}'); // Add debug log

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      await storeToken(responseData['token']);

      // Décoder le token pour obtenir le nom
      final token = responseData['token'];
      final parts = token.split('.');
      final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      await storeUserName(payload['name']); // Utiliser le nom du token

      return responseData;
    } else {
      // Gérer le cas où la réponse est une chaîne simple
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erreur de connexion');
      } catch (e) {
        // Si le jsonDecode échoue, utiliser la chaîne directement
        throw Exception(response.body);
      }
    }
  } catch (e) {
    print('API Error: $e');
    rethrow; // Propager l'erreur pour une meilleure gestion dans l'UI
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
    print('API Error: $e');
    rethrow; // Propager l'erreur pour la gérer dans l'UI
  }
}

Future<dynamic> getAppointments() async {
  try {
    final token = await getToken(); // Récupérer le token stocké
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('http://localhost:3001/appointment'),
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
    print('API Error: $e');
    throw Exception('Failed to fetch appointments');
  }
}

Future<dynamic> getAppointmentById(String id) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3001/appointment/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch appointment: ${response.statusCode}');
    }
  } catch (e) {
    print('API Error: $e');
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
    print('API Error: $e');
    rethrow;
  }
}
