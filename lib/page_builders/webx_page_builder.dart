import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';
import 'package:html_parser/html_document.dart';
import 'package:html_parser/html_element.dart';
import 'package:html_parser/html_node.dart';
import 'package:html_parser/html_text.dart';

class WebXPageBuilder extends PageBuilder {
  WebXPageBuilder({
    required this.requestedUri,
    required this.resolvedUri,
    required this.head,
    required this.document,
    required this.source,
    required this.controller,
  });

  final Uri requestedUri;
  final Uri resolvedUri;
  final HtmlDocument document;
  final String source;
  final BrowserController controller;

  @override
  final HeadInformation head;

  @override
  Widget buildPage(BuildContext context) {
    final body = document.findFirstElement((n) => n.tagName == 'body')!;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: _buildElement(context, body, 0),
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

  Widget _buildNode(BuildContext context, HtmlNode element, int level) {
    return switch (element) {
      HtmlText text => Text(text.text),
      HtmlElement element => _buildElement(context, element, level),
      _ => const Text('Unknown node'),
    };
  }

  Widget _buildElement(BuildContext context, HtmlElement element, int level) {
    switch (element.tagName) {
      case 'body':
      case 'div':
      case 'html':
      case 'p':
        return _buildNested(context, element, level);
      case 'button':
        return _buildButton(context, element);
      case 'input':
        return _buildInput(context, element);
      case 'head':
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

  Widget _buildNested(BuildContext context, HtmlElement element, int level) {
    // TODO get class and check style

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var child in element.children)
          _buildNode(context, child, level + 1),
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

  Widget _buildButton(BuildContext context, HtmlElement element) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(element.text),
    );
  }

  Widget _buildInput(BuildContext context, HtmlElement element) {
    return TextField(
      decoration: InputDecoration(
        labelText: element.attributes['placeholder'],
      ),
    );
  }
}
