import 'package:flutter/material.dart';
import 'package:wikiguru/base/data/namu_wiki_outline.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';
import 'package:wikiguru/webview/web_view_navigator.dart';

class NamuWikiOutlinesItem extends StatelessWidget {
  final NamuWikiOutline outlineItem;
  const NamuWikiOutlinesItem({
    super.key,
    required this.outlineItem,
  });

  @override
  Widget build(BuildContext context) {
    final indent = '    ' * outlineItem.depth;
    return GestureDetector(
      onTap: () {
        WebViewNavigator(context: context).goOutlinePage(outlineItem);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$indent${_getBulletinNumbering(outlineItem)}.',
              ),
              SizedBox(width: 2),
              Expanded(
                child: Text(
                  outlineItem.label,
                  style: TextStyle(
                    color: PlutoColors.primaryColor,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }

  String _getBulletinNumbering(NamuWikiOutline outlineItem) {
    return outlineItem.href.replaceFirst('s-', '');
  }
}
