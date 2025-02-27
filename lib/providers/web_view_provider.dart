import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';

enum WebViewScrollState {
  scrollingDown,
  scrollingUp,
  unknown,
}

class WebViewProvider with ChangeNotifier {
  int? _webViewLoadingProgress;
  WebViewScrollState? _webViewScrollState;
  double _currentScrollPositionY = 0.0;

  int get webViewLoadingProgress => _webViewLoadingProgress ?? 0;
  WebViewScrollState get webViewScrollState =>
      _webViewScrollState ?? WebViewScrollState.unknown;

  WebViewProvider() {
    _setLoadingProgressListener();
    _setScrollPositionListener();
  }

  void _setLoadingProgressListener() {
    WikiGuruWebViewController().webViewController.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) {
          _webViewLoadingProgress = progress;
          notifyListeners();
        },
      ),
    );
  }

  void _setScrollPositionListener() {
    WikiGuruWebViewController().webViewController.setOnScrollPositionChange(
      (scrollPositon) {
        final changedScrollState = (_currentScrollPositionY < scrollPositon.y)
            ? WebViewScrollState.scrollingDown
            : WebViewScrollState.scrollingUp;
        if (changedScrollState != _webViewScrollState) {
          _webViewScrollState = changedScrollState;
          notifyListeners();
        }
        _currentScrollPositionY = scrollPositon.y;
      },
    );
  }
}
