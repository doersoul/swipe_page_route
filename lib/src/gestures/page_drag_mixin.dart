import 'package:flutter/gestures.dart';

mixin PageDragMixin {
  VelocityTracker? velocityTracker;

  int activePointerCount = 0;

  bool dragUnderway = false;
}
