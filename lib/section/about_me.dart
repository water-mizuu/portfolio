import "package:flutter/material.dart";
import "package:portfolio/shared/extensions.dart";
import "package:provider/provider.dart";

base class AboutMeSection extends StatefulWidget {
  const AboutMeSection({required this.index, super.key});

  final int index;

  @override
  State<AboutMeSection> createState() => _AboutMeSectionState();
}

class _AboutMeSectionState extends State<AboutMeSection> with TickerProviderStateMixin {
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "I am graduate of Computer Science in the Technological Institute of the Philippines - Quezon City.",
                              textAlign: TextAlign.right,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const Text(""),
                            Text(
                              "I started my programming journey since I was 15 years old, after the subject was introduced to me in my high school. Since then, I have been passionate in creating coding projects that I find interesting.",
                              textAlign: TextAlign.right,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
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
