import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:wikiguru/base/theme/pluto_theme.dart';
import 'package:wikiguru/screens/home_screen.dart';

void main() {
  runZonedGuarded(
    () => runApp(
      WikiGuruApp(),
    ),
    (error, stackTrace) {
      Logger().e('error: $error, stackTrace: $stackTrace');
    },
  );
}

class WikiGuruApp extends StatelessWidget {
  const WikiGuruApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: PlutoTheme.materialTheme,
      home: const HomeScreen(),
    );
  }
}
