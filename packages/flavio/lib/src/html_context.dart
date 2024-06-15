part of '../flavio.dart';

class HtmlContext {
  HtmlContext({
    required this.document,
    required this.response,
    required this.styleController,
  });

  static HtmlContext of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<HtmlContextWidget>()!.context;
  }

  final HtmlDocument document;
  final http.BaseResponse? response;
  final StyleController styleController;
}
