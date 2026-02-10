import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_profile.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/repositories/driver_profile_repository.dart';

/// Use case for updating driver profile.
class UpdateDriverProfileUseCase {
  final DriverProfileRepository _repository;

  UpdateDriverProfileUseCase(this._repository);

  /// Executes the update driver profile use case.
  Future<ApiResult<DriverProfile>> call({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    String? bio,
    String? address,
    String? city,
    String? country,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return _repository.updateProfileInfo(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      profileImage: profileImage,
      bio: bio,
      address: address,
      city: city,
      country: country,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );
  }
}
