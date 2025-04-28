extension NamuWikiUrlExtension on DateTime {
  String get formattedKoreanDateTime {
    return '$year년 '
        '$month월 '
        '$day일 '
        '$hour시'
        '${minute.toString().padLeft(2, '0')}분';
  }
}
