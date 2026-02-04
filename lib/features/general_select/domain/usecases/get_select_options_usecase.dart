import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/general_select/domain/entities/select_option.dart';
import 'package:flavorizr/features/general_select/domain/repositories/general_select_repository.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_select_options_parameters.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

class GetSelectOptionsUseCase implements UseCase<List<SelectOption>, GetSelectOptionsParameters> {
  GetSelectOptionsUseCase(this._repository);

  final GeneralSelectRepository _repository;

  @override
  Future<ApiResult<List<SelectOption>>> call(GetSelectOptionsParameters params) {
    return _repository.getSelectOptions(params);
  }
}