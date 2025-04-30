import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Ajouter cet import
import 'package:multi_dropdown/multi_dropdown.dart';
import '../constants/styles.dart';

class SymptomsDropdown extends StatefulWidget {
  final MultiSelectController<String>? controller;
  final Function(List<String>)? onSelectionChange;

  const SymptomsDropdown({super.key, this.controller, this.onSelectionChange});

  @override
  State<SymptomsDropdown> createState() => _SymptomsDropdownState();
}

class _SymptomsDropdownState extends State<SymptomsDropdown> {
  final _formKey = GlobalKey<FormState>();
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    var items = [
      DropdownItem(label: 'Fièvre', value: 'Fièvre'),
      DropdownItem(label: 'Douleur', value: 'Douleur'),
      DropdownItem(label: 'Fatigue', value: 'Fatigue'),
      DropdownItem(label: 'Toux', value: 'Toux'),
      DropdownItem(label: 'Nausées', value: 'Nausées'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2), // Réduit de 6 à 2
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MultiDropdown<String>(
              items: items,
              controller: widget.controller,
              maxSelections: 3,
              enabled: true,
              searchEnabled: false,
              chipDecoration: ChipDecoration(
                backgroundColor: primaryColor,
                wrap: true,
                runSpacing: 2,
                spacing: 10,
                labelStyle: const TextStyle(color: Colors.white),
              ),
              fieldDecoration: FieldDecoration(
                hintText: 'Symptômes',
                hintStyle: const TextStyle(color: Colors.black87),
                prefixIcon: const Icon(CupertinoIcons.thermometer),
                showClearIcon: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.black87,
                  ),
                ),
              ),
              dropdownDecoration: const DropdownDecoration(
                maxHeight: 325,
                header: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Sélectionnez vos symptômes',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              dropdownItemDecoration: DropdownItemDecoration(
                selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                selectedBackgroundColor: Colors.transparent,
                disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner au moins un symptôme';
                }
                return null;
              },
              onSelectionChange: (selectedItems) {
                if (widget.onSelectionChange != null) {
                  widget.onSelectionChange!(selectedItems);
                }
                if (mounted && !_isOpen) {
                  setState(() => _isOpen = true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
