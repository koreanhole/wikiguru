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
              labelText: "오프라인 저장",
              subLabelText: "나무위키 문서를 오프라인으로 즐겨보세요.",
            ),
            SizedBox(height: 12),
            BottomSheetItem(
              labelText: "카카오톡으로 공유",
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
