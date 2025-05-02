import 'package:flutter/material.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/utils/web_view_navigator.dart';

class WikiGuruAnimatedAppBar {
  final BuildContext context;
  final bool needFullSize;
  final bool needGoBackButton;
  final Duration animationDuration;
  final String title;

  WikiGuruAnimatedAppBar({
    required this.context,
    required this.needFullSize,
    required this.needGoBackButton,
    required this.animationDuration,
    required this.title,
  });
  PreferredSizeWidget build() {
    final fullSizedAppBarHeight = MediaQuery.of(context).padding.top + 48.0;
    final fullSizedAppBarTitleSize = 18.0;
    final shrinkedSizedAppBarHeight = MediaQuery.of(context).padding.top + 24.0;
    final shrinkedAppBarTitleSize = 12.0;
    return PreferredSize(
      preferredSize: Size.fromHeight(
        needFullSize ? fullSizedAppBarHeight : shrinkedSizedAppBarHeight,
      ),
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeOut,
        height:
            needFullSize ? fullSizedAppBarHeight : shrinkedSizedAppBarHeight,
        child: AppBar(
          backgroundColor: PlutoColors.tertiaryColor,
          elevation: 3,
          scrolledUnderElevation: 3,
          leading: needFullSize && needGoBackButton
              ? _GoBackButton()
              : SizedBox.shrink(),
          actions: needFullSize ? [_RefreshButton()] : [],
          title: FittedBox(
            child: AnimatedDefaultTextStyle(
              duration: animationDuration,
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: needFullSize
                    ? fullSizedAppBarTitleSize
                    : shrinkedAppBarTitleSize,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              child: Text(
                title,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.keyboard_backspace),
      onPressed: () {
        WebViewNavigator(context: context).goBack();
      },
    );
  }
}

class _RefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {
        WebViewNavigator(context: context).refresh();
      },
    );
  }
}
