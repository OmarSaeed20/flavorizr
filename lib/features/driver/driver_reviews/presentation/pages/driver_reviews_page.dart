import 'package:fast_golden_taxi/features/driver/driver_reviews/presentation/providers/driver_reviews_providers.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/presentation/widgets/review_card.dart';
import 'package:fast_golden_taxi/features/driver/driver_reviews/presentation/widgets/review_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for displaying driver reviews
class DriverReviewsPage extends ConsumerStatefulWidget {
  final String driverId;

  const DriverReviewsPage({super.key, required this.driverId});

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
    ref
        .read(driverReviewsControllerProvider.notifier)
        .loadReviews(driverId: widget.driverId, refresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = ref.read(driverReviewsControllerProvider);
      if (state.hasMore && !state.isLoading) {
        ref
            .read(driverReviewsControllerProvider.notifier)
            .loadReviews(
              driverId: widget.driverId,
              page: state.currentPage + 1,
            );
      }
    }
  }

  void _applyFilters() {
    ref
        .read(driverReviewsControllerProvider.notifier)
        .loadReviews(
          driverId: widget.driverId,
          refresh: true,
          rating: _selectedMinRating,
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
    final state = ref.watch(driverReviewsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Reviews'),
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
                          label: 'Min Rating: $_selectedMinRating',
                          onDeleted: () {
                            setState(() {
                              _selectedMinRating = null;
                            });
                            _applyFilters();
                          },
                        ),
                      if (_selectedMaxRating != null)
                        ReviewFilterChip(
                          label: 'Max Rating: $_selectedMaxRating',
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
                              ? 'With Response'
                              : 'Without Response',
                          onDeleted: () {
                            setState(() {
                              _filterWithResponse = null;
                            });
                            _applyFilters();
                          },
                        ),
                      if (_filterPendingResponse != null)
                        ReviewFilterChip(
                          label: 'Pending Response',
                          onDeleted: () {
                            setState(() {
                              _filterPendingResponse = null;
                            });
                            _applyFilters();
                          },
                        ),
                      ReviewFilterChip(
                        label: 'Clear Filters',
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
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (state.reviews.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rate_review_outlined, size: 48),
                      SizedBox(height: 16),
                      Text('No reviews yet'),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final review = state.reviews[index];
                  return ReviewCard(
                    review: review,
                    onTap: () => _showReviewDetailDialog(context, review),
                  );
                }, childCount: state.reviews.length),
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
        title: const Text('Filter Reviews'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rating Range'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _selectedMinRating,
                        decoration: const InputDecoration(
                          labelText: 'Min Rating',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(5, (index) => index + 1)
                            .map(
                              (rating) => DropdownMenuItem(
                                value: rating,
                                child: Text('$rating'),
                              ),
                            )
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
                        initialValue: _selectedMaxRating,
                        decoration: const InputDecoration(
                          labelText: 'Max Rating',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(5, (index) => index + 1)
                            .map(
                              (rating) => DropdownMenuItem(
                                value: rating,
                                child: Text('$rating'),
                              ),
                            )
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
                  title: const Text('With Response'),
                  value: _filterWithResponse ?? false,
                  onChanged: (value) {
                    setDialogState(() {
                      _filterWithResponse = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Pending Response'),
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilters();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showReviewDetailDialog(BuildContext context, dynamic review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review Details'),
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
                const Text(
                  'Your Response',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                  child: const Text('Respond'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
        title: const Text('Respond to Review'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter your response',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
