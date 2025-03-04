import 'package:html_parser/html_parser.dart';
import 'package:test/test.dart';

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

  test('Tokenize standalone attribute', () {
    const html = '<button disabled>Click</button>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'button'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'disabled'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.text, 'Click'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'button'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });

  test('Tokenize standalone attribute with other attributes', () {
    const html = '<button disabled type="submit">Click</button>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'button'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'disabled'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'type'),
      HtmlToken(HtmlTokenType.attributeValue, 'submit'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.text, 'Click'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'button'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });

  test('Tokenize attributes on multiple lines', () {
    const html = '<button\n  disabled\n  type="submit">Click</button>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'button'),
      HtmlToken(HtmlTokenType.whitespace, '\n'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'disabled'),
      HtmlToken(HtmlTokenType.whitespace, '\n'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'type'),
      HtmlToken(HtmlTokenType.attributeValue, 'submit'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.text, 'Click'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'button'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });

  test('Tokenize attributes without quotes', () {
    const html = '<a class=gb1 href="https://www.google.com/imghp?hl=de&tab=wi">Bilder</a>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'a'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'class'),
      HtmlToken(HtmlTokenType.attributeValue, 'gb1'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'href'),
      HtmlToken(HtmlTokenType.attributeValue, 'https://www.google.com/imghp?hl=de&tab=wi'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.text, 'Bilder'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'a'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });

  test('Tokenize with script islands', () {
    const html = '<script type="text/javascript">alert("Hello");</script>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'script'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'type'),
      HtmlToken(HtmlTokenType.attributeValue, 'text/javascript'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.script, 'alert("Hello");'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'script'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });

  test('Tokenize with script and escaped HTML', () {
    const html = '<script type="text/javascript">alert("</script>");</script>';

    final tokens = HtmlTokenizer().tokenize(html).toList(growable: false);

    expect(tokens, [
      HtmlToken(HtmlTokenType.tagOpen, '<'),
      HtmlToken(HtmlTokenType.tagName, 'script'),
      HtmlToken(HtmlTokenType.whitespace, ' '),
      HtmlToken(HtmlTokenType.attributeName, 'type'),
      HtmlToken(HtmlTokenType.attributeValue, 'text/javascript'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
      HtmlToken(HtmlTokenType.script, 'alert("</script>");'),
      HtmlToken(HtmlTokenType.tagEndingOpen, '</'),
      HtmlToken(HtmlTokenType.tagName, 'script'),
      HtmlToken(HtmlTokenType.tagClose, '>'),
    ]);
  });
}
