import 'package:fast_golden_taxi/features/driver/driver_auth/presentation/providers/driver_auth_providers.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/presentation/widgets/driver_password_input.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/presentation/widgets/driver_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for driver login.
class DriverLoginPage extends ConsumerStatefulWidget {
  const DriverLoginPage({super.key});

  @override
  ConsumerState<DriverLoginPage> createState() => _DriverLoginPageState();
}

class _DriverLoginPageState extends ConsumerState<DriverLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(driverAuthControllerProvider.notifier)
          .login(
            phone: _phoneController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverAuthControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Driver Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Icon(Icons.taxi_alert, size: 80, color: Colors.blue),
                const SizedBox(height: 24),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue as a driver',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
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
                  onPressed: state.isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            '/driver/forgot-password',
                          );
                        },
                  child: const Text('Forgot Password?'),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              Navigator.pushNamed(context, '/driver/register');
                            },
                      child: const Text('Register'),
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
