import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_document.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_profile.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/entities/driver_vehicle.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/usecases/delete_driver_document_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/usecases/get_driver_documents_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/usecases/get_driver_profile_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/usecases/get_driver_vehicle_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/usecases/update_driver_profile_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/usecases/update_driver_vehicle_usecase.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/domain/usecases/upload_driver_document_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for driver profile operations.
class DriverProfileState {
  final DriverProfile? profile;
  final DriverVehicle? vehicle;
  final List<DriverDocument> documents;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  const DriverProfileState({
    this.profile,
    this.vehicle,
    this.documents = const [],
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
  });

  DriverProfileState copyWith({
    DriverProfile? profile,
    DriverVehicle? vehicle,
    List<DriverDocument>? documents,
    bool? isLoading,
    bool? isUpdating,
    String? error,
  }) {
    return DriverProfileState(
      profile: profile ?? this.profile,
      vehicle: vehicle ?? this.vehicle,
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
    );
  }
}

/// Controller for managing driver profile operations.
class DriverProfileController extends StateNotifier<DriverProfileState> {
  final GetDriverProfileUseCase _getDriverProfileUseCase;
  final UpdateDriverProfileUseCase _updateDriverProfileUseCase;
  final GetDriverVehicleUseCase _getDriverVehicleUseCase;
  final UpdateDriverVehicleUseCase _updateDriverVehicleUseCase;
  final UploadDriverDocumentUseCase _uploadDriverDocumentUseCase;
  final GetDriverDocumentsUseCase _getDriverDocumentsUseCase;
  final DeleteDriverDocumentUseCase _deleteDriverDocumentUseCase;

  DriverProfileController(
    this._getDriverProfileUseCase,
    this._updateDriverProfileUseCase,
    this._getDriverVehicleUseCase,
    this._updateDriverVehicleUseCase,
    this._uploadDriverDocumentUseCase,
    this._getDriverDocumentsUseCase,
    this._deleteDriverDocumentUseCase,
  ) : super(const DriverProfileState());

  /// Gets driver profile.
  Future<void> getDriverProfile() async {
    state = state.copyWith(isLoading: true);

    final result = await _getDriverProfileUseCase();

    result.when(
      success: (data, _) {
        state = state.copyWith(profile: data, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Updates driver profile.
  Future<void> updateDriverProfile({
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
  }) async {
    state = state.copyWith(isUpdating: true);

    final result = await _updateDriverProfileUseCase(
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

    result.when(
      success: (data, _) {
        state = state.copyWith(profile: data, isUpdating: false);
      },
      exception: (error) {
        state = state.copyWith(isUpdating: false, error: error.message);
      },
    );
  }

  /// Gets driver vehicle.
  Future<void> getDriverVehicle() async {
    state = state.copyWith(isLoading: true);

    final result = await _getDriverVehicleUseCase();

    result.when(
      success: (data, _) {
        state = state.copyWith(vehicle: data, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Updates driver vehicle.
  Future<void> updateDriverVehicle({
    String? vehicleTypeId,
    String? vehiclePlateNumber,
    String? vehicleImage,
    String? vehicleLicenseImage,
  }) async {
    state = state.copyWith(isUpdating: true);

    final result = await _updateDriverVehicleUseCase(
      vehicleTypeId: vehicleTypeId,
      vehiclePlateNumber: vehiclePlateNumber,
      vehicleImage: vehicleImage,
      vehicleLicenseImage: vehicleLicenseImage,
    );

    result.when(
      success: (data, _) {
        state = state.copyWith(vehicle: data, isUpdating: false);
      },
      exception: (error) {
        state = state.copyWith(isUpdating: false, error: error.message);
      },
    );
  }

  /// Uploads driver document.
  Future<void> uploadDriverDocument({
    required String documentType,
    required String documentImage,
  }) async {
    state = state.copyWith(isUpdating: true);

    final result = await _uploadDriverDocumentUseCase(
      documentType: documentType,
      documentImage: documentImage,
    );

    result.when(
      success: (data, _) {
        final updatedDocuments = [...state.documents, data];
        state = state.copyWith(documents: updatedDocuments, isUpdating: false);
      },
      exception: (error) {
        state = state.copyWith(isUpdating: false, error: error.message);
      },
    );
  }

  /// Gets driver documents.
  Future<void> getDriverDocuments() async {
    state = state.copyWith(isLoading: true);

    final result = await _getDriverDocumentsUseCase();

    result.when(
      success: (data, _) {
        state = state.copyWith(documents: data, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Deletes driver document.
  Future<void> deleteDriverDocument(String documentId) async {
    state = state.copyWith(isUpdating: true);

    final result = await _deleteDriverDocumentUseCase(documentId);

    result.when(
      success: (_, __) {
        final updatedDocuments = state.documents.where((doc) => doc.id != documentId).toList();
        state = state.copyWith(documents: updatedDocuments, isUpdating: false);
      },
      exception: (error) {
        state = state.copyWith(isUpdating: false, error: error.message);
      },
    );
  }

  /// Clears the current state.
  void clear() {
    state = const DriverProfileState();
  }

  /// Clears the error message.
  void clearError() {
    state = state.copyWith();
  }
}
