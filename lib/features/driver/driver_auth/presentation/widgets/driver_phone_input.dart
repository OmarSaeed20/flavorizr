import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget for driver phone number input.
class DriverPhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const DriverPhoneInput({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
      ],
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Enter your phone number',
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (value.length < 10) {
          return 'Phone number must be at least 10 digits';
        }
        return null;
      },
    );
  }
}