import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';
import 'package:html/dom.dart' as dom;

class WebXPageBuilder extends PageBuilder {
  WebXPageBuilder({
    required this.requestedUri,
    required this.resolvedUri,
    required this.head,
    required this.document,
    required this.controller,
  });

  final Uri requestedUri;
  final Uri resolvedUri;
  final dom.Document document;
  final BrowserController controller;

  @override
  final HeadInformation head;

  @override
  Widget buildPage(BuildContext context) {
    return Column(
      children: [
        for (var child in document.children)
          _buildElement(context, child),
      ],
    );
  }

  Widget _buildElement(BuildContext context, dom.Element element) {
    switch (element.localName) {
      case 'head':
        return const SizedBox.shrink();
      case 'body':
        return _buildBodyElement(context, element);
      case 'div':
        return _buildDivElement(context, element);
      default:
        return Text(element.outerHtml);
    }
  }

  Widget _buildBodyElement(BuildContext context, dom.Element element) {
    return ListView(
      children: [
        for (var child in element.children)
          _buildElement(context, child),
      ],
    );
  }

  Widget _buildDivElement(BuildContext context, dom.Element element) {
    // TODO get class and check style

    return Column(
      children: [
        for (var child in element.children)
          _buildElement(context, child),
      ],
    );
  }
}
