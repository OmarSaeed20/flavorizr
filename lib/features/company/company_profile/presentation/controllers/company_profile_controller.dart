// lib/features/company/company_profile/presentation/controllers/company_profile_controller.dart
import 'package:fast_golden_taxi/core/network/exception/network_exceptions.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_image_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_profile/data/parameters/update_company_profile_parameters.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/delete_company_profile_image_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/get_company_profile_detail_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/get_company_profile_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/update_company_profile_image_usecase.dart';
import 'package:fast_golden_taxi/features/company/company_profile/domain/usecases/update_company_profile_info_usecase.dart';
import 'package:fast_golden_taxi/features/user/auth/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_profile_controller.freezed.dart';

/// Company Profile State
///
/// Represents the current state of company profile.
@freezed
class CompanyProfileState with _$CompanyProfileState {
  const CompanyProfileState._();

  const factory CompanyProfileState.initial() = _Initial;

  const factory CompanyProfileState.loading() = _Loading;

  const factory CompanyProfileState.loaded(UserModel user) = _Loaded;

  const factory CompanyProfileState.error(NetworkException error) = _Error;

  const factory CompanyProfileState.updating() = _Updating;

  const factory CompanyProfileState.updated(UserModel user) = _Updated;
}

/// Company Profile Controller
///
/// Manages company profile state and operations.
/// Uses Riverpod for state management.
class CompanyProfileController extends StateNotifier<CompanyProfileState> {
  final GetCompanyProfileUseCase _getProfileUseCase;
  final GetCompanyProfileDetailUseCase _getProfileDetailUseCase;
  final UpdateCompanyProfileInfoUseCase _updateProfileInfoUseCase;
  final UpdateCompanyProfileImageUseCase _updateProfileImageUseCase;
  final DeleteCompanyProfileImageUseCase _deleteProfileImageUseCase;

  CompanyProfileController({
    required GetCompanyProfileUseCase getProfileUseCase,
    required GetCompanyProfileDetailUseCase getProfileDetailUseCase,
    required UpdateCompanyProfileInfoUseCase updateProfileInfoUseCase,
    required UpdateCompanyProfileImageUseCase updateProfileImageUseCase,
    required DeleteCompanyProfileImageUseCase deleteProfileImageUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _getProfileDetailUseCase = getProfileDetailUseCase,
       _updateProfileInfoUseCase = updateProfileInfoUseCase,
       _updateProfileImageUseCase = updateProfileImageUseCase,
       _deleteProfileImageUseCase = deleteProfileImageUseCase,
       super(const CompanyProfileState.initial());

  /// Get company profile
  Future<void> getProfile() async {
    state = const CompanyProfileState.loading();

    final result = await _getProfileUseCase.execute(null);

    result.when(
      success: (user, _) {
        state = CompanyProfileState.loaded(user);
      },
      exception: (error) {
        state = CompanyProfileState.error(error);
      },
    );
  }

  /// Get company profile detail
  Future<void> getProfileDetail() async {
    state = const CompanyProfileState.loading();

    final result = await _getProfileDetailUseCase.execute(null);

    result.when(
      success: (user, _) {
        state = CompanyProfileState.loaded(user);
      },
      exception: (error) {
        state = CompanyProfileState.error(error);
      },
    );
  }

  /// Update company profile info
  Future<void> updateProfileInfo(
    UpdateCompanyProfileParameters parameters,
  ) async {
    state = const CompanyProfileState.updating();

    final result = await _updateProfileInfoUseCase.execute(parameters);

    result.when(
      success: (user, _) {
        state = CompanyProfileState.updated(user);
      },
      exception: (error) {
        state = CompanyProfileState.error(error);
      },
    );
  }

  /// Update company profile image
  Future<void> updateProfileImage(
    UpdateCompanyProfileImageParameters parameters,
  ) async {
    state = const CompanyProfileState.updating();

    final result = await _updateProfileImageUseCase.execute(parameters);

    result.when(
      success: (user, _) {
        state = CompanyProfileState.updated(user);
      },
      exception: (error) {
        state = CompanyProfileState.error(error);
      },
    );
  }

  /// Delete company profile image
  Future<void> deleteProfileImage() async {
    state = const CompanyProfileState.updating();

    final result = await _deleteProfileImageUseCase.execute(null);

    result.when(
      success: (user, _) {
        state = CompanyProfileState.updated(user);
      },
      exception: (error) {
        state = CompanyProfileState.error(error);
      },
    );
  }

  /// Reset state to initial
  void resetState() {
    state = const CompanyProfileState.initial();
  }
}
