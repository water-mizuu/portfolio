import "dart:async";

import "package:flutter/material.dart";
import "package:portfolio/shared/extensions.dart";
import "package:portfolio/shared/widgets/mouse_scroll.dart";

class VerticalTabBarView extends StatefulWidget {
  const VerticalTabBarView({
    required this.tabController,
    required this.scrollController,
    required this.children,
    this.wrapper,
    this.footer,
    super.key,
  });

  /// The [TabController] to use for the [VerticalTabBarView].
  final TabController tabController;

  /// The [ScrollController] to use for the [VerticalTabBarView].
  final ScrollController scrollController;

  /// The widgets to display in the [VerticalTabBarView].
  final List<Widget> children;

  /// A widget that is displayed at the bottom of the [VerticalTabBarView].
  final Widget? footer;

  /// A wrapper around the body of the [VerticalTabBarView].
  final Widget Function(BuildContext context, SingleChildScrollView body)? wrapper;

  @override
  State<VerticalTabBarView> createState() => _VerticalTabBarViewState();
}

class _VerticalTabBarViewState extends State<VerticalTabBarView> with SingleTickerProviderStateMixin {
  // ignore: prefer_const_declarations
  static final Cubic animationCurve = Curves.easeOutQuart;
  static final Duration animationDuration = 380.ms;

  late final List<GlobalKey> globalKeys;

  late bool isDragging;
  late bool isClicking;

  void updateFocusedElement() {
    if (isDragging) {
      return;
    }

    TabController tabController = widget.tabController;
    (int, double)? lowest;
    for (var (int index, GlobalKey key) in globalKeys.indexed) {
      if (key.currentContext?.findRenderObject() case RenderBox renderBox) {
        double offset = renderBox.localToGlobal(Offset.zero).dy.abs();

        switch (lowest) {
          case null:
          case (_, double lowestOffset) when offset < lowestOffset:
            lowest = (index, offset);
        }
      }
    }

    if (lowest case (int index, _) when tabController.index != index) {
      isClicking = true;
      tabController.animateTo(index);

      /// We wait for the animation to scroll duration so that the user a feedback loop
      ///   won't occur.
      unawaited(Future<void>.delayed(animationDuration).whenComplete(() => isClicking = false));
    }
  }

  Future<void> scrollTo(int index) async {
    if (globalKeys[index].currentContext case BuildContext context) {
      isDragging = true;
      await Scrollable.ensureVisible(context, duration: animationDuration, curve: animationCurve);
      isDragging = false;
    }
  }

  @override
  void initState() {
    super.initState();

    isDragging = false;
    isClicking = false;

    globalKeys = <GlobalKey>[
      for (int i = 0; i < widget.children.length; ++i) GlobalKey(),
    ];

    if (widget.tabController case TabController tabController) {
      tabController.addListener(() async {
        if (isClicking) {
          return;
        }

        if (tabController.indexIsChanging && tabController.index != tabController.previousIndex) {
          isDragging = true;
          await scrollTo(tabController.index);
          isDragging = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseScroll(
      controller: widget.scrollController,
      scrollSpeed: 1.2,
      duration: animationDuration,
      animationCurve: animationCurve,
      builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics) {
        SingleChildScrollView child = SingleChildScrollView(
          controller: scrollController,
          physics: physics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < widget.children.length; ++i)
                KeyedSubtree(
                  key: globalKeys[i],
                  child: widget.children[i],
                ),
              if (widget.footer case Widget footer) footer,
            ],
          ),
        );

        return NotificationListener<Notification>(
          onNotification: (Notification notification) {
            switch (notification) {
              case ScrollUpdateNotification _:
                updateFocusedElement();
              case Notification _:
                print(notification);
            }
            return false;
          },
          child: widget.wrapper?.call(context, child) ?? child,
        );
      },
    );
  }
}
