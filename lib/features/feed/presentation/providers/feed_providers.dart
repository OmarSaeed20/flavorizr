// lib/features/feed/presentation/providers/feed_providers.dart
import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/features/auth/presentation/providers/auth_providers.dart';
import 'package:flavorizr/features/feed/data/datasources/feed_local_datasource.dart';
import 'package:flavorizr/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:flavorizr/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:flavorizr/features/feed/domain/repositories/feed_repository.dart';
import 'package:flavorizr/features/feed/domain/usecases/feed_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for NetworkInfo.
final feedNetworkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

/// Provider for FeedRemoteDataSource.
final feedRemoteDataSourceProvider = Provider<FeedRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return FeedRemoteDataSourceImpl(dio);
});

/// Provider for FeedLocalDataSource.
final feedLocalDataSourceProvider = Provider<FeedLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FeedLocalDataSourceImpl(prefs);
});

/// Provider for FeedRepository.
final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepositoryImpl(
    remoteDataSource: ref.watch(feedRemoteDataSourceProvider),
    localDataSource: ref.watch(feedLocalDataSourceProvider),
    networkInfo: ref.watch(feedNetworkInfoProvider),
  );
});

/// Provider for GetFeedPostsUseCase.
final getFeedPostsUseCaseProvider = Provider<GetFeedPostsUseCase>((ref) {
  return GetFeedPostsUseCase(ref.watch(feedRepositoryProvider));
});

/// Provider for GetUserPostsUseCase.
final getUserPostsUseCaseProvider = Provider<GetUserPostsUseCase>((ref) {
  return GetUserPostsUseCase(ref.watch(feedRepositoryProvider));
});

/// Provider for GetPostUseCase.
final getPostUseCaseProvider = Provider<GetPostUseCase>((ref) {
  return GetPostUseCase(ref.watch(feedRepositoryProvider));
});

/// Provider for CreatePostUseCase.
final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  return CreatePostUseCase(ref.watch(feedRepositoryProvider));
});

/// Provider for UpdatePostUseCase.
final updatePostUseCaseProvider = Provider<UpdatePostUseCase>((ref) {
  return UpdatePostUseCase(ref.watch(feedRepositoryProvider));
});

/// Provider for DeletePostUseCase.
final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  return DeletePostUseCase(ref.watch(feedRepositoryProvider));
});

/// Provider for ToggleReactionUseCase.
final toggleReactionUseCaseProvider = Provider<ToggleReactionUseCase>((ref) {
  return ToggleReactionUseCase(ref.watch(feedRepositoryProvider));
});

/// Provider for SearchPostsUseCase.
final searchPostsUseCaseProvider = Provider<SearchPostsUseCase>((ref) {
  return SearchPostsUseCase(ref.watch(feedRepositoryProvider));
});
