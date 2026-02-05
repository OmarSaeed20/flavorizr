import 'package:flutter/material.dart';

/// Widget for driver password input.
class DriverPasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;

  const DriverPasswordInput({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  @override
  State<DriverPasswordInput> createState() => _DriverPasswordInputState();
}

class _DriverPasswordInputState extends State<DriverPasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: widget.enabled
              ? () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                }
              : null,
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
