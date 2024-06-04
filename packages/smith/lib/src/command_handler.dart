part of '../smith.dart';

class CommandHandler {
  _CurrentPage? _currentPage;

  void register() {
    commandBus.on<ReloadCommand>().listen(_onReload);
    commandBus.on<NavigateCommand>().listen(_onNavigate);
  }

  void _onNavigate(NavigateCommand event) {
    _dispatchLoading();

    requestBus.fire(ResolveUrlRequest(
      query: event.query,
      fulfill: _onUrlResolved,
      reject: _onResolveFailed,
    ));
  }

  void _onReload(ReloadCommand event) {
    if (_currentPage == null) {
      return;
    }

    _dispatchLoading();

    requestBus.fire(ResolveUrlRequest(
      query: _currentPage!.uri.toString(),
      fulfill: _onUrlResolved,
      reject: _onResolveFailed,
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

  Future<void> _onUrlResolved(Uri uri) async {
    final information = PlaceholderPageInformation(uri: uri);

    uiBus.fire(DispatchBuilderEvent(information));
  }

  void _onResolveFailed(Object? error) {
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

    uiBus.fire(DispatchBuilderEvent(information));
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
