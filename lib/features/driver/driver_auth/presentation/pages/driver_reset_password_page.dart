import 'package:flavorizr/features/driver/driver_auth/presentation/providers/driver_auth_providers.dart';
import 'package:flavorizr/features/driver/driver_auth/presentation/widgets/driver_password_input.dart';
import 'package:flavorizr/features/driver/driver_auth/presentation/widgets/driver_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for resetting driver password.
class DriverResetPasswordPage extends ConsumerStatefulWidget {
  const DriverResetPasswordPage({super.key});

  @override
  ConsumerState<DriverResetPasswordPage> createState() =>
      _DriverResetPasswordPageState();
}

class _DriverResetPasswordPageState
    extends ConsumerState<DriverResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(driverAuthControllerProvider.notifier)
          .resetPassword(
            code: _otpController.text,
            phone: _phoneController.text,
            password: _newPasswordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverAuthControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Icon(Icons.lock_reset, size: 80, color: Colors.blue),
                const SizedBox(height: 24),
                const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your phone, OTP, and new password',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                DriverPhoneInput(
                  controller: _phoneController,
                  enabled: !state.isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otpController,
                  enabled: !state.isLoading,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    hintText: 'Enter 6-digit OTP',
                    prefixIcon: Icon(Icons.sms),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter OTP';
                    }
                    if (value.length != 6) {
                      return 'OTP must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DriverPasswordInput(
                  controller: _newPasswordController,
                  enabled: !state.isLoading,
                  labelText: 'New Password',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  enabled: !state.isLoading,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your new password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ElevatedButton(
                  onPressed: state.isLoading ? null : _handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Reset Password'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
