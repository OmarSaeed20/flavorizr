// lib/features/trip/presentation/controllers/trip_order_controller.dart
import 'package:flavorizr/core/network/resluts/dio_reslut.dart';
import 'package:flavorizr/features/trip/data/parameters/book_now_order_parameters.dart';
import 'package:flavorizr/features/trip/data/parameters/get_my_orders_parameters.dart';
import 'package:flavorizr/features/trip/data/parameters/trip_evaluation_parameters.dart';
import 'package:flavorizr/features/trip/domain/entities/trip_evaluation.dart';
import 'package:flavorizr/features/trip/domain/entities/trip_order.dart';
import 'package:flavorizr/features/trip/domain/usecases/trip_usecases.dart';
import 'package:flavorizr/features/trip/presentation/providers/trip_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for trip order operations.
class TripOrderState {
  const TripOrderState({
    this.orders = const [],
    this.currentOrder,
    this.isLoading = false,
    this.isBooking = false,
    this.isEvaluating = false,
    this.errorMessage,
    this.isSuccess = false,
    this.hasMore = true,
    this.currentPage = 1,
  });

  final List<TripOrder> orders;
  final TripOrder? currentOrder;
  final bool isLoading;
  final bool isBooking;
  final bool isEvaluating;
  final String? errorMessage;
  final bool isSuccess;
  final bool hasMore;
  final int currentPage;

  bool get isAnyLoading => isLoading || isBooking || isEvaluating;

  TripOrderState copyWith({
    List<TripOrder>? orders,
    TripOrder? currentOrder,
    bool? isLoading,
    bool? isBooking,
    bool? isEvaluating,
    String? errorMessage,
    bool? isSuccess,
    bool? hasMore,
    int? currentPage,
    bool clearError = false,
  }) {
    return TripOrderState(
      orders: orders ?? this.orders,
      currentOrder: currentOrder ?? this.currentOrder,
      isLoading: isLoading ?? this.isLoading,
      isBooking: isBooking ?? this.isBooking,
      isEvaluating: isEvaluating ?? this.isEvaluating,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Controller for trip order operations using Riverpod 3.x Notifier.
class TripOrderController extends AutoDisposeNotifier<TripOrderState> {
  late final GetMyOrdersUseCase _getMyOrdersUseCase;
  late final BookNowOrderUseCase _bookNowOrderUseCase;
  late final TripEvaluationUseCase _tripEvaluationUseCase;

  @override
  TripOrderState build() {
    _getMyOrdersUseCase = ref.watch(getMyOrdersUseCaseProvider);
    _bookNowOrderUseCase = ref.watch(bookNowOrderUseCaseProvider);
    _tripEvaluationUseCase = ref.watch(tripEvaluationUseCaseProvider);
    return const TripOrderState();
  }

  /// Load user's orders.
  Future<void> loadOrders({
    int page = 1,
    int perPage = 20,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final builder = GetMyOrdersParameters.builder()
        .withPage(page)
        .withPerPage(perPage);
    
    if (status != null) {
      builder.withStatus(status);
    }

    final result = await _getMyOrdersUseCase(
      builder.build(),
    );

    result.when(
      success: (orders, i) {
        final newOrders = page == 1 ? orders : [...state.orders, ...orders];
        state = state.copyWith(
          orders: newOrders,
          isLoading: false,
          hasMore: orders.length >= perPage,
          currentPage: page,
        );
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
    );
  }

  /// Load more orders (pagination).
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    await loadOrders(page: state.currentPage + 1);
  }

  /// Refresh orders.
  Future<void> refresh() async {
    await loadOrders();
  }

  /// Book a trip now.
  Future<TripOrder?> bookNow({
    required int orderId,
  }) async {
    state = state.copyWith(isBooking: true, clearError: true);

    final result = await _bookNowOrderUseCase(
      BookNowOrderParameters.builder()
          .withOrderId(orderId)
          .build(),
    );

    return result.when(
      success: (order, i) {
        state = state.copyWith(currentOrder: order, isBooking: false, isSuccess: true);
        return order;
      },
      exception: (error) {
        state = state.copyWith(isBooking: false, errorMessage: error.message);
        return null;
      },
    );
  }

  /// Evaluate a trip.
  Future<TripEvaluation?> evaluateTrip({
    required int orderId,
    required int driverId,
    required double rate,
    required String comment,
    String? anotherNote,
  }) async {
    state = state.copyWith(isEvaluating: true, clearError: true);

    final result = await _tripEvaluationUseCase(
      TripEvaluationParameters.builder()
          .withOrderId(orderId)
          .withDriverId(driverId)
          .withRate(rate)
          .withComment(comment)
          .withAnotherNote(anotherNote)
          .build(),
    );

    return result.when(
      success: (evaluation, i) {
        state = state.copyWith(isEvaluating: false, isSuccess: true);
        return evaluation;
      },
      exception: (error) {
        state = state.copyWith(isEvaluating: false, errorMessage: error.message);
        return null;
      },
    );
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Reset success state.
  void resetSuccess() {
    state = state.copyWith(isSuccess: false);
  }
}
