import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp_Credits extends StatefulWidget {
  const WebViewApp_Credits({Key? key}) : super(key: key);

  @override
  State<WebViewApp_Credits> createState() => _WebViewAppCreditsState();
}

class _WebViewAppCreditsState extends State<WebViewApp_Credits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credits'),
      ),
      body: const WebView(
        initialUrl: 'https://luigidibiasi.it/pon22/credits.html',
      ),
    );
  }
}
