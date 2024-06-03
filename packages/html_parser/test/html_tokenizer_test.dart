import 'package:test/test.dart';
import 'package:html_parser/html_token.dart';
import 'package:html_parser/html_token_type.dart';
import 'package:html_parser/html_tokenizer.dart';

void main() {
  test('Tokenize empty string', () {
    const html = '';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.text, ''),
    ]);
  });

  test('Tokenize self closing tag', () {
    const html = '<br/>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'br'),
      HtmlToken(HtmlTokenType.tagEndingClose, '/>'),
    ]);
  });

  test('Tokenize simple partial HTML', () {
    const html = '<h1>Hello</h1>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.text, 'Hello'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });

  test('Tokenize nested tags', () {
    const html = '<h1>Hello <b>World</b></h1>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.text, 'Hello '),
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'b'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.text, 'World'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'b'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });

  test('Tokenize tags with attributes', () {
    const html = '<h1 class="title"></h1>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'class'),
      HtmlToken(HtmlTokenType.attributeValue, 'title'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });

  test('Tokenize with line breaks in text', () {
    const html = '<h1>Hello\nWorld</h1>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.text, 'Hello\nWorld'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });

  test('Tokenize with line break in tag', () {
    const html = '<h1\r\n>Hello</h1>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.whitespace, '\r'),
      HtmlToken(HtmlTokenType.whitespace, '\n'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.text, 'Hello'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'h1'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });
}
