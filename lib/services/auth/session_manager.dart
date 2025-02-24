import 'package:shared_preferences/shared_preferences.dart';

const String _tokenKey = 'auth_token';

// Stocker le token
Future<void> storeToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_tokenKey, token);
}

// Récupérer le token
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_tokenKey);
}

// Supprimer le token (pour la déconnexion)
Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_tokenKey);
}

// Supprimer le nom d'utilisateur (pour la déconnexion)
Future<void> removeUserName() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_name');
}

Future<void> storeUserName(String firstName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_name', firstName);
}

Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name');
}
