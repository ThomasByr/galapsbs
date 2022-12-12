import 'dart:async';

import 'package:flutter/material.dart';

export 'palette.dart';

const int breakpoint = 600;

class Wrapper<T> {
  T value;

  final StreamController<T> _streamController = StreamController<T>.broadcast();
  Stream<T> get stream => _streamController.stream;

  Wrapper(this.value);

  Wrapper<T> copy() {
    return Wrapper(value);
  }
}

TextSpan textSpan(String text, {TextStyle? style}) {
  final List<TextSpan> children = <TextSpan>[];
  final List<String> parts = text.split(RegExp(r'(?<=\*\*)|(?=\*\*)|(?<=__)|(?=__)'));
  TextStyle currentStyle = style ?? const TextStyle();

  for (final String part in parts) {
    if (part == '**') {
      // toggle bold
      currentStyle = currentStyle.copyWith(
        fontWeight: currentStyle.fontWeight == FontWeight.bold ? FontWeight.normal : FontWeight.bold,
      );
    } else if (part == '__') {
      // toggle underline
      currentStyle = currentStyle.copyWith(
        decoration: currentStyle.decoration == TextDecoration.underline
            ? TextDecoration.none
            : TextDecoration.underline,
      );
    } else {
      children.add(TextSpan(text: part, style: currentStyle));
    }
  }
  return TextSpan(children: children);
}
