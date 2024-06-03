import 'dart:async';

import 'package:css_parser/css_map.dart';
import 'package:css_parser/css_parser.dart';
import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/style/style_controller.dart';
import 'package:html_parser/html_document.dart';
import 'package:html_parser/html_element.dart';
import 'package:html_parser/html_node.dart';
import 'package:html_parser/html_text.dart';

class WebXPage extends StatefulWidget {
  const WebXPage({
    required this.document,
    required this.browser,
    required this.requestedUri,
    required this.resolvedUri,
    super.key,
  });

  final Uri requestedUri;
  final Uri resolvedUri;
  final HtmlDocument document;
  final BrowserController browser;

  @override
  State<WebXPage> createState() => _WebXPageState();
}

class _WebXPageState extends State<WebXPage> {
  late final HtmlElement body;

  final StyleController _styleController = StyleController();

  @override
  void initState() {
    super.initState();

    body = widget.document.findFirstElement((n) => n.tagName == 'body')!;

    _styleController.addListener(_onStyleChanged);

    unawaited(_loadStyleSheets());
  }

  @override
  void dispose() {
    _styleController.removeListener(_onStyleChanged);

    super.dispose();
  }

  void _onStyleChanged() {
    setState(() {});
  }

  Future<void> _loadStyleSheets() async {
    final styleSheetUris = widget.document
        .findAllElements(
          (n) =>
              n.tagName == 'link' &&
              n.attributes['href'] != null &&
              n.attributes['href']!.endsWith('.css'),
        )
        .map((n) => widget.requestedUri.resolve(n.attributes['href']!));

    for (final styleSheetUri in styleSheetUris) {
      final response = await widget.browser.getBussResponse(uri: styleSheetUri);
      final css = response.body;
      final map = const CssParser().parse(css);

      _styleController.addMap(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _buildElement(context, body, 0),
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
      case 'div':
        return _buildDiv(context, element, level);
      case 'body':
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

  Map<String, CssValue> _resolveStyle(HtmlElement element) {
    final tagName = element.tagName;
    final classes = element.attributes['class']?.split(' ') ?? [];

    return _styleController.context.select([tagName, ...classes]);
  }

  Widget _buildNested(BuildContext context, HtmlElement element, int level) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var child in element.children)
          _buildNode(context, child, level + 1),
      ],
    );
  }

  Widget _buildDiv(BuildContext context, HtmlElement element, int level) {
    final map = _resolveStyle(element);
    final direction = map['direction']?.text;

    final column = direction == null || direction == 'column';

    return Flex(
      direction: column ? Axis.vertical : Axis.horizontal,
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
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 250,
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: element.attributes['placeholder'],
        ),
      ),
    );
  }
}
