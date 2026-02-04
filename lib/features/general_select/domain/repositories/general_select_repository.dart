import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/general_select/domain/entities/select_option.dart';
import 'package:flavorizr/features/general_select/data/parameters/get_select_options_parameters.dart';

abstract class GeneralSelectRepository {
  Future<ApiResult<List<SelectOption>>> getSelectOptions(GetSelectOptionsParameters params);
}