// lib/features/feed/presentation/providers/feed_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flavorizr/core/network/network_info.dart';
import 'package:flavorizr/features/feed/data/datasources/feed_local_datasource.dart';
import 'package:flavorizr/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:flavorizr/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:flavorizr/features/feed/domain/repositories/feed_repository.dart';
import 'package:flavorizr/features/feed/domain/usecases/feed_usecases.dart';

/// Provider for SharedPreferences.
/// Should be overridden in main.dart with actual instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Provider for Dio client.
/// Should be overridden with configured Dio instance.
final dioProvider = Provider<Dio>((ref) {
  throw UnimplementedError('Dio not initialized');
});

/// Provider for NetworkInfo.
final networkInfoProvider = Provider<NetworkInfo>((ref) {
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
    networkInfo: ref.watch(networkInfoProvider),
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
