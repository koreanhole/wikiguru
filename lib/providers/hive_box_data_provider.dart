import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum HiveBoxBooleanDataKey {
  isAnimatedFloatingActionButton,
}

class HiveBoxDataProvider with ChangeNotifier {
  final Box hiveBox;
  HiveBoxDataProvider(this.hiveBox) {
    hiveBox.watch().listen((event) {
      notifyListeners();
    });
  }

  bool getBooleanData(HiveBoxBooleanDataKey key) {
    return hiveBox.get(key.name, defaultValue: false);
  }

  Future<void> setBooleanData(HiveBoxBooleanDataKey key, bool value) async {
    await hiveBox.put(key.name, value);
  }
}
