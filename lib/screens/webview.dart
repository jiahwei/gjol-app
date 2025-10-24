// ... existing code ...
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ... existing code ...
class WebViewPage extends StatefulWidget {
  final String initialUrl;
  const WebViewPage({super.key, required this.initialUrl});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: WebViewWidget(controller: _controller),
      )
    );
  }
}
// ... existing code ...