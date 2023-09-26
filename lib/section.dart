import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:portfolio/shared/constants/colors.dart";
import "package:portfolio/shared/extensions.dart";
import "package:provider/provider.dart";

base class AboutMeSection extends StatefulWidget {
  const AboutMeSection({required this.index, super.key});

  final int index;

  @override
  State<AboutMeSection> createState() => _AboutMeSectionState();
}

class _AboutMeSectionState extends State<AboutMeSection> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = context.select((TabController controller) => controller.index);
    ThemeData theme = Theme.of(context);

    double opacity;
    if (widget.index == index) {
      opacity = 1.0;
      focusNode.requestFocus();
    } else {
      opacity = 0.25;
    }

    return Focus(
      focusNode: focusNode,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: 250.ms,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 96, 0, 32),
          child: Column(
            children: <Widget>[
              Text("About Me", style: theme.textTheme.titleLarge),
              const SizedBox(height: 64.0),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.5,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Element 0: Image.
                      Expanded(
                        child: DecoratedBox(
                          decoration: const BoxDecoration(color: Colors.grey),
                          child: Row(
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: 256.0,
                                  height: 256.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// Spacer.
                      const SizedBox(width: 64.0),

                      /// Element 1: Info.
                      Expanded(
                        child: Text(
                          "I am graduate of Computer Science in the Technological Institute of the Philippines - Quezon City.\n\nI started my programming journey since I was 15 years old, after the subject was introduced to me in my high school. Since then, I have been passionate in creating coding projects that I find interesting.",
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

base class ContactInfoSection extends StatefulWidget {
  const ContactInfoSection({required this.index, super.key});

  final int index;

  @override
  State<ContactInfoSection> createState() => _ContactInfoSectionState();
}

class _ContactInfoSectionState extends State<ContactInfoSection> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = context.select((TabController controller) => controller.index);
    ThemeData theme = Theme.of(context);

    double opacity;
    if (widget.index == index) {
      opacity = 1.0;
      focusNode.requestFocus();
    } else {
      opacity = 0.25;
    }

    return Focus(
      focusNode: focusNode,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: 250.ms,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 96, 0, 32),
          child: Column(
            children: <Widget>[
              Text(
                "Contact Info",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 64.0),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 3,
                child: Table(
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Text(
                          "Email: ",
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "jmt.zuniga.t@gmail.com",
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text(
                          "Mobile Number: ",
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "(+63) 998 546 2358",
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text("", style: theme.textTheme.bodyMedium),
                        Text("", style: theme.textTheme.bodyMedium),
                      ],
                    ),

                    ///
                    TableRow(
                      children: <Widget>[
                        Text(
                          "Facebook:",
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "/mikexzuni",
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text(
                          "GitHub:",
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "/water-mizuu",
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text(
                          "LinkedIn:",
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "/john_michael",
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

base class IntroductionSection extends StatefulWidget {
  const IntroductionSection({required this.index, super.key});

  final int index;

  @override
  State<IntroductionSection> createState() => _IntroductionSectionState();
}

class _IntroductionSectionState extends State<IntroductionSection> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int age = DateTime.now().difference(DateTime(2004, 4, 11)).inDays ~/ 365;
    int index = context.select((TabController controller) => controller.index);
    ThemeData theme = Theme.of(context);

    double opacity;
    if (widget.index == index) {
      opacity = 1.0;
      focusNode.requestFocus();
    } else {
      opacity = 0.25;
    }

    return Focus(
      focusNode: focusNode,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: 250.ms,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 96, 0, 32),
          child: Column(
            children: <Widget>[
              Text("Michael.", style: theme.textTheme.titleLarge),
              const SizedBox(height: 8.0),
              Text("Software Engineer & Programmer", style: theme.textTheme.titleSmall),
              const SizedBox(height: 64.0),
              Text(
                "Hello! I am John Michael T. Zuñiga, and I am \n"
                "an $age year old Software Engineer \n"
                "from the Philippines.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Warning. The code that follows is very spaghetti and is not recommended to be modified.
///   It also violates the fact that build methods should not have side effects.
///   So... yeah. If there is a better way to do this, please let me know.

base class ProjectsSection extends StatefulWidget {
  const ProjectsSection({required this.index, super.key});

  final int index;

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  static const List<_Project> _projects = <_Project>[
    (
      iconPath: "assets/images/2048.png",
      name: "2048",
      description: "Description 0",
    ),
    (
      iconPath: "assets/images/advent_of_code.png",
      name: "AOC 2022",
      description: "Description 1",
    ),
    (
      iconPath: "assets/images/portfolio.png",
      name: "Portfolio",
      description: "Description 2",
    ),
    (
      iconPath: "assets/images/leetcode.png",
      name: "LeetCode",
      description: "Description 3",
    ),
    (
      iconPath: "assets/images/peg_parser.png",
      name: "PEG Library",
      description: "Description 4",
    ),
  ];

  late final _Pulsar pulsar;
  late final FocusNode focusNode;

  late int itemIndex;

  @override
  void initState() {
    super.initState();

    pulsar = _Pulsar();
    focusNode = FocusNode();

    itemIndex = 0;
  }

  @override
  void dispose() {
    pulsar.dispose();
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

typedef _Project = ({String iconPath, String name, String description});

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

class _ProjectTile extends StatefulWidget {
  const _ProjectTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
  });

  static const double _imageWidth = 256;

  final Widget icon;
  final Widget title;
  final Widget description;
  final bool isSelected;

  @override
  State<_ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<_ProjectTile> {
  late bool isActive;

  @override
  void initState() {
    super.initState();

    isActive = false;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.isSelected) {
      return GestureDetector(
        onTap: () async {
          if (!widget.isSelected) {
            return;
          }

          setState(() {
            isActive = !isActive;
          });
        },

        /// If it is active, then we want the ui to be like:
        ///
        /// +---------------+-----------------------------+
        /// | +---------- + | Non-Scrollable View         |
        /// | |           | |                             |
        /// | |           | |                             |
        /// | |           | |                             |
        /// | +---------- + |                             |
        /// |     TITLE     |                             |
        /// |  Description  |                         [x] |
        /// +---------------+-----------------------------+
        ///
        /// Otherwise, we want the ui to be like:
        ///
        /// +---------------+
        /// | +---------- + |
        /// | |           | |
        /// | |           | |
        /// | |           | |
        /// | +---------- + |
        /// |     TITLE     |
        /// +---------------+
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: textColor),
            borderRadius: BorderRadius.circular(2.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              if (isActive) ...<Widget>[
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      // The image & title & description
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0x8FFFFFFF)),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            width: _ProjectTile._imageWidth,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: widget.icon,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          SizedBox(width: _ProjectTile._imageWidth, child: widget.title),
                          SizedBox(width: _ProjectTile._imageWidth, child: widget.description),
                        ],
                      ),
                      const VerticalDivider(width: 32.0, color: Colors.white),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Hello world!", style: theme.textTheme.titleMedium),
                            const SizedBox(height: 16.0),
                            Text("lorem ipsum dolor sit", style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...<Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0x8FFFFFFF)),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      width: _ProjectTile._imageWidth,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: widget.icon,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(width: _ProjectTile._imageWidth, child: widget.title),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    } else {
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
              width: _ProjectTile._imageWidth,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: widget.icon,
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(width: _ProjectTile._imageWidth, child: widget.title),
          ],
        ),
      );
    }
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
  late final List<Offset> translationTargets;
  late final List<double> scaleTargets;

  /// These are for animating the opacity of the arrows.
  late Animation<double> arrowOpacity;

  /// These are the animating values, which is initialized after the first frame.
  late List<Animation<double>> opacities;
  late List<Animation<Offset>> translations;
  late List<Animation<double>> scales;

  /// Flags used to prevent recomputing the opacity and offset targets.
  bool hasLoadedOpacityTargets = false;
  bool hasLoadedTranslationTargets = false;
  bool hasLoadedScaleTargets = false;

  /// Used to prevent the user from spamming the arrow keys.
  late bool isAnimating;

  /// The index of the currently highlighted project tile.
  late int activeIndex;

  static const int renderCount = 5;
  static const int logicalCount = renderCount + 2;
  int get projectCount => widget.projects.length;

  void resetAnimation() {
    animationController.reset();

    arrowOpacity = const AlwaysStoppedAnimation<double>(1.0);
    if (hasLoadedOpacityTargets) {
      opacities = <Animation<double>>[
        for (int i = 0; i < logicalCount; ++i) //
          AlwaysStoppedAnimation<double>(opacityTargets[i]),
      ];
    }

    if (hasLoadedTranslationTargets) {
      translations = <Animation<Offset>>[
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
  static final ({double Function(int x) opacity, double Function(int x) scale}) interpolations = (
    opacity: (int x) => exp(-1 * pow(x, 2)).clamp(0.0, 1.0),
    scale: (int x) => cos((pi / logicalCount) * x),
  );

  void computeOpacityTargets() {
    if (hasLoadedOpacityTargets) {
      return;
    }

    hasLoadedOpacityTargets = true;
    opacityTargets = <double>[
      for (int i = -logicalCount ~/ 2; i <= logicalCount ~/ 2; ++i) //
        interpolations.opacity(i),
    ];
  }

  void computeTranslationTargets() {
    if (hasLoadedTranslationTargets) {
      return;
    }

    hasLoadedTranslationTargets = true;
    translationTargets = <Offset>[
      for (int i = 0; i < logicalCount; ++i)
        if (globalKeys[i].currentContext?.findRenderObject() case RenderBox renderBox)
          renderBox.localToGlobal(Offset.zero),
    ];
  }

  void computeScaleTargets() {
    if (hasLoadedScaleTargets) {
      return;
    }

    hasLoadedScaleTargets = true;
    scaleTargets = <double>[
      for (int i = -logicalCount ~/ 2; i <= logicalCount ~/ 2; ++i) //
        interpolations.scale(i),
    ];
  }

  Future<void> highlightPreviousItem() async {
    arrowOpacity = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: animationController,
    ).drive(
      TweenSequence<double>(<TweenSequenceItem<double>>[
        TweenSequenceItem<double>(tween: ConstantTween<double>(0.5), weight: 0.99),
        TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: 0.01),
      ]),
    );

    opacities = <Animation<double>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<double>(begin: opacityTargets.cyclicAt(i), end: opacityTargets.cyclicAt(i + 1)),
        ),
    ];
    translations = <Animation<Offset>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<Offset>(begin: Offset.zero, end: translationTargets.cyclicAt(i + 1) - translationTargets.cyclicAt(i)),
        ),
    ];
    scales = <Animation<double>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<double>(begin: scaleTargets.cyclicAt(i), end: scaleTargets.cyclicAt(i + 1)),
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
    arrowOpacity = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: animationController,
    ).drive(
      TweenSequence<double>(<TweenSequenceItem<double>>[
        TweenSequenceItem<double>(tween: ConstantTween<double>(0.5), weight: 0.99),
        TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: 0.01),
      ]),
    );

    opacities = <Animation<double>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<double>(begin: opacityTargets.cyclicAt(i), end: opacityTargets.cyclicAt(i - 1)),
        ),
    ];
    translations = <Animation<Offset>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<Offset>(begin: Offset.zero, end: translationTargets.cyclicAt(i - 1) - translationTargets.cyclicAt(i)),
        ),
    ];
    scales = <Animation<double>>[
      for (int i = 0; i < logicalCount; ++i)
        animationController.drive(
          Tween<double>(begin: scaleTargets.cyclicAt(i), end: scaleTargets.cyclicAt(i - 1)),
        ),
    ];

    isAnimating = true;
    await animationController.forward(from: 0.0);
    isAnimating = false;

    setState(() {
      activeIndex += 1;
      resetAnimation();
    });
  }

  @override
  void initState() {
    super.initState();

    globalKeys = <GlobalKey<State<StatefulWidget>>>[for (int i = 0; i < logicalCount; ++i) GlobalKey()];
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

    arrowOpacity = const AlwaysStoppedAnimation<double>(1.0);

    /// Call computeOffsets after rendering the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      computeOpacityTargets();
      computeScaleTargets();
      computeTranslationTargets();
      setState(() {
        resetAnimation();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return UnconstrainedBox(
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: <Widget>[
              for (int i = -logicalCount ~/ 2; i <= logicalCount ~/ 2; ++i)
                if (widget.projects.cyclicAt(i + activeIndex)
                    case (
                      :String iconPath,
                      :String name,
                      :String description,
                    )) ...<Widget>[
                  if (i == 0)
                    AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget? child) {
                        return Opacity(
                          opacity: arrowOpacity.value,
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => widget.pulsar.move(_Movement.previous),
                          child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      ),
                    ),
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (BuildContext context, Widget? child) {
                      int v = i + renderCount ~/ 2 + 1;

                      double opacity = hasLoadedOpacityTargets ? opacities[v].value : interpolations.opacity(v);
                      Offset translation = hasLoadedTranslationTargets ? translations[v].value : Offset.zero;
                      double scale = hasLoadedScaleTargets ? scales[v].value : interpolations.scale(v);

                      return KeyedSubtree(
                        key: globalKeys[v],
                        child: Opacity(
                          opacity: opacity,

                          /// The hierarchy of transformations is as follows:
                          ///  1. Scale
                          ///  2. Translate
                          ///
                          /// This is important as the scale transformation will affect the offset of the child.
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(translation.dx, translation.dy)
                              ..scale(scale),
                            alignment: Alignment.center,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: constraints.constrainWidth() * 0.65),
                      child: _ProjectTile(
                        icon: Image(image: AssetImage(iconPath), fit: BoxFit.cover),
                        title: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            name,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                        description: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            description,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        isSelected: i == 0,
                      ),
                    ),
                  ),
                  if (i == 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (BuildContext context, Widget? child) => Opacity(
                          opacity: arrowOpacity.value,
                          child: child,
                        ),
                        child: GestureDetector(
                          onTap: () => widget.pulsar.move(_Movement.next),
                          child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                ],
            ],
          ),
        );
      },
    );
  }
}
