import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/html_page_builder.dart';
import 'package:fluttex/response_processors/response_processor.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HtmlResponseProcessor extends ResponseProcessor {
  const HtmlResponseProcessor({
    required super.response,
    required this.controller,
  });

  final BrowserController controller;

  @override
  Future<HtmlPageBuilder> process() async {
    final document = parser.parse(response.body);

    final baseUri = response.request!.url;
    final title = getTitle(document);
    final iconUri = getIconUri(document, baseUri);

    return HtmlPageBuilder(
      uri: baseUri,
      head: HeadInformation(
        title: title ?? 'Untitled',
        iconBuilder: (context) => iconUri != null
            ? Image.network(iconUri.toString())
            : const Icon(Icons.text_snippet_outlined),
        uri: response.request!.url,
      ),
      document: document,
      controller: controller,
    );
  }

  String? getTitle(dom.Document document) {
    final titleElement = document.head!.querySelector('title');
    if (titleElement == null) {
      return null;
    }

    return titleElement.text;
  }

  Uri? getIconUri(dom.Document document, Uri baseUri) {
    final linkElement = document.head!.querySelector('link[rel="icon"]');
    if (linkElement == null) {
      return null;
    }

    final href = linkElement.attributes['href'];
    if (href == null) {
      return null;
    }

    return baseUri.resolve(href);
  }
}
