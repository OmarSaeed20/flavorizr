import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/domain/entities/driver_home_data.dart';
import 'package:fast_golden_taxi/features/driver/driver_home/domain/usecases/get_driver_home_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for driver home
class DriverHomeState {
  final bool isLoading;
  final DriverHomeData? homeData;
  final String? errorMessage;

  const DriverHomeState({
    this.isLoading = false,
    this.homeData,
    this.errorMessage,
  });

  DriverHomeState copyWith({
    bool? isLoading,
    DriverHomeData? homeData,
    String? errorMessage,
  }) {
    return DriverHomeState(
      isLoading: isLoading ?? this.isLoading,
      homeData: homeData ?? this.homeData,
      errorMessage: errorMessage,
    );
  }
}

/// Controller for driver home
class DriverHomeController extends StateNotifier<DriverHomeState> {
  final GetDriverHomeData getDriverHomeData;

  DriverHomeController({required this.getDriverHomeData})
    : super(const DriverHomeState());

  /// Load complete driver home data
  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true);
    final result = await getDriverHomeData();
    result.when(
      success: (homeData, _) {
        state = state.copyWith(isLoading: false, homeData: homeData);
      },
      exception: (exception) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: exception.message,
        );
      },
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith();
  }
}
