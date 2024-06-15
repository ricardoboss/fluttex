import 'package:css_parser/css_map.dart';

typedef StyleRuleSet = Map<String, CssValue>;

class StyleContext {
  const StyleContext({
    StyleContext? parent,
    double? fontSize,
    CssMap? map,
  })  : _parent = parent,
        _fontSize = fontSize,
        _map = map;

  final StyleContext? _parent;

  final double? _fontSize;

  final CssMap? _map;

  StyleContext? get parent => _parent;

  double? get fontSize => _fontSize ?? _parent?.fontSize;

  CssMap? get map => _map ?? _parent?.map;

  StyleRuleSet select(List<String> selectors) {
    if (selectors.isEmpty) {
      return const {};
    }

    final mapsToConsider = <CssMap>[];
    StyleContext? current = this;
    while (current != null) {
      if (current.map != null) {
        mapsToConsider.add(current.map!);
      }

      current = current.parent;
    }

    if (mapsToConsider.isEmpty) {
      return const {};
    }

    final appliedProperties = <String, CssValue>{};
    for (final selector in selectors) {
      for (final map in mapsToConsider) {
        final entries = map.entries
            .where((e) => e.selectors.contains(selector))
            .toList(growable: false);

        if (entries.isNotEmpty) {
          entries.map((e) => e.properties).forEach(appliedProperties.addAll);

          break;
        }
      }
    }

    return appliedProperties;
  }
}
