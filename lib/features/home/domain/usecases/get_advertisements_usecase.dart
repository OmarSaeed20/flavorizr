import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/home/domain/entities/advertisement.dart';
import 'package:flavorizr/features/home/domain/repositories/home_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

class GetAdvertisementsUseCase implements UseCase<List<Advertisement>, NoParams> {
  GetAdvertisementsUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<ApiResult<List<Advertisement>>> call(NoParams params) {
    return _repository.getAdvertisements();
  }
}