Flutter full screen cupertino page transition

# Forked from
https://pub.dev/packages/swipeable_page_route

https://github.com/JonasWanke/swipeable_page_route

modified
* Solved the issue of full screen return failure when a new page contains scrolling components such as TabView or PageView
* 解决了当新页面包含 TabView 或 PageView 等滚动组件时，全屏返回失效的问题

# Usage
```yaml
dependencies:
  flutter:
    sdk: flutter
  swipe_page_route: any
```

case 1: app global default
```dart
ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: SwipePageTransitionsBuilder(),
      TargetPlatform.iOS: SwipePageTransitionsBuilder(),
    },
  ),
);
```

case 2: when navigator push
```dart
final PageRoute<T> route = SwipePageRoute<T>(
  canOnlySwipeFromEdge: canOnlySwipeFromEdge,
  transitionDuration: transitionDuration,
  reverseTransitionDuration: reverseTransitionDuration,
  builder: (ctx) => page,
);

Navigator.of(context).push(route);
```

case 3: with go_router
```dart
GoRoute(
    name: QuickMenuTestPage.name,
    path: '/${QuickMenuTestPage.name}',
    pageBuilder: (BuildContext ctx, GoRouterState state) {
      return SwipePage(
        builder: (BuildContext innerCtx) => const QuickMenuTestPage(),
      );
    },
);
```