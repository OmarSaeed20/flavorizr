// lib/features/consumer/consumer_auth/presentation/widgets/consumer_phone_input_widget.dart
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Phone input widget with country code selector.
///
/// Provides a unified phone input field with country code dropdown.
/// Used across consumer auth screens.
class ConsumerPhoneInputWidget extends StatelessWidget {
  const ConsumerPhoneInputWidget({
    super.key,
    required this.phoneController,
    required this.phoneIsoCodeController,
    this.onCountryCodeChanged,
    this.validator,
  });

  final TextEditingController phoneController;
  final TextEditingController phoneIsoCodeController;
  final void Function(String)? onCountryCodeChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      children: [
        // Country code dropdown
        Container(
          width: 80.w,
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: phoneIsoCodeController.text,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              isDense: true,
              items: const [
                DropdownMenuItem(value: 'EG', child: Text('+20')),
                DropdownMenuItem(value: 'SA', child: Text('+966')),
                DropdownMenuItem(value: 'AE', child: Text('+971')),
                DropdownMenuItem(value: 'KW', child: Text('+965')),
                DropdownMenuItem(value: 'QA', child: Text('+974')),
                DropdownMenuItem(value: 'BH', child: Text('+973')),
                DropdownMenuItem(value: 'OM', child: Text('+968')),
                DropdownMenuItem(value: 'JO', child: Text('+962')),
                DropdownMenuItem(value: 'LB', child: Text('+961')),
                DropdownMenuItem(value: 'US', child: Text('+1')),
              ],
              onChanged: (value) {
                if (value != null) {
                  phoneIsoCodeController.text = value;
                  onCountryCodeChanged?.call(value);
                }
              },
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Phone number input
        Expanded(
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.phoneNumber,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            validator:
                validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.phoneNumberRequired;
                  }
                  if (value.length < 10) {
                    return l10n.invalidPhoneNumber;
                  }
                  return null;
                },
          ),
        ),
      ],
    );
  }
}
