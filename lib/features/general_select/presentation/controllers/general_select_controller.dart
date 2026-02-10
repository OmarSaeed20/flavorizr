import 'package:fast_golden_taxi/core/network/results/dio_reslut.dart';
import 'package:fast_golden_taxi/features/general_select/data/parameters/get_select_options_parameters.dart';
import 'package:fast_golden_taxi/features/general_select/domain/entities/select_option.dart';
import 'package:fast_golden_taxi/features/general_select/domain/usecases/general_select_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for general select operations.
class GeneralSelectState {
  final List<SelectOption> options;
  final bool isLoading;
  final String? error;

  const GeneralSelectState({
    this.options = const [],
    this.isLoading = false,
    this.error,
  });

  GeneralSelectState copyWith({
    List<SelectOption>? options,
    bool? isLoading,
    String? error,
  }) {
    return GeneralSelectState(
      options: options ?? this.options,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Controller for managing general select operations.
class GeneralSelectController extends StateNotifier<GeneralSelectState> {
  final GetSelectOptionsUseCase _getSelectOptionsUseCase;

  GeneralSelectController(this._getSelectOptionsUseCase)
    : super(const GeneralSelectState());

  /// Gets select options based on type and filters.
  Future<void> getSelectOptions({
    required String type,
    String? search,
    int? limit,
  }) async {
    state = state.copyWith(isLoading: true);

    final builder = GetSelectOptionsParameters.builder().withType(type);
    if (search != null) {
      builder.withSearch(search);
    }
    if (limit != null) {
      builder.withLimit(limit);
    }

    final result = await _getSelectOptionsUseCase(builder.build());

    result.when(
      success: (data, _) {
        state = state.copyWith(options: data, isLoading: false);
      },
      exception: (error) {
        state = state.copyWith(isLoading: false, error: error.message);
      },
    );
  }

  /// Clears the current state.
  void clear() {
    state = const GeneralSelectState();
  }
}
