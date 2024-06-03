import 'package:css_parser/css_token_type.dart';

class CssToken {
  const CssToken(this.type, this.text);

  final CssTokenType type;
  final String text;

  @override
  String toString() => '${type.name}: $text';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssToken &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          text == other.text;

  @override
  int get hashCode => type.hashCode ^ text.hashCode;
}
