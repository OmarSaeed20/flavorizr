// lib/features/company/company_auth/presentation/widgets/company_phone_input_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fast_golden_taxi/core/theme/app_colors.dart';

/// Company Phone Input Widget
///
/// Reusable phone input widget with country code selector.
/// Used across company auth screens.
class CompanyPhoneInputWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController phoneIsoCodeController;
  final String labelText;
  final String? hintText;
  final String? Function(String?)? validator;

  const CompanyPhoneInputWidget({
    super.key,
    required this.phoneController,
    required this.phoneIsoCodeController,
    this.labelText = 'Phone Number',
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country Code
        SizedBox(
          width: 100,
          child: TextFormField(
            controller: phoneIsoCodeController,
            decoration: const InputDecoration(
              labelText: 'Code',
              hintText: 'EG',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              FilteringTextInputFormatter.allow(RegExp('[A-Z]')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              if (value.length != 2) {
                return 'Invalid';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        // Phone Number
        Expanded(
          child: TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText ?? 'Enter phone number',
              prefixIcon: const Icon(Icons.phone_outlined),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
            validator:
                validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length < 10) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
          ),
        ),
      ],
    );
  }
}
