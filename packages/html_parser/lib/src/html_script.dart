part of '../html_parser.dart';

class HtmlScript extends HtmlNode {
  const HtmlScript({
    required this.script,
    super.parent,
  }) : super(type: HtmlNodeType.script);

  final String script;

  @override
  String toString() => 'HtmlScript(script: $script)';

  @override
  HtmlNode withParent(HtmlNode? parent) {
    return HtmlScript(script: script, parent: parent);
  }

  @override
  String get text => script;
}
