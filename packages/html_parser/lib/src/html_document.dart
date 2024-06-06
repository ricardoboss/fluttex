part of '../html_parser.dart';

class HtmlDocument {
  HtmlDocument({
    required this.nodes,
  });

  final Iterable<HtmlNode> nodes;

  String get text => nodes.map((n) => n.text).join();

  T? findFirst<T extends HtmlNode>(bool Function(T node) test) {
    final nodes = Queue()..addAll(this.nodes);

    while (nodes.isNotEmpty) {
      final node = nodes.removeFirst();
      if (node is T && test(node)) {
        return node;
      }

      if (node is HtmlElement) {
        nodes.addAll(node.children);
      }
    }

    return null;
  }

  Iterable<T> findAll<T extends HtmlNode>(bool Function(T node) test) sync* {
    final nodes = Queue()..addAll(this.nodes);

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

  Iterable<HtmlElement> findAllElements(
    bool Function(HtmlElement element) test,
  ) sync* {
    yield* findAll<HtmlElement>(test);
  }
}