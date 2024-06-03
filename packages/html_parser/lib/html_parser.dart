import 'dart:collection';

import 'package:html_parser/html_document.dart';
import 'package:html_parser/html_element.dart';
import 'package:html_parser/html_error_node.dart';
import 'package:html_parser/html_node.dart';
import 'package:html_parser/html_text.dart';
import 'package:html_parser/html_token.dart';
import 'package:html_parser/html_token_queue_extensions.dart';
import 'package:html_parser/html_token_type.dart';
import 'package:html_parser/html_tokenizer.dart';

const kDefaultSelfClosingTags = [
  'area',
  'base',
  'br',
  'col',
  'embed',
  'hr',
  'img',
  'input',
  'link',
  'meta',
  'source',
  'track',
  'wbr',
];

class HtmlParser {
  const HtmlParser({
    this.selfClosingTags = kDefaultSelfClosingTags,
  });

  final List<String> selfClosingTags;

  HtmlDocument parse(String html) {
    final tokens = HtmlTokenizer().tokenize(html);

    final nodes = parseTokens(tokens).toList(growable: false);

    return HtmlDocument(nodes: nodes);
  }

  Iterable<HtmlNode> parseTokens(Iterable<HtmlToken> tokens) sync* {
    final queue = Queue<HtmlToken>()..addAll(tokens);

    yield* _parseTokens(queue);
  }

  Iterable<HtmlNode> _parseTokens(
    Queue<HtmlToken> queue, {
    String? bailOnTagEnd,
  }) sync* {
    while (queue.isNotEmpty) {
      final token = queue.removeFirst();

      switch (token.type) {
        case HtmlTokenType.text:
          yield HtmlText(text: token.text);
        case HtmlTokenType.whitespace:
          break;
        case HtmlTokenType.tagOpen:
          final tagName = queue.removeToken(HtmlTokenType.tagName).text;
          final attributes = _parseAttributes(queue);

          if (queue.isEmpty) {
            yield HtmlErrorNode(message: 'Missing tag closing');

            break;
          }

          final List<HtmlNode> children;
          if (queue.first.type == HtmlTokenType.tagClose) {
            queue.removeToken(HtmlTokenType.tagClose);

            if (selfClosingTags.contains(tagName)) {
              children = const [];
            } else {
              children = _parseTokens(
                queue,
                bailOnTagEnd: tagName,
              ).toList(growable: false);
            }
          } else if (queue.first.type == HtmlTokenType.tagEndingClose) {
            queue.removeToken(HtmlTokenType.tagEndingClose);

            children = const [];
          } else {
            yield HtmlErrorNode(
              message: 'Unexpected token type ${queue.first.type}',
            );

            break;
          }

          yield HtmlElement(
            tagName: tagName,
            attributes: attributes,
            children: children,
          );

          break;
        case HtmlTokenType.tagEndingOpen:
          if (bailOnTagEnd == null) {
            yield HtmlErrorNode(message: 'Unexpected tag ending');

            break;
          }

          if (queue.isEmpty) {
            yield HtmlErrorNode(message: 'Missing tag name in tag ending');

            break;
          }

          final tagName = queue.removeToken(HtmlTokenType.tagName).text;

          if (queue.isEmpty) {
            yield HtmlErrorNode(message: 'Missing tag closing');

            break;
          }

          queue.removeToken(HtmlTokenType.tagClose);

          if (tagName != bailOnTagEnd) {
            yield HtmlErrorNode(message: 'Unexpected tag name in tag ending');

            break;
          }

          return;
        default:
          yield HtmlErrorNode(message: 'Unexpected token type ${token.type}');

          while (queue.isNotEmpty && !queue.first.type.isValidInitializer) {
            queue.removeFirst();
          }

          break;
      }
    }
  }

  Map<String, String> _parseAttributes(Queue<HtmlToken> tokens) {
    final attributes = <String, String>{};

    while (tokens.isNotEmpty && !tokens.firstType.isTagClosing) {
      if (tokens.firstType == HtmlTokenType.whitespace) {
        tokens.removeFirst();

        continue;
      }

      final name = tokens.removeToken(HtmlTokenType.attributeName).text;
      final value = tokens.removeToken(HtmlTokenType.attributeValue).text;

      attributes[name] = value;
    }

    return attributes;
  }
}
