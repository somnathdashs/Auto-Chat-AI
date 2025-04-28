import 'package:shared_preferences/shared_preferences.dart';


enum MyKey {
  apiKey,
  details,
  Conversesion,
  Asyou,
  Whatsapp,
  WhatsappBusiness,
  // Add more key names here
}
String WhatsappBuissiness ="com.whatsapp.w4b";
String Whatsapp ="com.whatsapp";

class LocalStorage {

  static SharedPreferences? _prefs;

  /// Initializes the local storage. Call this once in your app's main function.
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Saves a string value to local storage.
  static Future<bool> saveString(String key, String value) async {
    _ensureInitialized();
    return await _prefs!.setString(key, value);
  }

  /// Gets a string value from local storage. Returns null if the key does not exist.
  static String? getString(String key) {
    _ensureInitialized();
    return _prefs!.getString(key);
  }

  /// Saves an integer value to local storage.
  static Future<bool> saveInt(String key, int value) async {
    _ensureInitialized();
    return await _prefs!.setInt(key, value);
  }

  /// Gets an integer value from local storage. Returns null if the key does not exist.
  static int? getInt(String key) {
    _ensureInitialized();
    return _prefs!.getInt(key);
  }

  /// Saves a boolean value to local storage.
  static Future<bool> saveBool(String key, bool value) async {
    _ensureInitialized();
    return await _prefs!.setBool(key, value);
  }

  /// Gets a boolean value from local storage. Returns null if the key does not exist.
  static bool? getBool(String key) {
    _ensureInitialized();
    return _prefs!.getBool(key);
  }

  /// Saves a double value to local storage.
  static Future<bool> saveDouble(String key, double value) async {
    _ensureInitialized();
    return await _prefs!.setDouble(key, value);
  }

  /// Gets a double value from local storage. Returns null if the key does not exist.
  static double? getDouble(String key) {
    _ensureInitialized();
    return _prefs!.getDouble(key);
  }

  /// Saves a list of strings to local storage.
  static Future<bool> saveStringList(String key, List<String> value) async {
    _ensureInitialized();
    return await _prefs!.setStringList(key, value);
  }

  /// Gets a list of strings from local storage. Returns null if the key does not exist.
  static List<String>? getStringList(String key) {
    _ensureInitialized();
    return _prefs!.getStringList(key);
  }

  /// Removes a value associated with the given key from local storage.
  static Future<bool> remove(String key) async {
    _ensureInitialized();
    return await _prefs!.remove(key);
  }

  /// Clears all data from local storage. Use with caution!
  static Future<bool> clear() async {
    _ensureInitialized();
    return await _prefs!.clear();
  }

  /// Ensures that the SharedPreferences instance has been initialized.
  static void _ensureInitialized() {
    if (_prefs == null) {
      throw Exception('Local storage has not been initialized. Call LocalStorage.initialize() in your main function.');
    }
  }
}