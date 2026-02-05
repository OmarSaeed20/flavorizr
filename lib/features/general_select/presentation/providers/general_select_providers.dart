import 'package:flavorizr/core/di/providers.dart';
import 'package:flavorizr/features/user/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/features/general_select/data/datasources/general_select_remote_datasource.dart';
import 'package:flavorizr/features/general_select/data/repositories/general_select_repository_impl.dart';
import 'package:flavorizr/features/general_select/domain/repositories/general_select_repository.dart';
import 'package:flavorizr/features/general_select/domain/usecases/get_select_options_usecase.dart';
import 'package:flavorizr/features/general_select/presentation/controllers/general_select_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for GeneralSelectRemoteDataSource.
final generalSelectRemoteDataSourceProvider = Provider<GeneralSelectRemoteDataSource>((ref) {
  return GeneralSelectRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

/// Provider for GeneralSelectRepository.
final generalSelectRepositoryProvider = Provider<GeneralSelectRepository>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);

  final remoteDataSource = ref.watch(generalSelectRemoteDataSourceProvider);

  return GeneralSelectRepositoryImpl(remoteDataSource: remoteDataSource, networkInfo: networkInfo);
});

/// Provider for GetSelectOptionsUseCase.
final getSelectOptionsUseCaseProvider = Provider<GetSelectOptionsUseCase>((ref) {
  return GetSelectOptionsUseCase(ref.watch(generalSelectRepositoryProvider));
});

/// Provider for GeneralSelectController.
final generalSelectControllerProvider =
    StateNotifierProvider<GeneralSelectController, GeneralSelectState>((ref) {
      return GeneralSelectController(ref.watch(getSelectOptionsUseCaseProvider));
    });
