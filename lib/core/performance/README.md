# Performance Module

The performance module provides performance monitoring and optimization utilities for the Fast Golden Taxi application, including image caching, lazy loading, and performance profiling.

## 📁 Directory Structure

```
lib/core/performance/
├── image_cache_service.dart  # Image caching and preloading
├── lazy_loading_service.dart # Lazy loading utilities
└── performance_profiler.dart # Performance profiling
```

## 🎯 Key Components

### 1. ImageCacheService (`image_cache_service.dart`)

Image caching and preloading service for optimal image loading performance.

**Features:**
- Automatic image caching
- Image preloading
- Cache size management
- Memory optimization
- Network optimization

**Usage:**
```dart
// Get service instance
final imageCache = ImageCacheService.instance;

// Preload images
await imageCache.preloadImages([
  'https://example.com/image1.jpg',
  'https://example.com/image2.jpg',
]);

// Clear cache
await imageCache.clearCache();

// Get cache size
final cacheSize = await imageCache.getCacheSize();

// Check if image is cached
final isCached = await imageCache.isImageCached('https://example.com/image.jpg');
```

**ImageCacheService:**
```dart
class ImageCacheService {
  static ImageCacheService? _instance;
  static ImageCacheService get instance {
    _instance ??= ImageCacheService._internal();
    return _instance!;
  }

  final int _maxCacheSize;
  final int _maxMemoryCacheSize;
  final Map<String, ImageProvider> _preloadedImages = {};

  ImageCacheService._internal()
      : _maxCacheSize = 100 * 1024 * 1024, // 100 MB
        _maxMemoryCacheSize = 50 * 1024 * 1024; // 50 MB

  Future<void> preloadImages(List<String> urls) async {
    for (final url in urls) {
      try {
        final imageProvider = CachedNetworkImageProvider(url);
        await precacheImage(imageProvider, navigatorKey.currentContext!);
        _preloadedImages[url] = imageProvider;
      } catch (e) {
        AppLogger.instance.error('Failed to preload image', error: e, category: 'performance');
      }
    }
  }

  Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
    PaintingBinding.instance.imageCache.clear();
    _preloadedImages.clear();
  }

  Future<int> getCacheSize() async {
    return await DefaultCacheManager().emptyCache();
  }

  Future<bool> isImageCached(String url) async {
    return await DefaultCacheManager().getFileFromCache(url) != null;
  }

  void configureCache() {
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = _maxMemoryCacheSize;
  }
}
```

### 2. LazyLoadingService (`lazy_loading_service.dart`)

Lazy loading utilities for optimizing list and grid performance.

**Features:**
- Lazy loading for lists
- Lazy loading for grids
- Pagination support
- Scroll optimization
- Memory management

**Usage:**
```dart
// Create lazy loading controller
final controller = LazyLoadingController(
  onLoadMore: () => loadMoreItems(),
  threshold: 0.8,
);

// Attach to scroll controller
ListView.builder(
  controller: controller.scrollController,
  itemCount: items.length + (controller.isLoading ? 1 : 0),
  itemBuilder: (context, index) {
    if (index == items.length) {
      return const LoadingWidget();
    }
    return ItemWidget(items[index]);
  },
);

// Dispose controller
controller.dispose();
```

**LazyLoadingController:**
```dart
class LazyLoadingController {
  final ScrollController scrollController = ScrollController();
  final Future<void> Function() onLoadMore;
  final double threshold;
  bool _isLoading = false;
  bool _hasMore = true;

  LazyLoadingController({
    required this.onLoadMore,
    this.threshold = 0.8,
  }) {
    scrollController.addListener(_onScroll);
  }

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  void _onScroll() {
    if (_isLoading || !_hasMore) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    final delta = maxScroll - currentScroll;

    if (delta <= maxScroll * (1 - threshold)) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    _isLoading = true;
    try {
      await onLoadMore();
    } catch (e) {
      AppLogger.instance.error('Failed to load more items', error: e, category: 'performance');
    } finally {
      _isLoading = false;
    }
  }

  void setHasMore(bool value) {
    _hasMore = value;
  }

  void dispose() {
    scrollController.dispose();
  }
}
```

**LazyLoadingBuilder:**
```dart
class LazyLoadingBuilder extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Future<void> Function() onLoadMore;
  final double threshold;
  final Widget? loadingWidget;
  final Widget? emptyWidget;

  const LazyLoadingBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onLoadMore,
    this.threshold = 0.8,
    this.loadingWidget,
    this.emptyWidget,
  });

  @override
  State<LazyLoadingBuilder> createState() => _LazyLoadingBuilderState();
}

class _LazyLoadingBuilderState extends State<LazyLoadingBuilder> {
  late LazyLoadingController _controller;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _controller = LazyLoadingController(
      onLoadMore: _loadMore,
      threshold: widget.threshold,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    await widget.onLoadMore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0 && widget.emptyWidget != null) {
      return widget.emptyWidget!;
    }

    return ListView.builder(
      controller: _controller.scrollController,
      itemCount: widget.itemCount + (_controller.isLoading && _hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.itemCount) {
          return widget.loadingWidget ?? const LoadingWidget();
        }
        return widget.itemBuilder(context, index);
      },
    );
  }
}
```

