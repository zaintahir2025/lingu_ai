import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_all/webview_all.dart';

class TurnstileWidget extends StatefulWidget {
  final String siteKey;
  final ValueChanged<String> onTokenReceived;
  final VoidCallback? onTokenExpired;

  const TurnstileWidget({
    super.key,
    required this.siteKey,
    required this.onTokenReceived,
    this.onTokenExpired,
  });

  @override
  State<TurnstileWidget> createState() => _TurnstileWidgetState();
}

class _TurnstileWidgetState extends State<TurnstileWidget> {
  WebViewController? _controller;

  bool get _hasEmbeddedWebView =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  @override
  void initState() {
    super.initState();
    if (!_hasEmbeddedWebView) return;

    final html =
        '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
        </head>
        <body style="display:flex;justify-content:center;align-items:center;height:100vh;margin:0;background:transparent;">
          <div class="cf-turnstile"
               data-sitekey="${widget.siteKey}"
               data-callback="javascriptCallback"
               data-expired-callback="expiredCallback"
               data-error-callback="expiredCallback"></div>
          <script>
            function javascriptCallback(token) {
              TurnstileChannel.postMessage(token);
            }
            function expiredCallback() {
              TurnstileChannel.postMessage('__expired__');
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
        onMessageReceived: (message) {
          if (message.message == '__expired__') {
            widget.onTokenExpired?.call();
          } else {
            widget.onTokenReceived(message.message);
          }
        },
      )
      ..loadHtmlString(html, baseUrl: 'https://localhost');
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasEmbeddedWebView) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      width: double.infinity,
      child: WebViewWidget(controller: _controller!),
    );
  }
}
