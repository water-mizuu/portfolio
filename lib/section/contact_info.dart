import "package:flutter/material.dart";
import "package:portfolio/shared/extensions.dart";
import "package:provider/provider.dart";

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
                        Text("(+63) 998 546 2358", style: theme.textTheme.bodyMedium, textAlign: TextAlign.right),
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
                        Text("Facebook:", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text("/something", style: theme.textTheme.bodyMedium, textAlign: TextAlign.right),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text("GitHub:", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text("/water-mizuu", style: theme.textTheme.bodyMedium, textAlign: TextAlign.right),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text("LinkedIn:", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const Text("/john_michael", style: TextStyle(fontSize: 18.0), textAlign: TextAlign.right),
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
