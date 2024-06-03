enum HtmlTokenType {
  text,
  whitespace,
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
      ].contains(this);

  bool get isTagClosing => [
        HtmlTokenType.tagClose,
        HtmlTokenType.tagEndingClose,
      ].contains(this);
}
