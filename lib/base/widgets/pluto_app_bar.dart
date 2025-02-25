import 'package:flutter/material.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';

class PlutoAppBar extends AppBar {
  PlutoAppBar({
    super.key,
    required String title,
    super.actions,
  }) : super(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: PlutoColors.primaryColor),
          backgroundColor: PlutoColors.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
        );
}
