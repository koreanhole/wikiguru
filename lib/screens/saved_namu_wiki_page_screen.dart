import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikiguru/components/wiki_guru_static_app_bar.dart';
import 'package:wikiguru/providers/hive_box_data_provider.dart';

class SavedNamuWikiPageScreen extends StatelessWidget {
  const SavedNamuWikiPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WikiGuruStaticAppBar(context: context, title: "저장된 페이지").build(),
      body: SafeArea(
        child: Text(
          context
                  .read<HiveBoxDataProvider>()
                  .getAllSavedNamuWikiHtmlData()
                  .firstOrNull
                  ?.htmlString ??
              "",
        ),
      ),
    );
  }
}
