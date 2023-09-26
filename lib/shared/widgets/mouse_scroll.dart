// ignore_for_file: unnecessary_breaks, discarded_futures

import "dart:math" as math;

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class MouseScroll extends StatelessWidget {
  const MouseScroll({
    required this.builder,
    required this.controller,
    super.key,
    this.mobilePhysics = kMobilePhysics,
    this.duration = const Duration(milliseconds: 380),
    this.scrollSpeed = 1.0,
    this.animationCurve = Curves.easeOutQuart,
  });
  final ScrollController controller;
  final ScrollPhysics mobilePhysics;
  final Duration duration;
  final double scrollSpeed;
  final Curve animationCurve;
  final Widget Function(BuildContext, ScrollController, ScrollPhysics) builder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollState>(
      create: (context) => ScrollState(mobilePhysics, controller, duration),
      builder: (context, _) {
        var scrollState = context.read<ScrollState>();
        var controller = scrollState.controller;
        var (physics, _) = context.select((ScrollState s) => (s.activePhysics, s.updateState));

        if (scrollState case ScrollState(:void Function() handlePipelinedScroll)) {
          handlePipelinedScroll();
        }
        return Listener(
          onPointerSignal: (signalEvent) => scrollState.handleDesktopScroll(signalEvent, scrollSpeed, animationCurve),
          onPointerDown: scrollState.handleTouchScroll,
          child: builder(context, controller, physics),
        );
      },
    );
  }
}

const kMobilePhysics = BouncingScrollPhysics();
const kDesktopPhysics = NeverScrollableScrollPhysics();

class ScrollState with ChangeNotifier {
  ScrollState(this.mobilePhysics, this.controller, this.duration);

  final ScrollPhysics mobilePhysics;
  final ScrollController controller;
  final Duration duration;

  late ScrollPhysics activePhysics = mobilePhysics;
  double futurePosition = 0;
  bool updateState = false;

  bool prevDeltaPositive = false;
  double? lastLock;

  Future<void>? _animationEnd;

  void Function()? handlePipelinedScroll;

  static double calcMaxDelta(ScrollController controller, double delta) {
    double pixels = controller.position.pixels;

    return delta.sign > 0
        ? math.min(pixels + delta, controller.position.maxScrollExtent) - pixels
        : math.max(pixels + delta, controller.position.minScrollExtent) - pixels;
  }

  void handleDesktopScroll(
    PointerSignalEvent event,
    double scrollSpeed,
    Curve animationCurve, {
    bool shouldReadLastDirection = true,
  }) {
    // Ensure desktop physics is being used.
    if (activePhysics == kMobilePhysics || lastLock != null) {
      if (lastLock != null) {
        updateState = !updateState;
      }
      if (event case PointerScrollEvent()) {
        double pixels = controller.position.pixels;

        /// If the scroll is at the top or bottom, don't allow the user to scroll further.
        if (pixels <= controller.position.minScrollExtent && event.scrollDelta.dy < 0 ||
            pixels >= controller.position.maxScrollExtent && event.scrollDelta.dy > 0) {
          return;
        } else {
          activePhysics = kDesktopPhysics;
        }

        double computedDelta = calcMaxDelta(controller, event.scrollDelta.dy);
        bool isOutOfBounds = pixels < controller.position.minScrollExtent || //
            pixels > controller.position.maxScrollExtent;

        if (!isOutOfBounds) {
          controller.jumpTo(lastLock ?? (pixels - computedDelta));
        }
        double deltaDifference = computedDelta - event.scrollDelta.dy;
        handlePipelinedScroll = () {
          handlePipelinedScroll = null;
          double currentPos = controller.position.pixels;
          double currentDelta = event.scrollDelta.dy;
          bool shouldLock = lastLock != null
              ? (lastLock == currentPos)
              : (pixels != currentPos + deltaDifference &&
                  (currentPos != controller.position.maxScrollExtent || currentDelta < 0) &&
                  (currentPos != controller.position.minScrollExtent || currentDelta > 0));
          if (!isOutOfBounds && shouldLock) {
            controller.jumpTo(pixels);
            lastLock = pixels;
            controller.position.moveTo(pixels).whenComplete(() {
              if (activePhysics == kDesktopPhysics) {
                activePhysics = kMobilePhysics;
                notifyListeners();
              }
            });
            return;
          } else {
            if (lastLock != null || isOutOfBounds) {
              controller.jumpTo(lastLock != null ? pixels : (currentPos - calcMaxDelta(controller, currentDelta)));
            }
            lastLock = null;
            handleDesktopScroll(event, scrollSpeed, animationCurve, shouldReadLastDirection: false);
          }
        };
        notifyListeners();
      }
    } else if (event case PointerScrollEvent()) {
      bool currentDeltaPositive = event.scrollDelta.dy > 0;
      if (shouldReadLastDirection && currentDeltaPositive == prevDeltaPositive) {
        futurePosition += event.scrollDelta.dy * scrollSpeed;
      } else {
        futurePosition = controller.position.pixels + event.scrollDelta.dy * scrollSpeed;
      }
      prevDeltaPositive = event.scrollDelta.dy > 0;

      Future<void> animationEnd = _animationEnd = controller.animateTo(
        futurePosition,
        duration: duration,
        curve: animationCurve,
      );
      animationEnd.whenComplete(() {
        if (animationEnd == _animationEnd && activePhysics == kDesktopPhysics) {
          activePhysics = mobilePhysics;
          notifyListeners();
        }
      });
    }
  }

  void handleTouchScroll(PointerDownEvent event) {
    if (activePhysics == kDesktopPhysics) {
      activePhysics = mobilePhysics;
      notifyListeners();
    }
  }
}
