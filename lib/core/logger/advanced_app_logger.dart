// lib/core/logger/app_logger.dart
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum LogLevel { debug, info, warning, error, critical }

enum LogCategory { network, ui, business, performance, security, crash }

class LogEntry {
  const LogEntry({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.data,
    this.stackTrace,
    this.userId,
    this.sessionId,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
    id: json['id'] as String? ?? '',
    timestamp: DateTime.parse(json['timestamp'] as String? ?? ''),
    level: LogLevel.values.byName(json['level'] as String? ?? ''),
    category: LogCategory.values.byName(json['category'] as String? ?? ''),
    message: json['message'] as String? ?? '',
    data: json['data'] as Map<String, dynamic>?,
    stackTrace: json['stackTrace'] as String? ?? '',
    userId: json['userId'] as String? ?? '',
    sessionId: json['sessionId'] as String? ?? '',
  );
  final String id;
  final DateTime timestamp;
  final LogLevel level;
  final LogCategory category;
  final String message;
  final Map<String, dynamic>? data;
  final String? stackTrace;
  final String? userId;
  final String? sessionId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'level': level.name,
    'category': category.name,
    'message': message,
    'data': data,
    'stackTrace': stackTrace,
    'userId': userId,
    'sessionId': sessionId,
  };
}

class AppLoggerConfig {
  const AppLoggerConfig({
    this.enableFileLogging = true,
    this.enableConsoleLogging = true,
    this.enableRemoteLogging = false,
    this.minLogLevel = LogLevel.debug,
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.maxLogFiles = 5,
    this.encryptLogs = false,
    this.enabledCategories = LogCategory.values,
    this.remoteEndpoint,
    this.customHeaders = const {},
  });
  final bool enableFileLogging;
  final bool enableConsoleLogging;
  final bool enableRemoteLogging;
  final LogLevel minLogLevel;
  final int maxFileSize;
  final int maxLogFiles;
  final bool encryptLogs;
  final List<LogCategory> enabledCategories;
  final String? remoteEndpoint;
  final Map<String, String> customHeaders;
}

class AppLogger {
  AppLogger._internal();
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._internal();

  late Talker _talker;
  late AppLoggerConfig _config;
  late String _sessionId;
  String? _userId;
  late String _logDirectory;
  final List<LogEntry> _logBuffer = [];

  Future<void> initialize({AppLoggerConfig? config}) async {
    _config = config ?? const AppLoggerConfig();
    _sessionId = _generateSessionId();

    await _setupLogDirectory();
    await _initializeTalker();
    await _loadUserSession();

    // Log app initialization
    await logInfo(
      'App Logger initialized',
      data: await _getSystemInfo(),
    );
  }

