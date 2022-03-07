import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static SharedPreferences? _preferences;
  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value
  })async
  {
    if(value is String) return await _preferences!.setString(key, value);
    return await _preferences!.setBool(key, value);
  }

  static getData({required String key}){
    return _preferences!.get(key);
  }

  static Future<bool> removeData({required String key}) {
    return _preferences!.remove(key);
  }
}