part of '../../flavio.dart';

StyleRuleSet _resolveStyle(BuildContext context, HtmlElement element) {
  final tagName = element.tagName;
  final classes = element.attributes['class']?.split(' ') ?? [];

  final htmlContext = HtmlContext.of(context);
  final style = htmlContext.styleController.context;

  return style.select([tagName, ...classes]);
}

mixin StyleResolver {
  StyleRuleSet resolveStyle(
    BuildContext context,
    HtmlElement element,
  ) =>
      _resolveStyle(context, element);
}

mixin StatefulStyleResolver {
  BuildContext get context;

  StyleRuleSet resolveStyle(HtmlElement element) =>
      _resolveStyle(context, element);
}
