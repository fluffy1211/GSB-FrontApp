import 'dart:convert';
import 'package:gsb/services/auth/session_manager.dart';
import 'package:flutter/material.dart';

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

  // Check si le user est un admin
  static Future<bool> isUserAdmin() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final decodedToken = _decodeToken(token);
      return decodedToken['role'] == 'admin';
    } catch (e) {
      debugPrint('Error decoding token: $e');
      return false;
    }
  }

  // Get le role de l'utilisateur
  static Future<String?> getUserRole() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final decodedToken = _decodeToken(token);
      return decodedToken['role'];
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return null;
    }
  }
}
