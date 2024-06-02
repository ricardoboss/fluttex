import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/webx_page_builder.dart';
import 'package:fluttex/response_processors/response_processor.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class WebXResponseProcessor extends ResponseProcessor {
  const WebXResponseProcessor({
    required super.response,
    required this.controller,
    required this.requestedUri,
  });

  final BrowserController controller;
  final Uri requestedUri;

  @override
  Future<WebXPageBuilder> process() async {
    final document = parser.parse(response.body);

    final baseUri = response.request!.url;
    final title = getTitle(document);
    final iconUri = getIconUri(document, baseUri);

    return WebXPageBuilder(
      requestedUri: requestedUri,
      resolvedUri: baseUri,
      head: HeadInformation(
        title: title ?? 'Untitled',
        iconBuilder: (context) => iconUri != null
            ? Image.network(iconUri.toString())
            : const Icon(Icons.text_snippet_outlined),
        uri: requestedUri,
      ),
      document: document,
      controller: controller,
    );
  }

  String? getTitle(dom.Document document) {
    final titleElement = document.querySelector('title');
    if (titleElement == null) {
      return null;
    }

    return titleElement.text;
  }

  Uri? getIconUri(dom.Document document, Uri baseUri) {
    final linkElement = document.querySelector('link[href]');
    if (linkElement == null) {
      return null;
    }

    final href = linkElement.attributes['href'];
    if (href == null) {
      return null;
    }

    if (href.startsWith('/')) {
      return baseUri.resolve(href);
    }

    return Uri.parse(href);
  }
}
