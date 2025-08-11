import 'package:logger/logger.dart';

/// Global logger instance for the UAWS application
///
/// Usage:
/// - AppLogger.i('Info message');
/// - AppLogger.d('Debug message');
/// - AppLogger.w('Warning message');
/// - AppLogger.e('Error message');
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat
          .onlyTimeAndSinceStart, // Use new format instead of printTime
    ),
  );

  /// Log info messages
  static void i(String message) {
    _logger.i(message);
  }

  /// Log debug messages
  static void d(String message) {
    _logger.d(message);
  }

  /// Log warning messages
  static void w(String message) {
    _logger.w(message);
  }

  /// Log error messages
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log trace messages (replaces deprecated verbose)
  static void t(String message) {
    _logger.t(message);
  }

  /// Log What The Hell messages (for critical errors)
  static void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
