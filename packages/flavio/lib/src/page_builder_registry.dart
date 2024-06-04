part of '../flavio.dart';

class PageBuilderRegistry {
  const PageBuilderRegistry._();

  static void register() {
    uiBus.on<DispatchBuilderEvent>().listen(_onDispatchBuilder);
  }

  static Future<void> _onDispatchBuilder(DispatchBuilderEvent event) async {
    final information = event.information;

    final builder = await _getBuilder(information);

    uiBus.fire(RenderPageEvent(builder));
  }

  static Future<PageBuilder> _getBuilder(PageInformation information) async {
    switch (information) {
      case final ErrorPageInformation error:
        return ErrorPageBuilder(information: error);
      case final PlaceholderPageInformation placeholder:
        return PlaceholderPageBuilder(information: placeholder);
      default:
        return ErrorPageBuilder(
          information: ErrorPageInformation(
            code: 'unimplemented_page_information',
            error: null,
          ),
        );
    }
  }
}