### 3. PerformanceProfiler (`performance_profiler.dart`)

Performance profiling utilities for measuring and optimizing app performance.

**Features:**
- Operation timing
- Memory profiling
- Frame rate monitoring
- Performance metrics
- Performance alerts

**Usage:**
```dart
// Get profiler instance
final profiler = PerformanceProfiler.instance;

// Profile an operation
await profiler.profileOperation('load_data', () async {
  await loadData();
});

// Start a timer
final timer = profiler.startTimer('api_request');
// ... do work ...
timer.stop();

// Get performance metrics
final metrics = profiler.getMetrics();

// Clear metrics
profiler.clearMetrics();
```

**PerformanceProfiler:**
```dart
class PerformanceProfiler {
  static PerformanceProfiler? _instance;
  static PerformanceProfiler get instance {
    _instance ??= PerformanceProfiler._internal();
    return _instance!;
  }

  final Map<String, PerformanceMetric> _metrics = {};
  final Map<String, Stopwatch> _timers = {};

  PerformanceProfiler._internal();

  Future<T> profileOperation<T>(String name, Future<T> Function() operation) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      _recordMetric(name, stopwatch.elapsedMilliseconds);
      return result;
    } catch (e) {
      stopwatch.stop();
      _recordMetric(name, stopwatch.elapsedMilliseconds, error: e);
      rethrow;
    }
  }

  PerformanceTimer startTimer(String name) {
    final stopwatch = Stopwatch()..start();
    _timers[name] = stopwatch;
    return PerformanceTimer._(stopwatch, name, this);
  }

  void _recordMetric(String name, int duration, {Object? error}) {
    final metric = _metrics[name] ?? PerformanceMetric(name: name);
    _metrics[name] = metric.copyWith(
      count: metric.count + 1,
      totalDuration: metric.totalDuration + duration,
      averageDuration: (metric.totalDuration + duration) / (metric.count + 1),
      minDuration: metric.minDuration == null ? duration : min(metric.minDuration!, duration),
      maxDuration: max(metric.maxDuration, duration),
      lastError: error?.toString(),
    );
  }

  PerformanceMetric? getMetric(String name) {
    return _metrics[name];
  }

  Map<String, PerformanceMetric> getMetrics() {
    return Map.from(_metrics);
  }

  void clearMetrics() {
    _metrics.clear();
  }

  void _stopTimer(String name) {
    final stopwatch = _timers.remove(name);
    if (stopwatch != null) {
      stopwatch.stop();
      _recordMetric(name, stopwatch.elapsedMilliseconds);
    }
  }
}

class PerformanceTimer {
  final Stopwatch _stopwatch;
  final String _name;
  final PerformanceProfiler _profiler;

  PerformanceTimer._(this._stopwatch, this._name, this._profiler);

  void stop() {
    _profiler._stopTimer(_name);
  }

  int get elapsed => _stopwatch.elapsedMilliseconds;
}

@freezed
class PerformanceMetric with _$PerformanceMetric {
  const factory PerformanceMetric({
    required String name,
    @Default(0) int count,
    @Default(0) int totalDuration,
    @Default(0) double averageDuration,
    int? minDuration,
    @Default(0) int maxDuration,
    String? lastError,
  }) = _PerformanceMetric;

  factory PerformanceMetric.fromJson(Map<String, dynamic> json) =>
      _$PerformanceMetricFromJson(json);
}
```

## 🏗️ Architecture

### Performance Optimization Flow

```
1. App starts
2. Initialize performance services
3. Configure caches
4. Monitor performance
5. Optimize based on metrics
6. Alert on performance issues
```

### Image Caching Flow

```
Image Request
    ↓
Check Cache
    ↓
Cache Hit? → Return Cached Image
    ↓ No
Load from Network
    ↓
Store in Cache
    ↓
Return Image
```

### Lazy Loading Flow

```
User Scrolls
    ↓
Check Threshold
    ↓
Threshold Reached? → Load More
    ↓ No
Continue Scrolling
```

## 📝 Best Practices

### 1. Use Image Caching

```dart
// Good
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
);

// Bad
Image.network('https://example.com/image.jpg');
```

### 2. Preload Images

