// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';

final _namuWikiBaseUrl = Uri.parse("https://namu.wiki");

class WikiGuruWebViewController {
  static WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(_namuWikiBaseUrl)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) {
          Logger().d("progress: $progress");
        },
        onPageStarted: (url) {
          Logger().d("onPageStarted: $url");
        },
        onPageFinished: (url) {
          _hidePageNavigationButtons();
          _enableSwipeToGoBackInIOS();
        },
      ),
    );
  static Future<void> focusOnSearchBar(BuildContext context) async {
    try {
      await webViewController.runJavaScript(
        "document.querySelector('input[placeholder=\"여기에서 검색\"]').focus();",
      );
    } catch (exception) {
      Logger().e("focusOnSearchBar: $exception");
      if (context.mounted == true) {
        PlutoSnackBar.showFailureSnackBar(context, "검색할 수 없습니다.");
      }
    }
  }

  static Future<void> goBack(BuildContext context) async {
    if (await webViewController.canGoBack() == true) {
      await webViewController.goBack();
    } else {
      if (context.mounted == true) {
        PlutoSnackBar.showFailureSnackBar(context, "뒤로 갈 수 없습니다.");
      }
    }
  }

  static Future<void> goMainPage(BuildContext context) async {
    await webViewController.loadRequest(_namuWikiBaseUrl);
  }

  static Future<void> _hidePageNavigationButtons() async {
    webViewController.runJavaScript(
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

  static Future<void> _enableSwipeToGoBackInIOS() async {
    if (webViewController.platform is WebKitWebViewController) {
      (webViewController.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }
  }
}
