import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  final String titleText;

  const DialogTitle({
    super.key,
    required this.titleText,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    );
  }
}
