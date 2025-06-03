import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum HiveBoxBooleanDataKey {
  isAnimatedFloatingActionButton(true),
  isContentBlockerEnabled(true);

  final bool defaultValue;
  const HiveBoxBooleanDataKey(this.defaultValue);
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
}
