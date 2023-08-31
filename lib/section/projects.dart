/// Warning. The code that follows is very spaghetti and is not recommended to be moved.
///   It also violates the fact that build methods should not have side effects.
///   So... yeah. If there is a better way to do this, please let me know.

library;

import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:portfolio/shared/constants/colors.dart";
import "package:portfolio/shared/extensions.dart";
import "package:provider/provider.dart";

base class ProjectsSection extends StatefulWidget {
  const ProjectsSection({required this.index, super.key});

  final int index;

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  static final List<_Project> _projects = <_Project>[
    (iconPath: "assets/images/2048.png", name: "2048"),
    (iconPath: "assets/images/advent_of_code.png", name: "AOC 2022"),
    (iconPath: "assets/images/portfolio.png", name: "(This) Portfolio"),
    (iconPath: "assets/images/leetcode.png", name: "LeetCode"),
    (iconPath: "assets/images/peg_parser.png", name: "PEG Library"),
  ];

  late final _Pulsar pulsar;
  late final FocusNode focusNode;
  late final ScrollController scrollController;

  late int itemIndex;

  @override
  void initState() {
    super.initState();

    pulsar = _Pulsar();
    itemIndex = 0;
    focusNode = FocusNode();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = context.select((TabController controller) => controller.index);
    ThemeData theme = Theme.of(context);

    double opacity;
    if (this.widget.index == index) {
      opacity = 1.0;
      focusNode.requestFocus();
    } else {
      opacity = 0.25;
    }

    return KeyboardListener(
      onKeyEvent: (KeyEvent event) {
        if (event is KeyUpEvent) {
          return;
        }

        switch (event.physicalKey) {
          case PhysicalKeyboardKey.arrowLeft:
            pulsar.move(_Movement.previous);
          case PhysicalKeyboardKey.arrowRight:
            pulsar.move(_Movement.next);
        }
      },
      focusNode: focusNode,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: 250.ms,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 96, 0, 32),
          child: Column(
            children: <Widget>[
              Text("Projects", style: theme.textTheme.titleLarge),
              const SizedBox(height: 64.0),
              _ProjectDisplay(projects: _projects, pulsar: pulsar),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Movement {
  none,
  previous,
  next;
}

typedef _Project = ({String iconPath, String name});

/// A convoluted way to pass events downward. (Isn't it usually upwards?)
class _Pulsar extends ChangeNotifier {
  _Pulsar();

  _Movement latest = _Movement.none;

  void move(_Movement movement) {
    latest = movement;
    if (movement case _Movement.previous || _Movement.next) {
      notifyListeners();
    }
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    required this.icon,
    required this.title,
  });

  static const double _imageWidth = 256;

  final Widget icon;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.circular(2.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x8FFFFFFF)),
              borderRadius: BorderRadius.circular(2.0),
            ),
            width: _imageWidth,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: icon,
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(width: _imageWidth, child: title),
        ],
      ),
    );
  }
}

class _ProjectDisplay extends StatefulWidget {
  const _ProjectDisplay({required this.projects, required this.pulsar});

  final List<_Project> projects;

  final _Pulsar pulsar;

  @override
  State<_ProjectDisplay> createState() => _ProjectDisplayState();
}

class _ProjectDisplayState extends State<_ProjectDisplay> with SingleTickerProviderStateMixin {
  /// Used to get the offsets of each project tile after the first render frame.
  late final List<GlobalKey> globalKeys;

  /// Animation controller used to animate the opacity and offset of each project tile.
  late final AnimationController animationController;

  /// The "targets", which just refers to the opacity and offset of each project tile before animation.
  late final List<double> opacityTargets;
  late final List<Offset> offsetTargets;
  late final List<double> scaleTargets;

  /// These are the animating values, which is initialized after the first frame.
  late List<Animation<double>> opacities;
  late List<Animation<Offset>> offsets;
  late List<Animation<double>> scales;

  /// Flags used to prevent recomputing the opacity and offset targets.
  bool hasLoadedOpacityTargets = false;
  bool hasLoadedOffsetTargets = false;
  bool hasLoadedScaleTargets = false;

  /// Used to prevent the user from spamming the arrow keys.
  late bool isAnimating;

  /// The index of the currently highlighted project tile.
  late int activeIndex;

  late final int renderCount = 5;
  late final int logicalCount = renderCount + 2;
  late final int projectCount = widget.projects.length;

  void resetAnimation() {
    animationController.reset();

    if (hasLoadedOpacityTargets) {
      opacities = <Animation<double>>[
        for (int i = 0; i < logicalCount; ++i) //
          AlwaysStoppedAnimation<double>(opacityTargets[i]),
      ];
    }

    if (hasLoadedOffsetTargets) {
      offsets = <Animation<Offset>>[
        for (int i = 0; i < logicalCount; ++i) //
          const AlwaysStoppedAnimation<Offset>(Offset.zero),
      ];
    }

    if (hasLoadedScaleTargets) {
      scales = <Animation<double>>[
        for (int i = 0; i < logicalCount; ++i) //
          AlwaysStoppedAnimation<double>(scaleTargets[i]),
      ];
    }
  }

