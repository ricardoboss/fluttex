import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';
import 'package:html/dom.dart' as dom;

class HtmlPageBuilder extends PageBuilder {
  HtmlPageBuilder({
    required this.uri,
    required this.head,
    required this.document,
    required this.controller,
  });

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
