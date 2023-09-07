// ignore_for_file: unnecessary_breaks

import "dart:async";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class MouseScroll extends StatelessWidget {
  const MouseScroll({
    required this.builder,
    required this.controller,
    this.mobilePhysics = kMobilePhysics,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.linear,
    super.key,
  });

  final Widget Function(
    BuildContext context,
    ScrollController controller,
    ScrollPhysics physics,
  ) builder;
  final ScrollPhysics mobilePhysics;
  final Duration duration;
  final Curve curve;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ChangeNotifierProvider<ScrollState>(
          create: (BuildContext context) => ScrollState(mobilePhysics, duration, curve, controller),
          builder: (BuildContext context, _) {
            ScrollState scrollState = context.read<ScrollState>();

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification case ScrollEndNotification _) {
                  scrollState.futurePosition = controller.offset;
                }
                return false;
              },
              child: Listener(
                onPointerSignal: scrollState.handleDesktopScroll,
                onPointerDown: scrollState.handleTouchScroll,
                child: builder(context, controller, context.select((ScrollState s) => s.physics)),
              ),
            );
          },
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
      return;
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
      return;
    }
  }
}
