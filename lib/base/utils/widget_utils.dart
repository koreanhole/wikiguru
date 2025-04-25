import 'package:flutter/material.dart';

List<Widget> addSpacingBetween({
  required List<Widget> widgets,
  required double widthSpacing,
}) {
  List<Widget> spaced = [];
  for (int i = 0; i < widgets.length; i++) {
    spaced.add(widgets[i]);
    if (i != widgets.length - 1) {
      spaced.add(SizedBox(width: widthSpacing)); // Row라면 width로 변경
    }
  }
  return spaced;
}
