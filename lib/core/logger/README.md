# Logger Module

The logger module provides advanced logging infrastructure for the Fast Golden Taxi application with Talker integration, log levels, categories, file logging, and UI viewer.

## 📁 Directory Structure

```
lib/core/logger/
├── advanced_app_logger.dart  # Main logger implementation
├── app_logger.dart           # Simple logger interface
└── logger_ui_components.dart # UI components for viewing logs
```

## 🎯 Key Components

### 1. AdvancedAppLogger (`advanced_app_logger.dart`)

Main logger implementation with Talker integration.

**Features:**
- Multiple log levels (verbose, debug, info, warning, error, critical)
- Log categories for organization
- File logging
- Console logging
- UI log viewer
- Log filtering
- Log export

**Usage:**
```dart
// Get logger instance
final logger = AdvancedAppLogger.instance;

// Log at different levels
logger.verbose('Verbose message');
logger.debug('Debug message');
logger.info('Info message');
logger.warning('Warning message');
logger.error('Error message', error: exception, stackTrace: stackTrace);
logger.critical('Critical message', error: exception, stackTrace: stackTrace);

// Log with category
logger.info('User logged in', category: 'auth');

// Log with metadata
logger.info('API request', category: 'api', data: {
  'url': 'https://api.example.com/users',
  'method': 'GET',
});
```

**Log Levels:**
```dart
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  critical,
}
```

**Log Categories:**
```dart
enum LogCategory {
  general,
  api,
  auth,
  database,
  ui,
  performance,
  security,
  analytics,
}
```

**AdvancedAppLogger:**
```dart
class AdvancedAppLogger {
  static AdvancedAppLogger? _instance;
  static AdvancedAppLogger get instance {
    _instance ??= AdvancedAppLogger._internal();
    return _instance!;
  }

  final Talker _talker;
  final Set<LogLevel> _enabledLevels;
  final Set<LogCategory> _enabledCategories;
  final bool _enableFileLogging;
  final bool _enableConsoleLogging;

  AdvancedAppLogger._internal()
      : _talker = TalkerFlutter.init(),
        _enabledLevels = {
          LogLevel.verbose,
          LogLevel.debug,
          LogLevel.info,
          LogLevel.warning,
          LogLevel.error,
          LogLevel.critical,
        },
        _enabledCategories = LogCategory.values.toSet(),
        _enableFileLogging = true,
        _enableConsoleLogging = true;

  void verbose(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    if (!_isEnabled(LogLevel.verbose, category)) return;

    _talker.verbose(
      _formatMessage(message, category, data),
      key: category.name,
    );
  }

  void debug(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    if (!_isEnabled(LogLevel.debug, category)) return;

    _talker.debug(
      _formatMessage(message, category, data),
      key: category.name,
    );
  }

  void info(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    if (!_isEnabled(LogLevel.info, category)) return;

    _talker.info(
      _formatMessage(message, category, data),
      key: category.name,
    );
  }

  void warning(
    String message, {
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    if (!_isEnabled(LogLevel.warning, category)) return;

    _talker.warning(
      _formatMessage(message, category, data),
      key: category.name,
    );
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    if (!_isEnabled(LogLevel.error, category)) return;

    _talker.error(
      _formatMessage(message, category, data),
      error,
      stackTrace,
      key: category.name,
    );
  }

  void critical(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    LogCategory category = LogCategory.general,
    Map<String, dynamic>? data,
  }) {
    if (!_isEnabled(LogLevel.critical, category)) return;

    _talker.critical(
      _formatMessage(message, category, data),
      error,
      stackTrace,
      key: category.name,
    );
  }

  bool _isEnabled(LogLevel level, LogCategory category) {
    return _enabledLevels.contains(level) &&
        _enabledCategories.contains(category);
  }

  String _formatMessage(
    String message,
    LogCategory category,
    Map<String, dynamic>? data,
  ) {
    final buffer = StringBuffer('[${category.name}] $message');
    if (data != null && data.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Data: ${jsonEncode(data)}');
    }
    return buffer.toString();
  }

  void setLogLevel(LogLevel level, bool enabled) {
    if (enabled) {
      _enabledLevels.add(level);
    } else {
      _enabledLevels.remove(level);
    }
  }

  void setCategoryEnabled(LogCategory category, bool enabled) {
    if (enabled) {
      _enabledCategories.add(category);
    } else {
      _enabledCategories.remove(category);
    }
  }

  void clearLogs() {
    _talker.cleanHistory();
  }

  List<TalkerLog> getLogs() {
    return _talker.history;
  }

  List<TalkerLog> getLogsByCategory(LogCategory category) {
    return _talker.history.where((log) => log.key == category.name).toList();
  }

  List<TalkerLog> getLogsByLevel(LogLevel level) {
    return _talker.history.where((log) {
      switch (level) {
        case LogLevel.verbose:
          return log.type == TalkerLogType.verbose;
        case LogLevel.debug:
          return log.type == TalkerLogType.debug;
        case LogLevel.info:
          return log.type == TalkerLogType.info;
        case LogLevel.warning:
          return log.type == TalkerLogType.warning;
        case LogLevel.error:
          return log.type == TalkerLogType.error;
        case LogLevel.critical:
          return log.type == TalkerLogType.exception;
      }
    }).toList();
  }

  void exportLogs() {
    final logs = _talker.history;
    final json = jsonEncode(logs.map((log) => log.toJson()).toList());
    // Export to file or send to server
  }
}
```

