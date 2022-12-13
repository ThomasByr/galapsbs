import '../../animated.dart';
import 'drag_region.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Custom builder for icons in the switch.
typedef CustomIconBuilder<T> = Widget Function(
    BuildContext context, LocalToggleProperties<T> local, DetailedGlobalToggleProperties<T> global);

/// Custom builder for the indicator of the switch.
typedef CustomIndicatorBuilder<T> = Widget Function(
    BuildContext context, DetailedGlobalToggleProperties<T> global);

/// Custom builder for the wrapper of the switch.
typedef CustomWrapperBuilder<T> = Widget Function(
    BuildContext context, GlobalToggleProperties<T> local, Widget child);

enum FittingMode { none, preventHorizontalOverlapping }

enum IconArrangement {
  /// Indicates that the icons should be in a row.
  ///
  /// This is the default setting.
  row,

  /// Indicates that the icons should overlap.
  /// Normally you don't need this setting unless you want the icons to overlap.
  ///
  /// This is used for example with [AnimatedToggleSwitch.dual],
  /// because the texts partially overlap here.
  overlap
}

class CustomAnimatedToggleSwitch<T> extends StatefulWidget {
  /// The currently selected value. It has to be set at [onChanged] or whenever for animating to this value.
  ///
  /// [current] has to be in [values] for working correctly.
  final T current;

  /// All possible values.
  final List<T> values;

  /// The IconBuilder for all icons with the specified size.
  final CustomWrapperBuilder<T>? wrapperBuilder;

  /// The IconBuilder for all icons with the specified size.
  final CustomIconBuilder<T> iconBuilder;

  /// A builder for an indicator which is in front of the icons.
  final CustomIndicatorBuilder<T>? foregroundIndicatorBuilder;

  /// A builder for an indicator which is in behind the icons.
  final CustomIndicatorBuilder<T>? backgroundIndicatorBuilder;

  /// Duration of the motion animation.
  final Duration animationDuration;

  /// Curve of the motion animation.
  final Curve animationCurve;

  /// Size of the indicator.
  final Size indicatorSize;

  /// Callback for selecting a new value. The new [current] should be set here.
  final Function(T)? onChanged;

  /// Space between the "indicator rooms" of the adjacent icons.
  final double dif;

  /// Callback for tapping anywhere on the widget.
  final Function()? onTap;

  /// Indicates if [onChanged] is called when an icon is tapped.
  /// If [false] the user can change the value only by dragging the indicator.
  final bool iconsTappable;

  /// Indicates if the icons should overlap.
  ///
  /// Defaults to [IconArrangement.row] because it fits the most use cases.
  final IconArrangement iconArrangement;

  /// The [FittingMode] of the switch.
  ///
  /// Change this only if you don't want the switch to adjust when the constraints are too small.
  final FittingMode fittingMode;

  /// The height of the whole switch including wrapper.
  final double height;

  /// A padding between wrapper and icons/indicator.
  final EdgeInsetsGeometry padding;

  /// The minimum width of the indicator's hitbox.
  ///
  /// Helpful if the indicator is so small that you can hardly grip it.
  final double minTouchTargetSize;

  /// The duration for the animation to the thumb when the user starts dragging.
  final Duration dragStartDuration;

  /// The curve for the animation to the thumb when the user starts dragging.
  final Curve dragStartCurve;

  /// The direction in which the icons are arranged.
  ///
  /// If set to null, the [TextDirection] is taken from the [BuildContext].
  final TextDirection? textDirection;

  /// [MouseCursor] to show when not hovering an indicator.
  ///
  /// Defaults to [SystemMouseCursors.click] if [iconsTappable] is [true]
  /// and to [MouseCursor.defer] otherwise.
  final MouseCursor? defaultCursor;

  /// [MouseCursor] to show when grabbing the indicators.
  final MouseCursor draggingCursor;

  /// [MouseCursor] to show when hovering the indicators.
  final MouseCursor dragCursor;

  const CustomAnimatedToggleSwitch({
    Key? key,
    required this.current,
    required this.values,
    required this.iconBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCirc,
    this.indicatorSize = const Size(48.0, double.infinity),
    this.onChanged,
    this.dif = 0.0,
    this.onTap,
    this.fittingMode = FittingMode.preventHorizontalOverlapping,
    this.wrapperBuilder,
    this.foregroundIndicatorBuilder,
    this.backgroundIndicatorBuilder,
    this.height = 50.0,
    this.iconArrangement = IconArrangement.row,
    this.iconsTappable = true,
    this.padding = EdgeInsets.zero,
    this.minTouchTargetSize = 48.0,
    this.dragStartDuration = const Duration(milliseconds: 200),
    this.dragStartCurve = Curves.easeInOutCirc,
    this.textDirection,
    this.defaultCursor,
    this.draggingCursor = SystemMouseCursors.grabbing,
    this.dragCursor = SystemMouseCursors.grab,
  })  : assert(foregroundIndicatorBuilder != null || backgroundIndicatorBuilder != null),
        super(key: key);

