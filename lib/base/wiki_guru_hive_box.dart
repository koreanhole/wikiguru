import 'package:hive_flutter/hive_flutter.dart';

const _wikiguruHiveBoxKey = "wikiguruHiveBox";

class WikiGuruHiveBoxService {
  // Singleton 인스턴스 생성
  static final WikiGuruHiveBoxService _instance =
      WikiGuruHiveBoxService._internal();

  factory WikiGuruHiveBoxService() {
    return _instance;
  }

  WikiGuruHiveBoxService._internal();

  bool _initialized = false;
  late Box _hiveBox;

  Future<void> initialize() async {
    if (!_initialized) {
      await Hive.initFlutter();
      // 필요한 경우 어댑터 등록: Hive.registerAdapter(YourAdapter());
      _hiveBox = await Hive.openBox(_wikiguruHiveBoxKey); // 사용할 박스 이름 지정
      _initialized = true;
    }
  }

  Box get box {
    if (!_initialized) {
      throw Exception("HiveService is not initialized. Call initHive() first.");
    }
    return _hiveBox;
  }
}
