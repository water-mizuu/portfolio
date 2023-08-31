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
  MouseScroll? _mouseScroll;

  Future<void> scrollTo(int index) async {
    if (globalKeys[index].currentContext case BuildContext context) {
      isDragging = true;
      await Scrollable.ensureVisible(context, duration: 250.ms, curve: Curves.easeOut);
      isDragging = false;

      /// Debug-time assertion instead of at runtime
      ///   because we do not want to crash the app if this happens.
      assert(_mouseScroll != null, "MouseScroll should not be null!");
      if (_mouseScroll case MouseScroll mouseScroll) {
        mouseScroll.scrollState.futurePosition = scrollController.offset;
      }
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
    globalKeys = <GlobalKey>[
      for (int i = 0; i < widget.children.length; ++i) GlobalKey(),
    ];

    widget.tabController.addListener(() async {
      if (widget.tabController.indexIsChanging) {
        await scrollTo(widget.tabController.index);
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

            if (lowest == null || offset < lowest.$2) {
              lowest = (index, offset);
            }
          }
        }

        if (lowest case (int index, _) when widget.tabController.index != index) {
          widget.tabController.animateTo(index);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return _mouseScroll = MouseScroll(
      duration: 200.ms,
      curve: Curves.easeOut,
      controller: scrollController,
      builder: (BuildContext context, ScrollPhysics physics) {
        return SingleChildScrollView(
          controller: scrollController,
          physics: physics,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  for (int i = 0; i < widget.children.length; ++i)
                    KeyedSubtree(
                      key: globalKeys[i],
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: widget.children[i],
                          ),
                        ],
                      ),
                    ),
                  if (widget.footer case Widget footer) footer,
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
