// lib/features/splash/presentation/providers/splash_providers.dart
import 'package:flavorizr/features/splash/data/datasources/splash_local_datasource.dart';
import 'package:flavorizr/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:flavorizr/features/splash/domain/repositories/splash_repository.dart';
import 'package:flavorizr/features/splash/domain/usecases/check_app_initialization_usecase.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== Data Sources ====================

/// Provider for SplashLocalDataSource.
final splashLocalDataSourceProvider = Provider<SplashLocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return SplashLocalDataSourceImpl(secureStorage: secureStorage, prefs: prefs);
});

// ==================== Repository ====================

/// Provider for SplashRepository.
final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  final localDataSource = ref.watch(splashLocalDataSourceProvider);
  return SplashRepositoryImpl(localDataSource: localDataSource);
});

// ==================== Use Cases ====================

/// Provider for CheckAppInitializationUseCase.
final checkAppInitializationUseCaseProvider =
    Provider<CheckAppInitializationUseCase>((ref) {
      return CheckAppInitializationUseCase(ref.watch(splashRepositoryProvider));
    });
