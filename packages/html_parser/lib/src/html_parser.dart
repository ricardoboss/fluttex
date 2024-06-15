part of '../html_parser.dart';

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
  '!DOCTYPE',
];

class HtmlParser {
  const HtmlParser({
    this.selfClosingTags = kDefaultSelfClosingTags,
    this.emitErrorNodes = true,
  });

  final List<String> selfClosingTags;
  final bool emitErrorNodes;

  HtmlDocument parse(String html) {
    final tokens = HtmlTokenizer().tokenize(html);

    final nodes = parseTokens(tokens).toList(growable: false);

    return HtmlDocument(children: nodes);
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
            if (emitErrorNodes) {
              yield HtmlErrorNode(message: 'Missing tag closing');
            }

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
            if (emitErrorNodes) {
              yield HtmlErrorNode(
                message: 'Unexpected token type ${queue.first.type}',
              );
            }

            break;
          }

          switch (tagName) {
            case 'body':
              yield HtmlBodyElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'head':
              yield HtmlHeadElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'div':
              yield HtmlDivElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'hr':
              yield HtmlHrElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'h1':
            case 'h2':
            case 'h3':
            case 'h4':
            case 'h5':
            case 'h6':
              yield HtmlHElement(
                level: int.parse(tagName.substring(1)),
                attributes: attributes,
                children: children,
              );

              break;
            case 'p':
              yield HtmlPElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'input':
              yield HtmlInputElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'img':
              yield HtmlImgElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'button':
              yield HtmlButtonElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'a':
              yield HtmlAElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'header':
              yield HtmlHeaderElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'article':
              yield HtmlArticleElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'footer':
              yield HtmlFooterElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'li':
              yield HtmlLiElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'ol':
              yield HtmlOlElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'ul':
              yield HtmlUlElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'br':
              yield HtmlBrElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'nav':
              yield HtmlNavElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'section':
              yield HtmlSectionElement(
                attributes: attributes,
                children: children,
              );

              break;
            case 'main':
              yield HtmlMainElement(
                attributes: attributes,
                children: children,
              );

              break;
            default:
              yield HtmlElement(
                tagName: tagName,
                attributes: attributes,
                children: children,
              );

              break;
          }

          break;
        case HtmlTokenType.tagEndingOpen:
          if (bailOnTagEnd == null) {
            if (emitErrorNodes) {
              yield HtmlErrorNode(message: 'Unexpected tag ending');
            }

            break;
          }

          if (queue.isEmpty) {
            if (emitErrorNodes) {
              yield HtmlErrorNode(message: 'Missing tag name in tag ending');
            }

            break;
          }

          final tagName = queue.removeToken(HtmlTokenType.tagName).text;

          if (queue.isEmpty) {
            if (emitErrorNodes) {
              yield HtmlErrorNode(
                message: 'Missing tag closing for <$tagName>',
              );
            }

            break;
          }

          queue.removeToken(HtmlTokenType.tagClose);

          if (tagName != bailOnTagEnd) {
            if (emitErrorNodes) {
              yield HtmlErrorNode(
                message: 'Unexpected </$tagName> when expecting </$bailOnTagEnd>',
              );
            }

            break;
          }

          return;
        case HtmlTokenType.commentOpen:
          final comment = queue.removeToken(HtmlTokenType.commentText).text;
          queue.removeToken(HtmlTokenType.commentClose);

          yield HtmlCommentNode(comment: comment);

          break;
        default:
          if (emitErrorNodes) {
            yield HtmlErrorNode(message: 'Unexpected token type ${token.type}');
          }

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

      if (tokens.firstType == HtmlTokenType.attributeValue) {
        final value = tokens.removeToken(HtmlTokenType.attributeValue).text;

        attributes[name] = value;
      } else {
        attributes[name] = '';
      }
    }

    return attributes;
  }
}
