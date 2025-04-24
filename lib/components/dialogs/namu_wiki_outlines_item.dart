import 'package:flutter/material.dart';
import 'package:wikiguru/base/data/namu_wiki_outline.dart';
import 'package:wikiguru/base/theme/pluto_colors.dart';

class NamuWikiOutlinesItem extends StatelessWidget {
  final NamuWikiOutline outlineItem;
  const NamuWikiOutlinesItem({
    super.key,
    required this.outlineItem,
  });

  @override
  Widget build(BuildContext context) {
    final indent = '    ' * outlineItem.depth;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '$indent${_getBulletinNumbering(outlineItem)}.',
            ),
            SizedBox(width: 2),
            Text(
              outlineItem.label,
              style: TextStyle(
                color: PlutoColors.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
      ],
    );
  }

  String _getBulletinNumbering(NamuWikiOutline outlineItem) {
    return outlineItem.href.replaceFirst('s-', '');
  }
}
