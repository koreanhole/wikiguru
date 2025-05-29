import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/webview/web_view_navigator.dart';
import 'package:wikiguru/base/utils/widget_utils.dart';
import 'package:wikiguru/base/widgets/pluto_bottom_sheet.dart';
import 'package:wikiguru/base/widgets/pluto_dialog.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/components/bottomsheets/more_bottom_sheets.dart';
import 'package:wikiguru/components/dialogs/namu_wiki_outlines_dialog.dart';
import 'package:wikiguru/components/floatingbutton/wiki_web_view_floating_button.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';
import 'package:wikiguru/webview/web_view_provider.dart';

class WikiWebViewFloatingButtonContainer extends StatelessWidget {
  final Duration animatedContainerDuration;
  final bool isWebViewScrollingDown;
  const WikiWebViewFloatingButtonContainer({
    super.key,
    required this.animatedContainerDuration,
    required this.isWebViewScrollingDown,
  });

  @override
  Widget build(BuildContext context) {
    final hiveBoxDataProvider = context.watch<HiveBoxDataProvider>();
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: hiveBoxDataProvider.getBooleanData(
              HiveBoxBooleanDataKey.isAnimatedFloatingActionButton)
          ? AnimatedSlide(
              duration: animatedContainerDuration,
              curve: Curves.easeOut,
              offset: isWebViewScrollingDown ? Offset(0, 0) : Offset(0, 1.5),
              child: _WebViewFloatingButtons(),
            )
          : _WebViewFloatingButtons(),
    );
  }
}

class _WebViewFloatingButtons extends StatelessWidget {
  final List<Widget> _floatingButtonWigets = [
    _WebViewSearchButton(),
    _WebViewShowNamuWikiOutlinesButton(),
    _WebViewMoreButton(),
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.0 * _floatingButtonWigets.length,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(30),
        color: PlutoColors.backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...addSpacingBetween(
                widgets: _floatingButtonWigets,
                widthSpacing: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebViewSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WikiWebViewFloatingButton(
      onTap: () async {
        await WebViewNavigator(context: context).focusOnSearchBar();
      },
      iconData: Icons.search,
    );
  }
}

class _WebViewMoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WikiWebViewFloatingButton(
      onTap: () async {
        await showPlutotBottomsheet(
          context: context,
          child: MoreBottomSheets(),
        );
      },
      iconData: Icons.more_vert_outlined,
    );
  }
}

class _WebViewShowNamuWikiOutlinesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WikiWebViewFloatingButton(
      onTap: () async {
        final namuWikiOutlines =
            await context.read<WebViewProvider>().getNamuWikiOutlines();
        if (namuWikiOutlines.isNotEmpty && context.mounted) {
          await showPlutoDialog(
            context: context,
            child: NamuWikiOutlinesDialog(),
          );
        } else if (context.mounted) {
          PlutoSnackBar.showFailureSnackBar(context, "목차를 불러올 수 없습니다.");
        }
      },
      iconData: Icons.subject,
    );
  }
}
