import '../animated.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class GlobalToggleProperties<T> {
  /// The position of the indicator relative to the indices of the values.
  final double position;

  /// The current value which is given to the switch.
  ///
  /// Helpful if the value is generated e.g.
  /// when the switch constructor is called.
  final T current;

  /// The previous value of the switch.
  final T? previous;

  /// The values which are given to the switch.
  ///
  /// Helpful if the list is generated e.g.
  /// when the switch constructor is called.
  final List<T> values;

  /// The previous position of the indicator relative
  /// to the indices of the values.
  final double previousPosition;

  /// The [TextDirection] of the switch.
  final TextDirection textDirection;

  /// The current [ToggleMode] of the switch.
  final ToggleMode mode;

  const GlobalToggleProperties({
    required this.position,
    required this.current,
    required this.previous,
    required this.values,
    required this.previousPosition,
    required this.textDirection,
    required this.mode,
  });
}

class DetailedGlobalToggleProperties<T> extends GlobalToggleProperties<T> {
  /// The final width of the space between the icons.
  ///
  /// May differ from the value passed to the switch.
  final double dif;

  /// The final size of the indicator.
  ///
  /// May differ from the value passed to the switch.
  final Size indicatorSize;

  /// The size of the switch exclusive the outer wrapper
  final Size switchSize;

  const DetailedGlobalToggleProperties({
    required this.dif,
    required this.indicatorSize,
    required this.switchSize,
    required double position,
    // TODO: Rename to current (small breaking change)
    required T value,
    required T? previousValue,
    required List<T> values,
    required double previousPosition,
    required TextDirection textDirection,
    required ToggleMode mode,
  }) : super(
          position: position,
          current: value,
          previous: previousValue,
          values: values,
          previousPosition: previousPosition,
          textDirection: textDirection,
          mode: mode,
        );
}

class LocalToggleProperties<T> {
  /// The value.
  final T value;

  /// The index of [value].
  final int index;

  const LocalToggleProperties({
    required this.value,
    required this.index,
  });
}

class AnimatedToggleProperties<T> extends LocalToggleProperties<T> {
  /// A value between 0 and 1.
  ///
  /// 0 indicates that [value] is not selected.
  /// 1 indicates that [value] is selected.
  final double animationValue;

  AnimatedToggleProperties.fromLocal({
    required this.animationValue,
    required LocalToggleProperties<T> properties,
  }) : super(value: properties.value, index: properties.index);

  const AnimatedToggleProperties({
    required T value,
    required int index,
    required this.animationValue,
  }) : super(
          value: value,
          index: index,
        );

  AnimatedToggleProperties<T> copyWith({T? value, int? index}) {
    return AnimatedToggleProperties(
        value: value ?? this.value, index: index ?? this.index, animationValue: animationValue);
  }
}

class RollingProperties<T> extends LocalToggleProperties<T> {
  /// The size the icon should currently have.
  final Size iconSize;

  /// Indicates if the icon is in the foreground.
  ///
  /// For [RollingIconBuilder] it indicates if the icon will be on the indicator
  /// or in the background.
  final bool foreground;

  RollingProperties.fromLocal({
    required Size iconSize,
    required bool foreground,
    required LocalToggleProperties<T> properties,
  }) : this(
          iconSize: iconSize,
          foreground: foreground,
          value: properties.value,
          index: properties.index,
        );

  const RollingProperties({
    required this.iconSize,
    required this.foreground,
    required T value,
    required int index,
  }) : super(
          value: value,
          index: index,
        );
}

class SizeProperties<T> extends AnimatedToggleProperties<T> {
  /// The size the icon should currently have.
  final Size iconSize;

  SizeProperties.fromAnimated({
    required Size iconSize,
    required AnimatedToggleProperties<T> properties,
  }) : this(
          iconSize: iconSize,
          value: properties.value,
          index: properties.index,
          animationValue: properties.animationValue,
        );

  const SizeProperties({
    required this.iconSize,
    required T value,
    required int index,
    required double animationValue,
  }) : super(
          value: value,
          index: index,
          animationValue: animationValue,
        );
}
