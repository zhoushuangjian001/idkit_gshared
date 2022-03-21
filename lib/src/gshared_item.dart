import 'dart:async' show Stream, StreamController;

/// Storage object for shared data objects.
class GSharedListen<T extends Object> {
  const GSharedListen({
    required this.streamController,
    required this.instance,
  });

  /// Subscriber management objects for storage objects that share data objects.
  final StreamController<T?> streamController;

  /// Shared data object.
  final T? instance;

  /// Get a subscription stream for shared data objects.
  Stream<T?> get stream => streamController.stream;

  /// Release monitor object.
  void dispose() {
    streamController.close();
  }
}
