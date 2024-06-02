import 'package:flutter/material.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/page_builder.dart';

class HtmlPageBuilder extends PageBuilder {
  HtmlPageBuilder({
    required this.uri,
    required this.head,
    required this.document,
    required this.controller,
  });

  factory HtmlPageBuilder.fromSource({
    required Uri uri,
    required HeadInformation headInformation,
    required String source,
    required BrowserController controller,
  }) {
    final document = parser.parse(source);

    return HtmlPageBuilder(
      uri: uri,
      head: headInformation,
      document: document,
      controller: controller,
    );
  }

  final Uri uri;
  final dom.Document document;
  final BrowserController controller;

  @override
  Widget buildPage(BuildContext context) {
    return SingleChildScrollView(
      child: Text(document.outerHtml),
    );
  }

  @override
  final HeadInformation head;
}
