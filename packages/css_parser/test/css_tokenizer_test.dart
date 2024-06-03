import 'package:css_parser/css_token.dart';
import 'package:css_parser/css_token_type.dart';
import 'package:css_parser/css_tokenizer.dart';
import 'package:test/test.dart';

void main() {
  test('Tokenize Simple CSS', () {
    const css = 'h1 { color: red; }';

    final tokens = const CssTokenizer().tokenize(css).toList(growable: false);

    expect(tokens, [
      CssToken(CssTokenType.selector, 'h1'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.openCurly, '{'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.propertyName, 'color'),
      CssToken(CssTokenType.colon, ':'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.discreteValue, 'red'),
      CssToken(CssTokenType.semicolon, ';'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.closeCurly, '}'),
    ]);
  });

  test('Tokenize multiline CSS', () {
    const css = 'h1 {\r\n  color: red;\r\n}\r\n';

    final tokens = const CssTokenizer().tokenize(css).toList(growable: false);

    expect(tokens, [
      CssToken(CssTokenType.selector, 'h1'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.openCurly, '{'),
      CssToken(CssTokenType.whitespace, '\r'),
      CssToken(CssTokenType.whitespace, '\n'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.propertyName, 'color'),
      CssToken(CssTokenType.colon, ':'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.discreteValue, 'red'),
      CssToken(CssTokenType.semicolon, ';'),
      CssToken(CssTokenType.whitespace, '\r'),
      CssToken(CssTokenType.whitespace, '\n'),
      CssToken(CssTokenType.closeCurly, '}'),
      CssToken(CssTokenType.whitespace, '\r'),
      CssToken(CssTokenType.whitespace, '\n'),
    ]);
  });

  test('Tokenize CSS with number', () {
    const css = 'h1 { line-height: 1; }';

    final tokens = const CssTokenizer().tokenize(css).toList(growable: false);

    expect(tokens, [
      CssToken(CssTokenType.selector, 'h1'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.openCurly, '{'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.propertyName, 'line-height'),
      CssToken(CssTokenType.colon, ':'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.number, '1'),
      CssToken(CssTokenType.semicolon, ';'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.closeCurly, '}'),
    ]);
  });

  test('Tokenize CSS with number and unit', () {
    const css = 'h1 { line-height: 1px; }';

    final tokens = const CssTokenizer().tokenize(css).toList(growable: false);

    expect(tokens, [
      CssToken(CssTokenType.selector, 'h1'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.openCurly, '{'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.propertyName, 'line-height'),
      CssToken(CssTokenType.colon, ':'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.number, '1'),
      CssToken(CssTokenType.unit, 'px'),
      CssToken(CssTokenType.semicolon, ';'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.closeCurly, '}'),
    ]);
  });

  test('Tokenize short hex color', () {
    const css = 'h1 { color: #fff; }';

    final tokens = const CssTokenizer().tokenize(css).toList(growable: false);

    expect(tokens, [
      CssToken(CssTokenType.selector, 'h1'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.openCurly, '{'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.propertyName, 'color'),
      CssToken(CssTokenType.colon, ':'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.hexColor, '#fff'),
      CssToken(CssTokenType.semicolon, ';'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.closeCurly, '}'),
    ]);
  });

  test('Tokenize long hex color', () {
    const css = 'h1 { color: #ffffff; }';

    final tokens = const CssTokenizer().tokenize(css).toList(growable: false);

    expect(tokens, [
      CssToken(CssTokenType.selector, 'h1'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.openCurly, '{'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.propertyName, 'color'),
      CssToken(CssTokenType.colon, ':'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.hexColor, '#ffffff'),
      CssToken(CssTokenType.semicolon, ';'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.closeCurly, '}'),
    ]);
  });

  test('Tokenize multiple selectors', () {
    const css = 'h1, h2 { color: red; }';

    final tokens = const CssTokenizer().tokenize(css).toList(growable: false);

    expect(tokens, [
      CssToken(CssTokenType.selector, 'h1'),
      CssToken(CssTokenType.comma, ','),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.selector, 'h2'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.openCurly, '{'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.propertyName, 'color'),
      CssToken(CssTokenType.colon, ':'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.discreteValue, 'red'),
      CssToken(CssTokenType.semicolon, ';'),
      CssToken(CssTokenType.whitespace, ' '),
      CssToken(CssTokenType.closeCurly, '}'),
    ]);
  });
}
