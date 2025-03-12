import 'package:flutter/material.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';

class WikiGuruAnimatedAppBar {
  final BuildContext context;
  final bool needFullSize;
  final Duration animationDuration;
  final String title;

  WikiGuruAnimatedAppBar({
    required this.context,
    required this.needFullSize,
    required this.animationDuration,
    required this.title,
  });
  PreferredSizeWidget build() {
    final fullSizedAppBarHeight = MediaQuery.of(context).padding.top + 48.0;
    final fullSizedAppBarTitleSize = 18.0;
    final shrinkedSizedAppBarHeight = MediaQuery.of(context).padding.top + 24.0;
    final shrinkedAppBarTitleSize = 14.0;
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
          backgroundColor: PlutoColors.backgroundColor,
          elevation: 3,
          scrolledUnderElevation: 3,
          title: FittedBox(
            child: Text(
              title,
              style: TextStyle(
                fontSize: needFullSize
                    ? fullSizedAppBarTitleSize
                    : shrinkedAppBarTitleSize,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
