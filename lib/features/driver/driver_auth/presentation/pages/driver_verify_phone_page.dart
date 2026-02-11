import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/driver/driver_auth/presentation/providers/driver_auth_providers.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Page for verifying driver phone number with OTP.
class DriverVerifyPhonePage extends ConsumerStatefulWidget {
  final String phone;

  const DriverVerifyPhonePage({super.key, required this.phone});

  @override
  ConsumerState<DriverVerifyPhonePage> createState() => _DriverVerifyPhonePageState();
}

class _DriverVerifyPhonePageState extends ConsumerState<DriverVerifyPhonePage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onOtpSubmitted(int index, String value) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (_otpCode.length == 6) {
      _handleVerify();
    }
  }

  void _handleVerify() {
    if (_otpCode.length != 6) return;

    // Firebase token should be obtained from notification service
    // For now, using a placeholder token
    const firebaseToken = 'placeholder_firebase_token';
    ref
        .read(driverAuthControllerProvider.notifier)
        .verifyPhone(phone: widget.phone, code: _otpCode, firebaseToken: firebaseToken);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverAuthControllerProvider);

    return Scaffold(
      backgroundColor: AuthDesignConstants.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Top white header
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                height: 109,
                color: Colors.white,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Skip button
                        TextButton(
                          onPressed: () => context.go(Routes.home),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: AuthDesignConstants.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            Positioned.fill(
              top: 109,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 37),

                    // OTP illustration/icon
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sms_outlined,
                        size: 120,
                        color: AuthDesignConstants.primary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Bottom sheet with form
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: [AuthDesignConstants.bottomSheetShadow],
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          const Text(
                            'OTP Verification',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AuthDesignConstants.textPrimary,
                              fontFamily: AuthDesignConstants.fontHeadings,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            'Enter the 6-digit code sent to\n${widget.phone}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AuthDesignConstants.textTertiary,
                              fontFamily: AuthDesignConstants.fontBody,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // OTP Input Fields
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 48,
                                height: 56,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  enabled: !state.isLoading,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: AuthDesignConstants.textPrimary,
                                    fontFamily: AuthDesignConstants.fontHeadings,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor: AuthDesignConstants.inputBorder,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: AuthDesignConstants.primary,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: AuthDesignConstants.error,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) => _onOtpChanged(index, value),
                                  onSubmitted: (value) => _onOtpSubmitted(index, value),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 24),

                          // Error message
                          if (state.error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 16,
                                    color: AuthDesignConstants.error,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      state.error!,
                                      style: const TextStyle(
                                        color: AuthDesignConstants.error,
                                        fontSize: 14,
                                        fontFamily: AuthDesignConstants.fontBody,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Verify button
                          SizedBox(
                            width: double.infinity,
                            height: AuthDesignConstants.buttonHeight,
                            child: ElevatedButton(
                              onPressed: state.isLoading || _otpCode.length != 6
                                  ? null
                                  : _handleVerify,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AuthDesignConstants.primary,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AuthDesignConstants.buttonBorderRadius,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: state.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                      ),
                                    )
                                  : const Text(
                                      'Verify',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AuthDesignConstants.fontHeadings,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Resend section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                  color: AuthDesignConstants.textTertiary,
                                  fontSize: 14,
                                  fontFamily: AuthDesignConstants.fontBody,
                                ),
                              ),
                              TextButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        // Resend OTP logic
                                      },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Resend',
                                  style: TextStyle(
                                    color: AuthDesignConstants.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AuthDesignConstants.fontBody,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom home indicator
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 32,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