  @override
  _CustomAnimatedToggleSwitchState createState() => _CustomAnimatedToggleSwitchState<T>();
}

class _CustomAnimatedToggleSwitchState<T> extends State<CustomAnimatedToggleSwitch<T>>
    with SingleTickerProviderStateMixin {
  /// The [AnimationController] for the movement of the indicator.
  late final AnimationController _controller;

  /// The [Animation] for the movement of the indicator.
  late CurvedAnimation _animation;

  /// The current state of the movement of the indicator.
  late _AnimationInfo _animationInfo;

  @override
  void initState() {
    super.initState();

    _animationInfo = _AnimationInfo(widget.values.indexOf(widget.current).toDouble());
    _controller = AnimationController(vsync: this, duration: widget.animationDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && _animationInfo.toggleMode != ToggleMode.dragged) {
          _animationInfo = _animationInfo.ended();
        }
      });

    _animation = CurvedAnimation(parent: _controller, curve: widget.animationCurve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomAnimatedToggleSwitch<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkValuePosition();
  }

  /// Checks if the current value has a different position than the indicator
  /// and starts an animation if necessary.
  void _checkValuePosition() {
    if (_animationInfo.toggleMode == ToggleMode.dragged) return;
    int index = widget.values.indexOf(widget.current);
    if (index != _animationInfo.end) _animateTo(index);
  }

  /// Returns the value position by the local position of the cursor.
  /// It is mainly intended as a helper function for the build method.
  double _doubleFromPosition(double x, DetailedGlobalToggleProperties properties) {
    double result = (x.clamp(properties.indicatorSize.width / 2,
                properties.switchSize.width - properties.indicatorSize.width / 2) -
            properties.indicatorSize.width / 2) /
        (properties.indicatorSize.width + properties.dif);
    if (properties.textDirection == TextDirection.rtl) result = widget.values.length - 1 - result;
    return result;
  }

  /// Returns the value index by the local position of the cursor.
  /// It is mainly intended as a helper function for the build method.
  int _indexFromPosition(double x, DetailedGlobalToggleProperties properties) {
    return _doubleFromPosition(x, properties).round();
  }

  /// Returns the value by the local position of the cursor.
  /// It is mainly intended as a helper function for the build method.
  T _valueFromPosition(double x, DetailedGlobalToggleProperties properties) {
    return widget.values[_indexFromPosition(x, properties)];
  }

  @override
  Widget build(BuildContext context) {
    double dif = widget.dif;
    final textDirection = _textDirectionOf(context);

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            double positionValue =
                _animationInfo.valueAt(_animation.value).clamp(0, widget.values.length - 1);
            GlobalToggleProperties<T> properties = GlobalToggleProperties(
              position: positionValue,
              current: widget.current,
              previous: _animationInfo.start.toInt() == _animationInfo.start
                  ? widget.values[_animationInfo.start.toInt()]
                  : null,
              values: widget.values,
              previousPosition: _animationInfo.start,
              textDirection: textDirection,
              mode: _animationInfo.toggleMode,
            );
            Widget child = Padding(
              padding: widget.padding,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double height = constraints.maxHeight;
                  assert(
                      constraints.maxWidth.isFinite || widget.indicatorSize.width.isFinite,
                      "With unbound width constraints "
                      "the width of the indicator can't be infinite");

                  // Recalculates the indicatorSize if its width or height is
                  // infinite.
                  Size indicatorSize = Size(
                      widget.indicatorSize.width.isInfinite
                          ? (constraints.maxWidth - dif * (widget.values.length - 1)) / widget.values.length
                          : widget.indicatorSize.width,
                      widget.indicatorSize.height.isInfinite ? height : widget.indicatorSize.height);

                  // Calculates the required width of the widget.
                  double width =
                      indicatorSize.width * widget.values.length + (widget.values.length - 1) * dif;

                  // Handles the case that the required width of the widget
                  // cannot be used due to the given BoxConstraints.
                  if (widget.fittingMode == FittingMode.preventHorizontalOverlapping &&
                      width > constraints.maxWidth) {
                    double factor = constraints.maxWidth / width;
                    dif *= factor;
                    width = constraints.maxWidth;
                    indicatorSize = Size(
                        indicatorSize.width.isInfinite
                            ? width / widget.values.length
                            : factor * indicatorSize.width,
                        indicatorSize.height);
                  } else if (constraints.minWidth > width) {
                    dif += (constraints.minWidth - width) / (widget.values.length - 1);
                    width = constraints.minWidth;
                  }

                  // The additional width of the indicator's hitbox needed
                  // to reach the minTouchTargetSize.
                  double dragDif = indicatorSize.width < widget.minTouchTargetSize
                      ? (widget.minTouchTargetSize - indicatorSize.width)
                      : 0;

                  // The local position of the indicator.
                  double position = (indicatorSize.width + dif) * positionValue + indicatorSize.width / 2;

                  bool isHoveringIndicator(Offset offset) {
                    double dx = textDirection == TextDirection.rtl ? width - offset.dx : offset.dx;
                    return position - (indicatorSize.width + dragDif) / 2 <= dx &&
                        dx <= (position + (indicatorSize.width + dragDif) / 2);
                  }

                  DetailedGlobalToggleProperties<T> properties = DetailedGlobalToggleProperties(
                    dif: dif,
                    position: positionValue,
                    indicatorSize: indicatorSize,
                    switchSize: Size(width, height),
                    value: widget.current,
                    previousValue: _animationInfo.start.toInt() == _animationInfo.start
                        ? widget.values[_animationInfo.start.toInt()]
                        : null,
                    values: widget.values,
                    previousPosition: _animationInfo.start,
                    textDirection: textDirection,
                    mode: _animationInfo.toggleMode,
                  );

                  List<Widget> stack = <Widget>[
                    if (widget.backgroundIndicatorBuilder != null)
                      _Indicator(
                        textDirection: textDirection,
                        height: height,
                        indicatorSize: indicatorSize,
                        position: position,
                        child: widget.backgroundIndicatorBuilder!(context, properties),
                      ),
                    ...(widget.iconArrangement == IconArrangement.overlap
                        ? _buildBackgroundStack(context, properties)
                        : _buildBackgroundRow(context, properties)),
                    if (widget.foregroundIndicatorBuilder != null)
                      _Indicator(
                        textDirection: textDirection,
                        height: height,
                        indicatorSize: indicatorSize,
                        position: position,
                        child: widget.foregroundIndicatorBuilder!(context, properties),
                      ),
                  ];

                  return SizedBox(
                    width: width,
                    height: height,
                    // manual check if cursor is above indicator
                    // to make sure that GestureDetector and MouseRegion match.
                    // TODO: one widget for DragRegion and GestureDetector to avoid redundancy
                    child: DragRegion(
                      dragging: _animationInfo.toggleMode == ToggleMode.dragged,
                      draggingCursor: widget.draggingCursor,
                      dragCursor: widget.dragCursor,
                      hoverCheck: isHoveringIndicator,
                      defaultCursor: widget.defaultCursor ??
                          (widget.iconsTappable ? SystemMouseCursors.click : MouseCursor.defer),
                      child: GestureDetector(
                        dragStartBehavior: DragStartBehavior.down,
                        onTapUp: (details) {
                          widget.onTap?.call();
                          if (!widget.iconsTappable) return;
                          T newValue = _valueFromPosition(details.localPosition.dx, properties);
                          if (newValue == widget.current) return;
                          widget.onChanged?.call(newValue);
                        },
                        onHorizontalDragStart: (details) {
                          if (!isHoveringIndicator(details.localPosition)) return;
                          _onDragged(
                              _doubleFromPosition(details.localPosition.dx, properties), positionValue);
                        },
                        onHorizontalDragUpdate: (details) {
                          _onDragUpdate(_doubleFromPosition(details.localPosition.dx, properties));
                        },
                        onHorizontalDragEnd: (details) {
                          _onDragEnd();
                        },
                        // DecoratedBox for gesture detection
                        child: DecoratedBox(
                            position: DecorationPosition.background,
                            decoration: const BoxDecoration(),
                            child: Stack(clipBehavior: Clip.none, children: stack)),
                      ),
                    ),
                  );
                },
              ),
            );
            return widget.wrapperBuilder?.call(context, properties, child) ?? child;
          }),
    );
  }

  /// The builder of the icons for [IconArrangement.overlap].
  List<Positioned> _buildBackgroundStack(BuildContext context, DetailedGlobalToggleProperties<T> properties) {
    return List.generate(widget.values.length, (i) {
      double position = i * (properties.indicatorSize.width + properties.dif);
      return Positioned.directional(
        textDirection: _textDirectionOf(context),
        start: i == 0 ? position : position - properties.dif,
        width: (i == 0 || i == widget.values.length - 1 ? 1 : 2) * properties.dif +
            properties.indicatorSize.width,
        height: properties.indicatorSize.height,
        child:
            widget.iconBuilder(context, LocalToggleProperties(value: widget.values[i], index: i), properties),
      );
    }).toList();
  }

  /// The builder of the icons for [IconArrangement.row].
  List<Widget> _buildBackgroundRow(BuildContext context, DetailedGlobalToggleProperties<T> properties) {
    return [
      Row(
        textDirection: _textDirectionOf(context),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.values.length,
          (i) => SizedBox(
            width: properties.indicatorSize.width,
            height: properties.indicatorSize.height,
            child: widget.iconBuilder(
                context, LocalToggleProperties(value: widget.values[i], index: i), properties),
          ),
        ),
      ),
    ];
  }

  /// Animates the indicator to a specific item by its index.
  void _animateTo(int index, {double? current}) {
    if (index.toDouble() == _animationInfo.end || _animationInfo.toggleMode == ToggleMode.dragged) return;
    _animationInfo =
        _animationInfo.toEnd(index.toDouble(), current: current ?? _animationInfo.valueAt(_animation.value));
    _controller.duration = widget.animationDuration;
    _animation.curve = widget.animationCurve;
    _controller.forward(from: 0.0);
  }

  /// Starts the dragging of the indicator and starts the animation to
  /// the current cursor position.
  void _onDragged(double indexPosition, double pos) {
    _animationInfo = _animationInfo.dragged(indexPosition, pos: pos);
    _controller.duration = widget.dragStartDuration;
    _animation.curve = widget.dragStartCurve;
    _controller.forward(from: 0.0);
  }

  /// Updates the current drag position.
  void _onDragUpdate(double indexPosition) {
    if (_animationInfo.toggleMode != ToggleMode.dragged) return;
    setState(() {
      _animationInfo = _animationInfo.dragged(indexPosition);
    });
  }

  /// Ends the dragging of the indicator and starts an animation
  /// to the new value if necessary.
  void _onDragEnd() {
    if (_animationInfo.toggleMode != ToggleMode.dragged) return;
    int index = _animationInfo.end.round();
    T newValue = widget.values[index];
    if (widget.current != newValue) widget.onChanged?.call(newValue);
    _animationInfo = _animationInfo.none(current: _animationInfo.end);
    _checkValuePosition();
  }

  /// Returns the [TextDirection] of the widget.
  TextDirection _textDirectionOf(BuildContext context) =>
      widget.textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr;
}

