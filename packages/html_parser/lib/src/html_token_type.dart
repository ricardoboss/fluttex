part of '../html_parser.dart';

enum HtmlTokenType {
  text,
  whitespace,
  commentOpen,
  commentText,
  commentClose,
  tagOpen,
  tagEndingOpen,
  tagName,
  attributeName,
  attributeValue,
  tagClose,
  tagEndingClose;

  bool get isValidInitializer => [
        HtmlTokenType.text,
        HtmlTokenType.whitespace,
        HtmlTokenType.tagOpen,
        HtmlTokenType.commentOpen,
      ].contains(this);

  bool get isTagClosing => [
        HtmlTokenType.tagClose,
        HtmlTokenType.tagEndingClose,
      ].contains(this);
}
