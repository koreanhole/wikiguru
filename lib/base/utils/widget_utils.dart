import 'package:flutter/material.dart';

List<Widget> addSpacingBetween(
    {required List<Widget> widgets,
    double widthSpacing = 0.0,
    double heightSpacing = 0.0}) {
  List<Widget> spaced = [];
  for (int i = 0; i < widgets.length; i++) {
    spaced.add(widgets[i]);
    if (i != widgets.length - 1) {
      spaced.add(SizedBox(
        width: widthSpacing,
        height: heightSpacing,
      )); // Row라면 width로 변경
    }
  }
  return spaced;
}
