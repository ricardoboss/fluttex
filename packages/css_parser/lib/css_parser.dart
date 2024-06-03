import 'dart:collection';

import 'package:css_parser/css_map.dart';
import 'package:css_parser/css_token.dart';
import 'package:css_parser/css_token_queue_extensions.dart';
import 'package:css_parser/css_token_type.dart';
import 'package:css_parser/css_tokenizer.dart';

class CssParser {
  const CssParser();

  CssMap parse(String css) {
    final tokens = CssTokenizer().tokenize(css);

    final entries = parseRules(tokens).toList(growable: false);

    return CssMap(entries: entries);
  }

  Iterable<CssMapEntry> parseRules(Iterable<CssToken> tokens) sync* {
    final queue = Queue<CssToken>()..addAll(tokens);

    yield* _parseRules(queue);
  }

  Iterable<CssMapEntry> _parseRules(Queue<CssToken> queue) sync* {
    while (queue.isNotEmpty) {
      final token = queue.removeFirst();

      switch (token.type) {
        case CssTokenType.selector:
          final selectors = <CssToken>[token];
          while (queue.isNotEmpty &&
              queue.firstTypeNoWhitespace != CssTokenType.openCurly) {
            final next = queue.removeFirst();

            if (next.type == CssTokenType.selector) {
              selectors.add(next);
            } else {
              assert(next.type == CssTokenType.comma ||
                  next.type == CssTokenType.whitespace);

              continue;
            }
          }

          queue.removeToken(CssTokenType.openCurly);

          Map<String, CssValue> properties = {};
          while (queue.isNotEmpty &&
              queue.firstTypeNoWhitespace != CssTokenType.closeCurly) {
            final name = queue.removeToken(CssTokenType.propertyName).text;

            queue.removeToken(CssTokenType.colon);

            switch (queue.firstTypeNoWhitespace) {
              case CssTokenType.hexColor:
                final value = queue.removeToken(CssTokenType.hexColor).text;

                properties[name] = CssColor.hex(value);

                break;
              case CssTokenType.number:
                final value = queue.removeToken(CssTokenType.number).text;
                final number = double.parse(value);

                if (queue.firstTypeNoWhitespace == CssTokenType.semicolon) {
                  properties[name] = CssUnitlessNumber(value: number);
                } else {
                  final unitString = queue.removeToken(CssTokenType.unit).text;
                  final CssUnit unit;
                  switch (unitString) {
                    case 'px':
                      unit = const PxUnit();
                      break;
                    case 'em':
                      unit = const EmUnit();
                      break;
                    default:
                      throw UnimplementedError("Unexpected unit $unitString");
                  }

                  properties[name] = CssNumber(value: number, unit: unit);
                }

                break;
              case CssTokenType.discreteValue:
                final value =
                    queue.removeToken(CssTokenType.discreteValue).text;

                properties[name] = CssDiscreteValue(value: value);

                break;
              default:
                throw UnimplementedError(
                    "Unexpected property type ${queue.firstTypeNoWhitespace}");
            }

            queue.removeToken(CssTokenType.semicolon);
          }

          queue.removeToken(CssTokenType.closeCurly);

          yield CssMapEntry(
            selectors: selectors.map((s) => s.text).toList(growable: false),
            properties: properties,
          );

          break;
        case CssTokenType.whitespace:
          continue;
        default:
          throw UnimplementedError("Unexpected token type ${token.type}");
      }
    }
  }
}
