// lib/ui/logger/log_viewer_screen.dart
import 'dart:convert' show JsonEncoder;

import 'package:dio/dio.dart' show Dio, InterceptorsWrapper;
import 'package:flavorizr/config/flavors.dart' show F;
import 'package:flavorizr/core/logger/logger_integration_helpers.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;

import 'advanced_app_logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with PerformanceLoggerMixin {
  int _counter = 0;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _setupNetworking();
    AppLogger.instance.setUserId('user_123'); // Set user ID for tracking
  }

  void _setupNetworking() {
    _dio = Dio();
    _dio.interceptors.add(const LoggerInterceptor());
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['stopwatch'] = Stopwatch()..start();
          handler.next(options);
        },
      ),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Logger Demo - ${F.title}'),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              AppLogger.instance.logUserAction('View logs button pressed');
              Navigator.pushNamed(context, '/logs');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              AppLogger.instance.logUserAction('Settings button pressed');
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Advanced App Logger Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Text(
              'Counter: $_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(
                  'Increment Counter',
                  Icons.add,
                  Colors.green,
                  _incrementCounter,
                ),
                _buildActionButton(
                  'Test Network',
                  Icons.cloud,
                  Colors.blue,
                  _testNetworkCall,
                ),
                _buildActionButton(
                  'Generate Error',
                  Icons.error,
                  Colors.red,
                  _generateError,
                ),
                _buildActionButton(
                  'Performance Test',
                  Icons.speed,
                  Colors.orange,
                  _performanceTest,
                ),
                _buildActionButton(
                  'Security Event',
                  Icons.security,
                  Colors.purple,
                  _securityEvent,
                ),
                _buildActionButton(
                  'Bulk Logs',
                  Icons.storage,
                  Colors.teal,
                  _generateBulkLogs,
                ),
              ],
            ),

            const SizedBox(height: 32),

            Card(
              margin: const EdgeInsets.all(16),
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Logger Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow('Session ID', AppLogger.instance.sessionId),
                    _buildInfoRow(
                      'User ID',
                      AppLogger.instance.userId ?? 'Not set',
                    ),
                    _buildInfoRow(
                      'Build Mode',
                      kReleaseMode ? 'Release' : 'Debug',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppLogger.instance.logUserAction('FAB pressed - Quick log view');
          showDialog(
            context: context,
            builder: (context) => const QuickLogDialog(),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.bug_report),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _incrementCounter() {
    setState(() => _counter++);

    AppLogger.instance.logUserAction(
      'Counter incremented',
      context: {'oldValue': _counter - 1, 'newValue': _counter},
    );
  }

  Future<void> _testNetworkCall() async {
    await logMethod('testNetworkCall', () async {
      try {
        final response = await _dio.get(
          'https://jsonplaceholder.typicode.com/posts/1',
        );

        // Log successful business operation
        await AppLogger.instance.logInfo(
          'Post data retrieved successfully',
          data: {
            'postId': response.data['id'],
            'title': response.data['title'],
          },
        );

        _showSnackBar('Network call successful!', Colors.green);
      } catch (e) {
        _showSnackBar('Network call failed: $e', Colors.red);
      }
    }, category: LogCategory.network);
  }

  void _generateError() {
    try {
      // Intentionally cause an error
      final result = 10 ~/ 0;
      AppLogger.instance.logInfo('This should not be reached: $result');
    } catch (error, stackTrace) {
      AppLogger.instance.logError(
        'Intentional error generated',
        data: {
          'errorType': error.runtimeType.toString(),
          'operation': 'division by zero',
          'intentional': true,
        },
        stackTrace: stackTrace.toString(),
      );

      _showSnackBar('Error generated and logged!', Colors.orange);
    }
  }

  Future<void> _performanceTest() async {
    await logMethod('performanceTest', () async {
      final stopwatch = Stopwatch()..start();

      // Simulate heavy computation
      var sum = 0;
      for (var i = 0; i < 10000000; i++) {
        sum += i;
      }

      stopwatch.stop();

      await AppLogger.instance.logPerformance(
        'Heavy computation',
        stopwatch.elapsed,
        metrics: {
          'iterations': 10000000,
          'result': sum,
          'avgTimePerIteration': stopwatch.elapsed.inMicroseconds / 10000000,
        },
      );

      _showSnackBar('Performance test completed!', Colors.blue);
    }, category: LogCategory.performance);
  }

  void _securityEvent() {
    final events = [
      'Suspicious login attempt detected',
      'Multiple failed authentication attempts',
      'Unauthorized API access attempt',
      'Data encryption key rotation',
      'Security policy violation detected',
    ];

    final event = events[DateTime.now().millisecond % events.length];
    final isIncident =
        DateTime.now().millisecond % 3 == 0; // 33% chance of incident

    AppLogger.instance.logSecurityEvent(
      event,
      details: {
        'userAgent': 'Flutter App',
        'timestamp': DateTime.now().toIso8601String(),
        'severity': isIncident ? 'high' : 'medium',
        'source': 'demo_app',
      },
      isIncident: isIncident,
    );

    _showSnackBar(
      '${isIncident ? 'Security incident' : 'Security event'} logged!',
      isIncident ? Colors.red : Colors.orange,
    );
  }

  Future<void> _generateBulkLogs() async {
    await logMethod('generateBulkLogs', () async {
      for (var i = 0; i < 50; i++) {
        final level = LogLevel.values[i % LogLevel.values.length];
        final category = LogCategory.values[i % LogCategory.values.length];

        await AppLogger.instance
            .logV(level, 'Bulk log message #${i + 1}', category, {
              'index': i + 1,
              'timestamp': DateTime.now().toIso8601String(),
              'randomValue': DateTime.now().microsecond,
            });
        // Add small delay to spread timestamps
        await Future.delayed(const Duration(milliseconds: 10));
      }

      _showSnackBar('50 bulk logs generated!', Colors.teal);
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Quick Log Dialog for floating action button
class QuickLogDialog extends StatefulWidget {
  const QuickLogDialog({super.key});

  @override
  State<QuickLogDialog> createState() => _QuickLogDialogState();
}

class _QuickLogDialogState extends State<QuickLogDialog> {
  List<LogEntry> _recentLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentLogs();
  }

  Future<void> _loadRecentLogs() async {
    try {
      final logs = await AppLogger.instance.getLogs(limit: 10);
      setState(() {
        _recentLogs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Logs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _recentLogs.isEmpty
                  ? const Center(
                      child: Text(
                        'No recent logs',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _recentLogs.length,
                      itemBuilder: (context, index) {
                        final log = _recentLogs[index];
                        return _buildQuickLogItem(log);
                      },
                    ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/logs');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('View All Logs'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLogItem(LogEntry log) {
    final timeFormat = DateFormat('HH:mm:ss');
    final colors = {
      LogLevel.debug: Colors.grey,
      LogLevel.info: Colors.blue,
      LogLevel.warning: Colors.orange,
      LogLevel.error: Colors.red,
      LogLevel.critical: Colors.red[900]!,
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        // border: Border.left(
        //   width: 4,
        //   color: colors[log.level]!,
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors[log.level]?.withValues(alpha: 0.2),
                  border: Border.all(color: colors[log.level]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  log.level.name.toUpperCase(),
                  style: TextStyle(
                    color: colors[log.level],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeFormat.format(log.timestamp),
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  border: Border.all(color: Colors.purple),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  log.category.name,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            log.message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// lib/core/logger/logger_widgets.dart
class LoggerDebugPanel extends StatefulWidget {
  const LoggerDebugPanel({required this.child, super.key, this.enabled = true});
  final Widget child;
  final bool enabled;

  @override
  State<LoggerDebugPanel> createState() => _LoggerDebugPanelState();
}

class _LoggerDebugPanelState extends State<LoggerDebugPanel> {
  bool _isExpanded = false;
  List<LogEntry> _logs = [];

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _loadRecentLogs();
    }
  }

  Future<void> _loadRecentLogs() async {
    final logs = await AppLogger.instance.getLogs(limit: 5);
    if (mounted) {
      setState(() => _logs = logs);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || kReleaseMode) {
      return widget.child;
    }

    return Material(
      child: Stack(
        children: [
          widget.child,
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton.small(
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  backgroundColor: Colors.black87,
                  child: Icon(_isExpanded ? Icons.close : Icons.bug_report),
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.bug_report,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Debug Logs',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _logs.length,
                            itemBuilder: (context, index) {
                              final log = _logs[index];
                              return Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '${log.level.name}: ${log.message}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key});

  @override
  State<LogViewerScreen> createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  LogLevel? _selectedLevel;
  LogCategory? _selectedCategory;
  String _searchQuery = '';
  List<LogEntry> _filteredLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    try {
      final logs = await AppLogger.instance.getLogs(limit: 500);
      setState(() {
        _filteredLogs = logs;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load logs: $e');
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredLogs = _filteredLogs.where((log) {
        final matchesLevel =
            _selectedLevel == null || log.level == _selectedLevel;
        final matchesCategory =
            _selectedCategory == null || log.category == _selectedCategory;
        final matchesSearch =
            _searchQuery.isEmpty ||
            log.message.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (log.data?.toString().toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ??
                false);

        return matchesLevel && matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadLogs),
          IconButton(icon: const Icon(Icons.download), onPressed: _exportLogs),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showClearConfirmation,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoggerSettingsScreen()),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildLogList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TalkerScreen(talker: AppLogger.instance.talker),
          ),
        ),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.bug_report),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[800],
      child: Column(
        children: [
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search logs...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[700],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
          ),
          const SizedBox(height: 12),

          // Filter chips
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Level filter
                      _buildFilterChip(
                        'Level: ${_selectedLevel?.name ?? 'All'}',
                        onTap: _showLevelPicker,
                      ),
                      const SizedBox(width: 8),

                      // Category filter
                      _buildFilterChip(
                        'Category: ${_selectedCategory?.name ?? 'All'}',
                        onTap: _showCategoryPicker,
                      ),
                      const SizedBox(width: 8),

                      // Clear filters
                      if (_selectedLevel != null || _selectedCategory != null)
                        _buildFilterChip(
                          'Clear',
                          isSelected: false,
                          onTap: () {
                            setState(() {
                              _selectedLevel = null;
                              _selectedCategory = null;
                            });
                            _loadLogs();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label, {
    bool isSelected = true,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[600],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLogList() {
    if (_filteredLogs.isEmpty) {
      return const Center(
        child: Text(
          'No logs found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredLogs.length,
      itemBuilder: (context, index) {
        final log = _filteredLogs[index];
        return _buildLogItem(log);
      },
    );
  }

  Widget _buildLogItem(LogEntry log) {
    final timeFormat = DateFormat('HH:mm:ss.SSS');
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.grey[800],
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.all(16),
        leading: _buildLevelIcon(log.level),
        title: Text(
          log.message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _buildCategoryChip(log.category),
                const SizedBox(width: 8),
                Text(
                  '${dateFormat.format(log.timestamp)} ${timeFormat.format(log.timestamp)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        children: [_buildLogDetails(log)],
      ),
    );
  }

  Widget _buildLevelIcon(LogLevel level) {
    IconData icon;
    Color color;

    switch (level) {
      case LogLevel.debug:
        icon = Icons.bug_report;
        color = Colors.grey;
      case LogLevel.info:
        icon = Icons.info;
        color = Colors.blue;
      case LogLevel.warning:
        icon = Icons.warning;
        color = Colors.orange;
      case LogLevel.error:
        icon = Icons.error;
        color = Colors.red;
      case LogLevel.critical:
        icon = Icons.dangerous;
        color = Colors.red[900]!;
    }

    return Icon(icon, color: color, size: 24);
  }

  Widget _buildCategoryChip(LogCategory category) {
    final colors = {
      LogCategory.network: Colors.green,
      LogCategory.ui: Colors.purple,
      LogCategory.business: Colors.blue,
      LogCategory.performance: Colors.orange,
      LogCategory.security: Colors.red,
      LogCategory.crash: Colors.red[900]!,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors[category]?.withValues(alpha: 0.2),
        border: Border.all(color: colors[category]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category.name.toUpperCase(),
        style: TextStyle(
          color: colors[category],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLogDetails(LogEntry log) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic info
          _buildDetailRow('ID', log.id),
          _buildDetailRow('Session', log.sessionId),
          if (log.userId != null) _buildDetailRow('User', log.userId),

          // Data section
          if (log.data != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Data:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _formatJson(log.data!),
                style: const TextStyle(
                  color: Colors.green,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],

          // Stack trace section
          if (log.stackTrace != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Stack Trace:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                log.stackTrace!,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],

          // Action buttons
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _copyToClipboard(log),
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy'),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _shareLog(log),
                icon: const Icon(Icons.share, size: 16),
                label: const Text('Share'),
                style: TextButton.styleFrom(foregroundColor: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatJson(Map<String, dynamic> data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  void _showLevelPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Select Log Level',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => _selectedLevel = null);
                _loadLogs();
                Navigator.pop(context);
              },
            ),
            ...LogLevel.values.map(
              (level) => ListTile(
                leading: _buildLevelIcon(level),
                title: Text(
                  level.name,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() => _selectedLevel = level);
                  _loadLogs();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Select Category',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => _selectedCategory = null);
                _loadLogs();
                Navigator.pop(context);
              },
            ),
            ...LogCategory.values.map(
              (category) => ListTile(
                leading: _buildCategoryChip(category),
                title: Text(
                  category.name,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() => _selectedCategory = category);
                  _loadLogs();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(LogEntry log) {
    final text =
        '''
ID: ${log.id}
Time: ${log.timestamp}
Level: ${log.level.name}
Category: ${log.category.name}
Message: ${log.message}
${log.data != null ? 'Data: ${_formatJson(log.data!)}' : ''}
${log.stackTrace != null ? 'Stack Trace: ${log.stackTrace}' : ''}
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Log copied to clipboard')));
  }

  void _shareLog(LogEntry log) {
    // ignore: unused_local_variable
    final text =
        'Log Entry: ${log.message}\nTime: ${log.timestamp}\nLevel: ${log.level.name}';
    // Share.share(text); // Requires share_plus package
  }

  Future<void> _exportLogs() async {
    try {
      // ignore: unused_local_variable
      final exported = await AppLogger.instance.exportLogs(
        minLevel: _selectedLevel,
        category: _selectedCategory,
      );

      // Save to file or share
      // This would typically involve file_picker or share_plus packages
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logs exported successfully')),
        );
      }
    } catch (e) {
      _showError('Failed to export logs: $e');
    }
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text('Clear Logs', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to clear all logs? This action cannot be undone.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AppLogger.instance.clearLogs();
              await _loadLogs();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logs cleared successfully')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

// lib/ui/logger/logger_settings_screen.dart
class LoggerSettingsScreen extends StatefulWidget {
  const LoggerSettingsScreen({super.key});

  @override
  State<LoggerSettingsScreen> createState() => _LoggerSettingsScreenState();
}

class _LoggerSettingsScreenState extends State<LoggerSettingsScreen> {
  late AppLoggerConfig _config;
  bool _enableFileLogging = true;
  bool _enableConsoleLogging = true;
  bool _enableRemoteLogging = false;
  LogLevel _minLogLevel = LogLevel.debug;
  bool _encryptLogs = false;
  List<LogCategory> _enabledCategories = LogCategory.values;
  String _remoteEndpoint = '';

  @override
  void initState() {
    super.initState();
    _config = AppLogger.instance.config;
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _enableFileLogging = _config.enableFileLogging;
      _enableConsoleLogging = _config.enableConsoleLogging;
      _enableRemoteLogging = _config.enableRemoteLogging;
      _minLogLevel = _config.minLogLevel;
      _encryptLogs = _config.encryptLogs;
      _enabledCategories = List.from(_config.enabledCategories);
      _remoteEndpoint = _config.remoteEndpoint ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logger Settings'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text('SAVE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('General Settings', [
            _buildSwitchTile(
              'Enable File Logging',
              'Save logs to device storage',
              _enableFileLogging,
              (value) => setState(() => _enableFileLogging = value),
            ),
            _buildSwitchTile(
              'Enable Console Logging',
              'Show logs in debug console',
              _enableConsoleLogging,
              (value) => setState(() => _enableConsoleLogging = value),
            ),
            _buildSwitchTile(
              'Encrypt Logs',
              'Encrypt logs before saving to file',
              _encryptLogs,
              (value) => setState(() => _encryptLogs = value),
            ),
          ]),

          _buildSection('Log Level', [
            _buildDropdownTile(
              'Minimum Log Level',
              'Only log messages at this level or higher',
              _minLogLevel.name,
              LogLevel.values.map((e) => e.name).toList(),
              (value) =>
                  setState(() => _minLogLevel = LogLevel.values.byName(value)),
            ),
          ]),

          _buildSection('Categories', [..._buildCategoryTiles()]),

          _buildSection('Remote Logging', [
            _buildSwitchTile(
              'Enable Remote Logging',
              'Send logs to remote server',
              _enableRemoteLogging,
              (value) => setState(() => _enableRemoteLogging = value),
            ),
            if (_enableRemoteLogging) ...[
              _buildTextFieldTile(
                'Remote Endpoint',
                'URL to send logs to',
                _remoteEndpoint,
                (value) => _remoteEndpoint = value,
              ),
            ],
          ]),

          _buildSection('System Info', [
            _buildInfoTile('Session ID', AppLogger.instance.sessionId),
            _buildInfoTile('User ID', AppLogger.instance.userId ?? 'Not set'),
          ]),

          const SizedBox(height: 32),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8, top: 24),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          color: Colors.grey[800],
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
      trailing: DropdownButton<String>(
        value: value,
        dropdownColor: Colors.grey[800],
        style: const TextStyle(color: Colors.white),
        items: options
            .map(
              (option) => DropdownMenuItem(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: (newValue) => onChanged(newValue!),
      ),
    );
  }

  Widget _buildTextFieldTile(
    String title,
    String subtitle,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: TextStyle(color: Colors.grey[400])),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[700],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              hintText: 'Enter URL...',
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Text(
        value,
        style: TextStyle(color: Colors.grey[400], fontFamily: 'monospace'),
      ),
    );
  }

  List<Widget> _buildCategoryTiles() {
    return LogCategory.values.map((category) {
      final isEnabled = _enabledCategories.contains(category);
      return CheckboxListTile(
        title: Text(
          category.name.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        value: isEnabled,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              if (value == true) {
                _enabledCategories.add(category);
              } else {
                _enabledCategories.remove(category);
              }
            });
          }
        },
        activeColor: Colors.blue,
      );
    }).toList();
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _testLogging,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Test Logging'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.restore),
            label: const Text('Reset to Defaults'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  void _saveSettings() {
    // In a real implementation, you would recreate the AppLogger with new config
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved! Restart app to apply changes.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _testLogging() {
    AppLogger.instance.logDebug('Test debug message', data: {'test': true});
    AppLogger.instance.logInfo('Test info message', category: LogCategory.ui);
    AppLogger.instance.logWarning(
      'Test warning message',
      category: LogCategory.performance,
    );
    AppLogger.instance.logError(
      'Test error message',
      category: LogCategory.network,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Test logs generated!')));
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Reset Settings',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Reset all settings to default values?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _enableFileLogging = true;
                _enableConsoleLogging = true;
                _enableRemoteLogging = false;
                _minLogLevel = LogLevel.debug;
                _encryptLogs = false;
                _enabledCategories = List.from(LogCategory.values);
                _remoteEndpoint = '';
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
