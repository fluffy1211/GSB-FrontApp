import 'package:shared_preferences/shared_preferences.dart';

const String _tokenKey = 'auth_token';
const String _userNameKey = 'user_name';
const String _userRoleKey = 'user_role';

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
  await prefs.remove(_userNameKey);
}

Future<void> storeUserName(String firstName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userNameKey, firstName);
}

Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userNameKey);
}

// Stocker le rôle de l'utilisateur
Future<void> storeUserRole(String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userRoleKey, role);
}

// Récupérer le rôle de l'utilisateur
Future<String?> getUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userRoleKey);
}

// Supprimer le rôle de l'utilisateur (pour la déconnexion)
Future<void> removeUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_userRoleKey);
}
