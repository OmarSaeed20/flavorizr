import 'package:flavorizr/core/network/base/repo/base_repository.dart';
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/general_select/data/datasources/general_select_remote_datasource.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_select_options_parameters.dart';
import 'package:flavorizr/features/general_select/domain/entities/select_option.dart';
import 'package:flavorizr/features/general_select/domain/repositories/general_select_repository.dart';

/// Implementation of [GeneralSelectRepository].
class GeneralSelectRepositoryImpl extends BaseRepository implements GeneralSelectRepository {
  final GeneralSelectRemoteDataSource _remoteDataSource;

  GeneralSelectRepositoryImpl({
    required GeneralSelectRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;
  final NetworkInfo _networkInfo;

  @override
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<ApiResult<List<SelectOption>>> getSelectOptions(GetSelectOptionsParameters params) async {
    final result = await executeRemoteRequest(
      request: () => _remoteDataSource.getSelectOptions(params),
    );
    return result.map(
      success: (data) => ApiResult.success(data.data.map((e) => e.toEntity()).toList()),
      exception: (error) => ApiResult.exception(error.exception),
    );
  }
}
