import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/web.dart';
import 'package:wikiguru/base/data/namu_wiki_outline.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/base/wiki_web_view_controller.dart';

class WebViewNavigator {
  final BuildContext context;
  WebViewNavigator({required this.context});

  Future<String?> getCurrentUrl() async {
    final webUri = await WikiWebViewController().webViewController?.getUrl();
    return webUri.toString();
  }

  Future<void> focusOnSearchBar() async {
    try {
      await WikiWebViewController().webViewController?.evaluateJavascript(
            source:
                "document.querySelector('input[placeholder=\"여기에서 검색\"]').focus();",
          );
    } catch (exception) {
      Logger().e("focusOnSearchBar: $exception");
      if (context.mounted == true) {
        PlutoSnackBar.showFailureSnackBar(context, "검색할 수 없습니다.");
      }
    }
  }

  Future<void> goBack() async {
    if (await WikiWebViewController().webViewController?.canGoBack() == true) {
      await WikiWebViewController().webViewController?.goBack();
    } else {
      if (context.mounted == true) {
        PlutoSnackBar.showFailureSnackBar(context, "뒤로 갈 수 없습니다.");
      }
    }
  }

  Future<void> goMainPage() async {
    await WikiWebViewController().webViewController?.loadUrl(
          urlRequest: URLRequest(
            url: namuWikiBaseWebUri,
          ),
        );
  }

  Future<void> goOutlinePage(
    NamuWikiOutline namuWikiOutline,
  ) async {
    final currentUrl = await getCurrentUrl();
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
    await WikiWebViewController().webViewController?.evaluateJavascript(
        source: 'location.replace("$cleanedUrl#${namuWikiOutline.href}");');
    if (context.mounted == true) {
      Navigator.of(context).pop();
    }
  }

  Future<void> refresh() async {
    WikiWebViewController().webViewController?.reload();
  }
}
