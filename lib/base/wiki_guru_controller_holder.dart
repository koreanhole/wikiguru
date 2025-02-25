import 'package:logger/web.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WikiGuruControllerHolder {
  static WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('https://namu.wiki'))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) {
          Logger().d("progress: $progress");
        },
        onPageStarted: (url) {
          Logger().d("onPageStarted: $url");
        },
      ),
    );
}
