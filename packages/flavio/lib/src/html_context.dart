part of '../flavio.dart';

class HtmlContext {
  HtmlContext({
    required this.document,
    required this.response,
  });

  static HtmlContext of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<HtmlContextWidget>()!.context;
  }

  final HtmlDocument document;
  final http.BaseResponse? response;
}
