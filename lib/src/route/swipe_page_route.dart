import 'package:flutter/cupertino.dart';
import 'package:swipe_page_route/src/route/cupertino_back_gesture_detector.dart';
import 'package:swipe_page_route/src/route/swipe_back_gesture_controller.dart';
import 'package:swipe_page_route/src/route/swipe_back_gesture_detector.dart';

typedef SwipeTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      bool isSwipeGesture,
      Widget child,
    );

class SwipePageRoute<T> extends CupertinoPageRoute<T> {
  bool swipeFromEdge;

  final Duration? _transitionDuration;

  final Duration? _reverseTransitionDuration;

  final SwipeTransitionBuilder transitionBuilder;

  SwipePageRoute({
    this.swipeFromEdge = false,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    SwipeTransitionBuilder? transitionBuilder,
    required super.builder,
    super.title,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  }) : _transitionDuration = transitionDuration,
       _reverseTransitionDuration = reverseTransitionDuration,
       transitionBuilder =
           transitionBuilder ?? defaultTransitionBuilder(fullscreenDialog);

  static SwipeTransitionBuilder defaultTransitionBuilder(
    bool fullscreenDialog,
  ) {
    if (fullscreenDialog) {
      return (context, animation, secondaryAnimation, isSwipeGesture, child) {
        return CupertinoFullscreenDialogTransition(
          primaryRouteAnimation: animation,
          secondaryRouteAnimation: secondaryAnimation,
          linearTransition: isSwipeGesture,
          child: child,
        );
      };
    } else {
      return (context, animation, secondaryAnimation, isSwipeGesture, child) {
        return CupertinoPageTransition(
          primaryRouteAnimation: animation,
          secondaryRouteAnimation: secondaryAnimation,
          linearTransition: isSwipeGesture,
          child: child,
        );
      };
    }
  }

  static Widget buildPageTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child, {
    bool swipeFromEdge = false,
    SwipeTransitionBuilder? transitionBuilder,
  }) {
    final Widget wrappedChild;

    if (route.fullscreenDialog || route.isFirst) {
      wrappedChild = child;
    } else {
      if (!swipeFromEdge) {
        wrappedChild = CupertinoBackGestureDetector<T>(
          enabledCallback: () => _isPopGestureEnabled(route),
          onStartPopGesture: () => _startPopGesture(route),
          child: SwipeBackGestureDetector<T>(
            enabledCallback: () => _isPopGestureEnabled(route),
            onStartPopGesture: () => _startPopGesture(route),
            child: child,
          ),
        );
      } else {
        wrappedChild = CupertinoBackGestureDetector<T>(
          enabledCallback: () => _isPopGestureEnabled(route),
          onStartPopGesture: () => _startPopGesture(route),
          child: child,
        );
      }
    }

    transitionBuilder ??= defaultTransitionBuilder(route.fullscreenDialog);

    return transitionBuilder(
      context,
      animation,
      secondaryAnimation,
      route.popGestureInProgress,
      wrappedChild,
    );
  }

  // Copied and modified from `CupertinoRouteTransitionMixin`
  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    if (route.isFirst) {
      return false;
    }

    if (route.willHandlePopInternally) {
      return false;
    }

    if (route.hasScopedWillPopCallback ||
        route.popDisposition == RoutePopDisposition.doNotPop) {
      return false;
    }

    if (route.fullscreenDialog) {
      return false;
    }

    if (route.animation!.status != AnimationStatus.completed) {
      return false;
    }

    if (route.secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }

    if (route.popGestureInProgress) {
      return false;
    }

    return true;
  }

  static SwipeBackGestureController<T> _startPopGesture<T>(PageRoute<T> route) {
    return SwipeBackGestureController<T>(
      navigator: route.navigator!,
      getIsCurrent: () => route.isCurrent,
      getIsActive: () => route.isActive,
      controller: route.controller!,
    );
  }

  @override
  Duration get transitionDuration {
    return _transitionDuration ?? super.transitionDuration;
  }

  @override
  Duration get reverseTransitionDuration {
    return _reverseTransitionDuration ?? super.reverseTransitionDuration;
  }

  @override
  bool get popGestureEnabled => _isPopGestureEnabled(this);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return buildPageTransitions(
      this,
      context,
      animation,
      secondaryAnimation,
      child,
      swipeFromEdge: swipeFromEdge,
      transitionBuilder: transitionBuilder,
    );
  }
}
