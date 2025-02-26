import 'package:flutter/material.dart';

class BottomSheetTitle extends StatelessWidget {
  final String titleText;

  const BottomSheetTitle({
    super.key,
    required this.titleText,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        titleText,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }
}
