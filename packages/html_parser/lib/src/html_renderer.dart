part of '../html_parser.dart';

class HtmlRenderer {
  const HtmlRenderer();

  String render(HtmlDocument document) {
    final buffer = StringBuffer();

    for (var node in document.nodes) {
      buffer.writeln(renderNode(node));
    }

    return buffer.toString();
  }

  String renderNode(HtmlNode node) {
    final buffer = StringBuffer();

    switch (node) {
      case final HtmlElement element:
        buffer.write('<${element.tagName}');

        for (var attribute in element.attributes.entries) {
          buffer.write(' ${attribute.key}="${attribute.value}"');
        }

        if (element.children.isEmpty) {
          buffer.write(' />');
        } else {
          buffer.write('>');

          for (var child in node.children) {
            buffer.write(renderNode(child));
          }

          buffer.write('</${element.tagName}>');
        }

        break;
      case final HtmlText text:
        buffer.write(text.text);
        break;
      case HtmlErrorNode error:
        buffer.write('<!-- error: ${error.message} -->');
        break;
      default:
        throw Exception('Unsupported node type ${node.type}');
    }

    return buffer.toString();
  }
}
