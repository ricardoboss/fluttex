import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/webx_page_builder.dart';
import 'package:fluttex/response_processors/response_processor.dart';
import 'package:html_parser/html_document.dart';
import 'package:html_parser/html_parser.dart';

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
    final document = HtmlParser().parse(response.body);

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

  String? getTitle(HtmlDocument document) {
    final titleElement = document.findFirstElement((n) => n.tagName == 'title');
    if (titleElement == null) {
      return null;
    }

    return titleElement.text;
  }

  Uri? getIconUri(HtmlDocument document, Uri baseUri) {
    final linkElement = document.findFirstElement(
      (n) => n.tagName == 'link' && n.attributes['href'] != null,
    );
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
