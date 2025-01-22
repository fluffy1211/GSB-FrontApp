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

    // Print de debug
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

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

    // Print de debug
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

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
