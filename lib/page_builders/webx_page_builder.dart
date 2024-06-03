import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/head_information.dart';
import 'package:fluttex/page_builders/page_builder.dart';
import 'package:fluttex/widgets/webx_page.dart';
import 'package:html_parser/html_document.dart';

class WebXPageBuilder extends PageBuilder {
  WebXPageBuilder({
    required this.requestedUri,
    required this.resolvedUri,
    required this.head,
    required this.document,
    required this.source,
    required this.browser,
  });

  final Uri requestedUri;
  final Uri resolvedUri;
  final HtmlDocument document;
  final String source;
  final BrowserController browser;

  @override
  final HeadInformation head;

  @override
  Widget buildPage(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: WebXPage(
            document: document,
            browser: browser,
            requestedUri: requestedUri,
            resolvedUri: resolvedUri,
          ),
        ),
        const Divider(),
        Container(
          height: 400,
          color: Theme.of(context).colorScheme.inverseSurface,
          child: DefaultTextStyle(
            style: TextStyle(
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Text(source),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
