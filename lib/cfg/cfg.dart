import 'dart:async';

export 'palette.dart';

class Wrapper<T> {
  T value;

  final StreamController<T> _streamController = StreamController<T>.broadcast();
  Stream<T> get stream => _streamController.stream;

  Wrapper(this.value);

  Wrapper<T> copy() {
    return Wrapper(value);
  }
}
