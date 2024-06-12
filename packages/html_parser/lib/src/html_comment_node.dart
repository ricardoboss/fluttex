part of '../html_parser.dart';

class HtmlCommentNode extends HtmlNode {
  final String comment;

  const HtmlCommentNode({
    required this.comment,
    super.parent,
  }) : super(type: HtmlNodeType.comment);

  @override
  String toString() {
    return 'HtmlCommentNode(comment: $comment)';
  }

  @override
  String get text => "";

  @override
  HtmlNode withParent(HtmlNode? parent) {
    return HtmlCommentNode(
      comment: comment,
      parent: parent,
    );
  }
}
