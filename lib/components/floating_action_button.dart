import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/widgets/pluto_bottom_sheet.dart';
import 'package:wikiguru/base/widgets/pluto_dialog.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:wikiguru/components/bottomsheets/more_bottom_sheets.dart';
import 'package:wikiguru/components/dialogs/namu_wiki_outlines_dialog.dart';
import 'package:wikiguru/providers/web_view_provider.dart';

final _actionButtonFullSizedContainerPadding =
    EdgeInsets.symmetric(horizontal: 75.0);
final _actionButtonShrinkedContainerPadding =
    EdgeInsets.symmetric(horizontal: 150.0);
final _actionButtonItemPadding =
    EdgeInsets.symmetric(horizontal: 8, vertical: 4);
final _actionButtonContainerBorderRadius = BorderRadius.circular(30);

class StaticFloatingActionButton extends StatelessWidget {
  const StaticFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _actionButtonFullSizedContainerPadding,
      child: _FullSizedWebViewButton(),
    );
  }
}

class AnimatedFloatingActionButton extends StatelessWidget {
  final Duration animationDuration;

  const AnimatedFloatingActionButton({
    super.key,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final isWebViewScrollingDown =
        context.watch<WebViewProvider>().isWebViewScollingDown;

    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeOut,
      padding: isWebViewScrollingDown
          ? _actionButtonFullSizedContainerPadding
          : _actionButtonShrinkedContainerPadding,
      child: isWebViewScrollingDown
          ? _FullSizedWebViewButton()
          : _ShrinkedWebViewButton(),
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
            _WebViewSearchButton(),
            SizedBox(width: 12),
            _WebViewShowNamuWikiOutlinesButton(),
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
      iconData: Icons.more_vert_outlined,
    );
  }
}

class _WebViewShowNamuWikiOutlinesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final namuWikiOutlines = context.watch<WebViewProvider>().namuWikiOutlines;
    return _WebViewButton(
      onTap: () async {
        if (namuWikiOutlines.isNotEmpty) {
          await showPlutoDialog(
            context: context,
            child: NamuWikiOutlinesDialog(),
          );
        } else {
          PlutoSnackBar.showFailureSnackBar(context, "목차를 불러올 수 없습니다.");
        }
      },
      iconData: Icons.subject,
    );
  }
}
