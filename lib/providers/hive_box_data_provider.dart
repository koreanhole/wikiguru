import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxDataProvider with ChangeNotifier {
  final Box hiveBox;
  HiveBoxDataProvider(this.hiveBox) {
    hiveBox.watch().listen((event) {
      notifyListeners();
    });
  }

  dynamic getData(String key) {
    return hiveBox.get(key);
  }

  Future<void> setData(String key, dynamic value) async {
    await hiveBox.put(key, value);
  }
}
