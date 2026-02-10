import 'package:fast_golden_taxi/core/di/providers.dart';
import 'package:fast_golden_taxi/features/general_select/data/datasources/general_select_local_datasource.dart';
import 'package:fast_golden_taxi/features/general_select/data/datasources/general_select_remote_datasource.dart';
import 'package:fast_golden_taxi/features/general_select/data/repositories/general_select_repository_impl.dart';
import 'package:fast_golden_taxi/features/general_select/domain/repositories/general_select_repository.dart';
import 'package:fast_golden_taxi/features/general_select/domain/usecases/general_select_usecases.dart';
import 'package:fast_golden_taxi/features/general_select/presentation/controllers/general_select_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for GeneralSelectRemoteDataSource.
final generalSelectRemoteDataSourceProvider =
    Provider<GeneralSelectRemoteDataSource>((ref) {
      return GeneralSelectRemoteDataSourceImpl(ref.watch(apiClientProvider));
    });

/// Provider for GeneralSelectLocalDataSource.
final generalSelectLocalDataSourceProvider =
    Provider<GeneralSelectLocalDataSource>((ref) {
      return const GeneralSelectLocalDataSourceImpl();
    });

/// Provider for GeneralSelectRepository.
final generalSelectRepositoryProvider = Provider<GeneralSelectRepository>((
  ref,
) {
  final networkInfo = ref.watch(networkInfoProvider);
  final remoteDataSource = ref.watch(generalSelectRemoteDataSourceProvider);
  final localDataSource = ref.watch(generalSelectLocalDataSourceProvider);

  return GeneralSelectRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

/// Provider for GetSelectOptionsUseCase.
final getSelectOptionsUseCaseProvider = Provider<GetSelectOptionsUseCase>((
  ref,
) {
  return GetSelectOptionsUseCase(ref.watch(generalSelectRepositoryProvider));
});

/// Provider for GeneralSelectController.
final generalSelectControllerProvider =
    StateNotifierProvider<GeneralSelectController, GeneralSelectState>((ref) {
      return GeneralSelectController(
        ref.watch(getSelectOptionsUseCaseProvider),
      );
    });
