import 'package:flutter/material.dart';
import 'package:swipe_page_route/src/route/swipe_page_route.dart';

class SwipePage<T> extends Page<T> {
  final bool canOnlySwipeFromEdge;

  final Duration? transitionDuration;

  final Duration? reverseTransitionDuration;

  final SwipeTransitionBuilder transitionBuilder;

  final String? title;

  final bool maintainState;

  final bool fullscreenDialog;

  final bool allowSnapshotting;

  final WidgetBuilder builder;

  SwipePage({
    this.canOnlySwipeFromEdge = false,
    this.transitionDuration,
    this.reverseTransitionDuration,
    SwipeTransitionBuilder? transitionBuilder,
    this.title,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
    required this.builder,
  }) : transitionBuilder =
           transitionBuilder ??
           SwipePageRoute.defaultTransitionBuilder(fullscreenDialog);

  @override
  Route<T> createRoute(BuildContext context) {
    return SwipePageRoute(
      canOnlySwipeFromEdge: canOnlySwipeFromEdge,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionBuilder: transitionBuilder,
      builder: builder,
      title: title,
      settings: this,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      allowSnapshotting: allowSnapshotting,
    );
  }
}
