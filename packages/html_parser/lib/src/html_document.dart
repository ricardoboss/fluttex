part of '../html_parser.dart';

class HtmlDocument extends HtmlElement {
  HtmlDocument({
    required super.children,
    super.attributes,
    super.parent,
  }) : super(tagName: 'html');

  HtmlHeadElement? get head => findFirst<HtmlHeadElement>();

  HtmlBodyElement? get body => findFirst<HtmlBodyElement>();
}
