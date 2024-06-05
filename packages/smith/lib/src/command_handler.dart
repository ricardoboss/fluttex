part of '../smith.dart';

class CommandHandler {
  String? _lastQuery;

  void register() {
    commandBus.on<ReloadCommand>().listen(_onReload);
    commandBus.on<NavigateCommand>().listen(_onNavigate);
  }

  void _onNavigate(NavigateCommand event) {
    _dispatchLoading();

    _lastQuery = event.query;

    requestBus.fire(QueryRequest(
      query: event.query,
      fulfill: _onResponse,
      reject: _onRequestFailed,
    ));
  }

  void _onReload(ReloadCommand event) {
    if (_lastQuery == null) {
      return;
    }

    _dispatchLoading();

    requestBus.fire(QueryRequest(
      query: _lastQuery!,
      fulfill: _onResponse,
      reject: _onRequestFailed,
    ));
  }

  void _dispatchLoading({
    Uri? uri,
  }) {
    if (uri != null) {
      uiBus.fire(UriChangedEvent(uri));
    }

    uiBus.fire(TitleChangedEvent('Loading...'));
    uiBus.fire(FaviconChangedEvent(_buildLoadingFavicon));
  }

  Widget _buildLoadingFavicon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: const CircularProgressIndicator(),
    );
  }

  Future<void> _onResponse(http.BaseResponse response) async {
    final uri = response.request!.url;

    final information = HttpResponsePageInformation(
      // TODO: only override content-type for text/plain from raw.githubusercontent.com
      response: response..headers['content-type'] = 'text/html',
      uri: uri,
    );

    uiBus.fire(DispatchBuilderEvent(information));
  }

  void _onRequestFailed(Object? error) {
    _onShowErrorPage(
      code: 'resolve-failed',
      error: error,
    );
  }

  void _onShowErrorPage({
    required String code,
    required Object? error,
    Uri? uri,
  }) {
    final information = ErrorPageInformation(
      code: code,
      error: error,
      uri: uri,
    );

    uiBus.fire(TitleChangedEvent('Error'));
    uiBus.fire(FaviconChangedEvent(_buildErrorFavicon));
    uiBus.fire(DispatchBuilderEvent(information));
  }

  Widget _buildErrorFavicon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: const Icon(Icons.error),
    );
  }
}

class _CurrentPage {
  _CurrentPage({required this.uri});

  final Uri uri;
}

class ErrorPageInformation extends PageInformation {
  ErrorPageInformation({
    required this.code,
    required this.error,
    this.uri,
  });

  final Uri? uri;
  final String code;
  final Object? error;
}

class PlaceholderPageInformation extends PageInformation {
  PlaceholderPageInformation({
    required this.uri,
  });

  final Uri uri;
}

class HttpResponsePageInformation extends PageInformation {
  HttpResponsePageInformation({
    required this.response,
    required this.uri,
  });

  final http.BaseResponse response;
  final Uri uri;
}
