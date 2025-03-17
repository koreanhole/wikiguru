import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:wikiguru/components/floating_action_button.dart';
import 'package:wikiguru/components/wiki_guru_animated_app_bar.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';
import 'package:wikiguru/providers/web_view_provider.dart';

const _actionButtonContainerAnimatedDuration = Duration(milliseconds: 200);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final webViewProvier = context.watch<WebViewProvider>();
    final hiveBoxDataProvider = context.watch<HiveBoxDataProvider>();

    return Scaffold(
      appBar: WikiGuruAnimatedAppBar(
        context: context,
        needFullSize: webViewProvier.isWebViewScollingDown,
        animationDuration: _actionButtonContainerAnimatedDuration,
        title: webViewProvier.currentUrl ?? "",
      ).build(),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: hiveBoxDataProvider.getBooleanData(
        HiveBoxBooleanDataKey.isAnimatedFloatingActionButton,
      )
          ? AnimatedFloatingActionButton(
              animationDuration: _actionButtonContainerAnimatedDuration,
            )
          : StaticFloatingActionButton(),
      body: SafeArea(
        bottom: false,
        child: WebViewWidget(
          controller: WikiGuruWebViewController().webViewController,
        ),
      ),
    );
  }
}
