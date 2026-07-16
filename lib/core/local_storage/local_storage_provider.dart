import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final localStorageProvider = Provider<Box>((ref) {
  throw UnimplementedError('localStorageProvider must be overridden');
});

class LocalStorageService {
  LocalStorageService._();

  static Future<Box> init() async {
    await Hive.initFlutter();
    return await Hive.openBox('lingu_ai_box');
  }
}
