import 'package:css_parser/css_map.dart';
import 'package:css_parser/style_context.dart';
import 'package:flutter/foundation.dart';

class StyleController with ChangeNotifier {
  StyleController();

  StyleContext _context = const StyleContext(
    fontSize: 16,
  );

  StyleContext get context => _context;

  void setContext(StyleContext context) {
    _context = context;

    notifyListeners();
  }

  void addMap(CssMap map) {
    final newContext = StyleContext(parent: _context, map: map);

    setContext(newContext);
  }
}
