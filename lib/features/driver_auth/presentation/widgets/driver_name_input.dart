import 'package:flutter/material.dart';

/// Widget for driver name input (first and last name).
class DriverNameInput extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final bool enabled;

  const DriverNameInput({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: firstNameController,
            enabled: enabled,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'First Name',
              hintText: 'Enter first name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter first name';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: lastNameController,
            enabled: enabled,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              hintText: 'Enter last name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter last name';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}