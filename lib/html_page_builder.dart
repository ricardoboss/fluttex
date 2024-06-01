import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builder.dart';

class HtmlPageBuilder extends PageBuilder {
  HtmlPageBuilder({
    required this.uri,
    required this.document,
    required this.controller,
  });

  factory HtmlPageBuilder.fromSource({
    required Uri uri,
    required String source,
    required BrowserController controller,
  }) {
    final document = parser.parse(source);

    return HtmlPageBuilder(
      uri: uri,
      document: document,
      controller: controller,
    );
  }

  final Uri uri;
  final dom.Document document;
  final BrowserController controller;

  @override
  Widget buildIcon(BuildContext context) {
    return const Icon(Icons.code);
  }

  @override
  Widget buildPage(BuildContext context) {
    return SingleChildScrollView(
      child: Text(document.outerHtml),
    );
  }

  @override
  String getTitle() {
    final titleElement =
        document.head?.children.cast<dom.Element?>().firstWhere(
              (element) => element!.localName == 'title',
              orElse: () => null,
            );

    return titleElement?.text ?? 'Untitled';
  }

  @override
  Uri getUri() => uri;
}
