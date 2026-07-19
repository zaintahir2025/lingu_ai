import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TurnstileWidget extends StatefulWidget {
  final String siteKey;
  final Function(String) onTokenReceived;

  const TurnstileWidget({
    super.key,
    required this.siteKey,
    required this.onTokenReceived,
  });

  @override
  State<TurnstileWidget> createState() => _TurnstileWidgetState();
}

class _TurnstileWidgetState extends State<TurnstileWidget> {
  WebViewController? _controller;

  bool get _isSupportedPlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();

    if (!_isSupportedPlatform) {
      Future.microtask(() => widget.onTokenReceived('mock-turnstile-token-bypassed'));
      return;
    }

    final html = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
        </head>
        <body style="display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: transparent;">
          <div class="cf-turnstile" 
               data-sitekey="${widget.siteKey}" 
               data-callback="javascriptCallback"></div>
          <script>
            function javascriptCallback(token) {
              TurnstileChannel.postMessage(token);
            }
          </script>
        </body>
      </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'TurnstileChannel',
        onMessageReceived: (JavaScriptMessage message) {
          widget.onTokenReceived(message.message);
        },
      )
      ..loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupportedPlatform) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text("Captcha verification (Bypassed on Desktop/Web)")),
      );
    }
    
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: WebViewWidget(controller: _controller!),
    );
  }
}
