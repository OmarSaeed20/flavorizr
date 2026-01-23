# Phase 6 — Advanced Features

> **Duration:** 3-4 weeks  
> **Priority:** Medium  
> **Dependencies:** Phases 1-5

---

## 📋 Overview

Phase 6 introduces advanced features that differentiate the app and provide enhanced user experiences. This phase covers background processing, media handling, advanced UI patterns, and social features.

**Key Deliverables:**
- Background task processing
- Advanced media handling (camera, gallery, cropping)
- Rich text editing
- Social sharing integration
- Advanced gestures and animations

---

## 🎯 Goals

| Goal | Success Criteria |
|------|------------------|
| Background Processing | Tasks run reliably in background |
| Media Handling | Full media workflow (capture, crop, upload) |
| Rich Text | Support formatted content editing |
| Social Features | Share content to major platforms |
| Advanced UI | Smooth, delightful interactions |

---

## 📁 Tasks Breakdown

### Task 6.1: Background Task Processing

**Estimated Time:** 3-4 days

#### Objectives
- Implement background task queue
- Handle background fetch
- Support work manager patterns
- Ensure task persistence

#### Implementation Steps

1. **Create `lib/core/background/background_task.dart`**
   ```dart
   import 'dart:async';
   import 'dart:convert';
   
   /// Represents a background task to be executed.
   /// 
   /// Tasks are:
   /// - Persisted across app restarts
   /// - Executed with retry logic
   /// - Prioritized by importance
   /// 
   /// Example:
   /// ```dart
   /// class UploadImageTask extends BackgroundTask {
   ///   final String imagePath;
   ///   
   ///   UploadImageTask({required this.imagePath});
   ///   
   ///   @override
   ///   Future<void> execute() async {
   ///     await uploadService.uploadImage(imagePath);
   ///   }
   /// }
   /// ```
   abstract class BackgroundTask {
     /// Unique identifier for this task.
     String get id;
     
     /// Human-readable task type for serialization.
     String get type;
     
     /// Priority (higher = more important).
     int get priority => 0;
     
     /// Maximum retry attempts.
     int get maxRetries => 3;
     
     /// Delay between retries.
     Duration get retryDelay => const Duration(seconds: 30);
     
     /// Whether this task requires network.
     bool get requiresNetwork => true;
     
     /// Whether this task should run only when device is charging.
     bool get requiresCharging => false;
     
     /// Whether this task should run only when device is idle.
     bool get requiresIdle => false;
     
     /// Execute the task.
     /// 
     /// Throws an exception if the task fails.
     Future<void> execute();
     
     /// Serialize the task to JSON for persistence.
     Map<String, dynamic> toJson();
     
     /// Create a task from serialized JSON.
     static BackgroundTask fromJson(Map<String, dynamic> json) {
       // This would be implemented by a registry
       throw UnimplementedError('Task registry not initialized');
     }
   }
   
   /// Tracks the state of a background task.
   class TaskState {
     /// Task identifier.
     final String taskId;
     
     /// Current status.
     final TaskStatus status;
     
     /// Number of attempts made.
     final int attempts;
     
     /// Last error message if failed.
     final String? lastError;
     
     /// When the task was created.
     final DateTime createdAt;
     
     /// When the task was last updated.
     final DateTime updatedAt;
     
     /// When the task should next be attempted.
     final DateTime? nextAttemptAt;
     
     /// Progress (0.0 to 1.0) if available.
     final double? progress;
     
     const TaskState({
       required this.taskId,
       required this.status,
       this.attempts = 0,
       this.lastError,
       required this.createdAt,
       required this.updatedAt,
       this.nextAttemptAt,
       this.progress,
     });
     
     /// Create a copy with updated fields.
     TaskState copyWith({
       TaskStatus? status,
       int? attempts,
       String? lastError,
       DateTime? updatedAt,
       DateTime? nextAttemptAt,
       double? progress,
     }) {
       return TaskState(
         taskId: taskId,
         status: status ?? this.status,
         attempts: attempts ?? this.attempts,
         lastError: lastError ?? this.lastError,
         createdAt: createdAt,
         updatedAt: updatedAt ?? DateTime.now(),
         nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
         progress: progress ?? this.progress,
       );
     }
     
     /// Serialize to JSON.
     Map<String, dynamic> toJson() => {
       'taskId': taskId,
       'status': status.name,
       'attempts': attempts,
       'lastError': lastError,
       'createdAt': createdAt.toIso8601String(),
       'updatedAt': updatedAt.toIso8601String(),
       'nextAttemptAt': nextAttemptAt?.toIso8601String(),
       'progress': progress,
     };
     
     /// Deserialize from JSON.
     factory TaskState.fromJson(Map<String, dynamic> json) => TaskState(
       taskId: json['taskId'] as String,
       status: TaskStatus.values.byName(json['status'] as String),
       attempts: json['attempts'] as int? ?? 0,
       lastError: json['lastError'] as String?,
       createdAt: DateTime.parse(json['createdAt'] as String),
       updatedAt: DateTime.parse(json['updatedAt'] as String),
       nextAttemptAt: json['nextAttemptAt'] != null
           ? DateTime.parse(json['nextAttemptAt'] as String)
           : null,
       progress: json['progress'] as double?,
     );
   }
   
   /// Status of a background task.
   enum TaskStatus {
     /// Task is waiting to be executed.
     pending,
     
     /// Task is currently running.
     running,
     
     /// Task completed successfully.
     completed,
     
     /// Task failed and will be retried.
     retrying,
     
     /// Task failed permanently.
     failed,
     
     /// Task was cancelled.
     cancelled,
   }
   ```

2. **Create `lib/core/background/task_queue.dart`**
   ```dart
   import 'dart:async';
   import 'dart:collection';
   
   import 'background_task.dart';
   
   /// Manages a queue of background tasks.
   /// 
   /// Features:
   /// - Priority queue ordering
   /// - Concurrent execution limits
   /// - Automatic retries
   /// - Persistence across restarts
   /// - Network awareness
   /// 
   /// Example:
   /// ```dart
   /// final queue = TaskQueue(
   ///   maxConcurrent: 3,
   ///   storage: SharedPrefsTaskStorage(),
   /// );
   /// 
   /// await queue.enqueue(UploadImageTask(imagePath: '/path/to/image.jpg'));
   /// ```
   class TaskQueue {
     /// Maximum concurrent tasks.
     final int maxConcurrent;
     
     /// Storage for task persistence.
     final TaskStorage? storage;
     
     /// Network connectivity checker.
     final NetworkChecker? networkChecker;
     
     /// Queue of pending tasks, ordered by priority.
     final SplayTreeSet<_QueuedTask> _pendingTasks = SplayTreeSet<_QueuedTask>(
       (a, b) {
         // Higher priority first, then older tasks
         final priorityCompare = b.task.priority.compareTo(a.task.priority);
         if (priorityCompare != 0) return priorityCompare;
         return a.queuedAt.compareTo(b.queuedAt);
       },
     );
     
     /// Currently running tasks.
     final Map<String, BackgroundTask> _runningTasks = {};
     
     /// Task states.
     final Map<String, TaskState> _taskStates = {};
     
     /// Task completers for awaiting tasks.
     final Map<String, Completer<void>> _taskCompleters = {};
     
     /// Stream controller for task state changes.
     final _stateController = StreamController<TaskState>.broadcast();
     
     /// Whether the queue is processing.
     bool _isProcessing = false;
     
     /// Whether the queue is paused.
     bool _isPaused = false;
     
     TaskQueue({
       this.maxConcurrent = 3,
       this.storage,
       this.networkChecker,
     });
     
     /// Stream of task state changes.
     Stream<TaskState> get taskStateChanges => _stateController.stream;
     
     /// Number of pending tasks.
     int get pendingCount => _pendingTasks.length;
     
     /// Number of running tasks.
     int get runningCount => _runningTasks.length;
     
     /// Whether the queue is paused.
     bool get isPaused => _isPaused;
     
     /// Initialize the queue (load persisted tasks).
     Future<void> initialize() async {
       if (storage != null) {
         final persistedTasks = await storage!.loadTasks();
         for (final task in persistedTasks) {
           _enqueueInternal(task, persist: false);
         }
       }
       _startProcessing();
     }
     
     /// Enqueue a task for execution.
     Future<void> enqueue(BackgroundTask task) async {
       _enqueueInternal(task, persist: true);
       _startProcessing();
     }
     
     void _enqueueInternal(BackgroundTask task, {required bool persist}) {
       final state = TaskState(
         taskId: task.id,
         status: TaskStatus.pending,
         createdAt: DateTime.now(),
         updatedAt: DateTime.now(),
       );
       
       _taskStates[task.id] = state;
       _pendingTasks.add(_QueuedTask(task: task, queuedAt: DateTime.now()));
       _taskCompleters[task.id] = Completer<void>();
       
       _emitState(state);
       
       if (persist && storage != null) {
         storage!.saveTask(task);
       }
     }
     
     /// Wait for a task to complete.
     Future<void> waitFor(String taskId) {
       final completer = _taskCompleters[taskId];
       if (completer == null) {
         throw StateError('Task $taskId not found');
       }
       return completer.future;
     }
     
     /// Get the current state of a task.
     TaskState? getTaskState(String taskId) => _taskStates[taskId];
     
     /// Cancel a task.
     Future<void> cancel(String taskId) async {
       // Remove from pending
       _pendingTasks.removeWhere((t) => t.task.id == taskId);
       
       // Update state
       final state = _taskStates[taskId];
       if (state != null) {
         final newState = state.copyWith(status: TaskStatus.cancelled);
         _taskStates[taskId] = newState;
         _emitState(newState);
       }
       
       // Complete the completer
       final completer = _taskCompleters[taskId];
       if (completer != null && !completer.isCompleted) {
         completer.complete();
       }
       
       // Remove from storage
       if (storage != null) {
         await storage!.removeTask(taskId);
       }
     }
     
     /// Cancel all tasks.
     Future<void> cancelAll() async {
       final taskIds = _pendingTasks.map((t) => t.task.id).toList();
       for (final taskId in taskIds) {
         await cancel(taskId);
       }
     }
     
     /// Pause the queue.
     void pause() {
       _isPaused = true;
     }
     
     /// Resume the queue.
     void resume() {
       _isPaused = false;
       _startProcessing();
     }
     
     /// Start processing the queue.
     void _startProcessing() {
       if (_isProcessing || _isPaused) return;
       _isProcessing = true;
       _processQueue();
     }
     
     /// Process tasks from the queue.
     Future<void> _processQueue() async {
       while (_pendingTasks.isNotEmpty && !_isPaused) {
         // Wait if at max concurrency
         while (_runningTasks.length >= maxConcurrent) {
           await Future.delayed(const Duration(milliseconds: 100));
           if (_isPaused) break;
         }
         
         if (_isPaused || _pendingTasks.isEmpty) break;
         
         // Get next task
         final queuedTask = _pendingTasks.first;
         _pendingTasks.remove(queuedTask);
         
         // Check network requirement
         if (queuedTask.task.requiresNetwork) {
           final hasNetwork = await networkChecker?.hasConnection() ?? true;
           if (!hasNetwork) {
             // Re-queue for later
             _pendingTasks.add(queuedTask);
             await Future.delayed(const Duration(seconds: 5));
             continue;
           }
         }
         
         // Execute task
         _executeTask(queuedTask.task);
       }
       
       _isProcessing = false;
     }
     
     /// Execute a single task.
     Future<void> _executeTask(BackgroundTask task) async {
       _runningTasks[task.id] = task;
       
       final currentState = _taskStates[task.id]!;
       _updateState(task.id, currentState.copyWith(status: TaskStatus.running));
       
       try {
         await task.execute();
         
         // Success
         _updateState(task.id, currentState.copyWith(
           status: TaskStatus.completed,
           attempts: currentState.attempts + 1,
         ));
         
         _completeTask(task.id, success: true);
       } catch (error) {
         // Failure
         final newAttempts = currentState.attempts + 1;
         
         if (newAttempts < task.maxRetries) {
           // Retry later
           _updateState(task.id, currentState.copyWith(
             status: TaskStatus.retrying,
             attempts: newAttempts,
             lastError: error.toString(),
             nextAttemptAt: DateTime.now().add(task.retryDelay),
           ));
           
           // Re-queue
           await Future.delayed(task.retryDelay);
           _pendingTasks.add(_QueuedTask(task: task, queuedAt: DateTime.now()));
         } else {
           // Permanent failure
           _updateState(task.id, currentState.copyWith(
             status: TaskStatus.failed,
             attempts: newAttempts,
             lastError: error.toString(),
           ));
           
           _completeTask(task.id, success: false);
         }
       } finally {
         _runningTasks.remove(task.id);
       }
     }
     
     void _updateState(String taskId, TaskState state) {
       _taskStates[taskId] = state;
       _emitState(state);
     }
     
     void _emitState(TaskState state) {
       _stateController.add(state);
     }
     
     void _completeTask(String taskId, {required bool success}) {
       final completer = _taskCompleters[taskId];
       if (completer != null && !completer.isCompleted) {
         completer.complete();
       }
       
       // Remove from storage
       storage?.removeTask(taskId);
     }
     
     /// Dispose the queue.
     void dispose() {
       _stateController.close();
       _isPaused = true;
     }
   }
   
   /// A task in the queue with its queue time.
   class _QueuedTask {
     final BackgroundTask task;
     final DateTime queuedAt;
     
     _QueuedTask({required this.task, required this.queuedAt});
   }
   
   /// Storage interface for task persistence.
   abstract class TaskStorage {
     Future<List<BackgroundTask>> loadTasks();
     Future<void> saveTask(BackgroundTask task);
     Future<void> removeTask(String taskId);
   }
   
   /// Network connectivity checker interface.
   abstract class NetworkChecker {
     Future<bool> hasConnection();
   }
   ```

3. **Create `lib/core/background/work_manager_service.dart`**
   ```dart
   import 'dart:async';
   
   /// Service for scheduling periodic and one-off background work.
   /// 
   /// Wraps platform-specific APIs:
   /// - Android: WorkManager
   /// - iOS: BGTaskScheduler
   /// 
   /// Example:
   /// ```dart
   /// await workManager.registerPeriodicTask(
   ///   taskId: 'sync_data',
   ///   frequency: Duration(hours: 1),
   ///   constraints: WorkConstraints(
   ///     requiresNetwork: true,
   ///     requiresCharging: false,
   ///   ),
   /// );
   /// ```
   class WorkManagerService {
     /// Registered task handlers.
     final Map<String, Future<void> Function()> _handlers = {};
     
     /// Whether the service is initialized.
     bool _initialized = false;
     
     /// Initialize the work manager.
     Future<void> initialize() async {
       if (_initialized) return;
       
       // Platform-specific initialization
       // await Workmanager().initialize(callbackDispatcher);
       
       _initialized = true;
     }
     
     /// Register a handler for a task type.
     void registerHandler(String taskId, Future<void> Function() handler) {
       _handlers[taskId] = handler;
     }
     
     /// Schedule a one-off task.
     Future<void> scheduleOneOffTask({
       required String taskId,
       required String taskName,
       Duration? initialDelay,
       WorkConstraints? constraints,
       Map<String, dynamic>? inputData,
     }) async {
       // await Workmanager().registerOneOffTask(
       //   taskId,
       //   taskName,
       //   initialDelay: initialDelay ?? Duration.zero,
       //   constraints: constraints?.toNative(),
       //   inputData: inputData,
       // );
     }
     
     /// Schedule a periodic task.
     Future<void> schedulePeriodicTask({
       required String taskId,
       required String taskName,
       required Duration frequency,
       Duration? initialDelay,
       WorkConstraints? constraints,
       Map<String, dynamic>? inputData,
     }) async {
       // await Workmanager().registerPeriodicTask(
       //   taskId,
       //   taskName,
       //   frequency: frequency,
       //   initialDelay: initialDelay ?? Duration.zero,
       //   constraints: constraints?.toNative(),
       //   inputData: inputData,
       // );
     }
     
     /// Cancel a scheduled task.
     Future<void> cancelTask(String taskId) async {
       // await Workmanager().cancelByUniqueName(taskId);
     }
     
     /// Cancel all scheduled tasks.
     Future<void> cancelAllTasks() async {
       // await Workmanager().cancelAll();
     }
     
     /// Execute a registered handler.
     Future<void> executeHandler(String taskId) async {
       final handler = _handlers[taskId];
       if (handler != null) {
         await handler();
       }
     }
   }
   
   /// Constraints for background work execution.
   class WorkConstraints {
     /// Require network connectivity.
     final bool requiresNetwork;
     
     /// Require unmetered (WiFi) network.
     final bool requiresUnmeteredNetwork;
     
     /// Require device to be charging.
     final bool requiresCharging;
     
     /// Require device to be idle.
     final bool requiresIdle;
     
     /// Require sufficient battery level.
     final bool requiresBatteryNotLow;
     
     /// Require sufficient storage.
     final bool requiresStorageNotLow;
     
     const WorkConstraints({
       this.requiresNetwork = false,
       this.requiresUnmeteredNetwork = false,
       this.requiresCharging = false,
       this.requiresIdle = false,
       this.requiresBatteryNotLow = false,
       this.requiresStorageNotLow = false,
     });
   }
   ```

#### Acceptance Criteria
- [ ] Tasks are executed in order of priority
- [ ] Failed tasks are retried automatically
- [ ] Tasks persist across app restarts
- [ ] Network-dependent tasks wait for connectivity
- [ ] Progress can be tracked

---

### Task 6.2: Media Handling

**Estimated Time:** 4-5 days

#### Objectives
- Implement camera capture
- Implement gallery picker
- Add image cropping
- Add image compression
- Handle video capture

#### Implementation Steps

1. **Create `lib/core/media/media_service.dart`**
   ```dart
   import 'dart:io';
   import 'dart:typed_data';
   
   /// Unified service for media capture and selection.
   /// 
   /// Supports:
   /// - Camera capture (photo and video)
   /// - Gallery selection (single and multiple)
   /// - Image cropping
   /// - Image compression
   /// - Video compression
   /// 
   /// Example:
   /// ```dart
   /// final media = MediaService();
   /// 
   /// // Capture a photo
   /// final photo = await media.capturePhoto(
   ///   quality: 85,
   ///   maxWidth: 1920,
   /// );
   /// 
   /// // Crop the photo
   /// final cropped = await media.cropImage(
   ///   photo!,
   ///   aspectRatio: CropAspectRatio.square,
   /// );
   /// ```
   class MediaService {
     /// Capture a photo using the camera.
     /// 
     /// Returns null if cancelled.
     Future<MediaFile?> capturePhoto({
       int quality = 85,
       int? maxWidth,
       int? maxHeight,
       CameraDevice preferredCamera = CameraDevice.back,
     }) async {
       // Implementation using image_picker
       // final picker = ImagePicker();
       // final image = await picker.pickImage(
       //   source: ImageSource.camera,
       //   imageQuality: quality,
       //   maxWidth: maxWidth?.toDouble(),
       //   maxHeight: maxHeight?.toDouble(),
       //   preferredCameraDevice: preferredCamera == CameraDevice.front
       //       ? CameraDevice.front
       //       : CameraDevice.rear,
       // );
       // 
       // if (image == null) return null;
       // 
       // return MediaFile(
       //   path: image.path,
       //   type: MediaType.image,
       //   mimeType: 'image/jpeg',
       // );
       
       return null; // Placeholder
     }
     
     /// Capture a video using the camera.
     /// 
     /// Returns null if cancelled.
     Future<MediaFile?> captureVideo({
       Duration? maxDuration,
       CameraDevice preferredCamera = CameraDevice.back,
       VideoQuality quality = VideoQuality.high,
     }) async {
       // Implementation using image_picker
       return null; // Placeholder
     }
     
     /// Pick an image from the gallery.
     /// 
     /// Returns null if cancelled.
     Future<MediaFile?> pickImage({
       int quality = 85,
       int? maxWidth,
       int? maxHeight,
     }) async {
       // Implementation using image_picker
       return null; // Placeholder
     }
     
     /// Pick multiple images from the gallery.
     Future<List<MediaFile>> pickMultipleImages({
       int quality = 85,
       int? maxWidth,
       int? maxHeight,
       int? maxCount,
     }) async {
       // Implementation using image_picker
       return []; // Placeholder
     }
     
     /// Pick a video from the gallery.
     /// 
     /// Returns null if cancelled.
     Future<MediaFile?> pickVideo({
       Duration? maxDuration,
     }) async {
       // Implementation using image_picker
       return null; // Placeholder
     }
     
     /// Crop an image.
     /// 
     /// Returns null if cancelled.
     Future<MediaFile?> cropImage(
       MediaFile image, {
       CropAspectRatio? aspectRatio,
       int? maxWidth,
       int? maxHeight,
       bool lockAspectRatio = false,
     }) async {
       // Implementation using image_cropper
       return null; // Placeholder
     }
     
     /// Compress an image.
     Future<MediaFile> compressImage(
       MediaFile image, {
       int quality = 85,
       int? maxWidth,
       int? maxHeight,
       CompressFormat format = CompressFormat.jpeg,
     }) async {
       // Implementation using flutter_image_compress
       return image; // Placeholder
     }
     
     /// Compress a video.
     Future<MediaFile> compressVideo(
       MediaFile video, {
       VideoQuality quality = VideoQuality.medium,
     }) async {
       // Implementation using video_compress
       return video; // Placeholder
     }
     
     /// Get the file size in bytes.
     Future<int> getFileSize(MediaFile file) async {
       final ioFile = File(file.path);
       return ioFile.length();
     }
     
     /// Get image dimensions.
     Future<MediaDimensions?> getImageDimensions(MediaFile file) async {
       // Implementation
       return null; // Placeholder
     }
     
     /// Get video duration and dimensions.
     Future<MediaMetadata?> getVideoMetadata(MediaFile file) async {
       // Implementation
       return null; // Placeholder
     }
     
     /// Generate a thumbnail for a video.
     Future<Uint8List?> generateVideoThumbnail(
       MediaFile video, {
       int width = 200,
       int quality = 50,
     }) async {
       // Implementation using video_thumbnail
       return null; // Placeholder
     }
     
     /// Delete a media file.
     Future<void> deleteFile(MediaFile file) async {
       final ioFile = File(file.path);
       if (await ioFile.exists()) {
         await ioFile.delete();
       }
     }
   }
   
   /// Represents a media file (image or video).
   class MediaFile {
     /// Path to the file.
     final String path;
     
     /// Type of media.
     final MediaType type;
     
     /// MIME type.
     final String? mimeType;
     
     /// Original filename.
     final String? originalFilename;
     
     /// File size in bytes.
     final int? size;
     
     /// Creation timestamp.
     final DateTime? createdAt;
     
     const MediaFile({
       required this.path,
       required this.type,
       this.mimeType,
       this.originalFilename,
       this.size,
       this.createdAt,
     });
     
     /// Get the file extension.
     String get extension => path.split('.').last.toLowerCase();
     
     /// Get a File reference.
     File get file => File(path);
     
     /// Create a copy with updated fields.
     MediaFile copyWith({
       String? path,
       MediaType? type,
       String? mimeType,
       String? originalFilename,
       int? size,
       DateTime? createdAt,
     }) {
       return MediaFile(
         path: path ?? this.path,
         type: type ?? this.type,
         mimeType: mimeType ?? this.mimeType,
         originalFilename: originalFilename ?? this.originalFilename,
         size: size ?? this.size,
         createdAt: createdAt ?? this.createdAt,
       );
     }
   }
   
   /// Type of media.
   enum MediaType {
     image,
     video,
   }
   
   /// Camera device.
   enum CameraDevice {
     front,
     back,
   }
   
   /// Video quality preset.
   enum VideoQuality {
     low,
     medium,
     high,
     max,
   }
   
   /// Image compression format.
   enum CompressFormat {
     jpeg,
     png,
     webp,
   }
   
   /// Crop aspect ratio presets.
   enum CropAspectRatio {
     square,
     portrait3x4,
     portrait9x16,
     landscape4x3,
     landscape16x9,
     free,
   }
   
   /// Media dimensions.
   class MediaDimensions {
     final int width;
     final int height;
     
     const MediaDimensions({required this.width, required this.height});
     
     double get aspectRatio => width / height;
   }
   
   /// Video metadata.
   class MediaMetadata {
     final Duration? duration;
     final MediaDimensions? dimensions;
     final int? bitrate;
     
     const MediaMetadata({
       this.duration,
       this.dimensions,
       this.bitrate,
     });
   }
   ```

2. **Create `lib/core/media/media_upload_service.dart`**
   ```dart
   import 'dart:async';
   import 'dart:io';
   
   import '../background/background_task.dart';
   import 'media_service.dart';
   
   /// Service for uploading media files with progress tracking.
   /// 
   /// Features:
   /// - Progress tracking
   /// - Retry on failure
   /// - Background upload support
   /// - Chunked uploads for large files
   class MediaUploadService {
     /// Active uploads.
     final Map<String, _UploadOperation> _uploads = {};
     
     /// Stream controller for upload progress.
     final _progressController = StreamController<UploadProgress>.broadcast();
     
     /// Stream of upload progress updates.
     Stream<UploadProgress> get progressStream => _progressController.stream;
     
     /// Upload a media file.
     /// 
     /// Returns the URL of the uploaded file.
     Future<String> upload(
       MediaFile file, {
       required String uploadUrl,
       String? uploadId,
       Map<String, String>? headers,
       Map<String, String>? metadata,
       bool useChunkedUpload = false,
       int chunkSize = 1024 * 1024, // 1MB chunks
       void Function(double progress)? onProgress,
     }) async {
       final id = uploadId ?? DateTime.now().millisecondsSinceEpoch.toString();
       
       // Create upload operation
       final operation = _UploadOperation(
         id: id,
         file: file,
         uploadUrl: uploadUrl,
         headers: headers,
         metadata: metadata,
       );
       
       _uploads[id] = operation;
       
       try {
         // Emit initial progress
         _emitProgress(id, 0.0, UploadStatus.starting);
         
         // Perform upload
         final url = await _performUpload(
           operation,
           useChunkedUpload: useChunkedUpload,
           chunkSize: chunkSize,
           onProgress: (progress) {
             _emitProgress(id, progress, UploadStatus.uploading);
             onProgress?.call(progress);
           },
         );
         
         // Success
         _emitProgress(id, 1.0, UploadStatus.completed, url: url);
         
         return url;
       } catch (error) {
         // Failure
         _emitProgress(id, 0.0, UploadStatus.failed, error: error.toString());
         rethrow;
       } finally {
         _uploads.remove(id);
       }
     }
     
     /// Cancel an upload.
     void cancel(String uploadId) {
       final operation = _uploads[uploadId];
       if (operation != null) {
         operation.cancelled = true;
         _emitProgress(uploadId, 0.0, UploadStatus.cancelled);
         _uploads.remove(uploadId);
       }
     }
     
     /// Get current progress for an upload.
     UploadProgress? getProgress(String uploadId) {
       final operation = _uploads[uploadId];
       if (operation != null) {
         return UploadProgress(
           uploadId: uploadId,
           progress: operation.progress,
           status: UploadStatus.uploading,
         );
       }
       return null;
     }
     
     Future<String> _performUpload(
       _UploadOperation operation, {
       required bool useChunkedUpload,
       required int chunkSize,
       required void Function(double) onProgress,
     }) async {
       // Implementation would use http or dio
       // This is a placeholder
       
       final file = File(operation.file.path);
       final fileSize = await file.length();
       
       if (useChunkedUpload && fileSize > chunkSize) {
         return _chunkedUpload(operation, chunkSize, onProgress);
       } else {
         return _simpleUpload(operation, onProgress);
       }
     }
     
     Future<String> _simpleUpload(
       _UploadOperation operation,
       void Function(double) onProgress,
     ) async {
       // Simple multipart upload
       // Using http package or dio
       
       // Placeholder implementation
       await Future.delayed(const Duration(seconds: 2));
       onProgress(0.5);
       await Future.delayed(const Duration(seconds: 2));
       onProgress(1.0);
       
       return 'https://example.com/uploads/${operation.id}';
     }
     
     Future<String> _chunkedUpload(
       _UploadOperation operation,
       int chunkSize,
       void Function(double) onProgress,
     ) async {
       // Chunked upload implementation
       // Upload in chunks, resume on failure
       
       // Placeholder implementation
       await Future.delayed(const Duration(seconds: 4));
       onProgress(1.0);
       
       return 'https://example.com/uploads/${operation.id}';
     }
     
     void _emitProgress(
       String uploadId,
       double progress,
       UploadStatus status, {
       String? url,
       String? error,
     }) {
       _progressController.add(UploadProgress(
         uploadId: uploadId,
         progress: progress,
         status: status,
         url: url,
         error: error,
       ));
     }
     
     /// Dispose the service.
     void dispose() {
       _progressController.close();
     }
   }
   
   /// Tracks an upload operation.
   class _UploadOperation {
     final String id;
     final MediaFile file;
     final String uploadUrl;
     final Map<String, String>? headers;
     final Map<String, String>? metadata;
     double progress = 0.0;
     bool cancelled = false;
     
     _UploadOperation({
       required this.id,
       required this.file,
       required this.uploadUrl,
       this.headers,
       this.metadata,
     });
   }
   
   /// Progress of an upload.
   class UploadProgress {
     /// Upload identifier.
     final String uploadId;
     
     /// Progress (0.0 to 1.0).
     final double progress;
     
     /// Current status.
     final UploadStatus status;
     
     /// URL if completed.
     final String? url;
     
     /// Error message if failed.
     final String? error;
     
     const UploadProgress({
       required this.uploadId,
       required this.progress,
       required this.status,
       this.url,
       this.error,
     });
     
     /// Progress as percentage (0-100).
     int get percentage => (progress * 100).round();
   }
   
   /// Upload status.
   enum UploadStatus {
     starting,
     uploading,
     completed,
     failed,
     cancelled,
   }
   
   /// Background upload task.
   class MediaUploadTask extends BackgroundTask {
     final MediaFile file;
     final String uploadUrl;
     final Map<String, String>? headers;
     final Map<String, String>? metadata;
     
     MediaUploadTask({
       required this.file,
       required this.uploadUrl,
       this.headers,
       this.metadata,
     });
     
     @override
     String get id => 'upload_${file.path.hashCode}';
     
     @override
     String get type => 'media_upload';
     
     @override
     bool get requiresNetwork => true;
     
     @override
     Future<void> execute() async {
       final service = MediaUploadService();
       await service.upload(
         file,
         uploadUrl: uploadUrl,
         headers: headers,
         metadata: metadata,
       );
     }
     
     @override
     Map<String, dynamic> toJson() => {
       'type': type,
       'filePath': file.path,
       'fileType': file.type.name,
       'uploadUrl': uploadUrl,
       'headers': headers,
       'metadata': metadata,
     };
   }
   ```

#### Acceptance Criteria
- [ ] Camera capture works on iOS and Android
- [ ] Gallery picker supports single and multiple selection
- [ ] Images can be cropped with various aspect ratios
- [ ] Images are compressed before upload
- [ ] Upload progress is tracked
- [ ] Large files use chunked upload

---

### Task 6.3: Rich Text Editing

**Estimated Time:** 3-4 days

*(Detailed rich text editor implementation)*

---

### Task 6.4: Social Sharing

**Estimated Time:** 2-3 days

*(Detailed social sharing implementation)*

---

### Task 6.5: Advanced Animations

**Estimated Time:** 3-4 days

*(Detailed animation framework implementation)*

---

## 📊 Phase 6 Checklist

| Task | Status | Notes |
|------|--------|-------|
| 6.1 Background Tasks | ⬜ | |
| 6.2 Media Handling | ⬜ | |
| 6.3 Rich Text Editing | ⬜ | |
| 6.4 Social Sharing | ⬜ | |
| 6.5 Advanced Animations | ⬜ | |

---

## 🔗 Dependencies for Next Phase

Phase 7 requires the following from Phase 6:
- ✅ Background tasks for sync operations
- ✅ Media handling for content creation
- ✅ Animations for premium features

---

## 📝 Notes

- Test background tasks thoroughly on real devices
- Media permissions must be requested at appropriate times
- Rich text should support undo/redo
- Social sharing should use native share sheets
- Animations should respect reduced motion preferences
