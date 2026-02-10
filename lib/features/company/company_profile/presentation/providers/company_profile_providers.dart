// lib/features/company/company_profile/presentation/providers/company_profile_providers.dart
import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/datasources/company_profile_remote_datasource.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/repositories/company_profile_repository_impl.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/repositories/company_profile_repository.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/delete_company_profile_image_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/get_company_profile_detail_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/get_company_profile_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/update_company_profile_image_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/update_company_profile_info_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_profile/presentation/controllers/company_profile_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================== Data Layer Providers ====================

/// Company Profile Remote Data Source Provider
final companyProfileRemoteDataSourceProvider = Provider<CompanyProfileRemoteDataSource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return CompanyProfileRemoteDataSource(dio: dio.dio);
});

/// Company Profile Repository Provider
final companyProfileRepositoryProvider = Provider<CompanyProfileRepository>((ref) {
  final remoteDataSource = ref.watch(companyProfileRemoteDataSourceProvider);
  return CompanyProfileRepositoryImpl(remoteDataSource: remoteDataSource);
});

// ==================== Domain Layer Providers ====================

/// Get Company Profile Use Case Provider
final getCompanyProfileUseCaseProvider = Provider<GetCompanyProfileUseCase>((ref) {
  final repository = ref.watch(companyProfileRepositoryProvider);
  return GetCompanyProfileUseCase(repository);
});

/// Get Company Profile Detail Use Case Provider
final getCompanyProfileDetailUseCaseProvider = Provider<GetCompanyProfileDetailUseCase>((ref) {
  final repository = ref.watch(companyProfileRepositoryProvider);
  return GetCompanyProfileDetailUseCase(repository);
});

/// Update Company Profile Info Use Case Provider
final updateCompanyProfileInfoUseCaseProvider = Provider<UpdateCompanyProfileInfoUseCase>((ref) {
  final repository = ref.watch(companyProfileRepositoryProvider);
  return UpdateCompanyProfileInfoUseCase(repository);
});

/// Update Company Profile Image Use Case Provider
final updateCompanyProfileImageUseCaseProvider = Provider<UpdateCompanyProfileImageUseCase>((ref) {
  final repository = ref.watch(companyProfileRepositoryProvider);
  return UpdateCompanyProfileImageUseCase(repository);
});

/// Delete Company Profile Image Use Case Provider
final deleteCompanyProfileImageUseCaseProvider = Provider<DeleteCompanyProfileImageUseCase>((ref) {
  final repository = ref.watch(companyProfileRepositoryProvider);
  return DeleteCompanyProfileImageUseCase(repository);
});

// ==================== Presentation Layer Providers ====================

/// Company Profile Controller Provider
final companyProfileControllerProvider =
    StateNotifierProvider<CompanyProfileController, CompanyProfileState>((ref) {
      return CompanyProfileController(
        getProfileUseCase: ref.watch(getCompanyProfileUseCaseProvider),
        getProfileDetailUseCase: ref.watch(getCompanyProfileDetailUseCaseProvider),
        updateProfileInfoUseCase: ref.watch(updateCompanyProfileInfoUseCaseProvider),
        updateProfileImageUseCase: ref.watch(updateCompanyProfileImageUseCaseProvider),
        deleteProfileImageUseCase: ref.watch(deleteCompanyProfileImageUseCaseProvider),
      );
    });

/// Company Profile State Provider (convenience)
final companyProfileStateProvider = companyProfileControllerProvider;

/// Company User Provider
final companyUserProvider = Provider((ref) {
  final state = ref.watch(companyProfileControllerProvider);
  return state.maybeWhen(loaded: (user) => user, updated: (user) => user, orElse: () => null);
});
