import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wikiguru/base/data/namu_wiki_html_data.dart';

enum HiveBoxBooleanDataKey {
  isAnimatedFloatingActionButton(true);

  final bool defaultValue;
  const HiveBoxBooleanDataKey(this.defaultValue);
}

enum HiveBoxHtmlDataKey {
  namuWiki;
}

class HiveBoxDataProvider with ChangeNotifier {
  final Box hiveBox;
  HiveBoxDataProvider(this.hiveBox) {
    hiveBox.watch().listen((event) {
      notifyListeners();
    });
  }

  bool getBooleanData(HiveBoxBooleanDataKey key) {
    return hiveBox.get(key.name, defaultValue: key.defaultValue);
  }

  Future<void> setBooleanData(HiveBoxBooleanDataKey key, bool value) async {
    await hiveBox.put(key.name, value);
  }

  Future<void> setNamuWikiHtmlData({
    required String htmlString,
    required String currentUrl,
  }) async {
    List<String> savedUrls = hiveBox.get(
      HiveBoxHtmlDataKey.namuWiki.name,
      defaultValue: List<String>.empty(growable: true),
    );
    savedUrls.add(currentUrl);
    await hiveBox.put(HiveBoxHtmlDataKey.namuWiki.name, savedUrls);
    await hiveBox.put(
      currentUrl,
      NamuWikiHtmlData(
        htmlString: htmlString,
        currentUrl: currentUrl,
        currentDateTime: DateTime.now(),
      ).toJson(),
    );
  }

  List<NamuWikiHtmlData> getAllSavedNamuWikiHtmlData() {
    final List<String> allSavedNamuWikiUrls = hiveBox.get(
      HiveBoxHtmlDataKey.namuWiki.name,
      defaultValue: List<String>.empty(),
    );
    if (allSavedNamuWikiUrls.isEmpty) {
      return List.empty();
    }
    return allSavedNamuWikiUrls
        .map(
          (url) => NamuWikiHtmlData.fromJson(
            hiveBox.get(url) as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
