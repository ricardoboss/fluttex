import 'package:html_parser/html_node_type.dart';

abstract class HtmlNode {
  const HtmlNode({
    required this.type,
    this.parent,
  });

  final HtmlNodeType type;
  final HtmlNode? parent;

  String get text;

  @override
  String toString() => 'HtmlNode(type: $type)';

  HtmlNode withParent(HtmlNode? parent);
}
