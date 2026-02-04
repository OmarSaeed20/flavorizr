// lib/features/trip/presentation/controllers/trip_history_controller.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/trip/data/parameters/get_trip_history_parameters.dart';
import 'package:flavorizr/features/trip/domain/entities/trip.dart';
import 'package:flavorizr/features/trip/domain/usecases/trip_usecases.dart';
import 'package:flavorizr/features/trip/presentation/providers/trip_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for trip history operations.
class TripHistoryState {
  const TripHistoryState({
    this.trips = const [],
    this.isLoading = false,
    this.errorMessage,
    this.hasMore = true,
    this.currentPage = 1,
  });

  final List<Trip> trips;
  final bool isLoading;
  final String? errorMessage;
  final bool hasMore;
  final int currentPage;

  TripHistoryState copyWith({
    List<Trip>? trips,
    bool? isLoading,
    String? errorMessage,
    bool? hasMore,
    int? currentPage,
    bool clearError = false,
  }) {
    return TripHistoryState(
      trips: trips ?? this.trips,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Controller for trip history operations using Riverpod 3.x Notifier.
class TripHistoryController extends AutoDisposeNotifier<TripHistoryState> {
  late final GetTripHistoryUseCase _getTripHistoryUseCase;

  @override
  TripHistoryState build() {
    _getTripHistoryUseCase = ref.watch(getTripHistoryUseCaseProvider);
    return const TripHistoryState();
  }

  /// Load trip history.
  Future<void> loadTripHistory({
    int page = 1,
    int perPage = 20,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getTripHistoryUseCase(
      GetTripHistoryParameters.builder()
          .withPage(page)
          .withPerPage(perPage)
          // .withStatus(status)
          // .withStartDate(startDate)
          // .withEndDate(endDate)
          .build(),
    );

    result.when(
      success: (trips, i) {
        final newTrips = page == 1 ? trips : [...state.trips, ...trips];
        state = state.copyWith(
          trips: newTrips,
          isLoading: false,
          hasMore: trips.length >= perPage,
          currentPage: page,
        );
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
    );
  }

  /// Load more trips (pagination).
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    await loadTripHistory(page: state.currentPage + 1);
  }

  /// Refresh trip history.
  Future<void> refresh() async {
    await loadTripHistory();
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
