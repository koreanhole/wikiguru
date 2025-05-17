import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wikiguru/base/data/namu_wiki_outline.dart';
import 'package:wikiguru/base/data/web_view_scroll_state.dart';
import 'package:wikiguru/base/utils/url_utils.dart';
import 'package:wikiguru/base/wiki_web_view_controller.dart';

class WebViewProvider with ChangeNotifier {
  int _lastScrollPositionY = 0;
  WebViewScrollState? _webViewScrollState;

  List<NamuWikiOutline>? _namuWikiOutlines;

  String namuWikiTitle = "";
  List<NamuWikiOutline> get namuWikiOutlines =>
      _namuWikiOutlines ?? List.empty();
  bool get isWebViewScollingDown {
    if (_webViewScrollState == WebViewScrollState.scrollingDown) {
      return false;
    }
    return true;
  }

  bool get isDefaultNamuWikiTitle =>
      namuWikiTitle == "" || namuWikiTitle == "나무위키:대문";

  void setWebViewScrollState(InAppWebViewController controller, int x, int y) {
    _setWebViewScrollState(y);
    notifyListeners();
  }

  void onUpdateVisitedHistory(
    InAppWebViewController controller,
    WebUri? url,
    bool? isReload,
  ) {
    _setNamuWikiTitle(url);
    _setNamuWikiOutlines();
    notifyListeners();
  }

  void onLoadStop(
    InAppWebViewController controller,
    WebUri? url,
  ) async {
    await _hidePageNavigationElements(controller);
  }

  void _setWebViewScrollState(int y) {
    if (y < 0) {
      return;
    }
    if (y > _lastScrollPositionY) {
      _webViewScrollState = WebViewScrollState.scrollingDown;
    } else if (y < _lastScrollPositionY) {
      _webViewScrollState = WebViewScrollState.scrollingUp;
    }
    _lastScrollPositionY = y;
  }

  Future<void> _hidePageNavigationElements(
      InAppWebViewController controller) async {
    await controller.evaluateJavascript(
      source: """
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

  void _setNamuWikiTitle(WebUri? uri) {
    namuWikiTitle = uri.toString().cleanNamuTitleDecode ?? "";
  }

  void _setNamuWikiOutlines() async {
    _namuWikiOutlines = null;
    notifyListeners();
    // Delay for page fully loaded -> 대문 페이지 갔을 때 이전 페이지의 목차가 보일때 있음
    await Future.delayed(Duration(milliseconds: 500));
    final resultString =
        await WikiWebViewController().webViewController?.evaluateJavascript(
      source: r'''
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
}
