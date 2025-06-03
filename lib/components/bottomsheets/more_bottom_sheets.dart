import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/webview/web_view_navigator.dart';
import 'package:wikiguru/base/utils/widget_utils.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/components/bottomsheets/bottom_sheet_item.dart';
import 'package:wikiguru/components/bottomsheets/bottom_sheet_title.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';
import 'package:wikiguru/webview/web_view_provider.dart';
import 'package:wikiguru/webview/wiki_web_view_controller.dart';

class MoreBottomSheets extends StatelessWidget {
  const MoreBottomSheets({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24),
            ...addSpacingBetween(
              widgets: [
                BottomSheetTitle(titleText: "더보기"),
                _SetAnimatedFloatingActionButtonBottomSheetItem(),
                _WebViewContentBlockerBottomSheetItem(),
                _LaunchInAppBrowserBottomSheetItem(),
                _SharePageBottomSheetItem(),
              ],
              heightSpacing: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _SetAnimatedFloatingActionButtonBottomSheetItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hiveboxDataProvider = context.watch<HiveBoxDataProvider>();
    final isAnimatedFloatingActionButton = hiveboxDataProvider.getBooleanData(
      HiveBoxBooleanDataKey.isAnimatedFloatingActionButton,
    );

    return BottomSheetItem(
      labelText: "하단 바 자동 숨기기",
      subLabelText: isAnimatedFloatingActionButton
          ? "스크롤 방향에 따라 하단 바가 자동으로 나타납니다."
          : "하단 바가 고정되어 있습니다.",
      trailingWidget: CupertinoSwitch(
        activeTrackColor: PlutoColors.primaryColor,
        value: isAnimatedFloatingActionButton,
        onChanged: (value) {
          hiveboxDataProvider.setBooleanData(
            HiveBoxBooleanDataKey.isAnimatedFloatingActionButton,
            value,
          );
        },
      ),
    );
  }
}

class _SharePageBottomSheetItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomSheetItem(
      labelText: "공유하기",
      subLabelText: "현재 페이지를 다른 앱으로 공유하세요.",
      leadingIcon: Icons.ios_share,
      onTap: () async {
        final currentUrl =
            await WebViewNavigator(context: context).getCurrentUrl();
        if (currentUrl == null && context.mounted) {
          PlutoSnackBar.showFailureSnackBar(context, "공유할 수 없습니다.");
          return;
        }
        Share.shareUri(
          Uri.parse(currentUrl!),
        );
      },
    );
  }
}

class _LaunchInAppBrowserBottomSheetItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomSheetItem(
      labelText: "브라우저로 열기",
      subLabelText: Platform.isIOS ? "앱 내 사파리로 이동합니다." : "기본 브라우저로 이동합니다.",
      leadingIcon: Icons.open_in_browser_outlined,
      onTap: () async {
        final currentUrl =
            await WebViewNavigator(context: context).getCurrentUrl();
        if (currentUrl == null) {
          return;
        }
        await launchUrlString(
          currentUrl,
          mode: LaunchMode.inAppBrowserView,
        );
      },
    );
  }
}

class _WebViewContentBlockerBottomSheetItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hiveboxDataProvider = context.watch<HiveBoxDataProvider>();
    final webViewProvider = context.read<WebViewProvider>();
    final isContentBlockerEnabled = hiveboxDataProvider.getBooleanData(
      HiveBoxBooleanDataKey.isContentBlockerEnabled,
    );
    return BottomSheetItem(
      labelText: "불필요한 요소 없애기",
      subLabelText: "나무위키를 더 몰입감있게 즐기세요.",
      leadingIcon: Icons.visibility_off_outlined,
      trailingWidget: CupertinoSwitch(
        activeTrackColor: PlutoColors.primaryColor,
        value: isContentBlockerEnabled,
        onChanged: (value) async {
          await hiveboxDataProvider.setBooleanData(
            HiveBoxBooleanDataKey.isContentBlockerEnabled,
            value,
          );
          await webViewProvider.setInAppWebViewSetting(
              needContentBlocker: value);
        },
      ),
    );
  }
}
