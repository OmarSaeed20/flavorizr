// lib/features/company/company_auth/presentation/pages/company_register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fast_golden_taxi/core/theme/app_colors.dart';
import 'package:fast_golden_taxi/core/theme/app_text_styles.dart';
import 'package:fast_golden_taxi/features/company/company_auth/data/parameters/company_register_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/controllers/company_auth_controller.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/providers/company_auth_providers.dart';
import 'package:fast_golden_taxi/features/company/company_auth/presentation/widgets/company_phone_input_widget.dart';
import 'package:fast_golden_taxi/shared/widgets/loading_overlay.dart';

/// Company Register Page
///
/// Registration page for new company accounts.
/// Collects company information and account details.
class CompanyRegisterPage extends ConsumerStatefulWidget {
  const CompanyRegisterPage({super.key});

  @override
  ConsumerState<CompanyRegisterPage> createState() => _CompanyRegisterPageState();
}

class _CompanyRegisterPageState extends ConsumerState<CompanyRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phoneIsoCodeController = TextEditingController(text: 'EG');
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _birthdateController = TextEditingController();
  String _selectedGender = 'male';
  final int _selectedCountryId = 1; // TODO: Load from API
  final int _selectedGovernorateId = 1; // TODO: Load from API
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    _phoneIsoCodeController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please agree to the terms and conditions'),
          backgroundColor: AppColors.of(context).error,
        ),
      );
      return;
    }

    final parameters = CompanyRegisterParameters(
      companyType: 'company',
      name: _nameController.text.trim(),
      nickname: _nicknameController.text.trim().isEmpty ? null : _nicknameController.text.trim(),
      phone: _phoneController.text.trim(),
      phoneIso2Code: _phoneIsoCodeController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _passwordConfirmationController.text,
      countryId: _selectedCountryId,
      governorateId: _selectedGovernorateId,
      birthdate: _birthdateController.text,
      gender: _selectedGender,
    );

    await ref.read(companyAuthControllerProvider.notifier).register(parameters);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(companyAuthControllerProvider);

    ref.listen<CompanyAuthState>(companyAuthControllerProvider, (previous, next) {
      next.maybeWhen(
        authenticated: () {
          context.go('/company/home');
        },
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message), backgroundColor: AppColors.of(context).error),
          );
        },
        orElse: () {},
      );
    });

    final isLoading = authState.maybeWhen(loading: () => true, orElse: () => false);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      'Company Registration',
                      style: AppTextStyles.of(context).headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your company account to manage your fleet',
                      style: AppTextStyles.of(
                        context,
                      ).bodyMedium.copyWith(color: AppColors.of(context).textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Company Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        hintText: 'Enter company name',
                        prefixIcon: Icon(Icons.business_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter company name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Nickname (Optional)
                    TextFormField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(
                        labelText: 'Nickname (Optional)',
                        hintText: 'Enter nickname',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Phone Input
                    CompanyPhoneInputWidget(
                      phoneController: _phoneController,
                      phoneIsoCodeController: _phoneIsoCodeController,
                    ),
                    const SizedBox(height: 16),
                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password Confirmation
                    TextFormField(
                      controller: _passwordConfirmationController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Birthdate
                    TextFormField(
                      controller: _birthdateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Birthdate',
                        hintText: 'Select birthdate',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: _selectBirthdate,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select birthdate';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Gender
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          const Text('Male'),
                          const SizedBox(width: 24),
                          Radio<String>(
                            value: 'female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          const Text('Female'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Terms and Conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Wrap(
                            children: [
                              const Text('I agree to the '),
                              TextButton(
                                onPressed: () {
                                  // TODO: Show terms and conditions
                                },
                                child: const Text('Terms and Conditions'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Register Button
                    ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTextStyles.of(context).bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            context.pop();
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
          if (isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }
}
