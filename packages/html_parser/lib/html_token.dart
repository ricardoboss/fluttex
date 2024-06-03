import 'package:html_parser/html_token_type.dart';

class HtmlToken {
  const HtmlToken(this.type, this.text);

  final HtmlTokenType type;
  final String text;

  @override
  String toString() => '$type: $text';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HtmlToken &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          text == other.text;

  @override
  int get hashCode => type.hashCode ^ text.hashCode;
}
