import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/utils/date_time_utils.dart';
import 'package:wikiguru/base/utils/url_utils.dart';
import 'package:wikiguru/components/bottomsheets/bottom_sheet_item.dart';
import 'package:wikiguru/components/wiki_guru_static_app_bar.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';

class SavedNamuWikiPageScreen extends StatelessWidget {
  const SavedNamuWikiPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedNamuWikiHtmlDataList =
        context.read<HiveBoxDataProvider>().getAllSavedNamuWikiHtmlData();
    return Scaffold(
      appBar: WikiGuruStaticAppBar(context: context, title: "저장된 페이지").build(),
      body: SafeArea(
        child: savedNamuWikiHtmlDataList.isEmpty
            ? Center(
                child: Text(
                  "저장된 페이지가 없습니다.",
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ...savedNamuWikiHtmlDataList.map(
                      (data) {
                        final cleanNamuTitle =
                            data.currentUrl.cleanNamuTitleDecode;
                        final formattedDateTimeString =
                            "${data.currentDateTime.formattedKoreanDateTime}에 저장됨";
                        if (cleanNamuTitle == null) {
                          return SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            BottomSheetItem(
                              // onTap: () async {
                              //   final webViewController = WebViewController();
                              //   await webViewController
                              //       .loadHtmlString(data.htmlString);
                              //   if (context.mounted == false) return;
                              //   PlutoSnackBar.showFailureSnackBar(
                              //       context, "미구현 기능");
                              // },
                              labelText: cleanNamuTitle,
                              subLabelText: formattedDateTimeString,
                              leadingIcon: Icons.download_done_outlined,
                              trailingWidget: Icon(
                                Icons.chevron_right_outlined,
                                color: PlutoColors.primaryColor,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
