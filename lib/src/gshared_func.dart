import 'dart:async' show StreamController;

/// Get the key of the key-value pair of the shared data object.
String keyGet<T extends Object>(String? mark) {
  return mark ?? T.toString();
}

/// Get shared data object.
T? instanceGet<T extends Object>(Map<String, dynamic> map, String key) {
  late T? _instance;
  try {
    _instance = map.cast<String, T?>()[key];
  } catch (e) {
    _instance = null;
  }
  return _instance;
}

/// Get the shared listener data object.
StreamController<T>? instanceListenGet<T extends Object>(Map<String, StreamController> map, String key) {
  late StreamController<T>? _gSharedListen;
  try {
    _gSharedListen = map.cast<String, StreamController<T>>()[key];
  } catch (e) {
    _gSharedListen = null;
  }
  return _gSharedListen;
}
