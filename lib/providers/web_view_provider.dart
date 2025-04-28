import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/data/namu_wiki_outline.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';

enum WebViewScrollState {
  scrollingDown,
  scrollingUp,
  unknown,
}

enum JavaScriptChannel {
  navigationUrlChannel,
}

class WebViewProvider with ChangeNotifier {
  int? _webViewLoadingProgress;
  WebViewScrollState? _webViewScrollState;
  double _currentScrollPositionY = 0.0;
  List<NamuWikiOutline>? _namuWikiOutlines;

  String? namuTitle;
  bool get isDefaultNamuTitle => namuTitle == "나무위키:대문" || namuTitle == null;
  int get webViewLoadingProgress => _webViewLoadingProgress ?? 0;
  bool get isWebViewScollingDown {
    if (_webViewScrollState == WebViewScrollState.scrollingDown) {
      return false;
    }
    return true;
  }

  List<NamuWikiOutline> get namuWikiOutlines =>
      _namuWikiOutlines ?? List.empty();

  WebViewProvider() {
    _addJavaScriptChannel();
    _setNavigationDelegate();
    _setOnScrollPositionChange();
  }

  Future<void> saveCurrentPageToHiveBox(BuildContext context) async {
    final htmlString = await WikiGuruWebViewController()
            .webViewController
            .runJavaScriptReturningResult("document.documentElement.outerHTML")
        as String;
    final currentUrl =
        await WikiGuruWebViewController().webViewController.currentUrl();
    if (currentUrl == null) {
      return;
    }
    if (context.mounted == true) {
      await context.read<HiveBoxDataProvider>().setNamuWikiHtmlData(
            htmlString: htmlString,
            currentUrl: currentUrl,
          );
    }
  }

  void _addJavaScriptChannel() {
    WikiGuruWebViewController().webViewController.addJavaScriptChannel(
      JavaScriptChannel.navigationUrlChannel.name,
      onMessageReceived: (javascriptMessage) {
        namuTitle = javascriptMessage.message.cleanNamuTitle;
        notifyListeners();
        _setNamuWikiOutlines();
      },
    );
  }

  void _setNavigationDelegate() {
    WikiGuruWebViewController().webViewController.setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              _webViewLoadingProgress = progress;
              notifyListeners();
            },
            onPageFinished: (url) {
              _initCurrentUrl(url);
              _setOnUrlChangeJavaScriptChannel();
              _hidePageNavigationButtons();
              _enableSwipeToGoBackInIOS();
            },
          ),
        );
  }

  void _initCurrentUrl(String url) {
    namuTitle = url.cleanNamuTitleDecode;
    notifyListeners();
  }

  void _setNamuWikiOutlines() async {
    _namuWikiOutlines = null;
    notifyListeners();
    // Delay for page fully loaded -> 대문 페이지 갔을 때 이전 페이지의 목차가 보일때 있음
    await Future.delayed(Duration(milliseconds: 500));
    final resultString = await WikiGuruWebViewController()
        .webViewController
        .runJavaScriptReturningResult(
      r'''
        (function() {
          var results = [];
          document.querySelectorAll('a[id^="s-"]').forEach(function(aTag) {
            if (/^s-(\d+(\.\d+)*)$/.test(aTag.id)) {
              var numberPart = aTag.id.slice(2);
              var depth = numberPart.split('.').length - 1;
              var nextElem = aTag.nextElementSibling;
              if (nextElem && nextElem.tagName.toLowerCase() === 'span' && nextElem.id) {
                results.push({
                  href: aTag.id,
                  label: nextElem.id,
                  depth: depth
                });
              }
            }
          });
          return JSON.stringify(results);
        })()
      ''',
    ) as String;
    final List<dynamic> jsonList = jsonDecode(resultString);
    _namuWikiOutlines =
        jsonList.map((item) => NamuWikiOutline.fromJson(item)).toList();
    notifyListeners();
  }

  void _setOnUrlChangeJavaScriptChannel() {
    WikiGuruWebViewController().webViewController.runJavaScript(
      '''
        (function() {
          // URL 변경 시 로그를 찍는 함수
          function logUrlChange() {
            ${JavaScriptChannel.navigationUrlChannel.name}.postMessage(decodeURI(window.location.href));
          }

          // history.pushState 재정의
          const originalPushState = history.pushState;
          history.pushState = function(state, title, url) {
            const result = originalPushState.apply(history, arguments);
            logUrlChange();
            return result;
          };

          // history.replaceState 재정의
          const originalReplaceState = history.replaceState;
          history.replaceState = function(state, title, url) {
            const result = originalReplaceState.apply(history, arguments);
            logUrlChange();
            return result;
          };

          // 뒤로/앞으로 이동 시 URL 변경 감지
          window.addEventListener('popstate', logUrlChange);

          // 해시 변경 감지 (hash 기반 라우팅 사용 시)
          window.addEventListener('hashchange', logUrlChange);
        })();
      ''',
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

extension NamuWikiUrlExtension on String {
  /// Namuwiki URL에서 "https://namu.wiki/w/" 접두사와
  /// '?from=' 이후의 내용을 제거한 제목을 반환합니다.
  /// 만약 두 요소가 모두 없다면 null을 반환합니다.
  String? get cleanNamuTitle {
    const prefix = "https://namu.wiki/w/";
    // 접두사나 '?from=' 둘 다 없으면 null 반환
    if (!startsWith(prefix) && !contains('?from=')) {
      return null;
    }

    String result = this;

    // 접두사가 있으면 제거
    if (result.startsWith(prefix)) {
      result = result.substring(prefix.length);
    }

    // '?from=' 이후의 부분 제거
    int fromIndex = result.indexOf('?from=');
    if (fromIndex != -1) {
      result = result.substring(0, fromIndex);
    }

    // '#' 이후의 부분 제거
    int hashTagIndex = result.indexOf('#');
    if (hashTagIndex != -1) {
      result = result.substring(0, hashTagIndex);
    }

    return result;
  }

  String? get cleanNamuTitleDecode {
    return Uri.decodeFull(this).cleanNamuTitle;
  }
}
