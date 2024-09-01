import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatewayScreen extends StatelessWidget {
  final String bankGatewayUrl;

  const PaymentGatewayScreen({super.key, required this.bankGatewayUrl});
  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
        controller: WebViewController()
          ..loadRequest(Uri.parse(bankGatewayUrl))
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onPageStarted: (url) {},
          )));
  }
}
