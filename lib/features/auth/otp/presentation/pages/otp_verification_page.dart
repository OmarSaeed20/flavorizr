// lib/features/auth/otp/presentation/pages/otp_verification_page.dart
import 'package:fast_golden_taxi/core/router/routes.dart';
import 'package:fast_golden_taxi/features/auth/otp/presentation/controllers/otp_controller.dart';
import 'package:fast_golden_taxi/l10n/app_localizations.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// OTP Verification page (Figma-accurate).
///
/// Layout:
/// - Background #F2F2F2 with back button
/// - 250x250 illustration centered
/// - Bottom sheet with title, subtitle (phone), timer, 6 OTP cells,
///   resend link, Verify & Proceed button
class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({
    super.key,
    required this.phone,
    this.flowContext = 'registration',
    required this.role,
  });

  final String role;
  final String phone;
  final String flowContext;

  @override
  ConsumerState<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(otpControllerProvider.notifier)
          .initialize(phone: widget.phone, flowContext: widget.flowContext);
    });
  }

  void _onOtpChanged(String otp) {
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
            context.go(Routes.resetPassword, extra: {'phone': widget.phone, 'otp': next.otp});
          case OtpFlowContext.driverForgotPassword:
            context.go(Routes.driverResetPassword, extra: {'phone': widget.phone, 'otp': next.otp});
          case OtpFlowContext.companyForgotPassword:
            context.go(Routes.companyResetPassword, extra: {'phone': widget.phone, 'otp': next.otp});
          case OtpFlowContext.driverRegistration:
          case OtpFlowContext.driverAuth:
            context.go(Routes.driverHome);
          case OtpFlowContext.companyRegistration:
          case OtpFlowContext.companyAuth:
            context.go(Routes.companyDashboard);
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
                  Text(
                    AppLocalizations.of(context)!.otpVerification,
                    textAlign: TextAlign.center,
                    style: AuthDesignConstants.screenTitle,
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.otpSubtitle,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PinCodeTextField(
                  appContext: context,
                  length: AuthDesignConstants.otpCellCount,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(AuthDesignConstants.inputBorderRadius),
                    fieldHeight: AuthDesignConstants.otpCellHeight,
                    fieldWidth: AuthDesignConstants.otpCellWidth,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: AuthDesignConstants.primaryVariant,
                    inactiveColor: AuthDesignConstants.inputBorder,
                    selectedColor: AuthDesignConstants.primaryVariant,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: TextEditingController(),
                  onCompleted: (v) {
                    ref.read(otpControllerProvider.notifier).setOtp(v);
                  },
                  onChanged: _onOtpChanged,
                  beforeTextPaste: (text) {
                    return true;
                  },
                  enabled: !state.isLoading,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: AuthDesignConstants.fontBody,
                    fontWeight: FontWeight.w500,
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
                      TextSpan(
                        text: AppLocalizations.of(context)!.didntReceiveCode,
                        style: const TextStyle(
                          color: AuthDesignConstants.textTertiary,
                          fontSize: 14,
                          fontFamily: AuthDesignConstants.fontBody,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(
                        text: AppLocalizations.of(context)!.resend,
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
                text: AppLocalizations.of(context)!.verify,
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
