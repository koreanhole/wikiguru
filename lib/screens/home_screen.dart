import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:wikiguru/components/floating_button_container.dart';
import 'package:wikiguru/components/wiki_guru_animated_app_bar.dart';
import 'package:wikiguru/providers/web_view_provider.dart';

const _actionButtonContainerAnimatedDuration = Duration(milliseconds: 200);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final webViewProvier = context.watch<WebViewProvider>();

    return Scaffold(
      appBar: WikiGuruAnimatedAppBar(
        context: context,
        needFullSize: webViewProvier.isWebViewScollingDown,
        animationDuration: _actionButtonContainerAnimatedDuration,
        title: webViewProvier.namuTitle ?? "",
      ).build(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            WebViewWidget(
              controller: WikiGuruWebViewController().webViewController,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingButtonContainer(
                  animatedContainerDuration:
                      _actionButtonContainerAnimatedDuration),
            )
          ],
        ),
      ),
    );
  }
}
