import 'package:flutter/material.dart';
import 'package:gsb/constants/styles.dart';
import 'package:gsb/services/auth/session_manager.dart';
import 'package:gsb/services/auth/auth_service.dart';
import 'package:gsb/pages/admin.dart';

class ProfilePage extends StatefulWidget {
  final Function(int)? onNavigationRequest;

  const ProfilePage({super.key, this.onNavigationRequest});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await getUserName();
    final isUserAdmin = await AuthService.isUserAdmin();

    if (mounted) {
      setState(() {
        userName = name;
        isAdmin = isUserAdmin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon Profil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 225, 225, 225),
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // Nom d'utilisateur
            Text(
              userName ?? 'Chargement...',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // Menu d'options - Navigate to appointments tab
            _buildProfileOption(
              'Mes rendez-vous',
              Icons.calendar_today,
              () {
                // Navigate to the appointments tab (index 0)
                if (widget.onNavigationRequest != null) {
                  widget.onNavigationRequest!(0);
                }
              },
            ),

            // Admin button - only shown for admin users
            if (isAdmin)
              _buildProfileOption(
                'Administration',
                Icons.admin_panel_settings,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPage()),
                  );
                },
                isAdmin: true,
              ),

            const SizedBox(height: 30),

            // Logout button
            ElevatedButton.icon(
              onPressed: () async {
                await removeToken();
                await removeUserName();
                await removeUserRole();

                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isAdmin = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Icon(
          icon,
          size: 30,
          color: isAdmin ? Colors.red : primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isAdmin ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