### 2. AppLogger (`app_logger.dart`)

Simple logger interface for basic logging needs.

**Features:**
- Simple API
- Automatic log level detection
- Category support
- Error handling

**Usage:**
```dart
// Get logger instance
final logger = AppLogger.instance;

// Log messages
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message', error: exception, stackTrace: stackTrace);

// Log with category
logger.i('User logged in', category: 'auth');
```

**AppLogger:**
```dart
class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance {
    _instance ??= AppLogger._internal();
    return _instance!;
  }

  final AdvancedAppLogger _advancedLogger;

  AppLogger._internal() : _advancedLogger = AdvancedAppLogger.instance;

  void d(String message, {String? category, Map<String, dynamic>? data}) {
    _advancedLogger.debug(
      message,
      category: _parseCategory(category),
      data: data,
    );
  }

  void i(String message, {String? category, Map<String, dynamic>? data}) {
    _advancedLogger.info(
      message,
      category: _parseCategory(category),
      data: data,
    );
  }

  void w(String message, {String? category, Map<String, dynamic>? data}) {
    _advancedLogger.warning(
      message,
      category: _parseCategory(category),
      data: data,
    );
  }

  void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? category,
    Map<String, dynamic>? data,
  }) {
    _advancedLogger.error(
      message,
      error: error,
      stackTrace: stackTrace,
      category: _parseCategory(category),
      data: data,
    );
  }

  LogCategory _parseCategory(String? category) {
    if (category == null) return LogCategory.general;
    return LogCategory.values.firstWhere(
      (c) => c.name == category,
      orElse: () => LogCategory.general,
    );
  }
}
```

### 3. LoggerUIComponents (`logger_ui_components.dart`)

UI components for viewing logs.

**Features:**
- Log viewer widget
- Log filtering
- Log search
- Log export
- Log clearing

**Usage:**
```dart
// Show log viewer
showLogViewer(context);

// Or use as a widget
const LogViewer();
```

**LogViewer:**
```dart
class LogViewer extends ConsumerWidget {
  const LogViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = AdvancedAppLogger.instance.getLogs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              AdvancedAppLogger.instance.clearLogs();
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              AdvancedAppLogger.instance.exportLogs();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return LogTile(log: log);
        },
      ),
    );
  }
}

class LogTile extends StatelessWidget {
  final TalkerLog log;

  const LogTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _getIcon(log.type),
      title: Text(log.message),
      subtitle: Text(log.time.toString()),
      onTap: () => _showLogDetails(context, log),
    );
  }

  Widget _getIcon(TalkerLogType type) {
    switch (type) {
      case TalkerLogType.verbose:
        return const Icon(Icons.info_outline, color: Colors.grey);
      case TalkerLogType.debug:
        return const Icon(Icons.bug_report, color: Colors.blue);
      case TalkerLogType.info:
        return const Icon(Icons.info, color: Colors.green);
      case TalkerLogType.warning:
        return const Icon(Icons.warning, color: Colors.orange);
      case TalkerLogType.error:
        return const Icon(Icons.error, color: Colors.red);
      case TalkerLogType.exception:
        return const Icon(Icons.error_outline, color: Colors.red);
      default:
        return const Icon(Icons.info_outline);
    }
  }

  void _showLogDetails(BuildContext context, TalkerLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(log.title),
        content: SingleChildScrollView(
          child: Text(log.message),
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
}
```

## 🏗️ Architecture

### Logging Flow

```
1. App starts
2. Initialize AdvancedAppLogger
3. Configure log levels and categories
4. Log messages throughout app
5. Logs stored in memory
6. Logs displayed in UI viewer
7. Logs exported to file/server
```

### Log Processing

```
Log Call
    ↓
Check Level & Category
    ↓
Format Message
    ↓
Send to Talker
    ↓
Store in History
    ↓
Display in UI (if enabled)
```

## 📝 Best Practices

### 1. Use Appropriate Log Levels

```dart
// Good
logger.verbose('Detailed debug information');
logger.debug('Debug information');
logger.info('General information');
logger.warning('Warning message');
logger.error('Error message', error: exception, stackTrace: stackTrace);
logger.critical('Critical error', error: exception, stackTrace: stackTrace);

// Bad
// Use error level for everything
logger.error('User logged in');
```

### 2. Use Categories for Organization