  Future<void> _setupLogDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    _logDirectory = '${directory.path}/logs';
    await Directory(_logDirectory).create(recursive: true);
  }

  Future<void> _initializeTalker() async {
    final settings = TalkerSettings(
      useConsoleLogs: _config.enableConsoleLogging,
    );

    final logger = TalkerLogger(
      formatter: const CustomLogFormatter(),
      settings: TalkerLoggerSettings(
        maxLineWidth: 120,
      ),
    );

    _talker = TalkerFlutter.init(
      logger: logger,
      settings: settings,
      observer: CustomTalkerObserver(),
    );

    if (_config.enableFileLogging) {
      await _setupFileLogging();
    }
  }

  Future<void> _setupFileLogging() async {
    // Clean up old log files
    await _cleanupOldLogs();
  }

  Future<void> _loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');
  }

  String _generateSessionId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return sha256.convert('$now$random'.codeUnits).toString().substring(0, 16);
  }

  Future<Map<String, dynamic>> _getSystemInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    final systemInfo = <String, dynamic>{
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
      'sessionId': _sessionId,
    };

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      systemInfo.addAll({
        'platform': 'Android',
        'model': androidInfo.model,
        'manufacturer': androidInfo.manufacturer,
        'version': androidInfo.version.release,
        'sdkInt': androidInfo.version.sdkInt,
      });
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      systemInfo.addAll({
        'platform': 'iOS',
        'model': iosInfo.model,
        'systemName': iosInfo.systemName,
        'systemVersion': iosInfo.systemVersion,
      });
    }

    return systemInfo;
  }

  void setUserId(String userId) {
    _userId = userId;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('user_id', userId);
    });
  }

  // Main logging methods
  Future<void> logDebug(
    String message, {
    LogCategory category = LogCategory.business,
    Map<String, dynamic>? data,
  }) async {
    await _log(LogLevel.debug, message, category, data);
  }

  Future<void> logInfo(
    String message, {
    LogCategory category = LogCategory.business,
    Map<String, dynamic>? data,
  }) async {
    await _log(LogLevel.info, message, category, data);
  }

  Future<void> logWarning(
    String message, {
    LogCategory category = LogCategory.business,
    Map<String, dynamic>? data,
  }) async {
    await _log(LogLevel.warning, message, category, data);
  }

  Future<void> logError(
    String message, {
    LogCategory category = LogCategory.business,
    Map<String, dynamic>? data,
    String? stackTrace,
  }) async {
    await _log(LogLevel.error, message, category, data, stackTrace);
  }

  Future<void> logCritical(
    String message, {
    LogCategory category = LogCategory.crash,
    Map<String, dynamic>? data,
    String? stackTrace,
  }) async {
    await _log(LogLevel.critical, message, category, data, stackTrace);
  }

  Future<void> logV(
    LogLevel level,
    String message,
    LogCategory category,
    Map<String, dynamic>? data, [
    String? stackTrace,
  ]) async {
    await _log(level, message, category, data, stackTrace);
  }

  // Specialized logging methods
  Future<void> logNetworkRequest(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) async {
    await logInfo(
      'Network Request: $method $url',
      category: LogCategory.network,
      data: {
        'method': method,
        'url': url,
        'headers': headers,
        'body': body,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logNetworkResponse(
    String method,
    String url,
    int statusCode, {
    Map<String, dynamic>? headers,
    dynamic body,
    int? duration,
  }) async {
    final level = statusCode >= 400 ? LogLevel.error : LogLevel.info;
    await _log(
      level,
      'Network Response: $method $url ($statusCode)',
      LogCategory.network,
      {
        'method': method,
        'url': url,
        'statusCode': statusCode,
        'headers': headers,
        'body': body,
        'duration': duration,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logUserAction(
    String action, {
    Map<String, dynamic>? context,
  }) async {
    await logInfo(
      'User Action: $action',
      category: LogCategory.ui,
      data: {
        'action': action,
        'context': context,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logPerformance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? metrics,
  }) async {
    final level = duration.inMilliseconds > 1000
        ? LogLevel.warning
        : LogLevel.info;
    await _log(
      level,
      'Performance: $operation took ${duration.inMilliseconds}ms',
      LogCategory.performance,
      {
        'operation': operation,
        'duration': duration.inMilliseconds,
        'metrics': metrics,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logSecurityEvent(
    String event, {
    Map<String, dynamic>? details,
    bool isIncident = false,
  }) async {
    final level = isIncident ? LogLevel.critical : LogLevel.warning;
    await _log(
      level,
      'Security Event: $event',
      LogCategory.security,
      {
        'event': event,
        'details': details,
        'isIncident': isIncident,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> _log(
    LogLevel level,
    String message,
    LogCategory category,
    Map<String, dynamic>? data, [
    String? stackTrace,
  ]) async {
    if (!_shouldLog(level, category)) return;

    final logEntry = LogEntry(
      id: _generateLogId(),
      timestamp: DateTime.now(),
      level: level,
      category: category,
      message: message,
      data: data,
      stackTrace: stackTrace,
      userId: _userId,
      sessionId: _sessionId,
    );

    // Add to buffer
    _logBuffer.add(logEntry);

    // Log to console via Talker
    _logToTalker(logEntry);

    // Save to file if enabled
    if (_config.enableFileLogging) {
      await _saveToFile(logEntry);
    }

    // Send to remote if enabled
    if (_config.enableRemoteLogging && _config.remoteEndpoint != null) {
      await _sendToRemote(logEntry);
    }

    // Cleanup buffer if too large
    if (_logBuffer.length > 1000) {
      _logBuffer.removeRange(0, 500);
    }
  }

  bool _shouldLog(LogLevel level, LogCategory category) {
    return level.index >= _config.minLogLevel.index &&
        _config.enabledCategories.contains(category);
  }

  String _generateLogId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  void _logToTalker(LogEntry entry) {
    final message = '[${entry.category.name.toUpperCase()}] ${entry.message}';
    final data = entry.data != null ? '\nData: ${jsonEncode(entry.data)}' : '';
    final stack = entry.stackTrace != null
        ? '\nStack: ${entry.stackTrace}'
        : '';

    switch (entry.level) {
      case LogLevel.debug:
        _talker.debug(message + data + stack);
      case LogLevel.info:
        _talker.info(message + data + stack);
      case LogLevel.warning:
        _talker.warning(message + data + stack);
      case LogLevel.error:
        _talker.error(message + data + stack);
      case LogLevel.critical:
        _talker.critical(message + data + stack);
    }
  }

  Future<void> _saveToFile(LogEntry entry) async {
    try {
      final dateFormatter = DateFormat('yyyy-MM-dd');
      final fileName = 'app_log_${dateFormatter.format(entry.timestamp)}.json';
      final file = File('$_logDirectory/$fileName');

      var logData = '${jsonEncode(entry.toJson())}\n';

      if (_config.encryptLogs) {
        logData = _encryptData(logData);
      }

      await file.writeAsString(logData, mode: FileMode.append);

      // Check file size and rotate if needed
      final stat = await file.stat();
      if (stat.size > _config.maxFileSize) {
        await _rotateLogFile(file);
      }
    } catch (e) {
      _talker.error('Failed to write log to file: $e');
    }
  }

  String _encryptData(String data) {
    // Simple base64 encoding (implement proper encryption for production)
    return base64Encode(utf8.encode(data));
  }

  Future<void> _rotateLogFile(File file) async {
    try {
      final baseName = file.path.replaceAll('.json', '');
      final rotatedFile = File(
        '${baseName}_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.rename(rotatedFile.path);
    } catch (e) {
      _talker.error('Failed to rotate log file: $e');
    }
  }

  Future<void> _cleanupOldLogs() async {
    try {
      final dir = Directory(_logDirectory);
      final files = await dir
          .list()
          .where((f) => f is File && f.path.endsWith('.json'))
          .toList();

      if (files.length > _config.maxLogFiles) {
        files.sort(
          (a, b) => File(
            a.path,
          ).lastModifiedSync().compareTo(File(b.path).lastModifiedSync()),
        );
        final filesToDelete = files.take(files.length - _config.maxLogFiles);

        for (final file in filesToDelete) {
          await file.delete();
        }
      }
    } catch (e) {
      _talker.error('Failed to cleanup old logs: $e');
    }
  }

  Future<void> _sendToRemote(LogEntry entry) async {
    // Implement remote logging (HTTP POST to your logging service)
    // This is a placeholder implementation
    try {
      // final response = await http.post(
      //   Uri.parse(_config.remoteEndpoint!),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     ..._config.customHeaders,
      //   },
      //   body: jsonEncode(entry.toJson()),
      // );
    } catch (e) {
      _talker.error('Failed to send log to remote: $e');
    }
  }

  // Utility methods
  Future<List<LogEntry>> getLogs({
    LogLevel? minLevel,
    LogCategory? category,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    var logs = List<LogEntry>.from(_logBuffer);

    if (minLevel != null) {
      logs = logs.where((log) => log.level.index >= minLevel.index).toList();
    }

    if (category != null) {
      logs = logs.where((log) => log.category == category).toList();
    }

    if (from != null) {
      logs = logs.where((log) => log.timestamp.isAfter(from)).toList();
    }

    if (to != null) {
      logs = logs.where((log) => log.timestamp.isBefore(to)).toList();
    }

    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (limit != null && logs.length > limit) {
      logs = logs.take(limit).toList();
    }

    return logs;
  }

  Future<String> exportLogs({
    LogLevel? minLevel,
    LogCategory? category,
    DateTime? from,
    DateTime? to,
  }) async {
    final logs = await getLogs(
      minLevel: minLevel,
      category: category,
      from: from,
      to: to,
    );

    final exportData = {
      'exportDate': DateTime.now().toIso8601String(),
      'sessionId': _sessionId,
      'userId': _userId,
      'logsCount': logs.length,
      'systemInfo': await _getSystemInfo(),
      'logs': logs.map((log) => log.toJson()).toList(),
    };

    return jsonEncode(exportData);
  }

  Future<void> clearLogs() async {
    _logBuffer.clear();
    _talker.cleanHistory();

    // Clear log files
    try {
      final dir = Directory(_logDirectory);
      await for (final file in dir.list()) {
        if (file is File && file.path.endsWith('.json')) {
          await file.delete();
        }
      }
    } catch (e) {
      _talker.error('Failed to clear log files: $e');
    }
  }

  // Getters
  Talker get talker => _talker;
  String get sessionId => _sessionId;
  String? get userId => _userId;
  AppLoggerConfig get config => _config;
}

// Custom Talker formatter
/* class CustomLogFormatter extends LoggerFormatter {
  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final timeFormat = DateFormat('HH:mm:ss.SSS');
    final time = timeFormat.dateOnly;
    final level = details.level.name.toUpperCase().padRight(8);

    return '[$time] $level ${details.message}';
  }
} */

class CustomLogFormatter implements LoggerFormatter {
  const CustomLogFormatter();

  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final underline = ConsoleUtils.getUnderline(
      settings.maxLineWidth,
      lineSymbol: settings.lineSymbol,
      withCorner: true,
    );
    final topline = ConsoleUtils.getTopline(
      settings.maxLineWidth,
      lineSymbol: settings.lineSymbol,
      withCorner: true,
    );
    final msg = details.message?.toString() ?? '';
    final msgBorderedLines = msg.split('\n').map((e) => '│ $e');
    if (!settings.enableColors) {
      return '$topline\n${msgBorderedLines.join('\n')}\n$underline';
    }
    var lines = [topline, ...msgBorderedLines, underline];
    lines = lines.map((e) => details.pen.write(e)).toList();
    final coloredMsg = lines.join('\n');
    return coloredMsg;
  }
}

// Custom Talker observer
class CustomTalkerObserver extends TalkerObserver {
  @override
  void onError(TalkerError err) {
    // Handle errors
    super.onError(err);
  }

  @override
  void onException(TalkerException err) {
    // Handle exceptions
    super.onException(err);
  }

  @override
  void onLog(TalkerData log) {
    // Handle all logs
    super.onLog(log);
  }
}

// Extension for easy logging
extension AppLoggerExtension on Object {
  void logDebug(String message, {Map<String, dynamic>? data}) {
    AppLogger.instance.logDebug(message, data: data);
  }

  void logInfo(String message, {Map<String, dynamic>? data}) {
    AppLogger.instance.logInfo(message, data: data);
  }

  void logWarning(String message, {Map<String, dynamic>? data}) {
    AppLogger.instance.logWarning(message, data: data);
  }

  void logError(
    String message, {
    Map<String, dynamic>? data,
    String? stackTrace,
  }) {
    AppLogger.instance.logError(message, data: data, stackTrace: stackTrace);
  }
}

// Usage Example:
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger
  await AppLogger.instance.initialize(
    config: AppLoggerConfig(
      enableFileLogging: true,
      enableConsoleLogging: !kReleaseMode,
      minLogLevel: kReleaseMode ? LogLevel.warning : LogLevel.debug,
      encryptLogs: kReleaseMode,
    ),
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        TalkerRouteObserver(AppLogger.instance.talker),
      ],
      home: MyHomePage(),
    );
  }
}
*/