  /// Weird stuff going on here. Just use it in Desmos.
  double opacityInterpolation(int x) {
    return exp(-1 * pow(x - logicalCount ~/ 2, 2)).clamp(0.0, 1.0);
  }

  void computeOpacityTargets() {
    if (!hasLoadedOpacityTargets) {
      opacityTargets = <double>[
        for (int i = 0; i < logicalCount; ++i) //
          opacityInterpolation(i),
      ];
    }
    hasLoadedOpacityTargets = true;
  }

  void computeOffsetTargets() {
    if (!hasLoadedOffsetTargets) {
      offsetTargets = <Offset>[
        for (int i = 0; i < logicalCount; ++i)
          if (globalKeys[i].currentContext?.findRenderObject() case RenderBox renderBox)
            renderBox.localToGlobal(Offset.zero),
      ];
    }
    hasLoadedOffsetTargets = true;
  }

  void computeScaleTargets() {
    if (!hasLoadedScaleTargets) {
      scaleTargets = <double>[
        for (int i = -logicalCount ~/ 2; i <= logicalCount ~/ 2; ++i)
          if (i == 0) 1.0 else 0.5,
      ];
    }
    hasLoadedScaleTargets = true;
  }

  Future<void> highlightPreviousItem() async {
    opacities = <Animation<double>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<double>(begin: opacityTargets[i], end: opacityTargets[(i + 1) % logicalCount]),
        ),
    ];
    offsets = <Animation<Offset>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<Offset>(begin: Offset.zero, end: offsetTargets[(i + 1) % logicalCount] - offsetTargets[i]),
        ),
    ];
    scales = <Animation<double>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<double>(begin: scaleTargets[i], end: scaleTargets[(i + 1) % logicalCount]),
        ),
    ];

    isAnimating = true;
    await animationController.forward(from: 0.0);
    isAnimating = false;
    setState(() {
      activeIndex -= 1;
      resetAnimation();
    });
  }

  Future<void> highlightNextItem() async {
    opacities = <Animation<double>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<double>(begin: opacityTargets[i], end: opacityTargets[(i - 1) % logicalCount]),
        ),
    ];
    offsets = <Animation<Offset>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<Offset>(begin: Offset.zero, end: offsetTargets[(i - 1) % logicalCount] - offsetTargets[i]),
        ),
    ];
    scales = <Animation<double>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<double>(begin: scaleTargets[i], end: scaleTargets[(i - 1) % logicalCount]),
        ),
    ];

    isAnimating = true;
    await animationController.forward(from: 0.0);
    isAnimating = false;
    setState(() {
      activeIndex += 1;
    });
    resetAnimation();
  }

  @override
  void initState() {
    super.initState();

    globalKeys = <GlobalKey>[for (int i = 0; i < logicalCount; ++i) GlobalKey()];
    animationController = AnimationController(vsync: this, duration: 250.ms);

    isAnimating = false;
    activeIndex = 0;
    widget.pulsar.addListener(() async {
      if (isAnimating) {
        return;
      }

      if (widget.pulsar.latest case _Movement.next) {
        await highlightNextItem();
      } else if (widget.pulsar.latest case _Movement.previous) {
        await highlightPreviousItem();
      }
    });

    /// Call computeOffsets after rendering the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      computeOpacityTargets();
      computeOffsetTargets();
      computeScaleTargets();
      resetAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: <Widget>[
          for (int i = -logicalCount ~/ 2; i <= logicalCount ~/ 2; ++i)
            if (widget.projects[(i + activeIndex) % projectCount] case (:String iconPath, :String name)) ...<Widget>[
              const SizedBox(width: 8.0),
              if (i == 0) ...<Widget>[
                GestureDetector(
                  onTap: highlightPreviousItem,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
                const SizedBox(width: 8.0),
              ],
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  int v = i + renderCount ~/ 2 + 1;
                  return Transform.translate(
                    offset: hasLoadedOffsetTargets ? offsets[v].value : Offset.zero,
                    child: Opacity(
                      opacity: hasLoadedOpacityTargets ? opacities[v].value : opacityInterpolation(v),
                      key: globalKeys[v],
                      child: Transform.scale(
                        scale: hasLoadedScaleTargets ? scales[v].value : (i == 0 ? 1.0 : 0.5),
                        child: child,
                      ),
                    ),
                  );
                },
                child: _ProjectTile(
                  icon: Image(image: AssetImage(iconPath), fit: BoxFit.cover),
                  title: FittedBox(fit: BoxFit.scaleDown, child: Text(name)),
                ),
              ),
              if (i == 0) ...<Widget>[
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: highlightNextItem,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
              const SizedBox(width: 8.0),
            ],
        ],
      ),
    );
  }
}
