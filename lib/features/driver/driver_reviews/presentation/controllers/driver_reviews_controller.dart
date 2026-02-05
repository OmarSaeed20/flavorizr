import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/entities/driver_review.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/entities/review_stats.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/usecases/get_driver_review_by_id.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/usecases/get_driver_review_stats.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/usecases/get_driver_reviews.dart';
import 'package:flavorizr/features/driver/driver_reviews/domain/usecases/respond_to_review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for driver reviews
class DriverReviewsController extends StateNotifier<DriverReviewsState> {
  final GetDriverReviews getDriverReviews;
  final GetDriverReviewById getDriverReviewById;
  final GetDriverReviewStats getDriverReviewStats;
  final RespondToReview respondToReview;

  DriverReviewsController({
    required this.getDriverReviews,
    required this.getDriverReviewById,
    required this.getDriverReviewStats,
    required this.respondToReview,
  }) : super(DriverReviewsState.initial());

  /// Load reviews for a driver
  Future<void> loadReviews({
    required String driverId,
    int page = 1,
    int limit = 20,
    int? minRating,
    int? maxRating,
    bool? withResponse,
    bool? pendingResponse,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        reviews: [],
        currentPage: 1,
        hasMore: true,
        error: null,
      );
    } else if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final result = await getDriverReviews(
      driverId: driverId,
      page: page,
      limit: limit,
      minRating: minRating,
      maxRating: maxRating,
      withResponse: withResponse,
      pendingResponse: pendingResponse,
    );

    result.when(
      success: (reviews, _) {
        final allReviews = refresh ? reviews : [...state.reviews, ...reviews];
        state = state.copyWith(
          isLoading: false,
          reviews: allReviews,
          currentPage: page,
          hasMore: reviews.length >= limit,
          error: null,
        );
      },
      exception: (message) {
        state = state.copyWith(isLoading: false, error: message.message);
      },
    );
  }

  /// Load review statistics
  Future<void> loadReviewStats({required String driverId}) async {
    state = state.copyWith(isLoadingStats: true, statsError: null);

    final result = await getDriverReviewStats(driverId: driverId);

    result.when(
      success: (stats, _) {
        state = state.copyWith(isLoadingStats: false, stats: stats, statsError: null);
      },
      exception: (message) {
        state = state.copyWith(isLoadingStats: false, statsError: message.message);
      },
    );
  }

  /// Load a specific review by ID
  Future<void> loadReviewById({required String reviewId}) async {
    state = state.copyWith(isLoadingReview: true, reviewError: null);

    final result = await getDriverReviewById(reviewId: reviewId);

    result.when(
      success: (review, _) {
        state = state.copyWith(isLoadingReview: false, selectedReview: review, reviewError: null);
      },
      exception: (message) {
        state = state.copyWith(isLoadingReview: false, reviewError: message.message);
      },
    );
  }

  /// Respond to a review
  Future<void> respondToReview({required String reviewId, required String response}) async {
    state = state.copyWith(isSubmittingResponse: true, responseError: null);

    final result = await respondToReview(reviewId: reviewId, response: response);

    result.when(
      success: (updatedReview, _) {
        // Update the review in the list
        final updatedReviews = state.reviews.map((review) {
          return review.id == reviewId ? updatedReview : review;
        }).toList();

        state = state.copyWith(
          isSubmittingResponse: false,
          reviews: updatedReviews,
          selectedReview: updatedReview,
          responseError: null,
        );
      },
      exception: (message) {
        state = state.copyWith(isSubmittingResponse: false, responseError: message.message);
      },
    );
  }

  /// Clear selected review
  void clearSelectedReview() {
    state = state.copyWith(selectedReview: null);
  }

  /// Clear errors
  void clearErrors() {
    state = state.copyWith(error: null, statsError: null, reviewError: null, responseError: null);
  }

  /// Reset state
  void reset() {
    state = DriverReviewsState.initial();
  }
}

/// State for driver reviews
class DriverReviewsState {
  final List<DriverReview> reviews;
  final ReviewStats? stats;
  final DriverReview? selectedReview;
  final bool isLoading;
  final bool isLoadingStats;
  final bool isLoadingReview;
  final bool isSubmittingResponse;
  final int currentPage;
  final bool hasMore;
  final String? error;
  final String? statsError;
  final String? reviewError;
  final String? responseError;

  const DriverReviewsState({
    this.reviews = const [],
    this.stats,
    this.selectedReview,
    this.isLoading = false,
    this.isLoadingStats = false,
    this.isLoadingReview = false,
    this.isSubmittingResponse = false,
    this.currentPage = 1,
    this.hasMore = true,
    this.error,
    this.statsError,
    this.reviewError,
    this.responseError,
  });

  factory DriverReviewsState.initial() {
    return const DriverReviewsState();
  }

  DriverReviewsState copyWith({
    List<DriverReview>? reviews,
    ReviewStats? stats,
    DriverReview? selectedReview,
    bool? isLoading,
    bool? isLoadingStats,
    bool? isLoadingReview,
    bool? isSubmittingResponse,
    int? currentPage,
    bool? hasMore,
    String? error,
    String? statsError,
    String? reviewError,
    String? responseError,
  }) {
    return DriverReviewsState(
      reviews: reviews ?? this.reviews,
      stats: stats ?? this.stats,
      selectedReview: selectedReview ?? this.selectedReview,
      isLoading: isLoading ?? this.isLoading,
      isLoadingStats: isLoadingStats ?? this.isLoadingStats,
      isLoadingReview: isLoadingReview ?? this.isLoadingReview,
      isSubmittingResponse: isSubmittingResponse ?? this.isSubmittingResponse,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      statsError: statsError,
      reviewError: reviewError,
      responseError: responseError,
    );
  }
}
