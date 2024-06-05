part of '../html_parser.dart';

class HtmlErrorNode extends HtmlNode {
  HtmlErrorNode({
    required this.message,
    super.parent,
  }) : super(type: HtmlNodeType.error);

  final String message;

  @override
  String toString() => 'HtmlErrorNode(message: $message)';

  @override
  String get text => "<!-- $message -->";

  @override
  HtmlNode withParent(HtmlNode? parent) {
    return HtmlErrorNode(
      message: message,
      parent: parent,
    );
  }
}
