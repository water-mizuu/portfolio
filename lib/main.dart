import "package:flutter/material.dart";
import "package:portfolio/section.dart";
import "package:portfolio/shared/constants/colors.dart" as colors;
import "package:portfolio/shared/constants/colors.dart";
import "package:portfolio/shared/scroll_delta.dart";
import "package:portfolio/shared/widgets/vertical_tab_view.dart";
import "package:provider/provider.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          background: colors.backgroundColor,
        ),
        fontFamily: "Inter",
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 56.0,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
          titleMedium: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
          titleSmall: TextStyle(
            fontSize: 16.0,
            color: textColor,
          ),
          bodyLarge: TextStyle(fontSize: 20.0, color: textColor),
          bodyMedium: TextStyle(fontSize: 18.0, color: textColor),
          bodySmall: TextStyle(fontSize: 16.0, color: textColor),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

typedef Section = ({Widget body, String name});

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static const List<Section> sections = <Section>[
    (name: "Introduction", body: IntroductionSection(index: 0)),
    (name: "About Me", body: AboutMeSection(index: 1)),
    (name: "Education", body: EducationSection(index: 2)),
    (name: "Projects", body: ProjectsSection(index: 3)),
    (name: "Contact Info", body: ContactInfoSection(index: 4)),
  ];

  late final TabController tabController;
  late bool isDragging;

  @override
  void initState() {
    super.initState();

    isDragging = false;
    tabController = TabController(length: sections.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ChangeNotifierProvider<ScrollDeltaChangeNotifier>(
      create: (_) => ScrollDeltaChangeNotifier(0),
      child: Builder(
        builder: (BuildContext context) {
          ScrollDeltaChangeNotifier delta = context.read();

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification case ScrollUpdateNotification(:double scrollDelta)) {
                delta.scroll(scrollDelta);
              }

              return false;
            },
            child: Stack(
              children: <Widget>[
                Scaffold(
                  appBar: AppBar(
                    backgroundColor: theme.colorScheme.background,
                    scrolledUnderElevation: 0,
                    title: Row(
                      children: <Widget>[
                        Expanded(child: Container()),
                        FittedBox(
                          child: TabBar(
                            controller: tabController,

                            /// Make the indicator act like a transparent "pill"
                            indicator: const BoxDecoration(
                              color: Color(0x10FFFFFF),
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            ),

                            /// Make the indicator take up the whole tab.
                            indicatorSize: TabBarIndicatorSize.tab,

                            /// Remove the automatic violet highlight when a tab is pressed.
                            labelColor: Colors.white,

                            /// Remove the bottom border of the tab widget.
                            dividerColor: Colors.transparent,

                            /// Make the tab buttons shrinkable.
                            isScrollable: true,

                            /// Disable splash.
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) => states.contains(MaterialState.focused) //
                                  ? null
                                  : Colors.transparent,
                            ),

                            /// React on tap.
                            tabs: <Widget>[
                              for (var (:String name, body: _) in sections) //
                                Tab(icon: Text(name)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: ChangeNotifierProvider<TabController>.value(
                    value: tabController,
                    child: VerticalTabBarView(
                      tabController: tabController,
                      footer: const Column(
                        children: <Widget>[
                          ColoredBox(
                            color: Colors.transparent,
                            child: SizedBox(height: 384.0 - 64.0 - 16.0 - 4.0),
                          ),
                          Column(
                            children: <Widget>[
                              Text("Created with Flutter and Dart."),
                            ],
                          ),
                          SizedBox(height: 32.0),
                        ],
                      ),
                      children: <Widget>[
                        for (var (name: _, :Widget body) in sections) body,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
