// lib/features/auth/otp/presentation/pages/otp_verification_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/auth/otp/presentation/controllers/otp_controller.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// OTP Verification page (Figma-accurate).
///
/// Layout:
/// - Background #F2F2F2 with back button
/// - 250x250 illustration centered
/// - Bottom sheet with title, subtitle (phone), timer, 6 OTP cells,
///   resend link, Verify & Proceed button
class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({super.key, required this.phone, this.flowContext = 'registration'});

  final String phone;
  final String flowContext;

  @override
  ConsumerState<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(AuthDesignConstants.otpCellCount, (_) => TextEditingController());
    _focusNodes = List.generate(AuthDesignConstants.otpCellCount, (_) => FocusNode());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(otpControllerProvider.notifier)
          .initialize(phone: widget.phone, flowContext: widget.flowContext);
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onCellChanged(int index, String value) {
    if (value.length == 1 && index < AuthDesignConstants.otpCellCount - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    _updateOtp();
  }

  void _onKeyDown(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      _updateOtp();
    }
  }

  void _updateOtp() {
    final otp = _controllers.map((c) => c.text).join();
    ref.read(otpControllerProvider.notifier).setOtp(otp);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpControllerProvider);

    // Listen for verification success
    ref.listen<OtpState>(otpControllerProvider, (previous, next) {
      if (next.isVerified && !(previous?.isVerified ?? false)) {
        switch (next.flowContext) {
          case OtpFlowContext.forgotPassword:
            context.go(Routes.resetPassword);
          case OtpFlowContext.registration:
          case OtpFlowContext.phoneChange:
            context.go(Routes.home);
        }
      }
    });

    return AuthScaffold(
      body: Column(
        children: [
          // ── Illustration area ──
          Expanded(
            child: Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Image.asset(
                  'assets/images/otp_verification.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.verified_user_outlined,
                    size: 120,
                    color: AuthDesignConstants.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom sheet ──
          AuthBottomSheet(
            padding: AuthDesignConstants.sheetPadding,
            children: [
              // Header with title + subtitle + timer
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'OTP Verification',
                    textAlign: TextAlign.center,
                    style: AuthDesignConstants.screenTitle,
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Enter the OTP sent to',
                          style: AuthDesignConstants.screenSubtitle,
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: state.phone,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AuthDesignConstants.fontBody,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.timerDisplay,
                    style: const TextStyle(
                      color: AuthDesignConstants.error,
                      fontSize: 14,
                      fontFamily: AuthDesignConstants.fontBody,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // OTP cells
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  AuthDesignConstants.otpCellCount,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 8,
                      right: index == AuthDesignConstants.otpCellCount - 1 ? 0 : 8,
                    ),
                    child: _OtpCell(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (v) => _onCellChanged(index, v),
                      onKeyEvent: (e) => _onKeyDown(index, e),
                      enabled: !state.isLoading,
                    ),
                  ),
                ),
              ),

              // Resend link
              GestureDetector(
                onTap: state.canResend
                    ? () => ref.read(otpControllerProvider.notifier).resend()
                    : null,
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Don't receive the code ?",
                        style: TextStyle(
                          color: AuthDesignConstants.textTertiary,
                          fontSize: 14,
                          fontFamily: AuthDesignConstants.fontBody,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(
                        text: 'RESEND CODE',
                        style: TextStyle(
                          color: state.canResend
                              ? AuthDesignConstants.primary
                              : AuthDesignConstants.textDisabled,
                          fontSize: 14,
                          fontFamily: AuthDesignConstants.fontBody,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Verify button
              AuthPrimaryButton(
                text: 'Verify & Proceed',
                isLoading: state.isLoading,
                isEnabled: state.canVerify,
                onPressed: () => ref.read(otpControllerProvider.notifier).verify(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A single OTP input cell matching Figma specs (41×49).
class _OtpCell extends StatelessWidget {
  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<RawKeyEvent> onKeyEvent;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AuthDesignConstants.otpCellWidth,
      height: AuthDesignConstants.otpCellHeight,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: onKeyEvent,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: AuthDesignConstants.fontBody,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthDesignConstants.inputBorderRadius),
              borderSide: const BorderSide(color: AuthDesignConstants.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthDesignConstants.inputBorderRadius),
              borderSide: const BorderSide(color: AuthDesignConstants.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthDesignConstants.inputBorderRadius),
              borderSide: const BorderSide(color: AuthDesignConstants.primaryVariant, width: 1.5),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
