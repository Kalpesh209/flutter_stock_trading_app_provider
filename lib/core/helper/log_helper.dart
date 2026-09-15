import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class LogHelper {
  static const String defaultTag = 'APPLog';
  static void debugLog(String message, {String tag = defaultTag}) {
    if (kDebugMode) {
      developer.log(message, name: tag);
    }
  }

  static void infoLog(String message, {String tag = defaultTag}) {
    developer.log(message, name: tag, level: 800);
  }

  static void warningLog(String message, {String tag = defaultTag}) {
    developer.log(message, name: tag, level: 900);
  }

  static void errorLog(
    String message, {
    String tag = defaultTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
