import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wikiguru/screens/home_screen.dart';
import 'package:wikiguru/screens/saved_namu_wiki_page_screen.dart';

enum WikiGuruRouteItems {
  savedNamuWikiPageScreen(
    WikiGuruRoute(
      path: '/savedNamuWikiPageScreen',
      screen: SavedNamuWikiPageScreen(),
    ),
  ),
  homeScreen(
    WikiGuruRoute(
      path: '/',
      screen: HomeScreen(),
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
