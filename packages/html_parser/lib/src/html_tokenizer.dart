part of '../html_parser.dart';

class HtmlTokenizer {
  Iterable<HtmlToken> tokenize(String html) sync* {
    if (html.isEmpty) {
      yield const HtmlToken(HtmlTokenType.text, '');

      return;
    }

    var state = _TokenizerState.initial;
    final buffer = StringBuffer();
    final queue = Queue<String>()..addAll(html.split(''));
    while (queue.isNotEmpty) {
      final char = queue.removeFirst();

      switch (char) {
        case '<':
          switch (state) {
            case _TokenizerState.initial:
              if (buffer.isNotEmpty) {
                final text = buffer.toString();
                buffer.clear();

                yield HtmlToken(HtmlTokenType.text, text);
              }

              state = _TokenizerState.tagName;

              if (queue.startsWith('/')) {
                queue.removeFirst();

                yield HtmlToken(HtmlTokenType.tagEndingOpen, '</');
              } else if (queue.startsWith('!--')) {
                queue.removeFirstEntries(3);

                yield HtmlToken(HtmlTokenType.commentOpen, '<!--');

                state = _TokenizerState.comment;
              } else {
                yield HtmlToken(HtmlTokenType.tagOpen, '<');
              }

              break;
            case _TokenizerState.comment:
              buffer.write(char);

              break;
            default:
              throw UnimplementedError("Unexpected '<' in state $state");
          }
        case ' ':
          switch (state) {
            case _TokenizerState.initial:
              buffer.write(char);

              break;
            case _TokenizerState.insideTag:
              yield HtmlToken(HtmlTokenType.whitespace, ' ');

              break;
            case _TokenizerState.tagName:
              final tagName = buffer.toString();
              buffer.clear();

              if (tagName.isEmpty) {
                throw Exception('Empty tag name');
              }

              yield HtmlToken(HtmlTokenType.tagName, tagName);

              yield HtmlToken(HtmlTokenType.whitespace, ' ');

              state = _TokenizerState.insideTag;

              break;
            case _TokenizerState.attributeValue:
              buffer.write(char);

              break;
            case _TokenizerState.comment:
              buffer.write(char);

              break;
            default:
              throw UnimplementedError("Unexpected space in state $state");
          }
        case '>':
          switch (state) {
            case _TokenizerState.initial:
              buffer.write(char);

              break;
            case _TokenizerState.tagName:
              if (buffer.isEmpty) {
                throw Exception('Empty tag name');
              }

              final tagName = buffer.toString();
              buffer.clear();

              yield HtmlToken(HtmlTokenType.tagName, tagName);

              yield HtmlToken(HtmlTokenType.tagClose, '>');

              state = _TokenizerState.initial;

              break;
            case _TokenizerState.insideTag:
              yield HtmlToken(HtmlTokenType.tagClose, '>');

              state = _TokenizerState.initial;

              break;
            case _TokenizerState.attributeName:
              if (buffer.isEmpty) {
                throw Exception('Empty attribute name');
              }

              final attributeName = buffer.toString();
              buffer.clear();

              yield HtmlToken(HtmlTokenType.attributeName, attributeName);

              yield HtmlToken(HtmlTokenType.tagClose, '>');

              state = _TokenizerState.initial;

              break;
            case _TokenizerState.comment:
              buffer.write(char);

              break;
            default:
              throw UnimplementedError("Unexpected '>' in state $state");
          }
        case '/':
          switch (state) {
            case _TokenizerState.initial:
              buffer.write(char);

              break;
            case _TokenizerState.tagName:
              if (buffer.isEmpty) {
                throw Exception('Empty tag name');
              }

              final tagName = buffer.toString();
              buffer.clear();

              yield HtmlToken(HtmlTokenType.tagName, tagName);

              if (queue.isEmpty || queue.first != '>') {
                throw Exception('Expected > after / inside tag');
              }

              queue.removeFirst();

              yield HtmlToken(HtmlTokenType.tagEndingClose, '/>');

              state = _TokenizerState.initial;

              break;
            case _TokenizerState.insideTag:
              if (queue.isEmpty || queue.first != '>') {
                throw Exception('Expected > after / inside tag');
              }

              queue.removeFirst();

              yield HtmlToken(HtmlTokenType.tagEndingClose, '/>');

              state = _TokenizerState.initial;

              break;
            case _TokenizerState.attributeValue:
              buffer.write(char);

              break;
            case _TokenizerState.comment:
              buffer.write(char);

              break;
            default:
              throw UnimplementedError("Unexpected '/' in state $state");
          }
        case '\r':
        case '\n':
          switch (state) {
            case _TokenizerState.initial:
              buffer.write(char);

              break;
            case _TokenizerState.tagName:
              if (buffer.isEmpty) {
                throw Exception('Empty tag name');
              }

              final tagName = buffer.toString();
              buffer.clear();

              yield HtmlToken(HtmlTokenType.tagName, tagName);

              yield HtmlToken(HtmlTokenType.whitespace, char);

              state = _TokenizerState.insideTag;

              break;
            case _TokenizerState.insideTag:
              yield HtmlToken(HtmlTokenType.whitespace, char);

              break;
            case _TokenizerState.comment:
              buffer.write(char);

              break;
            default:
              throw UnimplementedError("Unexpected line break in state $state");
          }
        default:
          switch (state) {
            case _TokenizerState.tagName:
              buffer.write(char);

              break;
            case _TokenizerState.attributeName:
              if (char == '=') {
                final attributeName = buffer.toString();
                buffer.clear();

                yield HtmlToken(HtmlTokenType.attributeName, attributeName);

                if (queue.isEmpty || queue.first != '"') {
                  throw Exception('Expected " after attribute name and =');
                }

                queue.removeFirst();

                state = _TokenizerState.attributeValue;
              } else {
                buffer.write(char);
              }

              break;
            case _TokenizerState.attributeValue:
              if (char == '"') {
                final attributeValue = buffer.toString();
                buffer.clear();

                yield HtmlToken(HtmlTokenType.attributeValue, attributeValue);

                state = _TokenizerState.insideTag;
              } else {
                buffer.write(char);
              }

              break;
            case _TokenizerState.insideTag:
              state = _TokenizerState.attributeName;

              buffer.clear();
              buffer.write(char);

              break;
            case _TokenizerState.comment:
              if (char != '-' || !queue.startsWith('->')) {
                buffer.write(char);

                break;
              }

              queue.removeFirstEntries(2);

              final comment = buffer.toString();
              buffer.clear();

              yield HtmlToken(HtmlTokenType.commentText, comment);

              yield HtmlToken(HtmlTokenType.commentClose, '-->');

              state = _TokenizerState.initial;

              break;
            default:
              buffer.write(char);

              break;
          }

          break;
      }
    }
  }
}

enum _TokenizerState {
  initial,
  tagName,
  insideTag,
  attributeName,
  attributeValue,
  comment,
}
