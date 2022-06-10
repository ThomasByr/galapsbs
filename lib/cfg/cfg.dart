export 'palette.dart';

class Wrapper<T> {
  T value;
  Wrapper(this.value);

  Wrapper<T> copy() {
    return Wrapper(value);
  }
}
