import "dart:async";

import "package:flutter/material.dart";
import "package:portfolio/shared/extensions.dart";
import "package:portfolio/shared/widgets/mouse_scroll.dart";

class VerticalTabBarView extends StatefulWidget {
  const VerticalTabBarView({
    required this.tabController,
    required this.children,
    this.footer,
    super.key,
  });

  final TabController tabController;
  final List<Widget> children;
  final Widget? footer;

  @override
  State<VerticalTabBarView> createState() => _VerticalTabBarViewState();
}

class _VerticalTabBarViewState extends State<VerticalTabBarView> with SingleTickerProviderStateMixin {
  late final List<GlobalKey> globalKeys;
  late final ScrollController scrollController;

  late bool isDragging;
  late bool isClicking;

  Future<void> scrollTo(int index) async {
    if (globalKeys[index].currentContext case BuildContext context) {
      isDragging = true;
      await Scrollable.ensureVisible(context, duration: 250.ms, curve: Curves.easeOut);
      isDragging = false;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    isDragging = false;
    isClicking = false;

    globalKeys = [
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
      scrollController = ScrollController()
        ..addListener(() {
          if (isDragging) {
            return;
          }

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
            isClicking = false;
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseScroll(
      duration: 150.ms,
      curve: Curves.easeOut,
      controller: scrollController,
      builder: (BuildContext context, ScrollController scrollController, ScrollPhysics physics) {
        return SingleChildScrollView(
          controller: scrollController,
          physics: physics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < widget.children.length; ++i)
                KeyedSubtree(key: globalKeys[i], child: widget.children[i]),
              if (widget.footer case Widget footer) footer,
            ],
          ),
        );
      },
    );
  }
}
