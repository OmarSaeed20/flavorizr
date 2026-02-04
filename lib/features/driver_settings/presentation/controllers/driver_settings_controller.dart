import 'package:flavorizr/features/driver_settings/data/parameters/update_driver_settings_parameters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver_settings/domain/entities/driver_settings.dart';
import 'package:flavorizr/features/driver_settings/domain/usecases/get_driver_settings_usecase.dart';
import 'package:flavorizr/features/driver_settings/domain/usecases/toggle_availability_status_usecase.dart';
import 'package:flavorizr/features/driver_settings/domain/usecases/toggle_online_status_usecase.dart';
import 'package:flavorizr/features/driver_settings/domain/usecases/update_driver_settings_usecase.dart';

/// State for driver settings operations.
class DriverSettingsState {
  final DriverSettings? settings;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  const DriverSettingsState({
    this.settings,
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
  });

  DriverSettingsState copyWith({
    DriverSettings? settings,
    bool? isLoading,
    bool? isUpdating,
    String? error,
  }) {
    return DriverSettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
    );
  }
}

/// Controller for managing driver settings operations.
class DriverSettingsController extends StateNotifier<DriverSettingsState> {
  final GetDriverSettingsUseCase _getDriverSettingsUseCase;
  final UpdateDriverSettingsUseCase _updateDriverSettingsUseCase;
  final ToggleOnlineStatusUseCase _toggleOnlineStatusUseCase;
  final ToggleAvailabilityStatusUseCase _toggleAvailabilityStatusUseCase;

  DriverSettingsController(
    this._getDriverSettingsUseCase,
    this._updateDriverSettingsUseCase,
    this._toggleOnlineStatusUseCase,
    this._toggleAvailabilityStatusUseCase,
  ) : super(const DriverSettingsState());

  /// Gets driver settings.
  Future<void> getDriverSettings() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getDriverSettingsUseCase();

    result.when(
      success: (data, i) {
        state = state.copyWith(settings: data, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Updates driver settings.
  Future<void> updateDriverSettings({
    bool? isOnline,
    bool? isAvailable,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? preferredVehicleType,
    double? maxDistance,
    String? language,
    String? currency,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);

    final result = await _updateDriverSettingsUseCase(
      UpdateDriverSettingsParameters(
        isOnline: isOnline,
        isAvailable: isAvailable,
        notificationsEnabled: notificationsEnabled,
        soundEnabled: soundEnabled,
        vibrationEnabled: vibrationEnabled,
        preferredVehicleType: preferredVehicleType,
        maxDistance: maxDistance,
        language: language,
        currency: currency,
      ),
    );

    result.when(
      success: (data, i) {
        state = state.copyWith(settings: data, isUpdating: false);
      },
      exception: (error) {
        state = state.copyWith(isUpdating: false, error: error.message);
      },
    );
  }

  /// Toggles online status.
  Future<void> toggleOnlineStatus(bool isOnline) async {
    state = state.copyWith(isUpdating: true, error: null);

    final result = await _toggleOnlineStatusUseCase(isOnline);

    result.when(
      success: (data, i) {
        state = state.copyWith(settings: data, isUpdating: false);
      },
      exception: (error) {
        state = state.copyWith(isUpdating: false, error: error.message);
      },
    );
  }

  /// Toggles availability status.
  Future<void> toggleAvailabilityStatus(bool isAvailable) async {
    state = state.copyWith(isUpdating: true, error: null);

    final result = await _toggleAvailabilityStatusUseCase(isAvailable);

    result.when(
      success: (data, i) {
        state = state.copyWith(settings: data, isUpdating: false);
      },
      exception: (error) {
        state = state.copyWith(isUpdating: false, error: error.message);
      },
    );
  }

  /// Clears the current state.
  void clear() {
    state = const DriverSettingsState();
  }
}
