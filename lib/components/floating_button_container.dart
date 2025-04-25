import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/utils/widget_utils.dart';
import 'package:wikiguru/base/widgets/pluto_bottom_sheet.dart';
import 'package:wikiguru/base/widgets/pluto_dialog.dart';
import 'package:wikiguru/base/widgets/pluto_snack_bar.dart';
import 'package:wikiguru/base/wiki_guru_web_view_controller.dart';
import 'package:wikiguru/components/bottomsheets/more_bottom_sheets.dart';
import 'package:wikiguru/components/dialogs/namu_wiki_outlines_dialog.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';
import 'package:wikiguru/providers/web_view_provider.dart';

final _actionButtonItemPadding =
    EdgeInsets.symmetric(horizontal: 8, vertical: 4);
final _actionButtonContainerBorderRadius = BorderRadius.circular(30);
final _floatingButtonSpaceBetween = 12.0;
final double _floatingButtonContainerWidthMultiplier = 72;

final List<Widget> _fullSizedFloatingButtons = [
  _WebViewBackButton(),
  _WebViewSearchButton(),
  _WebViewShowNamuWikiOutlinesButton(),
  _WebViewMoreButton(),
];

final List<Widget> _shrinkedFloatingButtons = [
  _WebViewSearchButton(),
];

class FloatingButtonContainer extends StatelessWidget {
  final Duration animatedContainerDuration;
  const FloatingButtonContainer({
    super.key,
    required this.animatedContainerDuration,
  });

  @override
  Widget build(BuildContext context) {
    final hiveBoxDataProvider = context.watch<HiveBoxDataProvider>();

    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: hiveBoxDataProvider.getBooleanData(
              HiveBoxBooleanDataKey.isAnimatedFloatingActionButton)
          ? _AnimatedFloatingActionButton(
              animationDuration: animatedContainerDuration)
          : _StaticFloatingActionButton(),
    );
  }
}

class _StaticFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _floatingButtonContainerWidthMultiplier *
          _fullSizedFloatingButtons.length,
      child: _FullSizedWebViewButton(),
    );
  }
}

class _AnimatedFloatingActionButton extends StatelessWidget {
  final Duration animationDuration;

  const _AnimatedFloatingActionButton({
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    final isWebViewScrollingDown =
        context.watch<WebViewProvider>().isWebViewScollingDown;

    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeOut,
      width: isWebViewScrollingDown
          ? _floatingButtonContainerWidthMultiplier *
              _fullSizedFloatingButtons.length
          : _floatingButtonContainerWidthMultiplier *
              _shrinkedFloatingButtons.length,
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
            ...addSpacingBetween(
              widgets: _fullSizedFloatingButtons,
              widthSpacing: _floatingButtonSpaceBetween,
            ),
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
            ...addSpacingBetween(
              widgets: _shrinkedFloatingButtons,
              widthSpacing: _floatingButtonSpaceBetween,
            ),
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
    return _WebViewButton(
      onTap: () async {
        final namuWikiOutlines =
            context.read<WebViewProvider>().namuWikiOutlines;
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
