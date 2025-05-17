import 'package:flutter/material.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';

class WikiGuruStaticAppBar {
  final BuildContext context;
  final String title;

  WikiGuruStaticAppBar({
    required this.context,
    required this.title,
  });
  PreferredSizeWidget build() {
    final fullSizedAppBarHeight = MediaQuery.of(context).padding.top + 48.0;
    final fullSizedAppBarTitleSize = 18.0;
    return PreferredSize(
      preferredSize: Size.fromHeight(fullSizedAppBarHeight),
      child: SizedBox(
        height: fullSizedAppBarHeight,
        child: AppBar(
          backgroundColor: PlutoColors.tertiaryColor,
          elevation: 3,
          scrolledUnderElevation: 3,
          title: FittedBox(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fullSizedAppBarTitleSize,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
