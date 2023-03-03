import 'package:get_storage/get_storage.dart';

mixin CacheManager {
  Future<bool> saveToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  Future<bool> saveRefreshToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.REFRESHTOKEN.toString(), token);
    return true;
  }

  String? getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.TOKEN.toString());
  }

  String? getRefreshToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.REFRESHTOKEN.toString());
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.TOKEN.toString());
  }

  Future<void> removeRefreshToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.REFRESHTOKEN.toString());
  }
}

enum CacheManagerKey {
  TOKEN,
  REFRESHTOKEN
}