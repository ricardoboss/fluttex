import 'package:css_parser/css_map.dart';
import 'package:css_parser/css_parser.dart';
import 'package:test/test.dart';

void main() {
  test('Parse simple CSS', () {
    const css = 'h1 { color: red; }';

    final map = const CssParser().parse(css);

    expect(map.entries.length, 1);
    expect(map.entries.first.selectors, ['h1']);
    expect(
      map.entries.first.properties['color'],
      CssDiscreteValue(value: 'red'),
    );
  });

  test('Parse normal CSS', () {
    const css = '''
body {
    background-color: #242424;
    padding: 10px;
    border-radius: 1em;
    gap: 50;
}
''';

    final map = const CssParser().parse(css);

    expect(map.entries.length, 1);
    expect(map.entries.first.selectors, ['body']);
    expect(
      map.entries.first.properties['background-color'],
      CssColor.hex('242424'),
    );
    expect(map.entries.first.properties['padding'], CssNumber.px(10));
    expect(map.entries.first.properties['border-radius'], CssNumber.em(1));
    expect(map.entries.first.properties['gap'], CssUnitlessNumber(value: 50));
  });
}
