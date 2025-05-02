// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final namuWikiBaseWebUri = WebUri("https://namu.wiki");

class WikiGuruWebViewController {
  // 1. private static instance
  static final WikiGuruWebViewController _instance =
      WikiGuruWebViewController._internal();

  // 2. private constructor
  WikiGuruWebViewController._internal();

  // 3. factory constructor
  factory WikiGuruWebViewController() => _instance;

  // 4. 실제 컨트롤러 변수 (nullable)
  InAppWebViewController? _controller;

  // 5. 컨트롤러 getter
  InAppWebViewController? get webViewController => _controller;

  // 6. 컨트롤러 setter
  set controller(InAppWebViewController controller) {
    _controller = controller;
  }
}
