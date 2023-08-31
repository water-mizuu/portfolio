import "package:flutter/material.dart";
import "package:portfolio/shared/extensions.dart";
import "package:provider/provider.dart";

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
                "an $age year old Software Engineer\n"
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
