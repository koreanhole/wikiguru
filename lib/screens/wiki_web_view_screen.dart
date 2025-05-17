import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:wikiguru/base/wiki_web_view_controller.dart';
import 'package:wikiguru/components/floatingbutton/wiki_web_view_floating_button_container.dart';
import 'package:wikiguru/components/appbar/wiki_guru_animated_app_bar.dart';
import 'package:wikiguru/providers/web_view_provider.dart';

const _baseAnimatedContainerDuration = Duration(milliseconds: 200);

class WikiWebViewScreen extends StatefulWidget {
  const WikiWebViewScreen({super.key});

  @override
  State<WikiWebViewScreen> createState() => _WikiWebViewScreenState();
}

class _WikiWebViewScreenState extends State<WikiWebViewScreen> {
  @override
  Widget build(BuildContext context) {
    final webViewProvider = context.watch<WebViewProvider>();
    return Scaffold(
      appBar: WikiGuruAnimatedAppBar(
        context: context,
        needFullSize: webViewProvider.isWebViewScollingDown,
        needGoBackButton: !webViewProvider.isDefaultNamuWikiTitle,
        animatedContainerDuration: _baseAnimatedContainerDuration,
        title: webViewProvider.namuWikiTitle,
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
              onWebViewCreated: (InAppWebViewController controller) =>
                  WikiWebViewController().controller = controller,
              onScrollChanged: webViewProvider.setWebViewScrollState,
              onUpdateVisitedHistory: webViewProvider.onUpdateVisitedHistory,
              onLoadStop: webViewProvider.onLoadStop,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: WikiWebViewFloatingButtonContainer(
                isWebViewScrollingDown: webViewProvider.isWebViewScollingDown,
                animatedContainerDuration: _baseAnimatedContainerDuration,
              ),
            )
          ],
        ),
      ),
    );
  }
}