```dart
// Good
@override
void initState() {
  super.initState();
  ImageCacheService.instance.preloadImages([
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
  ]);
}

// Bad
// Don't preload images
```

### 3. Use Lazy Loading for Lists

```dart
// Good
LazyLoadingBuilder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
  onLoadMore: () => loadMoreItems(),
);

// Bad
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
);
```

### 4. Profile Performance

```dart
// Good
await PerformanceProfiler.instance.profileOperation('load_data', () async {
  await loadData();
});

// Bad
// Don't profile operations
```

### 5. Optimize Image Sizes

```dart
// Good
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
);

// Bad
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
);
```

## 🔧 Usage Examples

### Optimized Image Gallery

```dart
class OptimizedImageGallery extends StatefulWidget {
  final List<String> images;

  const OptimizedImageGallery({super.key, required this.images});

  @override
  State<OptimizedImageGallery> createState() => _OptimizedImageGalleryState();
}

class _OptimizedImageGalleryState extends State<OptimizedImageGallery> {
  @override
  void initState() {
    super.initState();
    // Preload first few images
    ImageCacheService.instance.preloadImages(
      widget.images.take(5).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: widget.images[index],
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Center(
            child: Icon(Icons.error),
          ),
          fit: BoxFit.cover,
        );
      },
    );
  }
}
```

### Optimized List with Lazy Loading

```dart
class OptimizedList extends ConsumerStatefulWidget {
  @override
  ConsumerState<OptimizedList> createState() => _OptimizedListState();
}

class _OptimizedListState extends ConsumerState<OptimizedList> {
  final List<Item> _items = [];
  int _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final newItems = await ref.read(itemRepositoryProvider).getItems(_page);
      setState(() {
        _items.addAll(newItems);
        _page++;
      });
    } catch (e) {
      AppLogger.instance.error('Failed to load items', error: e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LazyLoadingBuilder(
      itemCount: _items.length,
      itemBuilder: (context, index) => ItemWidget(_items[index]),
      onLoadMore: _loadItems,
      loadingWidget: const Center(child: CircularProgressIndicator()),
      emptyWidget: const Center(child: Text('No items found')),
    );
  }
}
```

### Performance Monitoring

```dart
class PerformanceMonitor extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = PerformanceProfiler.instance.getMetrics();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Metrics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              PerformanceProfiler.instance.clearMetrics();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: metrics.length,
        itemBuilder: (context, index) {
          final metric = metrics.values.elementAt(index);
          return ListTile(
            title: Text(metric.name),
            subtitle: Text(
              'Count: ${metric.count}, '
              'Avg: ${metric.averageDuration.toStringAsFixed(2)}ms, '
              'Min: ${metric.minDuration}ms, '
              'Max: ${metric.maxDuration}ms',
            ),
            trailing: metric.lastError != null
                ? const Icon(Icons.error, color: Colors.red)
                : null,
          );
        },
      ),
    );
  }
}
```

### Optimized API Calls

```dart
class OptimizedApiClient {
  final ApiClient _apiClient;
  final PerformanceProfiler _profiler = PerformanceProfiler.instance;

  OptimizedApiClient(this._apiClient);

  Future<Response> get(String path) async {
    return await _profiler.profileOperation('api_get_$path', () async {
      return await _apiClient.get(path);
    });
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _profiler.profileOperation('api_post_$path', () async {
      return await _apiClient.post(path, data: data);
    });
  }
}
```

## 🧪 Testing

### Unit Tests

```dart
test('PerformanceProfiler should record metrics', () async {
  final profiler = PerformanceProfiler.instance;

  await profiler.profileOperation('test_operation', () async {
    await Future.delayed(const Duration(milliseconds: 100));
  });

  final metric = profiler.getMetric('test_operation');
  expect(metric, isNotNull);
  expect(metric!.count, 1);
  expect(metric.averageDuration, greaterThan(0));
});
```

### Performance Tests

```dart
testWidgets('List should perform well with many items', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemCount: 1000,
          itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
        ),
      ),
    ),
  );

  final stopwatch = Stopwatch()..start();
  await tester.fling(find.byType(ListView), const Offset(0, -500), 10000);
  await tester.pumpAndSettle();
  stopwatch.stop();

  expect(stopwatch.elapsedMilliseconds, lessThan(1000));
});
```

## 📚 Additional Resources

- [Flutter Performance](https://flutter.dev/docs/perf)
- [Cached Network Image](https://pub.dev/packages/cached_network_image)
- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)

## 🤝 Contributing

When adding performance optimizations:

1. Measure before and after
2. Test on different devices
3. Monitor memory usage
4. Update documentation
5. Add tests

## 📄 License

This module is part of the Fast Golden Taxi project.