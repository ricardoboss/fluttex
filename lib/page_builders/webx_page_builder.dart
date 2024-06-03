import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';
import 'package:html_parser/html_document.dart';
import 'package:html_parser/html_element.dart';
import 'package:html_parser/html_node.dart';
import 'package:html_parser/html_renderer.dart';
import 'package:html_parser/html_text.dart';

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
  final HtmlDocument document;
  final BrowserController controller;

  @override
  final HeadInformation head;

  @override
  Widget buildPage(BuildContext context) {
    final source = const HtmlRenderer().render(document);

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              for (var child in document.nodes) _buildNode(context, child),
            ],
          ),
        ),
        const Divider(),
        Container(
          height: 400,
          color: Colors.black,
          child: SingleChildScrollView(
            child: Text(source),
          ),
        ),
      ],
    );
  }

  Widget _buildNode(BuildContext context, HtmlNode element) {
    switch (element) {
      case HtmlText text:
        return Text(text.text);
      case HtmlElement element:
        return _buildElement(context, element);
      default:
        return const Text('Unknown node');
    }
  }

  Widget _buildElement(BuildContext context, HtmlElement element) {
    switch (element.tagName) {
      case 'head':
      case 'body':
      case 'div':
      case 'html':
        return _buildNested(context, element);
      case 'title':
      case 'link':
      case 'meta':
      case 'script':
        return const SizedBox.shrink();
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        return _buildHeading(context, element);
      default:
        return Text(element.text);
    }
  }

  Widget _buildNested(BuildContext context, HtmlElement element) {
    // TODO get class and check style

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var child in element.children) _buildNode(context, child),
      ],
    );
  }

  Widget _buildHeading(BuildContext context, HtmlElement element) {
    final double fontSize = switch (element.tagName) {
      'h1' => 30,
      'h2' => 26,
      'h3' => 22,
      'h4' => 20,
      'h5' => 18,
      'h6' => 16,
      _ => 1,
    };

    return Text(
      element.text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
