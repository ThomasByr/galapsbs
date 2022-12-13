import 'dart:async';

import 'package:flutter/material.dart';

export 'palette.dart';

const int breakpoint = 600;

class Wrapper<T> {
  T value;
  Wrapper(this.value);

  Wrapper<T> copy() {
    return Wrapper(value);
  }
}

/// Returns a [TextSpan] with the given [text] and [style].
/// The [text] can contain markdown-like syntax to apply different styles.
/// For example, `**bold**` will make the text bold.
/// Supported syntax:
/// - `**bold**`
/// - `__underline__`
/// - `~~italic~~`
///
/// The [style] is applied to the whole text.
///
/// Example:
/// ```dart
/// Text.rich(textSpan(
///   'This is **bold** and this is __underlined__ and this is ~~italic~~',
///   style: const TextStyle(color: Colors.black),
/// ));
/// ```
TextSpan textSpan(String text, {TextStyle? style}) {
  final List<TextSpan> children = <TextSpan>[];
  final List<String> parts = text.split(RegExp(r'(?<=\*\*)|(?=\*\*)|(?<=__)|(?=__)|(?<=~~)|(?=~~)'));
  TextStyle currentStyle = style ?? const TextStyle();

  for (final String part in parts) {
    if (part == '**') {
      currentStyle = currentStyle.copyWith(
        fontWeight: currentStyle.fontWeight == FontWeight.bold ? FontWeight.normal : FontWeight.bold,
      );
    } else if (part == '__') {
      currentStyle = currentStyle.copyWith(
        decoration: currentStyle.decoration == TextDecoration.underline
            ? TextDecoration.none
            : TextDecoration.underline,
      );
    } else if (part == '~~') {
      currentStyle = currentStyle.copyWith(
        fontStyle: currentStyle.fontStyle == FontStyle.italic ? FontStyle.normal : FontStyle.italic,
      );
    } else {
      children.add(TextSpan(text: part, style: currentStyle));
    }
  }
  return TextSpan(children: children);
}
