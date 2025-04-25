// ignore_for_file: depend_on_referenced_packages

import 'package:webview_flutter/webview_flutter.dart';

final namuWikiBaseUrl = Uri.parse("https://namu.wiki");

class WikiGuruWebViewController {
  // 싱글톤 인스턴스
  static final WikiGuruWebViewController _instance =
      WikiGuruWebViewController._internal();

  factory WikiGuruWebViewController() {
    return _instance;
  }

  WikiGuruWebViewController._internal() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(namuWikiBaseUrl);
  }

  late final WebViewController _webViewController;

  // 필요하다면 외부에서 WebViewController에 접근할 수 있는 getter
  WebViewController get webViewController => _webViewController;
}
