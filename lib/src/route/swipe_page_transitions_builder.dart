import 'package:flutter/material.dart';
import 'package:swipe_page_route/src/route/swipe_page_route.dart';

class SwipePageTransitionsBuilder extends PageTransitionsBuilder {
  final SwipeBackGestureMode backGestureMode;
  final SwipeTransitionBuilder? transitionBuilder;

  const SwipePageTransitionsBuilder({
    this.backGestureMode = SwipeBackGestureMode.page,
    this.transitionBuilder,
  });

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SwipePageRoute.buildPageTransitions<T>(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
      backGestureMode: backGestureMode,
      transitionBuilder: transitionBuilder,
    );
  }
}
