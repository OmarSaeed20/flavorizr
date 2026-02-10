// lib/features/consumer/consumer_auth/presentation/providers/consumer_auth_providers.dart
import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/datasources/consumer_auth_local_datasource.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/datasources/consumer_auth_remote_datasource.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/repositories/consumer_auth_repository_impl.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/usecases/consumer_biometric_auth_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/usecases/consumer_forget_password_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/usecases/consumer_get_current_user_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/usecases/consumer_login_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/usecases/consumer_logout_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/usecases/consumer_register_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/usecases/consumer_reset_password_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/usecases/consumer_send_verification_code_usecase.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/usecases/consumer_verify_phone_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==================== Data Sources ====================

/// Provider for FlutterSecureStorage.
final consumerSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

/// Provider for SharedPreferences.
final consumerSharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return SharedPreferences.getInstance();
});

/// Provider for ConsumerAuthRemoteDataSource.
final consumerAuthRemoteDataSourceProvider =
    Provider<ConsumerAuthRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return ConsumerAuthRemoteDataSourceImpl(apiClient);
    });

/// Provider for ConsumerAuthLocalDataSource.
final consumerAuthLocalDataSourceProvider =
    Provider<ConsumerAuthLocalDataSource>((ref) {
      final secureStorage = ref.watch(consumerSecureStorageProvider);
      final sharedPreferences = ref
          .watch(consumerSharedPreferencesProvider)
          .value;

      if (sharedPreferences == null) {
        throw StateError('SharedPreferences not initialized');
      }

      return ConsumerAuthLocalDataSourceImpl(
        secureStorage: secureStorage,
        sharedPreferences: sharedPreferences,
      );
    });

// ==================== Repository ====================

/// Provider for ConsumerAuthRepository.
final consumerAuthRepositoryProvider = Provider<ConsumerAuthRepository>((ref) {
  final remoteDataSource = ref.watch(consumerAuthRemoteDataSourceProvider);
  final localDataSource = ref.watch(consumerAuthLocalDataSourceProvider);

  return ConsumerAuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// ==================== Use Cases ====================

/// Provider for ConsumerLoginUseCase.
final consumerLoginUseCaseProvider = Provider<ConsumerLoginUseCase>((ref) {
  final repository = ref.watch(consumerAuthRepositoryProvider);
  return ConsumerLoginUseCase(repository);
});

/// Provider for ConsumerRegisterUseCase.
final consumerRegisterUseCaseProvider = Provider<ConsumerRegisterUseCase>((
  ref,
) {
  final repository = ref.watch(consumerAuthRepositoryProvider);
  return ConsumerRegisterUseCase(repository);
});

/// Provider for ConsumerVerifyPhoneUseCase.
final consumerVerifyPhoneUseCaseProvider = Provider<ConsumerVerifyPhoneUseCase>(
  (ref) {
    final repository = ref.watch(consumerAuthRepositoryProvider);
    return ConsumerVerifyPhoneUseCase(repository);
  },
);

/// Provider for ConsumerSendVerificationCodeUseCase.
final consumerSendVerificationCodeUseCaseProvider =
    Provider<ConsumerSendVerificationCodeUseCase>((ref) {
      final repository = ref.watch(consumerAuthRepositoryProvider);
      return ConsumerSendVerificationCodeUseCase(repository);
    });

/// Provider for ConsumerForgetPasswordUseCase.
final consumerForgetPasswordUseCaseProvider =
    Provider<ConsumerForgetPasswordUseCase>((ref) {
      final repository = ref.watch(consumerAuthRepositoryProvider);
      return ConsumerForgetPasswordUseCase(repository);
    });

/// Provider for ConsumerResetPasswordUseCase.
final consumerResetPasswordUseCaseProvider =
    Provider<ConsumerResetPasswordUseCase>((ref) {
      final repository = ref.watch(consumerAuthRepositoryProvider);
      return ConsumerResetPasswordUseCase(repository);
    });

/// Provider for ConsumerLogoutUseCase.
final consumerLogoutUseCaseProvider = Provider<ConsumerLogoutUseCase>((ref) {
  final repository = ref.watch(consumerAuthRepositoryProvider);
  return ConsumerLogoutUseCase(repository);
});

/// Provider for ConsumerGetCurrentUserUseCase.
final consumerGetCurrentUserUseCaseProvider =
    Provider<ConsumerGetCurrentUserUseCase>((ref) {
      final repository = ref.watch(consumerAuthRepositoryProvider);
      return ConsumerGetCurrentUserUseCase(repository);
    });

/// Provider for ConsumerBiometricAuthUseCase.
final consumerBiometricAuthUseCaseProvider =
    Provider<ConsumerBiometricAuthUseCase>((ref) {
      final repository = ref.watch(consumerAuthRepositoryProvider);
      return ConsumerBiometricAuthUseCase(repository);
    });
