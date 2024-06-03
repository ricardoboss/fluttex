import 'package:html_parser/html_node.dart';
import 'package:html_parser/html_node_type.dart';

class HtmlElement extends HtmlNode {
  HtmlElement({
    required this.tagName,
    this.attributes = const {},
    this.children = const [],
    super.parent,
  }) : super(type: HtmlNodeType.element);

  final String tagName;
  final List<HtmlNode> children;
  final Map<String, String> attributes;

  @override
  String toString() {
    return 'HtmlElement(tagName: $tagName, attributes: $attributes, children: [${children.length} items])';
  }

  @override
  HtmlNode withParent(HtmlNode? parent) {
    return HtmlElement(
      tagName: tagName,
      attributes: attributes,
      children: children,
      parent: parent,
    );
  }

  @override
  String get text => children.map((n) => n.text).join();

  String? get className => attributes['class'];
}
