import 'package:html_parser/html_node.dart';
import 'package:html_parser/html_node_type.dart';

class HtmlText extends HtmlNode {
  const HtmlText({
    required this.text,
    super.parent,
  }) : super(type: HtmlNodeType.text);

  @override
  final String text;

  @override
  String toString() => 'HtmlText(text: $text)';

  @override
  HtmlNode withParent(HtmlNode? parent) {
    return HtmlText(text: text, parent: parent);
  }
}
