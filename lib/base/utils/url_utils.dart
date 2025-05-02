extension NamuWikiUrlExtension on String {
  /// Namuwiki URL에서 "https://namu.wiki/w/" 접두사와
  /// '?from=' 이후의 내용을 제거한 제목을 반환합니다.
  /// 만약 두 요소가 모두 없다면 null을 반환합니다.
  String? get cleanNamuTitle {
    const prefix = "https://namu.wiki/w/";
    // 접두사나 '?from=' 둘 다 없으면 null 반환
    if (!startsWith(prefix) && !contains('?from=')) {
      return null;
    }

    String result = this;

    // 접두사가 있으면 제거
    if (result.startsWith(prefix)) {
      result = result.substring(prefix.length);
    }

    // '?from=' 이후의 부분 제거
    int fromIndex = result.indexOf('?from=');
    if (fromIndex != -1) {
      result = result.substring(0, fromIndex);
    }

    // '#' 이후의 부분 제거
    int hashTagIndex = result.indexOf('#');
    if (hashTagIndex != -1) {
      result = result.substring(0, hashTagIndex);
    }

    return result;
  }

  String? get cleanNamuTitleDecode {
    return Uri.decodeFull(this).cleanNamuTitle;
  }
}
