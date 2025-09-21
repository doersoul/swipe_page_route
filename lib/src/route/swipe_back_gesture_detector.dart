import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swipe_page_route/src/gestures/page_drag_listener.dart';
import 'package:swipe_page_route/src/gestures/page_drag_mixin.dart';
import 'package:swipe_page_route/src/gestures/page_drag_recognizer.dart';
import 'package:swipe_page_route/src/route/swipe_back_gesture_controller.dart';

/// copied from [_CupertinoBackGestureDetector]
class SwipeBackGestureDetector<T> extends StatefulWidget {
  final ValueGetter<bool> canOnlySwipeFromEdge;
  final ValueGetter<double> backGestureDetectionWidth;
  final ValueGetter<double> backGestureDetectionStartOffset;
  final ValueGetter<bool> enabledCallback;
  final ValueGetter<SwipeBackGestureController<T>?> onStartPopGesture;
  final Widget child;

  const SwipeBackGestureDetector({
    super.key,
    required this.canOnlySwipeFromEdge,
    required this.backGestureDetectionWidth,
    required this.backGestureDetectionStartOffset,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _SwipeBackGestureDetectorState();
}

class _SwipeBackGestureDetectorState<T>
    extends State<SwipeBackGestureDetector<T>>
    with PageDragMixin {
  late double _screenWidth;

  SwipeBackGestureController<T>? _backGestureController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _screenWidth = MediaQuery.sizeOf(context).width;
  }

  void _handleDragStart([DragStartDetails? details]) {
    if (!mounted || !widget.enabledCallback()) {
      return;
    }

    _backGestureController = widget.onStartPopGesture();

    dragUnderway = true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!mounted ||
        !dragUnderway ||
        _backGestureController == null ||
        _backGestureController!.controller.isAnimating) {
      return;
    }

    final double primaryDelta = details.primaryDelta ?? 0.0;

    _backGestureController!.dragUpdate(
      _convertToLogical(primaryDelta / _screenWidth),
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!mounted ||
        !dragUnderway ||
        _backGestureController == null ||
        _backGestureController!.controller.isAnimating) {
      return;
    }

    dragUnderway = false;

    _backGestureController!.dragEnd(
      _convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width,
      ),
    );
  }

  void _handleDragCancel() {
    if (!mounted ||
        !dragUnderway ||
        _backGestureController == null ||
        _backGestureController!.controller.isAnimating) {
      return;
    }

    dragUnderway = false;

    _backGestureController!.dragEnd(0);

    _backGestureController = null;
  }

  double _convertToLogical(double value) {
    return switch (Directionality.of(context)) {
      TextDirection.rtl => -value,
      TextDirection.ltr => value,
    };
  }

  double _dragAreaWidth(BuildContext context, TextDirection textDirection) {
    final EdgeInsets padding = MediaQuery.paddingOf(context);

    final double dragAreaWidth = switch (Directionality.of(context)) {
      TextDirection.ltr => padding.left,
      TextDirection.rtl => padding.right,
    };

    return math.max(dragAreaWidth, widget.backGestureDetectionWidth());
  }

  PageDragRecognizer _gestureRecognizerConstructor() {
    final TextDirection textDirection = Directionality.of(context);

    return PageDragRecognizer(
      debugOwner: this,
      directionality: textDirection,
      checkStartedCallback: () =>
          _backGestureController != null || dragUnderway,
      enabledCallback: widget.enabledCallback,
      detectionArea: () => widget.canOnlySwipeFromEdge()
          ? (
              startOffset: widget.backGestureDetectionStartOffset(),
              width: _dragAreaWidth(context, textDirection),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: {
        PageDragRecognizer:
            GestureRecognizerFactoryWithHandlers<PageDragRecognizer>(
              _gestureRecognizerConstructor,
              (instance) => instance
                ..dragStartBehavior = DragStartBehavior.down
                ..onStart = _handleDragStart
                ..onUpdate = _handleDragUpdate
                ..onEnd = _handleDragEnd
                ..onCancel = _handleDragCancel
                ..gestureSettings = MediaQuery.maybeOf(
                  context,
                )?.gestureSettings,
            ),
      },
      child: PageDragListener(
        parentState: this,
        onStart: (_) => _handleDragStart(),
        onUpdate: _handleDragUpdate,
        onEnd: _handleDragEnd,
        child: widget.child,
      ),
    );
  }
}
