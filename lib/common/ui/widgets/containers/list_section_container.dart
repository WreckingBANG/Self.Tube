import 'package:flutter/material.dart';

class ListSectionContainer extends StatelessWidget {
  final List<Widget> children;
  final String? title;

  const ListSectionContainer({
    super.key,
    required this.children,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              title!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
          ),
        ...List.generate(children.length, (index) {
          final shape = RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: index == 0
                  ? const Radius.circular(12)
                  : const Radius.circular(4),
              bottom: index == children.length - 1
                  ? const Radius.circular(12)
                  : const Radius.circular(4),
            ),
          );

          return Card(
            shape: shape,
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
            child: children[index],
          );
        }),
      ],
    );
  }
}
