// lib/core/performance/image_cache_service.dart
/// Image cache service for optimizing image loading and caching.
///
/// Provides utilities for:
/// - Image caching
/// - Image preloading
/// - Image optimization
library;

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Service for managing image caching and optimization.
class ImageCacheService {
  static ImageCacheService? _instance;

  ImageCacheService._();

  /// Gets the singleton instance.
  static ImageCacheService get instance {
    _instance ??= ImageCacheService._();
    return _instance!;
  }

  /// Maximum number of images to cache.
  static const int maxCacheSize = 100;

  /// Maximum size of cached images in bytes (100 MB).
  static const int maxCacheBytes = 100 * 1024 * 1024;

  /// Initializes the image cache service.
  Future<void> initialize() async {
    // Configure the default image cache
    PaintingBinding.instance.imageCache.maximumSize = maxCacheSize;
    PaintingBinding.instance.imageCache.maximumSizeBytes = maxCacheBytes;

    // Clear old cache on startup
    await clearOldCache();
  }

  /// Clears the image cache.
  void clearCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// Clears old cached images.
  Future<void> clearOldCache() async {
    try {
      final directory = await getTemporaryDirectory();
      final cacheDir = Directory('${directory.path}/cache');

      if (cacheDir.existsSync()) {
        final now = DateTime.now();
        final files = cacheDir.listSync();

        for (final file in files) {
          if (file is File) {
            final stat = file.statSync();
            final age = now.difference(stat.modified);

            // Delete files older than 7 days
            if (age.inDays > 7) {
              try {
                await file.delete();
              } catch (e) {
                debugPrint('Failed to delete old cache file: $e');
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to clear old cache: $e');
    }
  }

  /// Preloads an image into the cache.
  Future<ui.Image?> preloadImage(
    ImageProvider provider, {
    ImageSize size = ImageSize.medium,
  }) async {
    try {
      final ImageStream stream = provider.resolve(
        ImageConfiguration(size: _getSizeForQuality(size)),
      );

      final Completer<ui.Image> completer = Completer<ui.Image>();

      late ImageStreamListener listener;

      listener = ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(info.image);
          stream.removeListener(listener);
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          completer.completeError(exception, stackTrace);
          stream.removeListener(listener);
        },
      );

      stream.addListener(listener);
      return await completer.future;
    } catch (e) {
      debugPrint('Failed to preload image: $e');
      return null;
    }
  }

  /// Preloads multiple images into the cache.
  Future<void> preloadImages(
    List<ImageProvider> providers, {
    ImageSize size = ImageSize.medium,
  }) async {
    final futures = providers.map((provider) => preloadImage(provider, size: size));

    await Future.wait(futures);
  }

  /// Gets the current cache size.
  int get cacheSize => PaintingBinding.instance.imageCache.currentSize;

  /// Gets the current cache size in bytes.
  int get cacheSizeBytes => PaintingBinding.instance.imageCache.currentSizeBytes;

  /// Gets the cache status.
  Map<String, dynamic> get cacheStatus => {
    'currentSize': cacheSize,
    'maximumSize': maxCacheSize,
    'currentSizeBytes': cacheSizeBytes,
    'maximumSizeBytes': maxCacheBytes,
    'usagePercentage': (cacheSizeBytes / maxCacheBytes * 100).toStringAsFixed(2),
  };

  /// Evicts an image from the cache.
  Future<bool> evictImage(ImageProvider provider) async {
    try {
      return await provider.evict();
    } catch (e) {
      debugPrint('Failed to evict image: $e');
      return false;
    }
  }

  /// Gets the size for a given image quality.
  Size _getSizeForQuality(ImageSize size) {
    return switch (size) {
      ImageSize.thumbnail => const Size(100, 100),
      ImageSize.small => const Size(300, 300),
      ImageSize.medium => const Size(600, 600),
      ImageSize.large => const Size(1200, 1200),
      ImageSize.original => const Size(1920, 1920),
    };
  }
}

/// Image size options for caching.
enum ImageSize {
  /// Thumbnail size (100x100)
  thumbnail,

  /// Small size (300x300)
  small,

  /// Medium size (600x600)
  medium,

  /// Large size (1200x1200)
  large,

  /// Original size (1920x1920)
  original,
}

/// Extension methods for ImageProvider.
extension ImageProviderExtensions on ImageProvider {
  /// Preloads this image into the cache.
  Future<ui.Image?> preload({ImageSize size = ImageSize.medium}) {
    return ImageCacheService.instance.preloadImage(this, size: size);
  }

  /// Evicts this image from the cache.
  Future<bool> evictFromCache() {
    return ImageCacheService.instance.evictImage(this);
  }
}
