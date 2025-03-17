import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
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

    return BottomSheetItem(
      labelText: "하단 바 줄이기",
      subLabelText: "스크롤 방향에 따라 하단 바의 크기가 변합니다.",
      trailingWidget: CupertinoSwitch(
        activeTrackColor: PlutoColors.primaryColor,
        value: hiveboxDataProvider.getBooleanData(
          HiveBoxBooleanDataKey.isAnimatedFloatingActionButton,
        ),
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
      subLabelText: "현재 보고 있는 페이지를 공유하세요.",
      leadingIcon: Icons.ios_share,
      onTap: () async {
        final currentUrl = await WikiGuruWebViewController().getCurrentUrl();
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
