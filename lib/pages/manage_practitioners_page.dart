import 'package:flutter/material.dart';
import 'package:gsb/constants/styles.dart';
import 'package:gsb/services/auth/api.dart' as api;
import 'package:gsb/components/praticiens.dart';

class ManagePractitionersPage extends StatefulWidget {
  const ManagePractitionersPage({super.key});

  @override
  State<ManagePractitionersPage> createState() => _ManagePractitionersPageState();
}

class _ManagePractitionersPageState extends State<ManagePractitionersPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _specialtiesController = TextEditingController();
  String? _avatarPath;
  bool _isLoading = false;
  bool _isLoadingList = true;
  List<Praticien> _praticiens = [];

  @override
  void initState() {
    super.initState();
    _loadPraticiens();
  }

  Future<void> _loadPraticiens() async {
    setState(() {
      _isLoadingList = true;
    });

    try {
      debugPrint('Loading practitioners list');
      final data = await api.getPraticiens();

      setState(() {
        _praticiens = (data as List)
            .map((item) => Praticien(
                  praticienId: item['praticien_id'],
                  firstName: item['first_name'],
                  lastName: item['last_name'],
                  specialties: item['specialties'],
                  avatarPath: item['avatarPath'],
                ))
            .toList();
        _isLoadingList = false;
      });
      debugPrint('Loaded ${_praticiens.length} practitioners');
    } catch (e) {
      debugPrint('Error loading practitioners: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: Impossible de charger les praticiens - $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isLoadingList = false;
      });
    }
  }

  Future<void> _deletePraticien(int id) async {
    try {
      debugPrint('Attempting to delete practitioner with ID: $id');
      final result = await api.removePraticien(id);

      final appointmentsRemoved = result['appointmentsRemoved'] ?? 0;
      String message = 'Praticien supprimé avec succès';
      if (appointmentsRemoved > 0) {
        message += ' ainsi que $appointmentsRemoved rendez-vous associé${appointmentsRemoved > 1 ? 's' : ''}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the list
      _loadPraticiens();
    } catch (error) {
      debugPrint('Error deleting practitioner: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmDeletePraticien(Praticien praticien) async {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vous êtes sur le point de supprimer Dr. ${praticien.firstName} ${praticien.lastName}.',
              ),
              const SizedBox(height: 12),
              const Text(
                'Cette action supprimera également tous les rendez-vous associés à ce praticien.',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              const Text('Voulez-vous vraiment continuer ?'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deletePraticien(praticien.praticienId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _specialtiesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    debugPrint('Submit form button pressed');
    if (_formKey.currentState!.validate()) {
      debugPrint('Form validation successful');

      setState(() {
        _isLoading = true;
      });

      try {
        debugPrint('Preparing practitioner data for submission');
        final data = {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'specialties': _specialtiesController.text.trim(),
          'avatarPath': _avatarPath ?? "",
        };
        debugPrint('Practitioner data: $data');

        debugPrint('Calling api.addPraticien');
        await api.addPraticien(data);
        debugPrint('api.addPraticien call completed successfully');

        if (mounted) {
          debugPrint('Showing success message');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Praticien ajouté avec succès'),
              backgroundColor: Colors.green,
            ),
          );

          // Reset form
          debugPrint('Resetting form');
          _firstNameController.clear();
          _lastNameController.clear();
          _specialtiesController.clear();
          _avatarPath = null;

          // Refresh the list
          _loadPraticiens();
        }
      } catch (error) {
        debugPrint('Error submitting form: $error');
        if (mounted) {
          debugPrint('Showing error message');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        debugPrint('Form submission process completed');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      debugPrint('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestion des praticiens',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add practitioner form
            const Text(
              'Ajouter un praticien',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir un prénom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir un nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _specialtiesController,
                    decoration: const InputDecoration(
                      labelText: 'Spécialités',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir au moins une spécialité';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Ajouter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // List of practitioners with delete option
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Praticiens existants',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                if (!_isLoadingList)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadPraticiens,
                    tooltip: 'Rafraîchir la liste',
                  ),
              ],
            ),

            const SizedBox(height: 20),

            _isLoadingList
                ? const Center(child: CircularProgressIndicator())
                : _praticiens.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Aucun praticien trouvé'),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _praticiens.length,
                        itemBuilder: (context, index) {
                          final praticien = _praticiens[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                'Dr. ${praticien.firstName} ${praticien.lastName}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(praticien.specialties),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmDeletePraticien(praticien),
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
