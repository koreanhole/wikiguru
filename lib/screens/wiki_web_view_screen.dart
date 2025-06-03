import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';
import 'package:wikiguru/webview/wiki_web_view_controller.dart';
import 'package:wikiguru/components/floatingbutton/wiki_web_view_floating_button_container.dart';
import 'package:wikiguru/components/appbar/wiki_guru_animated_app_bar.dart';
import 'package:wikiguru/webview/web_view_provider.dart';

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
    final isWebViewLoading = webViewProvider.isWebViewLoading;
    final isContentBlockerEnabled =
        context.watch<HiveBoxDataProvider>().getBooleanData(
              HiveBoxBooleanDataKey.isContentBlockerEnabled,
            );
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
              initialSettings: InAppWebViewSettings(
                mediaPlaybackRequiresUserGesture: true,
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                WikiWebViewController().controller = controller;
                webViewProvider.setInAppWebViewSetting(
                    needContentBlocker: isContentBlockerEnabled);
              },
              onLoadStart: webViewProvider.onLoadStart,
              onLoadStop: webViewProvider.onLoadStop,
              onProgressChanged: webViewProvider.onProgressChanged,
              onReceivedError:
                  (controller, webReourceRequest, webResourceError) {
                webViewProvider.onReceivedError(
                    controller, webReourceRequest, webResourceError);
                PlutoSnackBar.showFailureSnackBar(context, "웹페이지를 로딩하지 못했습니다.");
              },
              onReceivedHttpError:
                  (controller, webReourceRequest, webResourceResponse) {
                webViewProvider.onReceivedHttpError(
                    controller, webReourceRequest, webResourceResponse);
                PlutoSnackBar.showFailureSnackBar(context, "웹페이지를 로딩하지 못했습니다.");
              },
              onScrollChanged: webViewProvider.setWebViewScrollState,
              onUpdateVisitedHistory: webViewProvider.onUpdateVisitedHistory,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: WikiWebViewFloatingButtonContainer(
                isWebViewScrollingDown: webViewProvider.isWebViewScollingDown,
                animatedContainerDuration: _baseAnimatedContainerDuration,
              ),
            ),
            if (isWebViewLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: PlutoColors.primaryColor, // 원하는 색상으로 변경 가능
                ),
              ),
          ],
        ),
      ),
    );
  }
}
