import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:flutter/cupertino.dart';

class SymptomsDropdown extends StatelessWidget {
  final MultiSelectController<String>? controller;
  final Function(List<String>)? onSelectionChange;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SymptomsDropdown({super.key, this.controller, this.onSelectionChange});

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
      padding: const EdgeInsets.all(6),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MultiDropdown<String>(
              items: items,
              controller: controller,
              maxSelections: 3,
              enabled: true,
              searchEnabled: false,
              chipDecoration: const ChipDecoration(
                backgroundColor: Colors.green,
                wrap: true,
                runSpacing: 2,
                spacing: 10,
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
                maxHeight: 305,
                header: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Séléctionnez vos symptômes',
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
                  return 'Please select a country';
                }
                return null;
              },
              onSelectionChange: (selectedItems) {
                debugPrint("OnSelectionChange: $selectedItems");
              },
            ),
          ],
        ),
      ),
    );
  }
}
