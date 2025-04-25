import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:wikiguru/base/data/namu_wiki_outline.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';

class WebViewNavigator {
  final BuildContext context;
  WebViewNavigator({required this.context});

  Future<String?> getCurrentUrl() async {
    return await WikiGuruWebViewController().webViewController.currentUrl();
  }

  Future<void> focusOnSearchBar() async {
    try {
      await WikiGuruWebViewController().webViewController.runJavaScript(
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
    if (await WikiGuruWebViewController().webViewController.canGoBack() ==
        true) {
      await WikiGuruWebViewController().webViewController.goBack();
    } else {
      if (context.mounted == true) {
        PlutoSnackBar.showFailureSnackBar(context, "뒤로 갈 수 없습니다.");
      }
    }
  }

  Future<void> goMainPage() async {
    await WikiGuruWebViewController()
        .webViewController
        .loadRequest(namuWikiBaseUrl);
  }

  Future<void> goOutlinePage(
    NamuWikiOutline namuWikiOutline,
  ) async {
    final currentUrl =
        await WikiGuruWebViewController().webViewController.currentUrl();
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
    await WikiGuruWebViewController().webViewController.loadRequest(
          Uri.parse(
            '$cleanedUrl#${namuWikiOutline.href}',
          ),
        );
    if (context.mounted == true) {
      Navigator.of(context).pop();
    }
  }

  Future<void> refresh() async {
    WikiGuruWebViewController().webViewController.reload();
  }
}
