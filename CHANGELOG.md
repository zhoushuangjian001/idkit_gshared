## 0.0.1

##### 1. Describe

This package is a solution to the relative troublesomeness of global data sharing in Flutter projects and requires a lot of code to be written. This package is easy to use, and the main process includes 3 main steps such as registration, reading, and logout. This package also supports asynchronous registration and monitoring of data.

##### 2. Extension methods and descriptions

- The factory method generates a globally shared management class.

  ```dart
  IDKitGShared factory IDKitGShared() => ...
  ```

- Register and manage the data objects to be shared.
  ```dart
  void register<T extends Object>( T? instance,{
      String? mark,
  })
  ```
- Get shared data object.

  ```dart
  T? read<T extends Object>({
      String? mark,
      bool disposable = false,
  })
  ```

- Unregister managed shared data objects.

  ```dart
  void unRegister<T extends Object>({
      String? mark,
  })
  ```

- Unregister all managed shared data objects.

  ```dart
  void unRegisterAll({
      bool listen = false,
  })
  ```

- Update shared data objects.

  ```dart
  void update<T extends Object>(
      T? Function(T? value) update, {
      String? mark,
  })
  ```

- Conveniently convert non-listening shared data objects into listening.

  ```dart
  void convertListen<T extends Object>({
      String? mark,
      bool broadcast = false,
      bool sync = false,
  })
  ```

- Registering a shared data object for listening mode.

  ```dart
  void registerListen<T extends Object>({
      String? mark,
      bool broadcast = false,
      bool sync = false,
  })
  ```

- Listen to shared visible listen data objects.

  ```dart
  Stream<T?>? watch<T extends Object>({
      String? mark,
  })
  ```

- Send listening shared data.

  ```dart
  void add<T extends Object>(
      T value, {
      String? mark,
  })
  ```

- Log out subscriber.

  ```dart
  void unRegisterListen<T extends Object>({
      String? mark,
  })
  ```

##### 3. Instructions for use

If you want to know more about this package, please check the [README](https://github.com/zhoushuangjian001/idkit_gshared/blob/master/README.md).
