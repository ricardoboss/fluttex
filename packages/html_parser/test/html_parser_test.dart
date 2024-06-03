import 'package:html_parser/html_element.dart';
import 'package:html_parser/html_node_type.dart';
import 'package:html_parser/html_parser.dart';
import 'package:html_parser/html_text.dart';
import 'package:html_parser/html_tokenizer.dart';
import 'package:test/test.dart';

void main() {
  test('Parse simple partial HTML', () {
    const html = '<h1>Hello</h1>';

    final tokens = HtmlTokenizer().tokenize(html);
    final nodes = HtmlParser().parseTokens(tokens).toList(growable: false);

    expect(nodes.first.type, HtmlNodeType.element);

    final h1 = nodes.first as HtmlElement;
    expect(h1.tagName, "h1");
    expect(h1.children.length, 1);
    expect(h1.children.first.type, HtmlNodeType.text);

    final text = h1.children.first as HtmlText;
    expect(text.text, "Hello");
  });

  test('Parse tag with attributes', () {
    const html = '<h1 class="title">Hello</h1>';

    final tokens = HtmlTokenizer().tokenize(html);
    final nodes = HtmlParser().parseTokens(tokens).toList(growable: false);

    expect(nodes.first.type, HtmlNodeType.element);

    final h1 = nodes.first as HtmlElement;
    expect(h1.tagName, "h1");
    expect(h1.attributes['class'], 'title');
    expect(h1.children.length, 1);
    expect(h1.children.first.type, HtmlNodeType.text);

    final text = h1.children.first as HtmlText;
    expect(text.text, "Hello");
  });

  test('Parse tag with self closing attributes', () {
    const html = '<h1 class="title" />';

    final tokens = HtmlTokenizer().tokenize(html);
    final nodes = HtmlParser().parseTokens(tokens).toList(growable: false);

    expect(nodes.first.type, HtmlNodeType.element);

    final h1 = nodes.first as HtmlElement;
    expect(h1.tagName, "h1");
    expect(h1.attributes['class'], 'title');
    expect(h1.children.length, 0);
  });

  test('Parse tag with self closing tag', () {
    const html = '<br />';

    final tokens = HtmlTokenizer().tokenize(html);
    final nodes = HtmlParser().parseTokens(tokens).toList(growable: false);

    expect(nodes.first.type, HtmlNodeType.element);

    final br = nodes.first as HtmlElement;
    expect(br.tagName, "br");
    expect(br.attributes, {});
    expect(br.children.length, 0);
  });
}
