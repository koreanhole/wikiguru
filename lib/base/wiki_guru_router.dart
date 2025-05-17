import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wikiguru/screens/wiki_web_view_screen.dart';

enum WikiGuruRouteItems {
  homeScreen(
    WikiGuruRoute(
      path: '/',
      screen: WikiWebViewScreen(),
    ),
  );

  final WikiGuruRoute item;
  const WikiGuruRouteItems(this.item);
}

class WikiGuruRoute {
  final String path;
  final Widget screen;

  const WikiGuruRoute({
    required this.path,
    required this.screen,
  });
}

class WikiGuruRouter {
  static final GoRouter router = GoRouter(
    routes: WikiGuruRouteItems.values
        .map(
          (element) => GoRoute(
            path: element.item.path,
            pageBuilder: (context, state) =>
                MaterialPage(child: element.item.screen),
          ),
        )
        .toList(),
  );
}
