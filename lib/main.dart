import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:wikiguru/base/theme/pluto_theme.dart';
import 'package:wikiguru/base/wiki_guru_hive_box.dart';
import 'package:wikiguru/base/wiki_guru_router.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';
import 'package:wikiguru/webview/web_view_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WikiGuruHiveBoxService().initialize();
  runApp(
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
  );
  PlatformDispatcher.instance.onError = (error, stack) {
    Logger().e('error: $error, stackTrace: $stack');
    return true;
  };
}

class WikiGuruApp extends StatelessWidget {
  const WikiGuruApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: PlutoTheme.materialTheme,
      routerConfig: WikiGuruRouter.router,
    );
  }
}
