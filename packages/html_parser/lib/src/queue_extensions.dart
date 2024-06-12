part of '../html_parser.dart';

extension QueueExtensions on Queue<String> {
  bool startsWith(String prefix) {
    if (isEmpty) {
      return false;
    }

    for (var i = 0; i < prefix.length; i++) {
      if (elementAt(i) != prefix[i]) {
        return false;
      }
    }

    return true;
  }

  void removeFirstEntries(int count) {
    for (var i = 0; i < count; i++) {
      removeFirst();
    }
  }
}
