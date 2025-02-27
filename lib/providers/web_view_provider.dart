import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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
    _setNavigationDelegate();
    _setOnScrollPositionChange();
  }

  void _setNavigationDelegate() {
    WikiGuruWebViewController().webViewController.setNavigationDelegate(
          NavigationDelegate(onProgress: (progress) {
            _webViewLoadingProgress = progress;
            notifyListeners();
          }, onPageFinished: (url) {
            _hidePageNavigationButtons();
            _enableSwipeToGoBackInIOS();
          }),
        );
  }

  void _setOnScrollPositionChange() {
    WikiGuruWebViewController().webViewController.setOnScrollPositionChange(
      (scrollPositon) {
        final changedScrollState = (_currentScrollPositionY < scrollPositon.y &&
                scrollPositon.y >= 0 &&
                _currentScrollPositionY >= 0)
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

  Future<void> _hidePageNavigationButtons() async {
    WikiGuruWebViewController().webViewController.runJavaScript(
      """
      const elementToTop = document.querySelector('[data-tooltip="맨 위로"]');
      if (elementToTop) {
        elementToTop.style.display = 'none';
      }
      const elementToBottom = document.querySelector('[data-tooltip="맨 아래로"]');
      if (elementToBottom) {
        elementToBottom.style.display = 'none';
      }
      """,
    );
  }

  Future<void> _enableSwipeToGoBackInIOS() async {
    if (WikiGuruWebViewController().webViewController.platform
        is WebKitWebViewController) {
      (WikiGuruWebViewController().webViewController.platform
              as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }
  }
}
