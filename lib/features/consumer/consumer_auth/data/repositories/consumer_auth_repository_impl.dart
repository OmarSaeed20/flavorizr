// lib/features/consumer/consumer_auth/data/repositories/consumer_auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:fast_golden_taxi/core/error/failures.dart';
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/datasources/consumer_auth_local_datasource.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/datasources/consumer_auth_remote_datasource.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_forget_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_login_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_logout_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_register_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_reset_password_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_send_verification_code_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/data/parameters/consumer_verify_phone_parameters.dart';
import 'package:fast_golden_taxi/features/consumer/consumer_auth/domain/repositories/consumer_auth_repository.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_result.dart';
import 'package:fast_golden_taxi/features/user/auth/domain/entities/auth_tokens.dart';

/// Implementation of [ConsumerAuthRepository].
///
/// Combines remote and local data sources with error handling.
/// Implements caching strategy for offline support.
class ConsumerAuthRepositoryImpl implements ConsumerAuthRepository {
  const ConsumerAuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final ConsumerAuthRemoteDataSource remoteDataSource;
  final ConsumerAuthLocalDataSource localDataSource;

  @override
  Future<Either<Failure, AuthResult>> login(
    ConsumerLoginParameters parameters,
  ) async {
    try {
      final result = await remoteDataSource.login(parameters);

      return result.when(
        success: (authResult, _) async {
          // Save tokens and user data locally
          await localDataSource.saveTokens(authResult.tokens);
          await localDataSource.saveUser(authResult.user.toModel());
          return Right(authResult);
        },
        exception: (exception) => Left(exception.toFailure()),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> register(
    ConsumerRegisterParameters parameters,
  ) async {
    try {
      final result = await remoteDataSource.register(parameters);

      return result.when(
        success: (authResult, _) async {
          // Save tokens and user data locally
          await localDataSource.saveTokens(authResult.tokens);
          await localDataSource.saveUser(authResult.user.toModel());
          return Right(authResult);
        },
        exception: (exception) => Left(exception.toFailure()),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout(
    ConsumerLogoutParameters parameters,
  ) async {
    try {
      final result = await remoteDataSource.logout(parameters);

      return result.when(
        success: (_, __) async {
          // Clear local data
          await localDataSource.clearTokens();
          await localDataSource.clearUser();
          return const Right(null);
        },
        exception: (exception) async {
          // Even if logout fails, clear local data
          await localDataSource.clearTokens();
          await localDataSource.clearUser();
          return Left(exception.toFailure());
        },
      );
    } catch (e) {
      // Clear local data even on error
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendVerificationCode(
    ConsumerSendVerificationCodeParameters parameters,
  ) async {
    try {
      final result = await remoteDataSource.sendVerificationCode(parameters);

      return result.when(
        success: (_, __) => const Right(null),
        exception: (exception) => Left(exception.toFailure()),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> verifyPhone(
    ConsumerVerifyPhoneParameters parameters,
  ) async {
    try {
      final result = await remoteDataSource.verifyPhone(parameters);

      return result.when(
        success: (authResult, _) async {
          // Save tokens and user data locally
          await localDataSource.saveTokens(authResult.tokens);
          await localDataSource.saveUser(authResult.user.toModel());
          return Right(authResult);
        },
        exception: (exception) => Left(exception.toFailure()),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    ConsumerResetPasswordParameters parameters,
  ) async {
    try {
      final result = await remoteDataSource.resetPassword(parameters);

      return result.when(
        success: (_, __) => const Right(null),
        exception: (exception) => Left(exception.toFailure()),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword(
    ConsumerForgetPasswordParameters parameters,
  ) async {
    try {
      final result = await remoteDataSource.forgetPassword(parameters);

      return result.when(
        success: (_, __) => const Right(null),
        exception: (exception) => Left(exception.toFailure()),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      // Try to get from local cache first
      final cachedUser = await localDataSource.getUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      // If not in cache, fetch from remote
      final result = await remoteDataSource.getCurrentUser();

      return result.when(
        success: (user, _) async {
          // Cache the user data
          await localDataSource.saveUser(user);
          return Right(user);
        },
        exception: (exception) => Left(exception.toFailure()),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOutAllDevices() async {
    try {
      final result = await remoteDataSource.signOutAllDevices();

      return result.when(
        success: (_, __) async {
          // Clear local data
          await localDataSource.clearTokens();
          await localDataSource.clearUser();
          return const Right(null);
        },
        exception: (exception) async {
          // Even if sign out fails, clear local data
          await localDataSource.clearTokens();
          await localDataSource.clearUser();
          return Left(exception.toFailure());
        },
      );
    } catch (e) {
      // Clear local data even on error
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return const Left(
          UnauthorizedFailure(message: 'No refresh token available'),
        );
      }

      final result = await remoteDataSource.refreshToken(refreshToken);

      return result.when(
        success: (tokens, _) async {
          // Save new tokens
          await localDataSource.saveTokens(tokens);
          return Right(tokens);
        },
        exception: (exception) => Left(exception.toFailure()),
      );
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final isAuth = await localDataSource.isAuthenticated();
      return Right(isAuth);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() async {
    try {
      final isCompleted = await localDataSource.isOnboardingCompleted();
      return Right(isCompleted);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setOnboardingCompleted(bool completed) async {
    try {
      await localDataSource.setOnboardingCompleted(completed);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveBiometricCredentials(
    String phone,
    String password,
  ) async {
    try {
      await localDataSource.saveBiometricCredentials(phone, password);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>?>>
  getBiometricCredentials() async {
    try {
      final credentials = await localDataSource.getBiometricCredentials();
      return Right(credentials);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearBiometricCredentials() async {
    try {
      await localDataSource.clearBiometricCredentials();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
