import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/widgets/pluto_app_bar.dart';
import 'package:wikiguru/base/widgets/pluto_bottom_sheet.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:wikiguru/components/bottomsheets/more_bottom_sheets.dart';
import 'package:wikiguru/components/wiki_guru_animated_app_bar.dart';
import 'package:wikiguru/providers/web_view_provider.dart';

final _actionButtonContainerBorderRadius = BorderRadius.circular(30);
const _actionButtonContainerAnimatedDuration = Duration(milliseconds: 200);
final _actionButtonFullSizedContainerPadding =
    EdgeInsets.symmetric(horizontal: 44.0);
final _actionButtonShrinkedContainerPadding =
    EdgeInsets.symmetric(horizontal: 150.0);

const _actionButtonItemPadding =
    EdgeInsets.symmetric(horizontal: 8, vertical: 4);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fullSizedAppBarHeight = MediaQuery.of(context).padding.top + 48.0;
    final shrinkedSizedAppBarHeight = MediaQuery.of(context).padding.top + 20.0;
    final webViewScrollState =
        context.watch<WebViewProvider>().webViewScrollState;

    bool needFullSizedButtons() {
      if (webViewScrollState == WebViewScrollState.scrollingDown) {
        return false;
      }
      return true;
    }

    return Scaffold(
      appBar: WikiGuruAnimatedAppBar(
        context: context,
        needFullSize: needFullSizedButtons(),
        animationDuration: _actionButtonContainerAnimatedDuration,
        title: "나무위키",
      ).build(),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedContainer(
        duration: _actionButtonContainerAnimatedDuration,
        curve: Curves.easeOut,
        padding: needFullSizedButtons()
            ? _actionButtonFullSizedContainerPadding
            : _actionButtonShrinkedContainerPadding,
        child: needFullSizedButtons()
            ? _FullSizedWebViewButton()
            : _ShrinkedWebViewButton(),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: _actionButtonContainerBorderRadius,
      color: PlutoColors.tertiaryColor,
      child: Padding(
        padding: _actionButtonItemPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }
}

class _ShrinkedWebViewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: _actionButtonContainerBorderRadius,
      color: PlutoColors.tertiaryColor,
      child: Padding(
        padding: _actionButtonItemPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _WebViewSearchButton(),
          ],
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
