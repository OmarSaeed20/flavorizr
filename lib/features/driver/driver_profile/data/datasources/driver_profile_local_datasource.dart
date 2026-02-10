import 'dart:convert';

import 'package:fast_golden_taxi/core/network/base/datasource/base_local_data_source.dart';
import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/models/driver_document_model.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/models/driver_profile_model.dart';
import 'package:fast_golden_taxi/features/driver/driver_profile/data/models/driver_vehicle_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for driver profile operations.
///
/// Handles all local storage operations related to driver profile management.
/// Uses SharedPreferences for caching profile data.
abstract class DriverProfileLocalDataSource {
  /// Gets cached driver profile.
  Future<ApiResult<DriverProfileModel>> getCachedProfile();

  /// Saves driver profile to cache.
  Future<ApiResult<void>> cacheProfile(DriverProfileModel profile);

  /// Gets cached driver vehicle.
  Future<ApiResult<DriverVehicleModel>> getCachedVehicle();

  /// Saves driver vehicle to cache.
  Future<ApiResult<void>> cacheVehicle(DriverVehicleModel vehicle);

  /// Gets cached driver documents.
  Future<ApiResult<List<DriverDocumentModel>>> getCachedDocuments();

  /// Saves driver documents to cache.
  Future<ApiResult<void>> cacheDocuments(List<DriverDocumentModel> documents);

  /// Gets cached verification status.
  Future<ApiResult<Map<String, dynamic>>> getCachedVerificationStatus();

  /// Saves verification status to cache.
  Future<ApiResult<void>> cacheVerificationStatus(Map<String, dynamic> status);

  /// Clears all cached profile data.
  Future<ApiResult<void>> clearProfileCache();
}

/// Implementation of [DriverProfileLocalDataSource] using BaseLocalDataSource.
class DriverProfileLocalDataSourceImpl
    with BaseLocalDataSource
    implements DriverProfileLocalDataSource {
  DriverProfileLocalDataSourceImpl({required SharedPreferences prefs})
    : _prefs = prefs;

  static const String _profileKey = 'driver_profile';
  static const String _vehicleKey = 'driver_vehicle';
  static const String _documentsKey = 'driver_documents';
  static const String _verificationStatusKey = 'driver_verification_status';

  final SharedPreferences _prefs;

  @override
  Future<ApiResult<DriverProfileModel>> getCachedProfile() async {
    return getLocalData<DriverProfileModel>(
      key: _profileKey,
      fetcher: () async {
        final json = _prefs.getString(_profileKey);
        if (json == null) return null;
        try {
          return DriverProfileModel.fromJson(
            jsonDecode(json) as Map<String, dynamic>,
          );
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheProfile(DriverProfileModel profile) async {
    return saveLocalData<DriverProfileModel>(
      key: _profileKey,
      data: profile,
      saver: (data) async {
        final json = jsonEncode(data.toJson());
        await _prefs.setString(_profileKey, json);
      },
    );
  }

  @override
  Future<ApiResult<DriverVehicleModel>> getCachedVehicle() async {
    return getLocalData<DriverVehicleModel>(
      key: _vehicleKey,
      fetcher: () async {
        final json = _prefs.getString(_vehicleKey);
        if (json == null) return null;
        try {
          return DriverVehicleModel.fromJson(
            jsonDecode(json) as Map<String, dynamic>,
          );
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheVehicle(DriverVehicleModel vehicle) async {
    return saveLocalData<DriverVehicleModel>(
      key: _vehicleKey,
      data: vehicle,
      saver: (data) async {
        final json = jsonEncode(data.toJson());
        await _prefs.setString(_vehicleKey, json);
      },
    );
  }

  @override
  Future<ApiResult<List<DriverDocumentModel>>> getCachedDocuments() async {
    return getLocalDataList<DriverDocumentModel>(
      key: _documentsKey,
      fetcher: () async {
        final json = _prefs.getString(_documentsKey);
        if (json == null) return null;
        try {
          final list = jsonDecode(json) as List<dynamic>;
          return list
              .map(
                (e) => DriverDocumentModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheDocuments(
    List<DriverDocumentModel> documents,
  ) async {
    return saveLocalDataList<DriverDocumentModel>(
      key: _documentsKey,
      data: documents,
      saver: (data) async {
        final json = jsonEncode(data.map((e) => e.toJson()).toList());
        await _prefs.setString(_documentsKey, json);
      },
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getCachedVerificationStatus() async {
    return getLocalData<Map<String, dynamic>>(
      key: _verificationStatusKey,
      fetcher: () async {
        final json = _prefs.getString(_verificationStatusKey);
        if (json == null) return null;
        try {
          return jsonDecode(json) as Map<String, dynamic>;
        } catch (_) {
          return null;
        }
      },
    );
  }

  @override
  Future<ApiResult<void>> cacheVerificationStatus(
    Map<String, dynamic> status,
  ) async {
    return saveLocalData<Map<String, dynamic>>(
      key: _verificationStatusKey,
      data: status,
      saver: (data) async {
        final json = jsonEncode(data);
        await _prefs.setString(_verificationStatusKey, json);
      },
    );
  }

  @override
  Future<ApiResult<void>> clearProfileCache() async {
    await deleteLocalData(
      key: _profileKey,
      deleter: () async => _prefs.remove(_profileKey),
    );
    await deleteLocalData(
      key: _vehicleKey,
      deleter: () async => _prefs.remove(_vehicleKey),
    );
    await deleteLocalData(
      key: _documentsKey,
      deleter: () async => _prefs.remove(_documentsKey),
    );
    return deleteLocalData(
      key: _verificationStatusKey,
      deleter: () async => _prefs.remove(_verificationStatusKey),
    );
  }
}
