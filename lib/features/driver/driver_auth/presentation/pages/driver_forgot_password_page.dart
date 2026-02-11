import 'package:fast_golden_taxi/core/router/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DriverForgotPasswordPage extends StatelessWidget {
  const DriverForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Driver Forgot Password',
      message: 'Enter your email/phone to reset driver password',
    );
  }
}
