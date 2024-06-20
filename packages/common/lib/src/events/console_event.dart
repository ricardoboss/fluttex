part of '../../common.dart';

class ConsoleEvent extends Event {
  ConsoleEvent({
    required this.message,
    required this.level,
  });

  factory ConsoleEvent.error(String message) => ConsoleEvent(
        message: message,
        level: 1,
      );

  factory ConsoleEvent.warn(String message) => ConsoleEvent(
        message: message,
        level: 2,
      );

  factory ConsoleEvent.info(String message) => ConsoleEvent(
        message: message,
        level: 3,
      );

  final String message;
  final int level;

  @override
  String get debug => '$ConsoleEvent -> [$level] $message';
}
