part of '../smith.dart';

class CommandHandler {
  final List<String> _queryHistory = [];
  int _historyOffset = 0;

  String get lastQuery =>
      _queryHistory.elementAt(_historyOffset);

  void register() {
    commandBus.on<ReloadCommand>().listen(_onReload);
    commandBus.on<NavigateCommand>().listen(_onNavigate);
    commandBus.on<BackCommand>().listen(_onBack);
    commandBus.on<ForwardCommand>().listen(_onForward);
  }

  void _onNavigate(NavigateCommand event) {
    _dispatchLoading(event.query);

    _queryHistory.insert(0, event.query);
    _historyOffset = 0;

    requestBus.fire(QueryRequest(
      query: event.query,
      fulfill: _onResponse,
      reject: _onRequestFailed,
    ));
  }

  void _onReload(ReloadCommand event) {
    if (_queryHistory.isEmpty) {
      return;
    }

    _dispatchLoading(lastQuery);

    requestBus.fire(QueryRequest(
      query: lastQuery,
      fulfill: _onResponse,
      reject: _onRequestFailed,
    ));
  }

  void _onBack(BackCommand event) {
    if (_historyOffset == _queryHistory.length) {
      return;
    }

    _historyOffset++;

    _dispatchLoading(lastQuery);

    requestBus.fire(QueryRequest(
      query: lastQuery,
      fulfill: _onResponse,
      reject: _onRequestFailed,
    ));
  }

  void _onForward(ForwardCommand event) {
    if (_historyOffset == 0) {
      return;
    }

    _historyOffset--;

    _dispatchLoading(lastQuery);

    requestBus.fire(QueryRequest(
      query: lastQuery,
      fulfill: _onResponse,
      reject: _onRequestFailed,
    ));
  }

  void _dispatchLoading([String? query]) {
    if (query != null) {
      uiBus.fire(UriChangedEvent(query));
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
      response: response,
      uri: uri,
    );

    uiBus.fire(DispatchBuilderEvent(information));
  }

  void _onRequestFailed(Object? error) {
    _onShowErrorPage(
      code: 'request-failed',
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
