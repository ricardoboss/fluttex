part of '../html_parser.dart';

class HtmlElement extends HtmlNode {
  HtmlElement({
    required this.tagName,
    this.attributes = const {},
    this.children = const [],
    super.parent,
  }) : super(type: HtmlNodeType.element);

  final String tagName;
  final List<HtmlNode> children;
  final Map<String, String> attributes;

  @override
  String toString() {
    return 'HtmlElement(tagName: $tagName, attributes: $attributes, children: [${children.length} items])';
  }

  @override
  HtmlNode withParent(HtmlNode? parent) {
    return HtmlElement(
      tagName: tagName,
      attributes: attributes,
      children: children,
      parent: parent,
    );
  }

  @override
  String get text => children.map((n) => n.text).join();

  String? get className => attributes['class'];

  T? findFirst<T extends HtmlNode>([bool Function(T node)? test]) {
    final nodes = Queue()..addAll(children);

    while (nodes.isNotEmpty) {
      final node = nodes.removeFirst();
      if (node is T && (test?.call(node) ?? true)) {
        return node;
      }

      if (node is HtmlElement) {
        nodes.addAll(node.children);
      }
    }

    return null;
  }

  Iterable<T> findAll<T extends HtmlNode>(bool Function(T node) test) sync* {
    final nodes = Queue()..addAll(children);

    while (nodes.isNotEmpty) {
      final node = nodes.removeFirst();
      if (node is T && test(node)) {
        yield node;
      }

      if (node is HtmlElement) {
        nodes.addAll(node.children);
      }
    }
  }

  HtmlElement? findFirstElement(bool Function(HtmlElement element) test) {
    final element = findFirst(test);
    if (element is HtmlElement) {
      return element;
    }

    return null;
  }

  HtmlElement? findFirstTag(
    String tagName, [
    bool Function(HtmlElement element)? test,
  ]) {
    return findFirstElement(
      (n) => n.tagName == tagName && (test?.call(n) ?? true),
    );
  }

  Iterable<HtmlElement> findAllTags(
    String tagName, [
    bool Function(HtmlElement element)? test,
  ]) sync* {
    yield* findAll<HtmlElement>(
      (n) => n.tagName == tagName && (test?.call(n) ?? true),
    );
  }

  Iterable<HtmlElement> findAllElements(
    bool Function(HtmlElement element) test,
  ) sync* {
    yield* findAll<HtmlElement>(test);
  }
}
