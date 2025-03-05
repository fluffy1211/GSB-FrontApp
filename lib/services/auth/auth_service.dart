import 'dart:convert';
import 'package:gsb/services/auth/session_manager.dart';

class AuthService {
  // Decode JWT token
  static Map<String, dynamic> _decodeToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token format');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));

    return json.decode(decoded);
  }

  // Check if the current user is an admin
  static Future<bool> isUserAdmin() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final decodedToken = _decodeToken(token);
      return decodedToken['role'] == 'admin';
    } catch (e) {
      print('Error decoding token: $e');
      return false;
    }
  }

  // Get current user's role
  static Future<String?> getUserRole() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final decodedToken = _decodeToken(token);
      return decodedToken['role'];
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }
}
