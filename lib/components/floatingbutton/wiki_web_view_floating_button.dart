import 'package:flutter/material.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';

class WikiWebViewFloatingButton extends StatelessWidget {
  final void Function()? onTap;
  final IconData? iconData;

  const WikiWebViewFloatingButton({
    super.key,
    required this.onTap,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: iconData,
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
