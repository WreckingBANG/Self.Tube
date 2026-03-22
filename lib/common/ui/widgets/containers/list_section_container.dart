import 'package:flutter/material.dart';

class ListSectionContainer extends StatelessWidget {
  final List<Widget>? children;
  final int? itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  final String? title;

  const ListSectionContainer({
    super.key,
    this.children,
    this.itemCount,
    this.itemBuilder,
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
        if (children != null)
          ...List.generate(children!.length, (index) {
            return Card(
              shape: _buildShape(index, children!.length),
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
              child: children![index],
            );
          })
        else if (itemBuilder != null || itemCount != null) 
          ListView.builder(
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Card(
                shape: _buildShape(index, itemCount!),
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                child: itemBuilder!(context, index),
              );
            },
          ) 
        else 
         SizedBox()
      ],
    );
  }

  RoundedRectangleBorder _buildShape(int index, int total) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: index == 0
            ? const Radius.circular(12)
            : const Radius.circular(4),
        bottom: index == total - 1
            ? const Radius.circular(12)
            : const Radius.circular(4),
      ),
    );
  }
}
