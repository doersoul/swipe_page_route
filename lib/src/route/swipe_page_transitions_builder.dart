import 'package:flutter/material.dart';
import 'package:swipe_page_route/src/route/swipe_page_route.dart';

class SwipePageTransitionsBuilder extends PageTransitionsBuilder {
  final bool canOnlySwipeFromEdge;
  final SwipeTransitionBuilder? transitionBuilder;

  const SwipePageTransitionsBuilder({
    this.canOnlySwipeFromEdge = false,
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
      canOnlySwipeFromEdge: () => canOnlySwipeFromEdge,
      transitionBuilder: transitionBuilder,
    );
  }
}
