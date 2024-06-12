import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/material.dart';

class BrowserUi extends StatefulWidget {
  const BrowserUi({super.key});

  @override
  State<BrowserUi> createState() => _BrowserUiState();
}

class _BrowserUiState extends State<BrowserUi> {
  late final StreamSubscription<UriChangedEvent> _uriChangedSubscription;
  late final StreamSubscription<TitleChangedEvent> _titleChangedSubscription;
  late final StreamSubscription<FaviconChangedEvent>
      _faviconChangedSubscription;
  late final StreamSubscription<RenderPageEvent> _renderPageSubscription;

  final _uriController = TextEditingController();

  String? _title;
  Widget Function(BuildContext context)? _faviconBuilder;
  Key? _pageKey;
  PageBuilder? _pageBuilder;

  @override
  void initState() {
    super.initState();

    _uriChangedSubscription = uiBus.on<UriChangedEvent>().listen(_onUriChanged);
    _titleChangedSubscription =
        uiBus.on<TitleChangedEvent>().listen(_onTitleChanged);
    _faviconChangedSubscription =
        uiBus.on<FaviconChangedEvent>().listen(_onFaviconChanged);
    _renderPageSubscription = uiBus.on<RenderPageEvent>().listen(_onRenderPage);
  }

  @override
  void dispose() {
    _uriChangedSubscription.cancel();
    _titleChangedSubscription.cancel();
    _faviconChangedSubscription.cancel();
    _renderPageSubscription.cancel();

    super.dispose();
  }

  void _onUriChanged(UriChangedEvent event) {
    setState(() {
      _uriController.text = event.uri;
    });
  }

  void _onTitleChanged(TitleChangedEvent event) {
    setState(() {
      _title = event.title;
    });
  }

  void _onFaviconChanged(FaviconChangedEvent event) {
    setState(() {
      _faviconBuilder = event.faviconBuilder;
    });
  }

  void _onRenderPage(RenderPageEvent event) {
    setState(() {
      _pageKey = UniqueKey();
      _pageBuilder = event.builder;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    _buildTab(context),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => commandBus.fire(const BackCommand()),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => commandBus.fire(const ForwardCommand()),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _uriController,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          commandBus.fire(NavigateCommand(value));
                        },
                        textInputAction: TextInputAction.go,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => commandBus.fire(const ReloadCommand()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Builder(
                    key: _pageKey,
                    builder: (c) {
                      if (_pageBuilder != null) {
                        return _pageBuilder!.buildPage(c);
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _faviconBuilder != null
                  ? _faviconBuilder!(context)
                  : const SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
            child: Text(
              _title ?? 'Untitled',
            ),
          ),
        ],
      ),
    );
  }
}
