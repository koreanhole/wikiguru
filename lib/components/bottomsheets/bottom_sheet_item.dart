import 'package:flutter/material.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/base/theme/pluto_radius.dart';

const bottomSheetLabelTextStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: Colors.black,
);

const bottomSheetSublabelTextStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 12,
  color: PlutoColors.darkGrey,
);

class BottomSheetItem extends StatelessWidget {
  final String labelText;
  final String? subLabelText;
  final Widget? trailingIcon;
  final void Function()? onTap;
  const BottomSheetItem({
    super.key,
    required this.labelText,
    this.subLabelText,
    this.trailingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: PlutoColors.tertiaryColor,
            borderRadius: PlutoRadius.defaultBoxBorderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      labelText,
                      style: bottomSheetLabelTextStyle,
                    ),
                    if (subLabelText != null) ...[
                      SizedBox(height: 2),
                      Text(
                        subLabelText!,
                        style: bottomSheetSublabelTextStyle,
                      )
                    ]
                  ],
                ),
                if (trailingIcon != null) trailingIcon!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
