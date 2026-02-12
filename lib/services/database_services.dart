import 'package:shared_preferences/shared_preferences.dart';

class DatabaseServices {
  Future<bool?> saveUrlLists(String key, List<String> urls) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result = await prefs.setStringList(key, urls);
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // get url lists
  Future<List<String>?> getUrlLists(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result = prefs.getStringList(key);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
