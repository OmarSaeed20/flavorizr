import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_home/domain/entities/driver_home_data.dart';

/// Repository interface for driver home data operations
abstract class DriverHomeRepository {
  /// Get complete driver home data including stats, earnings, and recent trips
  Future<ApiResult<DriverHomeData>> getDriverHomeData();
}
