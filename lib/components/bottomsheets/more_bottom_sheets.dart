import 'package:flutter/material.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/components/bottomsheets/bottom_sheet_item.dart';
import 'package:wikiguru/components/bottomsheets/bottom_sheet_title.dart';

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
            BottomSheetItem(
              leadingIcon: Icons.download,
              labelText: "오프라인 저장",
            ),
            SizedBox(height: 12),
            BottomSheetItem(
              labelText: "공유하기",
              subLabelText: "현재 보고 있는 페이지를 공유하세요.",
              leadingIcon: Icons.ios_share,
              onTap: () {
                PlutoSnackBar.showSuccessSnackBar(context, "message");
              },
            ),
          ],
        ),
      ),
    );
  }
}
