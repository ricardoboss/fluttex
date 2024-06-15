part of '../flavio.dart';

class StyleController with ChangeNotifier {
  StyleController();

  static const StyleContext defaultContext = StyleContext(
    fontSize: 16,
  );

  StyleContext _context = defaultContext;

  StyleContext get context => _context;

  void setContext(StyleContext context) {
    _context = context;

    notifyListeners();
  }

  void addMap(CssMap map) {
    final newContext = StyleContext(parent: _context, map: map);

    setContext(newContext);
  }

  void resetContext() {
    setContext(defaultContext);
  }
}
