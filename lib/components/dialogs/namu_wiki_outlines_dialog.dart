import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikiguru/components/dialogs/dialog_title.dart';
import 'package:wikiguru/components/dialogs/namu_wiki_outlines_item.dart';
import 'package:wikiguru/providers/web_view_provider.dart';

class NamuWikiOutlinesDialog extends StatelessWidget {
  const NamuWikiOutlinesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final namuWikiTitle = context.read<WebViewProvider>().namuWikiTitle;
    final namuWikiOutlines = context.read<WebViewProvider>().namuWikiOutlines;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24),
            DialogTitle(titleText: "목차($namuWikiTitle)"),
            SizedBox(height: 16),
            ...namuWikiOutlines.map(
              (item) => NamuWikiOutlinesItem(
                outlineItem: item,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
