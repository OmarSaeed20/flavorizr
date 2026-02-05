import 'package:flavorizr/features/driver/driver_auth/presentation/providers/driver_auth_providers.dart';
import 'package:flavorizr/features/driver/driver_auth/presentation/widgets/driver_email_input.dart';
import 'package:flavorizr/features/driver/driver_auth/presentation/widgets/driver_name_input.dart';
import 'package:flavorizr/features/driver/driver_auth/presentation/widgets/driver_password_input.dart';
import 'package:flavorizr/features/driver/driver_auth/presentation/widgets/driver_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for driver registration.
class DriverRegisterPage extends ConsumerStatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  ConsumerState<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends ConsumerState<DriverRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(driverAuthControllerProvider.notifier)
          .register(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverAuthControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Driver Registration')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Icon(Icons.person_add, size: 80, color: Colors.blue),
                const SizedBox(height: 24),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Join as a driver',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                DriverNameInput(
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  enabled: !state.isLoading,
                ),
                const SizedBox(height: 16),
                DriverEmailInput(
                  controller: _emailController,
                  enabled: !state.isLoading,
                ),
                const SizedBox(height: 16),
                DriverPhoneInput(
                  controller: _phoneController,
                  enabled: !state.isLoading,
                ),
                const SizedBox(height: 16),
                DriverPasswordInput(
                  controller: _passwordController,
                  enabled: !state.isLoading,
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
                  onPressed: state.isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
