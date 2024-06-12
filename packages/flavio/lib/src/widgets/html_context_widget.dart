part of '../../flavio.dart';

class HtmlContextWidget extends InheritedWidget {
  HtmlContextWidget({
    required super.child,
    required this.context,
    super.key,
  });

  final HtmlContext context;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is! HtmlContextWidget || oldWidget.context != context;
  }
}
