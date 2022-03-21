import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idkit_gshared/src/gshared_func.dart';

@immutable
class IDKitGShared {
  // Record shared data objects.
  late final Map<String, dynamic> _recordPool;
  // Record shared listening data object.
  late final Map<String, StreamController> _recordListenPool;
  // Shared management object construction.
  factory IDKitGShared() => _instance();
  static IDKitGShared _instance() => IDKitGShared._init();
  IDKitGShared._init() {
    _recordPool = {};
    _recordListenPool = {};
  }

  /// Register shared objects.
  ///
  /// [instance] --
  /// Shared object to register.
  ///
  /// [mark] --
  /// The unique identifier of the shared object to be registered.
  /// If there is only one shared object of the same type in the project,
  /// it can be used to distinguish it. Otherwise, it needs to be used to distinguish it.
  void register<T extends Object>(
    T? instance, {
    String? mark,
  }) {
    final Iterable<String> keys = _recordPool.keys;
    final String key = keyGet<T>(mark);
    if (keys.contains(key)) {
      _recordPool.update(key, (value) => instance);
    } else {
      _recordPool.putIfAbsent(key, () => instance);
    }
  }

  /// Get global shared object.
  ///
  /// [mark] --
  /// The unique identifier of the shared object to be registered.
  /// If there is only one shared object of the same type in the project,
  /// it can be used to distinguish it. Otherwise, it needs to be used to distinguish it.
  ///
  /// [disposable] --
  /// Gets whether the global shared object is one-time consumption.
  /// Even if you use it once, you can't use it again next time.
  T? read<T extends Object>({
    String? mark,
    bool disposable = false,
  }) {
    final String key = keyGet<T>(mark);
    if (disposable) {
      _recordPool.remove(key);
    }
    return instanceGet(_recordPool, key);
  }

  /// Unregister the specified global shared object.
  ///
  /// [mark] --
  /// The unique identifier of the shared object to be registered.
  /// If there is only one shared object of the same type in the project,
  /// it can be used to distinguish it. Otherwise, it needs to be used to distinguish it.
  void unRegister<T extends Object>({
    String? mark,
  }) {
    final Iterable<String> keys = _recordPool.keys;
    late String key = keyGet<T>(mark);
    if (keys.contains(key)) {
      _recordPool.remove(key);
    }
  }

  /// Unregister all global shared objects.
  ///
  /// [listen] --
  /// Distinguish between listening and non-listening global shared objects
  void unRegisterAll({
    bool listen = false,
  }) {
    _recordPool.clear();
    if (listen) {
      _recordListenPool.clear();
    }
  }

  /// Updates the specified global shared object.
  ///
  /// [update] --
  /// Callback event for updating shared data.
  ///
  /// [mark] --
  /// The unique identifier of the shared object to be registered.
  /// If there is only one shared object of the same type in the project,
  /// it can be used to distinguish it. Otherwise, it needs to be used to distinguish it.
  void update<T extends Object>(
    T? Function(T? value) update, {
    String? mark,
  }) {
    final String key = keyGet<T>(mark);
    final T? _instance = instanceGet(_recordPool, key);
    final T? item = update.call(_instance);
    if (_instance == null) {
      _recordPool.putIfAbsent(key, () => item);
    } else {
      _recordPool.update(key, (value) => item);
    }
  }

  /// Convert an object that has no listeners to a listener object.
  ///
  /// [mark] --
  /// Is the unique identifier of the shared data object before the query.
  ///
  /// [broadcast] --
  /// Listener broadcast form of shared object.
  ///
  /// [sync] --
  /// Whether the broadcast event should be delayed.
  void convertListen<T extends Object>({
    String? mark,
    bool broadcast = false,
    bool sync = false,
  }) {
    final String key = keyGet<T>(mark);
    final bool isExist = _recordPool.keys.contains(key);
    final StreamController<T> streamController = broadcast ? StreamController<T>.broadcast(sync: sync) : StreamController<T>(sync: sync);
    _recordListenPool[key] = streamController;
    if (isExist) {
      _recordPool.remove(key);
    }
  }

  /// Register a global shared listener object.
  ///
  /// [mark] --
  /// Is the unique identifier of the shared data object before the query.
  ///
  /// [broadcast] --
  /// Listener broadcast form of shared object.
  ///
  /// [sync] --
  /// Whether the broadcast event should be delayed.
  void registerListen<T extends Object>({
    String? mark,
    bool broadcast = false,
    bool sync = false,
  }) {
    final String key = keyGet<T>(mark);
    final StreamController<T> streamController = broadcast ? StreamController<T>.broadcast(sync: sync) : StreamController<T>(sync: sync);
    _recordListenPool[key] = streamController;
  }

  /// Subscribing to a shared listener data object.
  ///
  /// [mark] --
  /// Is the unique identifier of the shared data object before the query.
  Stream<T>? watch<T extends Object>({
    String? mark,
  }) {
    final String key = keyGet<T>(mark);
    final Iterable keys = _recordListenPool.keys;
    if (keys.contains(key)) {
      final StreamController<T>? gstreamController = instanceListenGet<T>(_recordListenPool, key);
      return gstreamController?.stream;
    }
    return null;
  }

  /// Send shared listening data.
  ///
  /// [value] --
  /// Shared listening data to send.
  ///
  /// [mark] --
  /// Check the unique identifier of the new sending carrier.
  void add<T extends Object>(
    T value, {
    String? mark,
  }) {
    final String key = keyGet<T>(mark);
    final Iterable keys = _recordListenPool.keys;
    if (keys.contains(key)) {
      final StreamController<T>? gstreamController = instanceListenGet(_recordListenPool, key);
      gstreamController?.add(value);
    }
  }

  /// Remove the specified listener object.
  ///
  /// [mark] --
  /// Query the unique identifier of the monitored object.
  void unRegisterListen<T extends Object>({
    String? mark,
  }) {
    final String key = keyGet<T>(mark);
    final Iterable keys = _recordListenPool.keys;
    if (keys.contains(key)) {
      final StreamController<T>? gstreamController = instanceListenGet(_recordListenPool, key);
      gstreamController?.close();
      _recordListenPool.remove(key);
    }
  }
}
