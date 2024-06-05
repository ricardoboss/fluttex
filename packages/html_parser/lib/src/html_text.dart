part of '../html_parser.dart';

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
