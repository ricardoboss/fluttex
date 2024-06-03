import 'package:css_parser/style_context.dart';

class CssMap {
  const CssMap({
    this.entries = const [],
  });

  final List<CssMapEntry> entries;

  CssMapEntry? operator [](String selector) => entries.firstWhere(
        (e) => e.selectors.contains(selector),
      );
}

class CssMapEntry {
  CssMapEntry({
    required this.selectors,
    required this.properties,
  });

  final List<String> selectors;
  final Map<String, CssValue> properties;

  @override
  String toString() {
    final buffer = StringBuffer();

    buffer.write(selectors.join(', '));
    buffer.writeln(' {');

    for (final property in properties.entries) {
      buffer.writeln('${property.key}: ${property.value.text};');
    }

    buffer.writeln('}');

    return buffer.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssMapEntry &&
          runtimeType == other.runtimeType &&
          selectors == other.selectors &&
          properties == other.properties;

  @override
  int get hashCode => selectors.hashCode ^ properties.hashCode;
}

abstract class CssValue {
  String get text;

  @override
  String toString() => text;
}

class CssUnitlessNumber extends CssValue {
  CssUnitlessNumber({
    required this.value,
  });

  final num value;

  @override
  String get text => value.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssUnitlessNumber &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class CssNumber extends CssValue {
  CssNumber({
    required this.value,
    required this.unit,
  });

  factory CssNumber.px(num value) => CssNumber(
        value: value,
        unit: const PxUnit(),
      );

  factory CssNumber.em(num value) => CssNumber(
        value: value,
        unit: const EmUnit(),
      );

  final num value;
  final CssUnit unit;

  @override
  String get text => '$value${unit.text}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssNumber &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          unit == other.unit;

  @override
  int get hashCode => value.hashCode ^ unit.hashCode;
}

abstract class CssUnit {
  const CssUnit();

  num resolve(StyleContext context, num value);

  String get text;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssUnit &&
          runtimeType == other.runtimeType &&
          text == other.text;

  @override
  int get hashCode => text.hashCode;
}

class PxUnit extends CssUnit {
  const PxUnit();

  @override
  num resolve(StyleContext context, num value) => value;

  @override
  String get text => 'px';
}

class EmUnit extends CssUnit {
  const EmUnit();

  static const defaultFontSize = 16.0;

  @override
  num resolve(StyleContext context, num value) =>
      (context.fontSize ?? defaultFontSize) * value;

  @override
  String get text => 'em';
}

class CssColor extends CssValue {
  CssColor({
    required this.color,
    required this.format,
  });

  factory CssColor.hex(String hex) {
    final actualValue = hex.startsWith('#') ? hex.substring(1) : hex;

    return CssColor(
      color: int.parse(actualValue, radix: 16),
      format: CssColorFormat.hex,
    );
  }

  final int color;
  final CssColorFormat format;

  @override
  String get text => switch (format) {
        CssColorFormat.hex => '#${color.toRadixString(16).padLeft(6, '0')}',
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssColor &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          format == other.format;

  @override
  int get hashCode => color.hashCode ^ format.hashCode;
}

enum CssColorFormat {
  hex,
}

class CssDiscreteValue extends CssValue {
  CssDiscreteValue({
    required this.value,
  });

  final String value;

  @override
  String get text => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssDiscreteValue &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
