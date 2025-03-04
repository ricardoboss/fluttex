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
    var tagName = '';
    var islandStringChar = '';
    var escapeNext = false;
    while (queue.isNotEmpty) {
      if (state == _TokenizerState.island) {
        if (queue.isEmpty) {
          throw Exception('Unexpected EOF in island');
        }

        if (islandStringChar.isEmpty) {
          if (queue.startsWith('</$tagName>')) {
            queue.removeFirstEntries('</$tagName>'.length);

            final script = buffer.toString();
            buffer.clear();

            yield HtmlToken(HtmlTokenType.script, script);

            yield HtmlToken(HtmlTokenType.tagEndingOpen, '</');
            yield HtmlToken(HtmlTokenType.tagName, tagName);
            yield HtmlToken(HtmlTokenType.tagClose, '>');

            state = _TokenizerState.initial;

            continue;
          }
        }

        final char = queue.removeFirst();
        if (!escapeNext) {
          if (char == '\\') {
            escapeNext = true;

            continue;
          }

          if (char == islandStringChar) {
            islandStringChar = '';
          } else if (char == '"' || char == "'") {
            islandStringChar = char;
          }
        } else {
          escapeNext = false;
        }

        buffer.write(char);

        continue;
      }

      final char = queue.removeFirst();

      switch (char) {
        case '<':
          switch (state) {
            case _TokenizerState.island:
            case _TokenizerState.initial:
              if (buffer.isNotEmpty) {
                final text = buffer.toString();
                buffer.clear();

                yield HtmlToken(
                  state == _TokenizerState.island
                      ? HtmlTokenType.script
                      : HtmlTokenType.text,
                  text,
                );
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
            case _TokenizerState.quotedAttributeValue:
            case _TokenizerState.comment:
            case _TokenizerState.island:
              buffer.write(char);

              break;
            case _TokenizerState.attributeValue:
              final attributeValue = buffer.toString();
              buffer.clear();

              yield HtmlToken(HtmlTokenType.attributeValue, attributeValue);

              yield HtmlToken(HtmlTokenType.whitespace, ' ');

              state = _TokenizerState.insideTag;

              break;
            case _TokenizerState.insideTag:
              yield HtmlToken(HtmlTokenType.whitespace, ' ');

              break;
            case _TokenizerState.tagName:
              tagName = buffer.toString();
              buffer.clear();

              if (tagName.isEmpty) {
                throw Exception('Empty tag name');
              }

              yield HtmlToken(HtmlTokenType.tagName, tagName);

              yield HtmlToken(HtmlTokenType.whitespace, ' ');

              state = _TokenizerState.insideTag;

              break;
            case _TokenizerState.attributeName:
              if (buffer.isEmpty) {
                throw Exception('Empty attribute name');
              }

              final attributeName = buffer.toString();
              buffer.clear();

              yield HtmlToken(HtmlTokenType.attributeName, attributeName);

              yield HtmlToken(HtmlTokenType.whitespace, ' ');

              state = _TokenizerState.insideTag;

              break;
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

              tagName = buffer.toString();
              buffer.clear();

              if (tagName.isEmpty) {
                throw Exception('Empty tag name');
              }

              yield HtmlToken(HtmlTokenType.tagName, tagName);

              yield HtmlToken(HtmlTokenType.tagClose, '>');

              state = _TokenizerState.initial;

              break;
            case _TokenizerState.insideTag:
              yield HtmlToken(HtmlTokenType.tagClose, '>');

              if (['script', 'style'].contains(tagName)) {
                state = _TokenizerState.island;

                break;
              }

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
            case _TokenizerState.attributeValue:
              final attributeValue = buffer.toString();
              buffer.clear();

              yield HtmlToken(HtmlTokenType.attributeValue, attributeValue);

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
            case _TokenizerState.quotedAttributeValue:
            case _TokenizerState.comment:
            case _TokenizerState.island:
              buffer.write(char);

              break;
            case _TokenizerState.tagName:
              if (buffer.isEmpty) {
                throw Exception('Empty tag name');
              }

              tagName = buffer.toString();
              buffer.clear();

              if (tagName.isEmpty) {
                throw Exception('Empty tag name');
              }

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
            default:
              throw UnimplementedError("Unexpected '/' in state $state");
          }
        case '\r':
        case '\n':
          switch (state) {
            case _TokenizerState.initial:
            case _TokenizerState.comment:
            case _TokenizerState.island:
              buffer.write(char);

              break;
            case _TokenizerState.tagName:
              if (buffer.isEmpty) {
                throw Exception('Empty tag name');
              }

              tagName = buffer.toString();
              buffer.clear();

              if (tagName.isEmpty) {
                throw Exception('Empty tag name');
              }

              yield HtmlToken(HtmlTokenType.tagName, tagName);

              yield HtmlToken(HtmlTokenType.whitespace, char);

              state = _TokenizerState.insideTag;

              break;
            case _TokenizerState.attributeName:
              if (buffer.isEmpty) {
                throw Exception('Empty attribute name');
              }

              final attributeName = buffer.toString();
              buffer.clear();

              yield HtmlToken(HtmlTokenType.attributeName, attributeName);

              yield HtmlToken(HtmlTokenType.whitespace, char);

              state = _TokenizerState.insideTag;

              break;
            case _TokenizerState.insideTag:
              yield HtmlToken(HtmlTokenType.whitespace, char);

              break;
            default:
              throw UnimplementedError("Unexpected line break in state $state");
          }
        default:
          switch (state) {
            case _TokenizerState.tagName:
            case _TokenizerState.attributeValue:
              buffer.write(char);

              break;
            case _TokenizerState.attributeName:
              if (char == '=') {
                final attributeName = buffer.toString();
                buffer.clear();

                yield HtmlToken(HtmlTokenType.attributeName, attributeName);

                if (queue.isEmpty) {
                  throw Exception(
                    'Expected attribute value after attribute name and =, got EOF',
                  );
                }

                if (queue.first == '"') {
                  queue.removeFirst();

                  state = _TokenizerState.quotedAttributeValue;
                } else {
                  state = _TokenizerState.attributeValue;
                }
              } else {
                buffer.write(char);
              }

              break;
            case _TokenizerState.quotedAttributeValue:
              if (char == '"') {
                final attributeValue = buffer.toString();
                buffer.clear();

                yield HtmlToken(HtmlTokenType.attributeValue, attributeValue);

                state = _TokenizerState.insideTag;

                break;
              }

              buffer.write(char);

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
  quotedAttributeValue,
  comment,
  island,
}
