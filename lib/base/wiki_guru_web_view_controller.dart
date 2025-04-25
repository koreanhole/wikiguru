// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/data/namu_wiki_outline.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';

final _namuWikiBaseUrl = Uri.parse("https://namu.wiki");

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
      ..loadRequest(_namuWikiBaseUrl);
  }

  late final WebViewController _webViewController;

  // 필요하다면 외부에서 WebViewController에 접근할 수 있는 getter
  WebViewController get webViewController => _webViewController;

  Future<String?> getCurrentUrl() async {
    return await _webViewController.currentUrl();
  }

  Future<void> focusOnSearchBar(BuildContext context) async {
    try {
      await _webViewController.runJavaScript(
        "document.querySelector('input[placeholder=\"여기에서 검색\"]').focus();",
      );
    } catch (exception) {
      Logger().e("focusOnSearchBar: $exception");
      if (context.mounted == true) {
        PlutoSnackBar.showFailureSnackBar(context, "검색할 수 없습니다.");
      }
    }
  }

  Future<void> goBack(BuildContext context) async {
    if (await _webViewController.canGoBack() == true) {
      await _webViewController.goBack();
    } else {
      if (context.mounted == true) {
        PlutoSnackBar.showFailureSnackBar(context, "뒤로 갈 수 없습니다.");
      }
    }
  }

  Future<void> goMainPage(BuildContext context) async {
    await _webViewController.loadRequest(_namuWikiBaseUrl);
  }

  Future<void> goOutlinePage(
    BuildContext context,
    NamuWikiOutline namuWikiOutline,
  ) async {
    final currentUrl = await _webViewController.currentUrl();
    if (currentUrl == null) {
      if (context.mounted == true) {
        PlutoSnackBar.showFailureSnackBar(
          context,
          "이동할 수 없습니다.",
        );
      }
      return;
    }
    // #를 포함하는 string들을 제거함
    final cleanedUrl = currentUrl.split("#")[0];
    await _webViewController.loadRequest(
      Uri.parse(
        '$cleanedUrl#${namuWikiOutline.href}',
      ),
    );
    if (context.mounted == true) {
      Navigator.of(context).pop();
    }
  }

  Future<void> refresh() async {
    _webViewController.reload();
  }
}
