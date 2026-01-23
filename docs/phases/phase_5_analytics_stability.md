# Phase 5 — Analytics & Stability

> **Duration:** 2-3 weeks  
> **Priority:** Medium-High  
> **Dependencies:** Phases 1-4

---

## 📋 Overview

Phase 5 focuses on comprehensive analytics, crash reporting, error handling, and app stability. This phase ensures you can monitor app health, understand user behavior, and quickly respond to issues.

**Key Deliverables:**
- Comprehensive analytics system
- Crash reporting and error tracking
- User behavior insights
- A/B testing infrastructure
- App health monitoring

---

## 🎯 Goals

| Goal | Success Criteria |
|------|------------------|
| Analytics | Track key user actions and funnels |
| Crash Reporting | < 1% crash-free session rate |
| Error Handling | All errors are logged and categorized |
| A/B Testing | Can run experiments on features |
| Monitoring | Real-time app health dashboards |

---

## 📁 Tasks Breakdown

### Task 5.1: Analytics Architecture

**Estimated Time:** 3-4 days

#### Objectives
- Create unified analytics abstraction
- Support multiple analytics providers
- Implement event tracking
- Track user properties and funnels

#### Implementation Steps

1. **Create `lib/core/analytics/analytics_event.dart`**
   ```dart
   /// Base class for all analytics events.
   /// 
   /// Events represent user actions, system events, or business metrics
   /// that should be tracked for analysis.
   /// 
   /// Example:
   /// ```dart
   /// class LoginEvent extends AnalyticsEvent {
   ///   final String method; // 'email', 'google', etc.
   ///   
   ///   LoginEvent({required this.method});
   ///   
   ///   @override
   ///   String get name => 'login';
   ///   
   ///   @override
   ///   Map<String, dynamic> get properties => {'method': method};
   /// }
   /// ```
   abstract class AnalyticsEvent {
     /// The name of the event (e.g., 'login', 'purchase', 'screen_view').
     /// 
     /// Should be snake_case and descriptive.
     String get name;
     
     /// Properties associated with this event.
     /// 
     /// Keys should be snake_case.
     /// Values should be primitive types (String, int, double, bool) or List/Map.
     Map<String, dynamic> get properties;
     
     /// Optional timestamp override (defaults to now).
     DateTime? get timestamp => null;
     
     /// Optional user ID override.
     String? get userId => null;
     
     /// Converts the event to a JSON-serializable map.
     Map<String, dynamic> toJson() {
       return {
         'event': name,
         'properties': properties,
         'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
         if (userId != null) 'user_id': userId,
       };
     }
     
     @override
     String toString() => 'AnalyticsEvent($name, $properties)';
   }
   
   /// Screen view event for tracking navigation.
   class ScreenViewEvent extends AnalyticsEvent {
     /// Name of the screen.
     final String screenName;
     
     /// Optional screen class for more detail.
     final String? screenClass;
     
     /// Optional previous screen name.
     final String? previousScreenName;
     
     /// Additional custom properties.
     final Map<String, dynamic>? customProperties;
     
     ScreenViewEvent({
       required this.screenName,
       this.screenClass,
       this.previousScreenName,
       this.customProperties,
     });
     
     @override
     String get name => 'screen_view';
     
     @override
     Map<String, dynamic> get properties => {
       'screen_name': screenName,
       if (screenClass != null) 'screen_class': screenClass,
       if (previousScreenName != null) 'previous_screen': previousScreenName,
       ...?customProperties,
     };
   }
   
   /// User action event for tracking interactions.
   class UserActionEvent extends AnalyticsEvent {
     /// The action name (e.g., 'button_click', 'swipe', 'submit').
     final String action;
     
     /// Category of the action (e.g., 'navigation', 'form', 'content').
     final String? category;
     
     /// Optional label for more detail.
     final String? label;
     
     /// Optional numeric value.
     final double? value;
     
     /// Additional properties.
     final Map<String, dynamic>? extraProperties;
     
     UserActionEvent({
       required this.action,
       this.category,
       this.label,
       this.value,
       this.extraProperties,
     });
     
     @override
     String get name => 'user_action';
     
     @override
     Map<String, dynamic> get properties => {
       'action': action,
       if (category != null) 'category': category,
       if (label != null) 'label': label,
       if (value != null) 'value': value,
       ...?extraProperties,
     };
   }
   
   /// Error event for tracking errors that don't crash the app.
   class ErrorEvent extends AnalyticsEvent {
     /// Error message.
     final String message;
     
     /// Error type/code.
     final String? errorType;
     
     /// Stack trace if available.
     final String? stackTrace;
     
     /// Where the error occurred.
     final String? location;
     
     /// Severity level.
     final ErrorSeverity severity;
     
     /// Additional context.
     final Map<String, dynamic>? context;
     
     ErrorEvent({
       required this.message,
       this.errorType,
       this.stackTrace,
       this.location,
       this.severity = ErrorSeverity.error,
       this.context,
     });
     
     @override
     String get name => 'error';
     
     @override
     Map<String, dynamic> get properties => {
       'message': message,
       'severity': severity.name,
       if (errorType != null) 'error_type': errorType,
       if (stackTrace != null) 'stack_trace': stackTrace,
       if (location != null) 'location': location,
       ...?context,
     };
   }
   
   /// Error severity levels.
   enum ErrorSeverity {
     /// Debug level - for development.
     debug,
     
     /// Info level - informational.
     info,
     
     /// Warning level - potential issue.
     warning,
     
     /// Error level - error occurred but handled.
     error,
     
     /// Fatal level - app cannot continue.
     fatal,
   }
   
   /// Timing event for tracking performance.
   class TimingEvent extends AnalyticsEvent {
     /// What is being timed (e.g., 'api_call', 'screen_load').
     final String category;
     
     /// Specific item being timed.
     final String variable;
     
     /// Duration in milliseconds.
     final int durationMs;
     
     /// Optional label.
     final String? label;
     
     TimingEvent({
       required this.category,
       required this.variable,
       required this.durationMs,
       this.label,
     });
     
     @override
     String get name => 'timing';
     
     @override
     Map<String, dynamic> get properties => {
       'category': category,
       'variable': variable,
       'duration_ms': durationMs,
       if (label != null) 'label': label,
     };
   }
   ```

2. **Create `lib/core/analytics/analytics_provider.dart`**
   ```dart
   import 'analytics_event.dart';
   
   /// Base interface for analytics providers.
   /// 
   /// Implement this to add support for analytics platforms like:
   /// - Firebase Analytics
   /// - Mixpanel
   /// - Amplitude
   /// - Segment
   /// - Custom backend
   abstract class AnalyticsProvider {
     /// Provider name for debugging.
     String get name;
     
     /// Initialize the provider.
     Future<void> initialize();
     
     /// Track an event.
     Future<void> trackEvent(AnalyticsEvent event);
     
     /// Identify the user.
     Future<void> identify(String userId, {Map<String, dynamic>? traits});
     
     /// Set user properties.
     Future<void> setUserProperties(Map<String, dynamic> properties);
     
     /// Reset/logout the user.
     Future<void> reset();
     
     /// Flush pending events.
     Future<void> flush();
     
     /// Enable or disable tracking.
     Future<void> setEnabled(bool enabled);
     
     /// Clean up resources.
     Future<void> dispose();
   }
   
   /// Firebase Analytics implementation.
   class FirebaseAnalyticsProvider implements AnalyticsProvider {
     // Firebase Analytics instance would be injected here
     bool _enabled = true;
     
     @override
     String get name => 'firebase';
     
     @override
     Future<void> initialize() async {
       // Initialize Firebase Analytics
       // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(_enabled);
     }
     
     @override
     Future<void> trackEvent(AnalyticsEvent event) async {
       if (!_enabled) return;
       
       // Map to Firebase Analytics event
       // await FirebaseAnalytics.instance.logEvent(
       //   name: event.name,
       //   parameters: _sanitizeParameters(event.properties),
       // );
     }
     
     @override
     Future<void> identify(String userId, {Map<String, dynamic>? traits}) async {
       if (!_enabled) return;
       
       // await FirebaseAnalytics.instance.setUserId(id: userId);
       if (traits != null) {
         await setUserProperties(traits);
       }
     }
     
     @override
     Future<void> setUserProperties(Map<String, dynamic> properties) async {
       if (!_enabled) return;
       
       // Firebase allows up to 25 user properties
       // for (final entry in properties.entries.take(25)) {
       //   await FirebaseAnalytics.instance.setUserProperty(
       //     name: entry.key,
       //     value: entry.value?.toString(),
       //   );
       // }
     }
     
     @override
     Future<void> reset() async {
       // await FirebaseAnalytics.instance.setUserId(id: null);
     }
     
     @override
     Future<void> flush() async {
       // Firebase Analytics auto-flushes
     }
     
     @override
     Future<void> setEnabled(bool enabled) async {
       _enabled = enabled;
       // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);
     }
     
     @override
     Future<void> dispose() async {
       // No cleanup needed for Firebase
     }
     
     /// Sanitize parameters for Firebase (no nested objects, limited types).
     Map<String, Object>? _sanitizeParameters(Map<String, dynamic>? params) {
       if (params == null || params.isEmpty) return null;
       
       return params.map((key, value) {
         // Firebase parameter names: 1-40 chars, alphanumeric + underscore
         final sanitizedKey = key
             .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_')
             .substring(0, key.length.clamp(0, 40));
         
         // Firebase parameter values: String (up to 100 chars), int, double
         Object sanitizedValue;
         if (value is String) {
           sanitizedValue = value.substring(0, value.length.clamp(0, 100));
         } else if (value is int || value is double || value is bool) {
           sanitizedValue = value;
         } else {
           sanitizedValue = value.toString().substring(
             0,
             value.toString().length.clamp(0, 100),
           );
         }
         
         return MapEntry(sanitizedKey, sanitizedValue);
       });
     }
   }
   
   /// Debug provider that logs all events.
   class DebugAnalyticsProvider implements AnalyticsProvider {
     final void Function(String)? logger;
     bool _enabled = true;
     
     DebugAnalyticsProvider({this.logger});
     
     @override
     String get name => 'debug';
     
     @override
     Future<void> initialize() async {
       _log('Analytics initialized');
     }
     
     @override
     Future<void> trackEvent(AnalyticsEvent event) async {
       if (!_enabled) return;
       _log('Event: ${event.name} | ${event.properties}');
     }
     
     @override
     Future<void> identify(String userId, {Map<String, dynamic>? traits}) async {
       if (!_enabled) return;
       _log('Identify: $userId | $traits');
     }
     
     @override
     Future<void> setUserProperties(Map<String, dynamic> properties) async {
       if (!_enabled) return;
       _log('User properties: $properties');
     }
     
     @override
     Future<void> reset() async {
       _log('Analytics reset');
     }
     
     @override
     Future<void> flush() async {
       _log('Analytics flushed');
     }
     
     @override
     Future<void> setEnabled(bool enabled) async {
       _enabled = enabled;
       _log('Analytics ${enabled ? 'enabled' : 'disabled'}');
     }
     
     @override
     Future<void> dispose() async {
       _log('Analytics disposed');
     }
     
     void _log(String message) {
       if (logger != null) {
         logger!('[Analytics] $message');
       } else {
         print('[Analytics] $message');
       }
     }
   }
   ```

3. **Create `lib/core/analytics/analytics_service.dart`**
   ```dart
   import 'dart:async';
   
   import 'analytics_event.dart';
   import 'analytics_provider.dart';
   
   /// Unified analytics service that dispatches to multiple providers.
   /// 
   /// Example usage:
   /// ```dart
   /// final analytics = AnalyticsService([
   ///   FirebaseAnalyticsProvider(),
   ///   MixpanelProvider(),
   ///   DebugAnalyticsProvider(),
   /// ]);
   /// 
   /// await analytics.initialize();
   /// 
   /// analytics.track(LoginEvent(method: 'email'));
   /// analytics.identify('user_123', traits: {'plan': 'premium'});
   /// ```
   class AnalyticsService {
     /// List of analytics providers.
     final List<AnalyticsProvider> _providers;
     
     /// Event queue for offline support.
     final List<AnalyticsEvent> _eventQueue = [];
     
     /// Maximum queue size.
     final int _maxQueueSize;
     
     /// Whether the service is initialized.
     bool _initialized = false;
     
     /// Whether tracking is enabled.
     bool _enabled = true;
     
     /// Current user ID.
     String? _userId;
     
     /// User properties.
     final Map<String, dynamic> _userProperties = {};
     
     /// Super properties (sent with every event).
     final Map<String, dynamic> _superProperties = {};
     
     /// Sampling rate (0.0 to 1.0).
     double _samplingRate = 1.0;
     
     AnalyticsService(
       this._providers, {
       int maxQueueSize = 1000,
     }) : _maxQueueSize = maxQueueSize;
     
     /// Initialize all providers.
     Future<void> initialize() async {
       if (_initialized) return;
       
       await Future.wait(
         _providers.map((p) => _safeCall(() => p.initialize())),
       );
       
       _initialized = true;
       
       // Process any queued events
       await _processQueue();
     }
     
     /// Track an event.
     /// 
     /// Events are sent to all providers. If not initialized, events are queued.
     void track(AnalyticsEvent event) {
       if (!_enabled) return;
       if (!_shouldSample()) return;
       
       if (!_initialized) {
         _queueEvent(event);
         return;
       }
       
       _trackToProviders(event);
     }
     
     /// Track a screen view.
     void trackScreen(
       String screenName, {
       String? screenClass,
       String? previousScreen,
       Map<String, dynamic>? properties,
     }) {
       track(ScreenViewEvent(
         screenName: screenName,
         screenClass: screenClass,
         previousScreenName: previousScreen,
         customProperties: properties,
       ));
     }
     
     /// Track a user action.
     void trackAction(
       String action, {
       String? category,
       String? label,
       double? value,
       Map<String, dynamic>? properties,
     }) {
       track(UserActionEvent(
         action: action,
         category: category,
         label: label,
         value: value,
         extraProperties: properties,
       ));
     }
     
     /// Track an error.
     void trackError(
       String message, {
       String? errorType,
       StackTrace? stackTrace,
       String? location,
       ErrorSeverity severity = ErrorSeverity.error,
       Map<String, dynamic>? context,
     }) {
       track(ErrorEvent(
         message: message,
         errorType: errorType,
         stackTrace: stackTrace?.toString(),
         location: location,
         severity: severity,
         context: context,
       ));
     }
     
     /// Track timing/performance.
     void trackTiming(
       String category,
       String variable,
       Duration duration, {
       String? label,
     }) {
       track(TimingEvent(
         category: category,
         variable: variable,
         durationMs: duration.inMilliseconds,
         label: label,
       ));
     }
     
     /// Identify the current user.
     Future<void> identify(
       String userId, {
       Map<String, dynamic>? traits,
     }) async {
       _userId = userId;
       if (traits != null) {
         _userProperties.addAll(traits);
       }
       
       if (!_initialized) return;
       
       await Future.wait(
         _providers.map((p) => _safeCall(() => p.identify(userId, traits: traits))),
       );
     }
     
     /// Set user properties.
     Future<void> setUserProperties(Map<String, dynamic> properties) async {
       _userProperties.addAll(properties);
       
       if (!_initialized) return;
       
       await Future.wait(
         _providers.map((p) => _safeCall(() => p.setUserProperties(properties))),
       );
     }
     
     /// Set super properties (included with every event).
     void setSuperProperties(Map<String, dynamic> properties) {
       _superProperties.addAll(properties);
     }
     
     /// Clear a super property.
     void clearSuperProperty(String key) {
       _superProperties.remove(key);
     }
     
     /// Reset analytics (logout).
     Future<void> reset() async {
       _userId = null;
       _userProperties.clear();
       _superProperties.clear();
       
       if (!_initialized) return;
       
       await Future.wait(
         _providers.map((p) => _safeCall(() => p.reset())),
       );
     }
     
     /// Enable or disable tracking.
     Future<void> setEnabled(bool enabled) async {
       _enabled = enabled;
       
       if (!_initialized) return;
       
       await Future.wait(
         _providers.map((p) => _safeCall(() => p.setEnabled(enabled))),
       );
     }
     
     /// Set sampling rate (0.0 to 1.0).
     void setSamplingRate(double rate) {
       _samplingRate = rate.clamp(0.0, 1.0);
     }
     
     /// Flush pending events to all providers.
     Future<void> flush() async {
       if (!_initialized) return;
       
       await Future.wait(
         _providers.map((p) => _safeCall(() => p.flush())),
       );
     }
     
     /// Dispose all providers.
     Future<void> dispose() async {
       await Future.wait(
         _providers.map((p) => _safeCall(() => p.dispose())),
       );
       _initialized = false;
     }
     
     /// Queue an event for later processing.
     void _queueEvent(AnalyticsEvent event) {
       if (_eventQueue.length >= _maxQueueSize) {
         _eventQueue.removeAt(0); // Remove oldest
       }
       _eventQueue.add(event);
     }
     
     /// Process queued events.
     Future<void> _processQueue() async {
       final events = List<AnalyticsEvent>.from(_eventQueue);
       _eventQueue.clear();
       
       for (final event in events) {
         _trackToProviders(event);
       }
     }
     
     /// Track event to all providers.
     void _trackToProviders(AnalyticsEvent event) {
       // Add super properties to event
       final enhancedEvent = _EnhancedEvent(event, _superProperties);
       
       for (final provider in _providers) {
         _safeCall(() => provider.trackEvent(enhancedEvent));
       }
     }
     
     /// Whether to sample this event.
     bool _shouldSample() {
       if (_samplingRate >= 1.0) return true;
       if (_samplingRate <= 0.0) return false;
       return DateTime.now().millisecond / 1000 < _samplingRate;
     }
     
     /// Safely call a provider method without throwing.
     Future<void> _safeCall(Future<void> Function() fn) async {
       try {
         await fn();
       } catch (e) {
         // Log error but don't throw
         print('[Analytics] Provider error: $e');
       }
     }
   }
   
   /// Wrapper that adds super properties to events.
   class _EnhancedEvent extends AnalyticsEvent {
     final AnalyticsEvent _original;
     final Map<String, dynamic> _superProperties;
     
     _EnhancedEvent(this._original, this._superProperties);
     
     @override
     String get name => _original.name;
     
     @override
     Map<String, dynamic> get properties => {
       ..._superProperties,
       ..._original.properties,
     };
     
     @override
     DateTime? get timestamp => _original.timestamp;
     
     @override
     String? get userId => _original.userId;
   }
   ```

4. **Create `lib/core/analytics/analytics_observer.dart`**
   ```dart
   import 'package:flutter/material.dart';
   
   import 'analytics_service.dart';
   
   /// Route observer that automatically tracks screen views.
   /// 
   /// Add to your MaterialApp:
   /// ```dart
   /// MaterialApp(
   ///   navigatorObservers: [
   ///     AnalyticsRouteObserver(analyticsService),
   ///   ],
   /// )
   /// ```
   class AnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
     final AnalyticsService _analytics;
     String? _previousRouteName;
     
     AnalyticsRouteObserver(this._analytics);
     
     @override
     void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
       super.didPush(route, previousRoute);
       if (route is PageRoute) {
         _trackScreen(route, previousRoute);
       }
     }
     
     @override
     void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
       super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
       if (newRoute is PageRoute) {
         _trackScreen(newRoute, oldRoute);
       }
     }
     
     @override
     void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
       super.didPop(route, previousRoute);
       if (previousRoute is PageRoute) {
         _trackScreen(previousRoute, route);
       }
     }
     
     void _trackScreen(Route<dynamic> route, Route<dynamic>? previousRoute) {
       final screenName = _getRouteName(route);
       final previousScreenName = _getRouteName(previousRoute);
       
       if (screenName != null) {
         _analytics.trackScreen(
           screenName,
           screenClass: route.settings.name,
           previousScreen: previousScreenName ?? _previousRouteName,
         );
         _previousRouteName = screenName;
       }
     }
     
     String? _getRouteName(Route<dynamic>? route) {
       if (route == null) return null;
       
       // Try to get a meaningful name
       return route.settings.name ??
           route.settings.arguments?.toString() ??
           route.runtimeType.toString();
     }
   }
   
   /// Mixin for widgets that track their own screen views.
   mixin AnalyticsScreenMixin<T extends StatefulWidget> on State<T> {
     /// Override to provide the screen name.
     String get analyticsScreenName;
     
     /// Override to provide additional properties.
     Map<String, dynamic>? get analyticsScreenProperties => null;
     
     /// The analytics service (must be provided by subclass).
     AnalyticsService get analyticsService;
     
     @override
     void initState() {
       super.initState();
       _trackScreenView();
     }
     
     void _trackScreenView() {
       analyticsService.trackScreen(
         analyticsScreenName,
         screenClass: T.toString(),
         properties: analyticsScreenProperties,
       );
     }
   }
   ```

#### Acceptance Criteria
- [ ] Events are tracked to all configured providers
- [ ] Screen views are automatically tracked
- [ ] User identification works correctly
- [ ] Events are queued when offline
- [ ] Sampling rate can be configured

---

### Task 5.2: Crash Reporting

**Estimated Time:** 2-3 days

#### Objectives
- Implement crash reporting with Crashlytics
- Capture unhandled exceptions
- Add custom crash context
- Symbolicate stack traces

#### Implementation Steps

1. **Create `lib/core/error/crash_reporter.dart`**
   ```dart
   import 'dart:async';
   import 'dart:isolate';
   
   import 'package:flutter/foundation.dart';
   import 'package:flutter/material.dart';
   
   /// Service for crash reporting and error tracking.
   /// 
   /// Captures:
   /// - Unhandled Flutter exceptions
   /// - Unhandled Dart exceptions
   /// - Isolate errors
   /// - Platform errors
   /// 
   /// Example:
   /// ```dart
   /// void main() async {
   ///   final crashReporter = CrashReporter();
   ///   await crashReporter.initialize();
   ///   
   ///   crashReporter.wrap(() {
   ///     runApp(const MyApp());
   ///   });
   /// }
   /// ```
   class CrashReporter {
     /// Crash reporting provider (e.g., Firebase Crashlytics).
     final CrashReportingProvider? _provider;
     
     /// Current user ID for crash reports.
     String? _userId;
     
     /// Custom keys for crash context.
     final Map<String, String> _customKeys = {};
     
     /// Whether the reporter is initialized.
     bool _initialized = false;
     
     CrashReporter({CrashReportingProvider? provider}) : _provider = provider;
     
     /// Initialize crash reporting.
     Future<void> initialize() async {
       if (_initialized) return;
       
       await _provider?.initialize();
       
       // Set up Flutter error handling
       FlutterError.onError = _handleFlutterError;
       
       // Set up platform dispatcher errors (replaces WidgetsBinding.instance.platformDispatcher.onError)
       PlatformDispatcher.instance.onError = (error, stack) {
         _handleError(error, stack, reason: 'Platform error');
         return true; // Prevent default handling
       };
       
       _initialized = true;
     }
     
     /// Wrap the app to catch all errors.
     void wrap(void Function() appRunner) {
       runZonedGuarded(
         appRunner,
         (error, stackTrace) {
           _handleError(error, stackTrace, reason: 'Uncaught async error');
         },
       );
     }
     
     /// Set the current user for crash reports.
     Future<void> setUser(String? userId) async {
       _userId = userId;
       await _provider?.setUserId(userId);
     }
     
     /// Set a custom key-value pair for crash context.
     Future<void> setCustomKey(String key, String value) async {
       _customKeys[key] = value;
       await _provider?.setCustomKey(key, value);
     }
     
     /// Set multiple custom keys.
     Future<void> setCustomKeys(Map<String, String> keys) async {
       _customKeys.addAll(keys);
       for (final entry in keys.entries) {
         await _provider?.setCustomKey(entry.key, entry.value);
       }
     }
     
     /// Log a message that will be attached to crash reports.
     Future<void> log(String message) async {
       await _provider?.log(message);
     }
     
     /// Record a non-fatal error.
     Future<void> recordError(
       dynamic error,
       StackTrace? stackTrace, {
       String? reason,
       bool fatal = false,
       Map<String, dynamic>? information,
     }) async {
       // Add custom information to context
       if (information != null) {
         for (final entry in information.entries) {
           await setCustomKey(entry.key, entry.value.toString());
         }
       }
       
       await _provider?.recordError(
         error,
         stackTrace ?? StackTrace.current,
         reason: reason,
         fatal: fatal,
       );
     }
     
     /// Force a test crash.
     void crash() {
       _provider?.crash();
     }
     
     /// Handle Flutter framework errors.
     void _handleFlutterError(FlutterErrorDetails details) {
       // Log the error
       FlutterError.presentError(details);
       
       // Report to crash reporting service
       _handleError(
         details.exception,
         details.stack,
         reason: details.context?.toString(),
       );
     }
     
     /// Handle any error.
     void _handleError(
       dynamic error,
       StackTrace? stackTrace, {
       String? reason,
     }) {
       // Don't report in debug mode unless testing
       if (kDebugMode && !_shouldReportInDebug) {
         return;
       }
       
       recordError(
         error,
         stackTrace,
         reason: reason,
         fatal: false,
       );
     }
     
     /// Whether to report errors in debug mode.
     bool get _shouldReportInDebug => false;
   }
   
   /// Interface for crash reporting providers.
   abstract class CrashReportingProvider {
     /// Initialize the provider.
     Future<void> initialize();
     
     /// Set the current user ID.
     Future<void> setUserId(String? userId);
     
     /// Set a custom key-value pair.
     Future<void> setCustomKey(String key, String value);
     
     /// Log a message.
     Future<void> log(String message);
     
     /// Record an error.
     Future<void> recordError(
       dynamic error,
       StackTrace stackTrace, {
       String? reason,
       bool fatal = false,
     });
     
     /// Force a test crash.
     void crash();
   }
   
   /// Firebase Crashlytics implementation.
   class FirebaseCrashlyticsProvider implements CrashReportingProvider {
     // FirebaseCrashlytics instance would be injected
     
     @override
     Future<void> initialize() async {
       // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
     }
     
     @override
     Future<void> setUserId(String? userId) async {
       // await FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
     }
     
     @override
     Future<void> setCustomKey(String key, String value) async {
       // await FirebaseCrashlytics.instance.setCustomKey(key, value);
     }
     
     @override
     Future<void> log(String message) async {
       // await FirebaseCrashlytics.instance.log(message);
     }
     
     @override
     Future<void> recordError(
       dynamic error,
       StackTrace stackTrace, {
       String? reason,
       bool fatal = false,
     }) async {
       // await FirebaseCrashlytics.instance.recordError(
       //   error,
       //   stackTrace,
       //   reason: reason,
       //   fatal: fatal,
       // );
     }
     
     @override
     void crash() {
       // FirebaseCrashlytics.instance.crash();
     }
   }
   ```

2. **Create `lib/core/error/error_boundary.dart`**
   ```dart
   import 'package:flutter/material.dart';
   
   /// Widget that catches errors in its descendants and shows a fallback UI.
   /// 
   /// Example:
   /// ```dart
   /// ErrorBoundary(
   ///   onError: (error, stack) {
   ///     crashReporter.recordError(error, stack);
   ///   },
   ///   fallback: (error) => ErrorScreen(error: error),
   ///   child: const MyRiskyWidget(),
   /// )
   /// ```
   class ErrorBoundary extends StatefulWidget {
     /// The child widget tree.
     final Widget child;
     
     /// Callback when an error occurs.
     final void Function(Object error, StackTrace stack)? onError;
     
     /// Fallback widget to show on error.
     final Widget Function(Object error)? fallback;
     
     /// Whether to re-throw errors after handling.
     final bool rethrow;
     
     const ErrorBoundary({
       super.key,
       required this.child,
       this.onError,
       this.fallback,
       this.rethrow = false,
     });
   
     @override
     State<ErrorBoundary> createState() => _ErrorBoundaryState();
   }
   
   class _ErrorBoundaryState extends State<ErrorBoundary> {
     Object? _error;
     
     @override
     void initState() {
       super.initState();
     }
     
     void _handleError(Object error, StackTrace stack) {
       setState(() {
         _error = error;
       });
       
       widget.onError?.call(error, stack);
       
       if (widget.rethrow) {
         throw error;
       }
     }
     
     void retry() {
       setState(() {
         _error = null;
       });
     }
     
     @override
     Widget build(BuildContext context) {
       if (_error != null) {
         return widget.fallback?.call(_error!) ?? _DefaultErrorWidget(
           error: _error!,
           onRetry: retry,
         );
       }
       
       return widget.child;
     }
   }
   
   /// Default error widget shown when no fallback is provided.
   class _DefaultErrorWidget extends StatelessWidget {
     final Object error;
     final VoidCallback? onRetry;
     
     const _DefaultErrorWidget({
       required this.error,
       this.onRetry,
     });
   
     @override
     Widget build(BuildContext context) {
       return Center(
         child: Padding(
           padding: const EdgeInsets.all(24),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Icon(
                 Icons.error_outline,
                 size: 64,
                 color: Theme.of(context).colorScheme.error,
               ),
               const SizedBox(height: 16),
               Text(
                 'Something went wrong',
                 style: Theme.of(context).textTheme.titleLarge,
               ),
               const SizedBox(height: 8),
               Text(
                 error.toString(),
                 style: Theme.of(context).textTheme.bodyMedium,
                 textAlign: TextAlign.center,
               ),
               if (onRetry != null) ...[
                 const SizedBox(height: 24),
                 ElevatedButton.icon(
                   onPressed: onRetry,
                   icon: const Icon(Icons.refresh),
                   label: const Text('Retry'),
                 ),
               ],
             ],
           ),
         ),
       );
     }
   }
   ```

#### Acceptance Criteria
- [ ] All crashes are reported to Crashlytics
- [ ] User ID is attached to crash reports
- [ ] Custom context is included
- [ ] Stack traces are properly symbolicated
- [ ] Error boundary catches widget errors

---

### Task 5.3: A/B Testing Infrastructure

**Estimated Time:** 2-3 days

#### Objectives
- Implement feature flags
- Support A/B experiments
- Track experiment exposure
- Integrate with Remote Config

*(Detailed A/B testing implementation)*

---

### Task 5.4: App Health Monitoring

**Estimated Time:** 2-3 days

#### Objectives
- Monitor app performance metrics
- Track network health
- Implement health check endpoint
- Set up alerting thresholds

*(Detailed monitoring implementation)*

---

## 📊 Phase 5 Checklist

| Task | Status | Notes |
|------|--------|-------|
| 5.1 Analytics Architecture | ⬜ | |
| 5.2 Crash Reporting | ⬜ | |
| 5.3 A/B Testing | ⬜ | |
| 5.4 App Health Monitoring | ⬜ | |

---

## 🔗 Dependencies for Next Phase

Phase 6 requires the following from Phase 5:
- ✅ Analytics service for tracking feature usage
- ✅ Error handling for graceful degradation
- ✅ A/B testing for feature rollouts

---

## 📝 Notes

- Use debug providers in development
- Ensure GDPR compliance for analytics
- Test crash reporting with test crashes
- Monitor false positive alerts
- Set up dashboards early
