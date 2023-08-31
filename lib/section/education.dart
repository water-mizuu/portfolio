import "package:flutter/material.dart";
import "package:portfolio/shared/extensions.dart";
import "package:provider/provider.dart";

base class EducationSection extends StatefulWidget {
  const EducationSection({required this.index, super.key});

  final int index;

  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
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
                "Education",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 64.0),
              Column(
                children: <Widget>[
                  Text("Angeles City Science High School", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8.0),
                  Text(
                    "Senior High School - STEM Track",
                    style: theme.textTheme.titleSmall?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  const Text(""),
                  Text("Year 11 - with High Honors", style: theme.textTheme.bodyMedium),
                  Text("Year 12 - with Highest Honors", style: theme.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 48.0),
              Column(
                children: <Widget>[
                  Text("Technological Institute of the Philippines", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8.0),
                  Text(
                    "Undergraduate Studies - Computer Science",
                    style: theme.textTheme.titleSmall?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  const Text(""),
                  Text("Year 1 Unit 1 - Dean's List", style: theme.textTheme.bodyMedium),
                  Text("Year 1 Unit 2 - President's List", style: theme.textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
