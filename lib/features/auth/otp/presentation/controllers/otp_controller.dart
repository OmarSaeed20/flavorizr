// lib/features/auth/otp/presentation/controllers/otp_controller.dart
import 'dart:async';

import 'package:fast_golden_taxi/features/user/auth/data/parameters/send_otp_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/data/parameters/verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/repositories/auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:fast_golden_taxi/shared/presentation/widgets/auth/auth_design_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Flow context for OTP verification.
enum OtpFlowContext {
  registration('registration'),
  forgotPassword('forgot-password'),
  phoneChange('phone-change');

  const OtpFlowContext(this.value);
  final String value;

  static OtpFlowContext fromString(String? value) {
    return OtpFlowContext.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OtpFlowContext.registration,
    );
  }
}

/// State for OTP verification.
class OtpState {
  const OtpState({
    this.phone = '',
    this.otp = '',
    this.isLoading = false,
    this.isVerified = false,
    this.errorMessage,
    this.remainingSeconds = AuthDesignConstants.otpResendTimerSeconds,
    this.canResend = false,
    this.flowContext = OtpFlowContext.registration,
  });

  final String phone;
  final String otp;
  final bool isLoading;
  final bool isVerified;
  final String? errorMessage;
  final int remainingSeconds;
  final bool canResend;
  final OtpFlowContext flowContext;

  bool get canVerify => otp.length == AuthDesignConstants.otpCellCount && !isLoading;

  String get timerDisplay {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  OtpState copyWith({
    String? phone,
    String? otp,
    bool? isLoading,
    bool? isVerified,
    String? errorMessage,
    int? remainingSeconds,
    bool? canResend,
    OtpFlowContext? flowContext,
    bool clearError = false,
  }) {
    return OtpState(
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      canResend: canResend ?? this.canResend,
      flowContext: flowContext ?? this.flowContext,
    );
  }
}

/// Controller for OTP verification screen.
class OtpController extends AutoDisposeNotifier<OtpState> {
  Timer? _timer;
  late final AuthRepository _repository;

  @override
  OtpState build() {
    _repository = ref.watch(authRepositoryProvider);
    ref.onDispose(_disposeTimer);
    return const OtpState();
  }

  void _disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Initialize with phone number and flow context.
  void initialize({required String phone, required String flowContext}) {
    state = state.copyWith(phone: phone, flowContext: OtpFlowContext.fromString(flowContext));
    _startTimer();
  }

  /// Update the OTP value as user types.
  void setOtp(String otp) {
    state = state.copyWith(otp: otp, clearError: true);
  }

  /// Start the countdown timer.
  void _startTimer() {
    _disposeTimer();
    state = state.copyWith(
      remainingSeconds: AuthDesignConstants.otpResendTimerSeconds,
      canResend: false,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.remainingSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(remainingSeconds: 0, canResend: true);
      } else {
        state = state.copyWith(remainingSeconds: remaining);
      }
    });
  }

  /// Verify the entered OTP.
  Future<void> verify() async {
    if (!state.canVerify) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Firebase token should be obtained from notification service
      // For now, using a placeholder token
      const firebaseToken = 'placeholder_firebase_token';

      final params = VerifyPhoneParameters(
        phone: state.phone,
        verificationCode: state.otp,
        firebaseToken: firebaseToken,
      );

      final result = await _repository.verifyPhone(params);

      if (result.error != null) {
        state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
      } else {
        state = state.copyWith(isLoading: false, isVerified: true);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Verification failed. Please try again.',
      );
    }
  }

  /// Resend OTP code.
  Future<void> resend() async {
    if (!state.canResend) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final params = SendOtpParameters(phoneNumber: state.phone);
      final result = await _repository.sendOtp(params);

      if (result.error != null) {
        state = state.copyWith(isLoading: false, errorMessage: result.error!.message);
      } else {
        state = state.copyWith(isLoading: false, otp: '');
        _startTimer();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to resend code. Please try again.',
      );
    }
  }
}

/// Provider for the OTP controller.
final otpControllerProvider = AutoDisposeNotifierProvider<OtpController, OtpState>(
  OtpController.new,
);
