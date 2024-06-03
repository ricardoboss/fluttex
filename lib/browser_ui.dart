import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';
import 'package:fluttex/page_builders/page_builder.dart';

class BrowserUi extends StatefulWidget {
  const BrowserUi({super.key});

  @override
  State<BrowserUi> createState() => _BrowserUiState();
}

class _BrowserUiState extends State<BrowserUi> {
  final _controller = BrowserController();
  final _uriController = TextEditingController();

  late PageBuilder _pageBuilder;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onBrowserChanged);
    _pageBuilder = _controller.getPageBuilder();
    _uriController.text = _pageBuilder.head.uri.toString();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.removeListener(_onBrowserChanged);
  }

  void _onBrowserChanged() {
    if (mounted) {
      setState(() {
        _pageBuilder = _controller.getPageBuilder();
        _uriController.text = _pageBuilder.head.uri.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pageBuilder.buildPage(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  _buildTab(context),
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
                        final uri = Uri.tryParse(value);
                        if (uri != null) {
                          _controller.navigateTo(uri: uri);
                        }
                      },
                      textInputAction: TextInputAction.go,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _controller.reload,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: page,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context) {
    final icon = _pageBuilder.head.iconBuilder(context);
    final title = _pageBuilder.head.title;

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
              child: icon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}
