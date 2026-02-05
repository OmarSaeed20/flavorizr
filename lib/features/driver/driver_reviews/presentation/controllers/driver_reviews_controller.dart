import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/entities/driver_review.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/usecases/get_driver_reviews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for driver reviews
class DriverReviewsController extends StateNotifier<DriverReviewsState> {
  final GetDriverReviews getDriverReviews;

  DriverReviewsController({required this.getDriverReviews}) : super(DriverReviewsState.initial());

  /// Load reviews for a driver
  Future<void> loadReviews({
    required String driverId,
    int? tripId,
    int? rating,
    int page = 1,
    int limit = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(isLoading: true, reviews: [], currentPage: 1, hasMore: true);
    } else if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true);

    final result = await getDriverReviews(
      driverId: driverId,
      tripId: tripId,
      rating: rating,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );

    result.when(
      success: (reviews, _) {
        final allReviews = refresh ? reviews : [...state.reviews, ...reviews];
        state = state.copyWith(
          isLoading: false,
          reviews: allReviews,
          currentPage: page,
          hasMore: reviews.length >= limit,
        );
      },
      exception: (message) {
        state = state.copyWith(isLoading: false, error: message.message);
      },
    );
  }

  /// Clear errors
  void clearErrors() {
    state = state.copyWith();
  }

  /// Reset state
  void reset() {
    state = DriverReviewsState.initial();
  }
}

/// State for driver reviews
class DriverReviewsState {
  final List<DriverReview> reviews;
  final bool isLoading;
  final int currentPage;
  final bool hasMore;
  final String? error;

  const DriverReviewsState({
    this.reviews = const [],
    this.isLoading = false,
    this.currentPage = 1,
    this.hasMore = true,
    this.error,
  });

  factory DriverReviewsState.initial() {
    return const DriverReviewsState();
  }

  DriverReviewsState copyWith({
    List<DriverReview>? reviews,
    bool? isLoading,
    int? currentPage,
    bool? hasMore,
    String? error,
  }) {
    return DriverReviewsState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}
