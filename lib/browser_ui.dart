import 'package:flutter/material.dart';
import 'package:fluttex/browser_controller.dart';

class BrowserUi extends StatefulWidget {
  const BrowserUi({super.key});

  @override
  State<BrowserUi> createState() => _BrowserUiState();
}

class _BrowserUiState extends State<BrowserUi> {
  final _controller = BrowserController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onBrowserChanged);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.removeListener(_onBrowserChanged);
  }

  void _onBrowserChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pageBuilder = _controller.getPageBuilder();
    final page = pageBuilder.buildPage(context);
    final uri = pageBuilder.getUri();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  _buildTab(pageBuilder),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: uri.toString(),
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        final uri = Uri.tryParse(value);
                        if (uri != null) {
                          _controller.load(uri);
                        }
                      },
                      textInputAction: TextInputAction.go,
                    ),
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

  Widget _buildTab(PageBuilder pageBuilder) {
    final icon = pageBuilder.buildIcon(context);
    final title = pageBuilder.getTitle();

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          const OutlineInputBorder().borderSide,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: icon,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}
