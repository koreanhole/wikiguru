import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _WebViewBackButton(),
          SizedBox(width: 12),
          _WebViewSearchButton(),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: WebViewWidget(
          controller: WikiGuruWebViewController.webViewController,
        ),
      ),
    );
  }
}

class _WebViewBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await WikiGuruWebViewController.goBack(context);
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.keyboard_backspace,
      ),
    );
  }
}

class _WebViewSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await WikiGuruWebViewController.focusOnSearchBar();
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.search,
      ),
    );
  }
}
