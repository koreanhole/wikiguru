import 'package:flutter/material.dart';

Future<T?> showPlutoDialog<T>({
  required BuildContext context,
  required Widget child,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      content: child,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '닫기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
