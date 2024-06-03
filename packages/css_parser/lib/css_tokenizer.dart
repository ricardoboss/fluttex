import 'dart:collection';

import 'package:css_parser/css_token.dart';
import 'package:css_parser/css_token_type.dart';
import 'package:css_parser/string_extensions.dart';

class CssTokenizer {
  const CssTokenizer();

  Iterable<CssToken> tokenize(String css) sync* {
    if (css.isEmpty) {
      yield const CssToken(CssTokenType.whitespace, '');

      return;
    }

    var state = _TokenizerState.initial;
    var buffer = StringBuffer();
    final queue = Queue<String>()..addAll(css.split(''));

    while (queue.isNotEmpty) {
      final char = queue.removeFirst();

      switch (char) {
        case '{':
          switch (state) {
            case _TokenizerState.beforeDefinition:
              if (buffer.isNotEmpty) {
                final selector = buffer.toString();
                buffer.clear();

                yield CssToken(CssTokenType.selector, selector);
              }

              state = _TokenizerState.insideDefinition;

              break;
            default:
              throw UnimplementedError(
                "Unexpected character '{' in state $state",
              );
          }

          yield CssToken(CssTokenType.openCurly, '{');

          break;
        case '}':
          switch (state) {
            case _TokenizerState.insideDefinition:
              state = _TokenizerState.initial;

              break;
            default:
              throw UnimplementedError(
                "Unexpected character '}' in state $state",
              );
          }

          yield CssToken(CssTokenType.closeCurly, '}');

          break;
        case ':':
          switch (state) {
            case _TokenizerState.propertyName:
              if (buffer.isEmpty) {
                throw Exception('Empty property name');
              }

              final propertyName = buffer.toString();
              buffer.clear();

              yield CssToken(CssTokenType.propertyName, propertyName);

              state = _TokenizerState.value;
              break;
            default:
              throw UnimplementedError(
                "Unexpected character ':' in state $state",
              );
          }

          yield CssToken(CssTokenType.colon, ':');

          break;
        case ';':
          switch (state) {
            case _TokenizerState.afterValue:
              break;
            case _TokenizerState.numberValue:
              final value = buffer.toString();
              buffer.clear();

              yield CssToken(CssTokenType.number, value);

              break;
            case _TokenizerState.unit:
              final unit = buffer.toString();
              buffer.clear();

              yield CssToken(CssTokenType.unit, unit);

              break;
            case _TokenizerState.predefinedValue:
              final value = buffer.toString();
              buffer.clear();

              yield CssToken(CssTokenType.discreteValue, value);

              break;
            case _TokenizerState.hexColor:
              final value = buffer.toString();
              buffer.clear();

              yield CssToken(CssTokenType.hexColor, value);

              break;
            default:
              throw UnimplementedError(
                "Unexpected character ';' in state $state",
              );
          }

          yield CssToken(CssTokenType.semicolon, ';');

          state = _TokenizerState.insideDefinition;

          break;
        case final String ws when ws.isWhitespace:
          switch (state) {
            case _TokenizerState.initial:
            case _TokenizerState.value:
            case _TokenizerState.insideDefinition:
            case _TokenizerState.beforeDefinition:
              break;
            case _TokenizerState.selector:
              if (buffer.isNotEmpty) {
                final selector = buffer.toString();
                buffer.clear();

                yield CssToken(CssTokenType.selector, selector);
              }

              state = _TokenizerState.beforeDefinition;
            default:
              throw UnimplementedError(
                "Unexpected character 0x${ws.codeUnitAt(0).toRadixString(16).padLeft(2, '0')} in state $state",
              );
          }

          yield CssToken(CssTokenType.whitespace, ws);

          break;
        case ',':
          switch (state) {
            case _TokenizerState.beforeDefinition:
            case _TokenizerState.selector:
              if (buffer.isEmpty) {
                throw Exception('Empty selector');
              }

              final selector = buffer.toString();
              buffer.clear();

              yield CssToken(CssTokenType.selector, selector);
            default:
              throw UnimplementedError(
                "Unexpected character ',' in state $state",
              );
          }

          yield CssToken(CssTokenType.comma, ',');

          break;
        default:
          switch (state) {
            case _TokenizerState.initial:
            case _TokenizerState.beforeDefinition:
              buffer.write(char);

              state = _TokenizerState.selector;

              break;
            case _TokenizerState.insideDefinition:
              buffer.write(char);

              state = _TokenizerState.propertyName;

              break;
            case _TokenizerState.selector:
            case _TokenizerState.predefinedValue:
            case _TokenizerState.propertyName:
              buffer.write(char);

              break;
            case _TokenizerState.value:
              state = switch (char) {
                _ when char == '-' => _TokenizerState.numberValue,
                _ when char == '.' => _TokenizerState.numberValue,
                _ when char == '#' => _TokenizerState.hexColor,
                _ when char.isOnlyDigits => _TokenizerState.numberValue,
                _ when char.isOnlyLetters => _TokenizerState.predefinedValue,
                _ => throw UnimplementedError(
                    "Unexpected character '$char' in state $state",
                  ),
              };

              buffer.write(char);

              break;
            case _TokenizerState.numberValue:
              if (char.isOnlyDigits) {
                buffer.write(char);
              } else {
                final number = buffer.toString();
                buffer.clear();

                yield CssToken(CssTokenType.number, number);

                buffer.write(char);

                state = _TokenizerState.unit;
              }

              break;
            case _TokenizerState.unit:
              if (char.isOnlyLetters) {
                buffer.write(char);
              } else {
                final unit = buffer.toString();
                buffer.clear();

                // handle unitless numbers
                if (buffer.isNotEmpty) {
                  yield CssToken(CssTokenType.unit, unit);
                }

                buffer.write(char);

                state = _TokenizerState.afterValue;
              }

              break;
            case _TokenizerState.hexColor:
              if (char.isOnlyHexDigits) {
                buffer.write(char);
              } else {
                final hexColor = buffer.toString();
                buffer.clear();

                yield CssToken(CssTokenType.hexColor, hexColor);

                buffer.write(char);

                state = _TokenizerState.afterValue;
              }

              break;
            default:
              throw UnimplementedError(
                "Unexpected character '$char' in state $state",
              );
          }
      }
    }
  }
}

enum _TokenizerState {
  initial,
  selector,
  beforeDefinition,
  insideDefinition,
  propertyName,
  value,
  predefinedValue,
  numberValue,
  unit,
  hexColor,
  afterValue,
}
