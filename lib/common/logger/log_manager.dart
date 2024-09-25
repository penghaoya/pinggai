import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class LogManager {
  static final LogManager _instance = LogManager._internal();
  factory LogManager() => _instance;
  LogManager._internal();

  final List<LogEntry> _logs = [];
  final _logController = StreamController<LogEntry>.broadcast();

  // 简化日志调用
  void info(dynamic content) {
    log(content, level: LogLevel.info);
  }

  void warning(dynamic content) {
    log(content, level: LogLevel.warning);
  }

  void err(dynamic content) {
    log(content, level: LogLevel.error);
  }

  void log(dynamic content, {LogLevel level = LogLevel.info}) {
    final entry = LogEntry(DateTime.now(), content, level);
    _logs.add(entry);
    _logController.add(entry);
  }

  // 新增：清除日志的函数
  void clearLogs() {
    _logs.clear();
    _logController.add(LogEntry(DateTime.now(), "Logs cleared", LogLevel.info));
  }

  Stream<LogEntry> get logStream => _logController.stream;
  List<LogEntry> get logs => _logs;
}

enum LogLevel { debug, info, warning, error }

class LogDisplay extends StatefulWidget {
  final double? width;
  final double? height;
  final Color backgroundColor;

  const LogDisplay({super.key, 
    this.width,
    this.height,
    this.backgroundColor = Colors.white,
  });

  @override
  _LogDisplayState createState() => _LogDisplayState();
}

class _LogDisplayState extends State<LogDisplay> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<LogEntry>(
              stream: LogManager().logStream,
              builder: (context, snapshot) {
                // 自动滚动到最底部
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: LogManager().logs.length,
                  itemBuilder: (context, index) {
                    final log = LogManager().logs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 1.0,
                        horizontal: 10.0,
                      ),
                      child: SelectableText.rich(
                        _formatLogEntry(log),
                        style: const TextStyle(
                          fontFamily: 'Consolas',
                          fontSize: 12,
                        ),
                        // 确保内容自动换行
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _formatLogEntry(LogEntry log) {
    return TextSpan(
      children: [
        TextSpan(
          text: '[${_formatTimestamp(log.timestamp)}] ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12, // 统一字体大小
          ),
        ),
        TextSpan(
          text: _getLevelPrefix(log.level),
          style: TextStyle(
            color: _getLevelColor(log.level),
            fontSize: 12, // 统一字体大小
          ),
        ),
        TextSpan(
          text: _formatLogContent(log.content),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12, // 统一字体大小
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }

  String _formatLogContent(dynamic content) {
    if (content is Map || content is List) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(content);
    } else {
      return content.toString();
    }
  }

  String _getLevelPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '[DEBUG] ';
      case LogLevel.info:
        return '[INFO] ';
      case LogLevel.warning:
        return '[WARN] ';
      case LogLevel.error:
        return '[ERROR] ';
    }
  }

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return Colors.cyan;
      case LogLevel.info:
        return Colors.green;
      case LogLevel.warning:
        return Colors.yellow;
      case LogLevel.error:
        return Colors.red;
    }
  }
}

class LogEntry {
  final DateTime timestamp;
  final dynamic content;
  final LogLevel level;

  LogEntry(this.timestamp, this.content, this.level);
}
