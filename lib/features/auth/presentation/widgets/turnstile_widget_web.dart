import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

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
  late final String _viewType;
  late final web.HTMLIFrameElement _iframe;
  StreamSubscription<web.MessageEvent>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _viewType = 'linguai-turnstile-${identityHashCode(this)}';
    final safeSiteKey = const HtmlEscape().convert(widget.siteKey);

    _iframe = web.HTMLIFrameElement()
      ..title = 'CAPTCHA verification'
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..srcdoc =
          '''
        <!doctype html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
          </head>
          <body style="display:flex;justify-content:center;align-items:center;height:100vh;margin:0;background:transparent;overflow:hidden;">
            <div class="cf-turnstile"
                 data-sitekey="$safeSiteKey"
                 data-callback="verified"
                 data-expired-callback="expired"
                 data-error-callback="failed"></div>
            <script>
              const send = (kind, token = '') => parent.postMessage(
                JSON.stringify({ source: 'linguai-turnstile', kind, token }), '*');
              function verified(token) { send('verified', token); }
              function expired() { send('expired'); }
              function failed() { send('error'); }
            </script>
          </body>
        </html>
      '''
              .toJS;

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (_) => _iframe);

    _messageSubscription = web.window.onMessage.listen((event) {
      if (event.source != _iframe.contentWindow) return;
      final rawMessage = event.data.dartify();
      if (rawMessage is! String) return;

      try {
        final message = jsonDecode(rawMessage);
        if (message is! Map || message['source'] != 'linguai-turnstile') return;
        if (message['kind'] == 'verified' && message['token'] is String) {
          widget.onTokenReceived(message['token'] as String);
        } else if (message['kind'] == 'expired' || message['kind'] == 'error') {
          widget.onTokenExpired?.call();
        }
      } on FormatException {
        // Ignore messages from unrelated scripts embedded in the page.
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      width: double.infinity,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
