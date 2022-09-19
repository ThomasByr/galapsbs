import 'dart:async';

export 'palette.dart';

class Wrapper<T> {
  T value;
  // stream to listen to changes
  final StreamController<T> _streamController = StreamController<T>.broadcast();
  // getter for the stream
  Stream<T> get stream => _streamController.stream;

  Wrapper(this.value);

  Wrapper<T> copy() {
    return Wrapper(value);
  }
}
