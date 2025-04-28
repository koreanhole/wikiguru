import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/utils/web_view_navigator.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/base/wiki_guru_router.dart';
import 'package:wikiguru/components/bottomsheets/bottom_sheet_item.dart';
import 'package:wikiguru/components/bottomsheets/bottom_sheet_title.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';

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
            BottomSheetTitle(titleText: "더보기"),
            SizedBox(height: 16),
            _SavePageBottomSheetItem(),
            SizedBox(height: 16),
            _SetAnimatedFloatingActionButtonBottomSheetItem(),
            SizedBox(height: 16),
            _SharePageBottomSheetItem(),
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

class _SavePageBottomSheetItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomSheetItem(
      labelText: "저장된 페이지 확인하기",
      subLabelText: "인터넷 연결이 없어도 확인할 수 있어요.",
      onTap: () {
        WikiGuruRouter.router
            .push(WikiGuruRouteItems.savedNamuWikiPageScreen.item.path);
      },
      leadingIcon: Icons.star_outline,
      trailingWidget: Icon(
        Icons.chevron_right_outlined,
        color: PlutoColors.primaryColor,
      ),
    );
  }
}
