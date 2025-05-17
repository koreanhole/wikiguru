import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:wikiguru/base/data/web_view_scroll_state.dart';
import 'package:wikiguru/base/utils/url_utils.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:wikiguru/components/floating_button_container.dart';
import 'package:wikiguru/components/wiki_guru_animated_app_bar.dart';
import 'package:wikiguru/providers/web_view_provider.dart';

const _actionButtonContainerAnimatedDuration = Duration(milliseconds: 200);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebViewScrollState? _webViewScrollState;
  int _lastScrollPositionY = 0;
  bool get isWebViewScollingDown {
    if (_webViewScrollState == WebViewScrollState.scrollingDown) {
      return false;
    }
    return true;
  }

  String namuTitle = "";
  bool get needGoBackButton {
    return !(namuTitle == "" || namuTitle == "나무위키:대문");
  }

  void setWebViewController(InAppWebViewController controller) {
    WikiGuruWebViewController().controller = controller;
  }

  void setWebViewScrollState(InAppWebViewController controller, int x, int y) {
    setState(
      () {
        if (y < 0) {
          return;
        }
        if (y > _lastScrollPositionY) {
          _webViewScrollState = WebViewScrollState.scrollingDown;
        } else if (y < _lastScrollPositionY) {
          _webViewScrollState = WebViewScrollState.scrollingUp;
        }
        _lastScrollPositionY = y;
      },
    );
  }

  void setNamuWikiTitle(
    InAppWebViewController controller,
    WebUri? url,
    bool? isReload,
  ) {
    setState(() {
      namuTitle = url.toString().cleanNamuTitleDecode ?? "";
    });
    context.read<WebViewProvider>().setNamuWikiOutlines();
  }

  void hidePageNavigationElements(
      InAppWebViewController controller, WebUri? url) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WikiGuruAnimatedAppBar(
        context: context,
        needFullSize: isWebViewScollingDown,
        needGoBackButton: needGoBackButton,
        animationDuration: _actionButtonContainerAnimatedDuration,
        title: namuTitle,
      ).build(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: namuWikiBaseWebUri,
              ),
              onWebViewCreated: setWebViewController,
              onScrollChanged: setWebViewScrollState,
              onUpdateVisitedHistory: setNamuWikiTitle,
              onLoadStop: hidePageNavigationElements,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingButtonContainer(
                isWebViewScrollingDown: isWebViewScollingDown,
                animatedContainerDuration:
                    _actionButtonContainerAnimatedDuration,
              ),
            )
          ],
        ),
      ),
    );
  }
}
