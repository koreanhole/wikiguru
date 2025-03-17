import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:wikiguru/base/theme/pluto_theme.dart';
import 'package:wikiguru/base/wiki_guru_hive_box.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';
import 'package:wikiguru/providers/web_view_provider.dart';
import 'package:wikiguru/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WikiGuruHiveBoxService().initialize();

  runZonedGuarded(
    () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => WebViewProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => HiveBoxDataProvider(WikiGuruHiveBoxService().box),
          )
        ],
        child: WikiGuruApp(),
      ),
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
