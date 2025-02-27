import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/widgets/pluto_bottom_sheet.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:wikiguru/components/bottomsheets/more_bottom_sheets.dart';
import 'package:wikiguru/providers/web_view_provider.dart';

final _actionButtonContainerBorderRadius = BorderRadius.circular(30);

const _actionButtonItemPadding =
    EdgeInsets.symmetric(horizontal: 8, vertical: 4);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final webViewScrollState =
        context.watch<WebViewProvider>().webViewScrollState;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          webViewScrollState == WebViewScrollState.scrollingDown
              ? _ShrinkedWebViewButton()
              : _FullSizedWebViewButton(),
      body: SafeArea(
        bottom: false,
        child: WebViewWidget(
          controller: WikiGuruWebViewController().webViewController,
        ),
      ),
    );
  }
}

class _FullSizedWebViewButton extends StatelessWidget {
  final _actionButtonContainerPadding = EdgeInsets.symmetric(horizontal: 44.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _actionButtonContainerPadding,
      child: Material(
        elevation: 3,
        borderRadius: _actionButtonContainerBorderRadius,
        color: PlutoColors.tertiaryColor,
        child: Padding(
          padding: _actionButtonItemPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _WebViewBackButton(),
              SizedBox(width: 12),
              _WebViewHomeButton(),
              SizedBox(width: 12),
              _WebViewSearchButton(),
              SizedBox(width: 12),
              _WebViewMoreButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShrinkedWebViewButton extends StatelessWidget {
  final _actionButtonContainerPadding = EdgeInsets.symmetric(horizontal: 150.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _actionButtonContainerPadding,
      child: Material(
        elevation: 3,
        borderRadius: _actionButtonContainerBorderRadius,
        color: PlutoColors.tertiaryColor,
        child: Padding(
          padding: _actionButtonItemPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _WebViewSearchButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebViewButton extends StatelessWidget {
  final void Function()? onTap;
  final IconData? iconData;

  const _WebViewButton({
    required this.onTap,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: PlutoColors.tertiaryColor,
      shape: CircleBorder(),
      child: Icon(
        iconData,
        size: 30,
      ),
    );
  }
}

class _WebViewBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _WebViewButton(
      onTap: () async {
        await WikiGuruWebViewController().goBack(context);
      },
      iconData: Icons.keyboard_backspace,
    );
  }
}

class _WebViewHomeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _WebViewButton(
      onTap: () async {
        await WikiGuruWebViewController().goMainPage(context);
      },
      iconData: Icons.home,
    );
  }
}

class _WebViewSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _WebViewButton(
      onTap: () async {
        await WikiGuruWebViewController().focusOnSearchBar(context);
      },
      iconData: Icons.search,
    );
  }
}

class _WebViewMoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _WebViewButton(
      onTap: () async {
        await showPlutotBottomsheet(
          context: context,
          child: MoreBottomSheets(),
        );
      },
      iconData: Icons.menu,
    );
  }
}
