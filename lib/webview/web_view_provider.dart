import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wikiguru/base/data/namu_wiki_outline.dart';
import 'package:wikiguru/base/data/web_view_scroll_state.dart';
import 'package:wikiguru/base/utils/url_utils.dart';
import 'package:wikiguru/webview/wiki_web_view_controller.dart';

class WebViewProvider with ChangeNotifier {
  int _lastScrollPositionY = 0;
  WebViewScrollState? _webViewScrollState;
  String namuWikiTitle = "";
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
    notifyListeners();
  }

  Future<List<NamuWikiOutline>> getNamuWikiOutlines() async {
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
    return jsonList.map((item) => NamuWikiOutline.fromJson(item)).toList();
  }

  Future<void> setInAppWebViewSetting({
    required bool needContentBlocker,
  }) async {
    final List<ContentBlocker> navigationBlockers = [
      ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: ".*",
        ),
        action: ContentBlockerAction(
          type: ContentBlockerActionType.CSS_DISPLAY_NONE,
          selector: '[data-tooltip="맨 위로"]',
        ),
      ),
      ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: ".*",
        ),
        action: ContentBlockerAction(
          type: ContentBlockerActionType.CSS_DISPLAY_NONE,
          selector: '[data-tooltip="맨 아래로"]',
        ),
      ),
    ];
    final List<ContentBlocker> googleAdsBlockers = [
      // Google AdSense and DoubleClick ads by CSS class
      ContentBlocker(
        trigger: ContentBlockerTrigger(urlFilter: ".*"),
        action: ContentBlockerAction(
          type: ContentBlockerActionType.CSS_DISPLAY_NONE,
          selector: ".adsbygoogle", // Common class for AdSense
        ),
      ),
      ContentBlocker(
        trigger: ContentBlockerTrigger(urlFilter: ".*"),
        action: ContentBlockerAction(
          type: ContentBlockerActionType.CSS_DISPLAY_NONE,
          selector: 'ins.adsbygoogle', // Often used with <ins> tags
        ),
      ),
      ContentBlocker(
        trigger: ContentBlockerTrigger(urlFilter: ".*"),
        action: ContentBlockerAction(
          type: ContentBlockerActionType.CSS_DISPLAY_NONE,
          selector: '[data-ad-client]',
        ),
      ),
      ContentBlocker(
        trigger: ContentBlockerTrigger(urlFilter: ".*"),
        action: ContentBlockerAction(
          type: ContentBlockerActionType.CSS_DISPLAY_NONE,
          selector: '[data-ad-slot]',
        ),
      ),
      ContentBlocker(
        trigger: ContentBlockerTrigger(urlFilter: ".*"),
        action: ContentBlockerAction(
          type: ContentBlockerActionType.CSS_DISPLAY_NONE,
          selector: '[data-ad-format]',
        ),
      ),
      // Blocking requests to common Google ad domains
      ContentBlocker(
        trigger:
            ContentBlockerTrigger(urlFilter: ".*googlesyndication\\.com.*"),
        action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK),
      ),
      ContentBlocker(
        trigger: ContentBlockerTrigger(urlFilter: ".*doubleclick\\.net.*"),
        action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK),
      ),
      ContentBlocker(
        trigger: ContentBlockerTrigger(urlFilter: ".*googleadservices\\.com.*"),
        action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK),
      ),
    ];
    if (needContentBlocker) {
      WikiWebViewController().webViewController?.setSettings(
            settings: InAppWebViewSettings(
              mediaPlaybackRequiresUserGesture: false,
              contentBlockers: [
                ...navigationBlockers,
                ...googleAdsBlockers,
              ],
            ),
          );
    } else {
      WikiWebViewController().webViewController?.setSettings(
            settings: InAppWebViewSettings(
              mediaPlaybackRequiresUserGesture: false,
            ),
          );
    }
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

  void _setNamuWikiTitle(WebUri? uri) {
    namuWikiTitle = uri.toString().cleanNamuTitleDecode ?? "";
  }
}