/// The [Positioned] for an indicator. It is used as wrapper for
/// [CustomAnimatedToggleSwitch.foregroundIndicatorBuilder] and
/// [CustomAnimatedToggleSwitch.backgroundIndicatorBuilder].
class _Indicator extends StatelessWidget {
  final double height;
  final Size indicatorSize;
  final double position;
  final Widget child;
  final TextDirection textDirection;

  const _Indicator({
    Key? key,
    required this.height,
    required this.indicatorSize,
    required this.position,
    required this.child,
    required this.textDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      textDirection: textDirection,
      top: (height - indicatorSize.height) / 2,
      start: position - indicatorSize.width / 2,
      width: indicatorSize.width,
      height: indicatorSize.height,
      child: SizedBox(
        width: indicatorSize.width,
        child: child,
      ),
    );
  }
}

/// A class for holding the current state of [_CustomAnimatedToggleSwitchState].
class _AnimationInfo {
  final double start;
  final double end;
  final ToggleMode toggleMode;

  const _AnimationInfo(this.start, {this.toggleMode = ToggleMode.none}) : end = start;

  const _AnimationInfo._internal(this.start, this.end, {this.toggleMode = ToggleMode.none});

  const _AnimationInfo.animating(this.start, this.end) : toggleMode = ToggleMode.animating;

  _AnimationInfo toEnd(double end, {double? current}) => _AnimationInfo.animating(current ?? start, end);

  _AnimationInfo none({double? current}) => _AnimationInfo(current ?? start, toggleMode: ToggleMode.none);

  _AnimationInfo ended() => _AnimationInfo(end);

  _AnimationInfo dragged(double current, {double? pos}) => _AnimationInfo._internal(
        pos ?? start,
        current,
        toggleMode: ToggleMode.dragged,
      );

  double valueAt(num position) => start + (end - start) * position;
}
