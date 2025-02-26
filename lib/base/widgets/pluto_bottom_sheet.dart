import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';

Future<T?> showPlutotBottomsheet<T>({
  required BuildContext context,
  required Widget child,
}) async {
  return showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: PlutoColors.backgroundColor,
      expand: false,
      builder: (context) => child);
}
