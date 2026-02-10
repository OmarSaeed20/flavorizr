import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/user/home/data/parameters/get_available_trips_parameters.dart';
import 'package:fast_golden_taxi/features/user/home/domain/entities/home_data.dart';
import 'package:fast_golden_taxi/features/user/home/domain/usecases/get_advertisements_usecase.dart';
import 'package:fast_golden_taxi/features/user/home/domain/usecases/get_available_trips_usecase.dart';
import 'package:fast_golden_taxi/features/user/home/domain/usecases/get_home_data_usecase.dart';
import 'package:fast_golden_taxi/features/user/home/domain/usecases/get_notification_count_usecase.dart';
import 'package:fast_golden_taxi/shared/domain/usecases/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController(
    this._getHomeDataUseCase,
    this._getAdvertisementsUseCase,
    this._getAvailableTripsUseCase,
    this._getNotificationCountUseCase,
  ) : super(const HomeState.initial());

  final GetHomeDataUseCase _getHomeDataUseCase;
  final GetAdvertisementsUseCase _getAdvertisementsUseCase;
  final GetAvailableTripsUseCase _getAvailableTripsUseCase;
  final GetNotificationCountUseCase _getNotificationCountUseCase;

  /// Loads home page data
  Future<void> loadHomeData() async {
    state = const HomeState.loading();
    final result = await _getHomeDataUseCase(const NoParams());
    result.when(
      success: (data, _) {
        state = HomeState.loaded(
          homeData: data,
          banners: data.banners,
          advertisements: data.advertisements,
          featuredTrips: data.featuredTrips,
          notificationCount: data.notificationCount,
        );
      },
      exception: (error) {
        state = HomeState.error(error.message);
      },
    );
  }

  /// Loads advertisements
  Future<void> loadAdvertisements() async {
    final result = await _getAdvertisementsUseCase(const NoParams());
    result.when(
      success: (data, _) {
        state = state.copyWith(advertisements: data);
      },
      exception: (error) {
        // Handle error silently or update state
      },
    );
  }

  /// Loads available trips
  Future<void> loadAvailableTrips(GetAvailableTripsParameters params) async {
    state = state.copyWith(isLoadingTrips: true);
    final result = await _getAvailableTripsUseCase(params);
    result.when(
      success: (data, _) {
        state = state.copyWith(featuredTrips: data, isLoadingTrips: false);
      },
      exception: (error) {
        state = state.copyWith(
          isLoadingTrips: false,
          errorMessage: error.message,
        );
      },
    );
  }

  /// Refreshes notification count
  Future<void> refreshNotificationCount() async {
    final result = await _getNotificationCountUseCase(const NoParams());
    result.when(
      success: (data, _) {
        state = state.copyWith(notificationCount: data);
      },
      exception: (error) {
        // Handle error silently
      },
    );
  }

  /// Refreshes all home data
  Future<void> refresh() async {
    await loadHomeData();
  }
}

class HomeState {
  final HomeData? homeData;
  final List<dynamic> banners;
  final List<dynamic> advertisements;
  final List<dynamic> featuredTrips;
  final int notificationCount;
  final bool isLoading;
  final bool isLoadingTrips;
  final String? errorMessage;

  const HomeState({
    this.homeData,
    this.banners = const [],
    this.advertisements = const [],
    this.featuredTrips = const [],
    this.notificationCount = 0,
    this.isLoading = false,
    this.isLoadingTrips = false,
    this.errorMessage,
  });

  const HomeState.initial()
    : homeData = null,
      banners = const [],
      advertisements = const [],
      featuredTrips = const [],
      notificationCount = 0,
      isLoading = false,
      isLoadingTrips = false,
      errorMessage = null;

  const HomeState.loading()
    : homeData = null,
      banners = const [],
      advertisements = const [],
      featuredTrips = const [],
      notificationCount = 0,
      isLoading = true,
      isLoadingTrips = false,
      errorMessage = null;

  const HomeState.loaded({
    required this.homeData,
    required this.banners,
    required this.advertisements,
    required this.featuredTrips,
    required this.notificationCount,
  }) : isLoading = false,
       isLoadingTrips = false,
       errorMessage = null;

  const HomeState.error(this.errorMessage)
    : homeData = null,
      banners = const [],
      advertisements = const [],
      featuredTrips = const [],
      notificationCount = 0,
      isLoading = false,
      isLoadingTrips = false;

  bool get isLoaded => homeData != null;
  bool get hasError => errorMessage != null;

  HomeState copyWith({
    HomeData? homeData,
    List<dynamic>? banners,
    List<dynamic>? advertisements,
    List<dynamic>? featuredTrips,
    int? notificationCount,
    bool? isLoading,
    bool? isLoadingTrips,
    String? errorMessage,
  }) {
    return HomeState(
      homeData: homeData ?? this.homeData,
      banners: banners ?? this.banners,
      advertisements: advertisements ?? this.advertisements,
      featuredTrips: featuredTrips ?? this.featuredTrips,
      notificationCount: notificationCount ?? this.notificationCount,
      isLoading: isLoading ?? this.isLoading,
      isLoadingTrips: isLoadingTrips ?? this.isLoadingTrips,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
