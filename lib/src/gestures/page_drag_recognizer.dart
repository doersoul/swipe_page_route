import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef PageHorizontalDragArea = ({double startOffset, double width});

class PageDragRecognizer extends HorizontalDragGestureRecognizer {
  final TextDirection directionality;
  final ValueGetter<bool> enabledCallback;
  final ValueGetter<PageHorizontalDragArea?> detectionArea;
  final ValueGetter<bool> checkStartedCallback;

  PageDragRecognizer({
    super.debugOwner,
    required this.directionality,
    required this.enabledCallback,
    required this.detectionArea,
    required this.checkStartedCallback,
  });

  @override
  void handleEvent(PointerEvent event) {
    if (_shouldHandle(event)) {
      super.handleEvent(event);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  bool _shouldHandle(PointerEvent event) {
    if (checkStartedCallback()) {
      return true;
    }

    if (!enabledCallback()) {
      return false;
    }

    final bool isCorrectDirection = switch ((directionality, event.delta.dx)) {
      (TextDirection.ltr, > 0) => true,
      (TextDirection.rtl, < 0) => true,
      (_, 0) => true,
      _ => false,
    };

    if (!isCorrectDirection) {
      return false;
    }

    final PageHorizontalDragArea? detectionArea = this.detectionArea();
    final double dx = event.localPosition.dx;

    if (detectionArea != null &&
        event is PointerDownEvent &&
        (dx < detectionArea.startOffset ||
            dx > detectionArea.startOffset + detectionArea.width)) {
      return false;
    }

    return true;
  }
}