```dart
// Good
logger.info('User logged in', category: 'auth');
logger.info('API request', category: 'api');
logger.info('Database query', category: 'database');

// Bad
// Don't use categories
logger.info('User logged in');
logger.info('API request');
logger.info('Database query');
```

### 3. Include Relevant Data

```dart
// Good
logger.info('API request', category: 'api', data: {
  'url': 'https://api.example.com/users',
  'method': 'GET',
  'status': 200,
  'duration': 1234,
});

// Bad
// Don't include context
logger.info('API request');
```

### 4. Log Errors with Stack Traces

```dart
// Good
try {
  // Some code
} catch (e, stackTrace) {
  logger.error('Operation failed', error: e, stackTrace: stackTrace);
}

// Bad
try {
  // Some code
} catch (e) {
  logger.error('Operation failed', error: e);
}
```

### 5. Disable Verbose Logging in Production

```dart
// Good
if (kDebugMode) {
  logger.verbose('Verbose message');
}

// Bad
// Always log verbose messages
logger.verbose('Verbose message');
```

## 🔧 Usage Examples

### Logging API Requests

```dart
class ApiClient {
  final AppLogger logger = AppLogger.instance;

  Future<Response> get(String path) async {
    final startTime = DateTime.now();

    try {
      final response = await dio.get(path);

      final duration = DateTime.now().difference(startTime);
      logger.info('API request successful', category: 'api', data: {
        'path': path,
        'method': 'GET',
        'status': response.statusCode,
        'duration': duration.inMilliseconds,
      });

      return response;
    } catch (e, stackTrace) {
      logger.error('API request failed', error: e, stackTrace: stackTrace, category: 'api', data: {
        'path': path,
        'method': 'GET',
      });
      rethrow;
    }
  }
}
```

### Logging User Actions

```dart
class AuthController {
  final AppLogger logger = AppLogger.instance;

  Future<void> login(String email, String password) async {
    try {
      logger.info('Login attempt', category: 'auth', data: {
        'email': email,
      });

      final user = await repository.login(email, password);

      logger.info('Login successful', category: 'auth', data: {
        'userId': user.id,
      });
    } catch (e, stackTrace) {
      logger.error('Login failed', error: e, stackTrace: stackTrace, category: 'auth', data: {
        'email': email,
      });
      rethrow;
    }
  }
}
```

### Logging Performance

```dart
class PerformanceMonitor {
  final AppLogger logger = AppLogger.instance;

  void measureOperation(String operation, Future<void> Function() fn) async {
    final stopwatch = Stopwatch()..start();

    try {
      await fn();

      stopwatch.stop();
      logger.info('Operation completed', category: 'performance', data: {
        'operation': operation,
        'duration': stopwatch.elapsedMilliseconds,
      });
    } catch (e, stackTrace) {
      stopwatch.stop();
      logger.error('Operation failed', error: e, stackTrace: stackTrace, category: 'performance', data: {
        'operation': operation,
        'duration': stopwatch.elapsedMilliseconds,
      });
      rethrow;
    }
  }
}
```

### Log Filter Widget

```dart
class LogFilter extends ConsumerStatefulWidget {
  @override
  ConsumerState<LogFilter> createState() => _LogFilterState();
}

class _LogFilterState extends ConsumerState<LogFilter> {
  LogLevel? selectedLevel;
  LogCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<LogLevel>(
          hint: const Text('Filter by level'),
          value: selectedLevel,
          items: LogLevel.values.map((level) {
            return DropdownMenuItem(
              value: level,
              child: Text(level.name),
            );
          }).toList(),
          onChanged: (level) {
            setState(() => selectedLevel = level);
          },
        ),
        DropdownButton<LogCategory>(
          hint: const Text('Filter by category'),
          value: selectedCategory,
          items: LogCategory.values.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (category) {
            setState(() => selectedCategory = category);
          },
        ),
      ],
    );
  }
}
```

## 🧪 Testing

### Unit Tests

```dart
test('AdvancedAppLogger should log messages', () {
  final logger = AdvancedAppLogger.instance;
  logger.info('Test message');

  final logs = logger.getLogs();
  expect(logs, isNotEmpty);
  expect(logs.last.message, contains('Test message'));
});

test('AdvancedAppLogger should filter by category', () {
  final logger = AdvancedAppLogger.instance;
  logger.info('Auth message', category: LogCategory.auth);
  logger.info('API message', category: LogCategory.api);

  final authLogs = logger.getLogsByCategory(LogCategory.auth);
  expect(authLogs.length, 1);
  expect(authLogs.first.message, contains('Auth message'));
});
```

## 📚 Additional Resources

- [Talker Package](https://pub.dev/packages/talker)
- [Talker Flutter](https://pub.dev/packages/talker_flutter)
- [Flutter Logging](https://flutter.dev/docs/testing/debugging#logging)

## 🤝 Contributing

When modifying the logger:

1. Test all log levels
2. Test log filtering
3. Test log export
4. Update documentation
5. Add tests

## 📄 License

This module is part of the Fast Golden Taxi project.