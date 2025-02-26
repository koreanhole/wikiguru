import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/widgets/pluto_bottom_sheet.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:wikiguru/components/bottomsheets/more_bottom_sheets.dart';
import 'package:wikiguru/components/bottomsheets/share_bottom_sheets.dart';

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
          _WebViewHomeButton(),
          SizedBox(width: 12),
          _WebViewSearchButton(),
          SizedBox(width: 12),
          _WebViewShareButton(),
          SizedBox(width: 12),
          _WebViewMoreButton(),
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

class _WebViewHomeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await WikiGuruWebViewController.goMainPage(context);
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.home,
      ),
    );
  }
}

class _WebViewSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await WikiGuruWebViewController.focusOnSearchBar(context);
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.search,
      ),
    );
  }
}

class _WebViewShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showPlutotBottomsheet(
          context: context,
          child: ShareBottomSheets(),
        );
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.ios_share,
      ),
    );
  }
}

class _WebViewMoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showPlutotBottomsheet(
          context: context,
          child: MoreBottomSheets(),
        );
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.more_horiz,
      ),
    );
  }
}
