import "dart:async";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class MouseScroll extends StatelessWidget {
  MouseScroll({
    required this.builder,
    required this.controller,
    this.mobilePhysics = kMobilePhysics,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.linear,
    super.key,
  }) : scrollState = ScrollState(mobilePhysics, duration, curve, controller);

  final ScrollState scrollState;
  final Widget Function(BuildContext, ScrollPhysics) builder;
  final ScrollPhysics mobilePhysics;
  final Duration duration;
  final Curve curve;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollState>.value(
      value: scrollState,
      builder: (BuildContext context, _) {
        return Listener(
          onPointerSignal: scrollState.handleDesktopScroll,
          onPointerDown: scrollState.handleTouchScroll,
          child: builder(context, context.select((ScrollState s) => s.physics)),
        );
      },
    );
  }
}

const BouncingScrollPhysics kMobilePhysics = BouncingScrollPhysics();
const NeverScrollableScrollPhysics kDesktopPhysics = NeverScrollableScrollPhysics();

class ScrollState with ChangeNotifier {
  ScrollState(
    this.mobilePhysics,
    this.duration,
    this.curve,
    this.controller,
  );

  final ScrollController controller;
  ScrollPhysics physics = kDesktopPhysics;
  double futurePosition = 0;

  final ScrollPhysics mobilePhysics;
  final Duration duration;
  final Curve curve;

  Future<void> handleDesktopScroll(PointerSignalEvent event) async {
    // Ensure desktop physics is being used.
    if (physics == kMobilePhysics) {
      physics = kDesktopPhysics;
      notifyListeners();
    }

    if (event is PointerScrollEvent) {
      // Return if limit is reached in either direction.
      if (event.scrollDelta.dy case double dy when controller.position.atEdge) {
        // Return if bounds exceeded.
        switch (controller.offset) {
          case <= 0:
            if (dy < 0) {
              return;
            }
          case _:
            if (dy > 0) {
              return;
            }
        }
      }
      futurePosition += event.scrollDelta.dy;

      await controller.animateTo(
        futurePosition,
        duration: duration,
        curve: curve,
      );
    }
  }

  void handleTouchScroll(PointerDownEvent event) {
    if (physics == kDesktopPhysics) {
      physics = mobilePhysics;
      notifyListeners();
    }
  }
}
