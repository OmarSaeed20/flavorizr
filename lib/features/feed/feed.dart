// lib/features/feed/feed.dart
/// Feed feature barrel file.
///
/// Exports all feed-related classes for clean imports.
library;

export 'data/datasources/feed_local_datasource.dart';
export 'data/datasources/feed_remote_datasource.dart';
// Data
export 'data/models/post_model.dart';
export 'data/repositories/feed_repository_impl.dart';
// Domain
export 'domain/entities/post.dart';
export 'domain/repositories/feed_repository.dart';
export 'domain/usecases/feed_usecases.dart';
export 'presentation/controllers/feed_controller.dart';
export 'presentation/pages/feed_page.dart';
// Presentation
export 'presentation/providers/feed_providers.dart';
export 'presentation/widgets/post_card.dart';
