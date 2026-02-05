import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flavorizr/l10n/app_localizations.dart';
import '../controllers/driver_reviews_controller.dart';
import '../providers/driver_reviews_providers.dart';
import '../widgets/review_stats_card.dart';
import '../widgets/review_card.dart';
import '../widgets/review_filter_chip.dart';

/// Page for displaying driver reviews
class DriverReviewsPage extends ConsumerStatefulWidget {
  final String driverId;

  const DriverReviewsPage({
    super.key,
    required this.driverId,
  });

  @override
  ConsumerState<DriverReviewsPage> createState() => _DriverReviewsPageState();
}

class _DriverReviewsPageState extends ConsumerState<DriverReviewsPage> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedMinRating;
  int? _selectedMaxRating;
  bool? _filterWithResponse;
  bool? _filterPendingResponse;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData() {
    ref.read(driverReviewsControllerProvider.notifier).loadReviews(
          driverId: widget.driverId,
          refresh: true,
        );
    ref.read(driverReviewsControllerProvider.notifier).loadReviewStats(
          driverId: widget.driverId,
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = ref.read(driverReviewsControllerProvider);
      if (state.hasMore && !state.isLoading) {
        ref.read(driverReviewsControllerProvider.notifier).loadReviews(
              driverId: widget.driverId,
              page: state.currentPage + 1,
              minRating: _selectedMinRating,
              maxRating: _selectedMaxRating,
              withResponse: _filterWithResponse,
              pendingResponse: _filterPendingResponse,
            );
      }
    }
  }

  void _applyFilters() {
    ref.read(driverReviewsControllerProvider.notifier).loadReviews(
          driverId: widget.driverId,
          refresh: true,
          minRating: _selectedMinRating,
          maxRating: _selectedMaxRating,
          withResponse: _filterWithResponse,
          pendingResponse: _filterPendingResponse,
        );
  }

  void _clearFilters() {
    setState(() {
      _selectedMinRating = null;
      _selectedMaxRating = null;
      _filterWithResponse = null;
      _filterPendingResponse = null;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(driverReviewsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.driverReviews),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Stats Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ReviewStatsCard(
                  stats: state.stats,
                  isLoading: state.isLoadingStats,
                  error: state.statsError,
                ),
              ),
            ),

            // Filter Chips
            if (_selectedMinRating != null ||
                _selectedMaxRating != null ||
                _filterWithResponse != null ||
                _filterPendingResponse != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: [
                      if (_selectedMinRating != null)
                        ReviewFilterChip(
                          label: '${l10n.minRating}: $_selectedMinRating',
                          onDeleted: () {
                            setState(() {
                              _selectedMinRating = null;
                            });
                            _applyFilters();
                          },
                        ),
                      if (_selectedMaxRating != null)
                        ReviewFilterChip(
                          label: '${l10n.maxRating}: $_selectedMaxRating',
                          onDeleted: () {
                            setState(() {
                              _selectedMaxRating = null;
                            });
                            _applyFilters();
                          },
                        ),
                      if (_filterWithResponse != null)
                        ReviewFilterChip(
                          label: _filterWithResponse!
                              ? l10n.withResponse
                              : l10n.withoutResponse,
                          onDeleted: () {
                            setState(() {
                              _filterWithResponse = null;
                            });
                            _applyFilters();
                          },
                        ),
                      if (_filterPendingResponse != null)
                        ReviewFilterChip(
                          label: l10n.pendingResponse,
                          onDeleted: () {
                            setState(() {
                              _filterPendingResponse = null;
                            });
                            _applyFilters();
                          },
                        ),
                      ReviewFilterChip(
                        label: l10n.clearFilters,
                        onDeleted: _clearFilters,
                      ),
                    ],
                  ),
                ),
              ),

            // Reviews List
            if (state.isLoading && state.reviews.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.error != null && state.reviews.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 16),
                      Text(state.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              )
            else if (state.reviews.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.rate_review_outlined, size: 48),
                      const SizedBox(height: 16),
                      Text(l10n.noReviews),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final review = state.reviews[index];
                    return ReviewCard(
                      review: review,
                      onTap: () => _showReviewDetailDialog(context, review),
                    );
                  },
                  childCount: state.reviews.length,
                ),
              ),

            // Loading indicator for pagination
            if (state.isLoading && state.reviews.isNotEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.filterReviews),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.ratingRange),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedMinRating,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.minRating,
                          border: const OutlineInputBorder(),
                        ),
                        items: List.generate(5, (index) => index + 1)
                            .map((rating) => DropdownMenuItem(
                                  value: rating,
                                  child: Text('$rating'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            _selectedMinRating = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedMaxRating,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.maxRating,
                          border: const OutlineInputBorder(),
                        ),
                        items: List.generate(5, (index) => index + 1)
                            .map((rating) => DropdownMenuItem(
                                  value: rating,
                                  child: Text('$rating'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            _selectedMaxRating = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.withResponse),
                  value: _filterWithResponse ?? false,
                  onChanged: (value) {
                    setDialogState(() {
                      _filterWithResponse = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.pendingResponse),
                  value: _filterPendingResponse ?? false,
                  onChanged: (value) {
                    setDialogState(() {
                      _filterPendingResponse = value;
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilters();
            },
            child: Text(AppLocalizations.of(context)!.apply),
          ),
        ],
      ),
    );
  }

  void _showReviewDetailDialog(BuildContext context, dynamic review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.reviewDetails),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: review.passengerAvatar != null
                        ? NetworkImage(review.passengerAvatar!)
                        : null,
                    child: review.passengerAvatar == null
                        ? Text(review.passengerName[0])
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.passengerName),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(review.comment),
              const SizedBox(height: 16),
              if (review.response != null) ...[
                Text(
                  AppLocalizations.of(context)!.yourResponse,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(review.response),
                ),
              ] else
                ElevatedButton(
                  onPressed: () => _showResponseDialog(context, review.id),
                  child: Text(AppLocalizations.of(context)!.respond),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _showResponseDialog(BuildContext context, String reviewId) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.respondToReview),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterYourResponse,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(driverReviewsControllerProvider.notifier)
                    .respondToReview(
                      reviewId: reviewId,
                      response: controller.text,
                    );
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.submit),
          ),
        ],
      ),
    );
  }
}