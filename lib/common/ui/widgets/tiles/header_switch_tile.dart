import 'package:flutter/material.dart';

class HeaderSwitchTile extends StatelessWidget {
  final Widget child;

  const HeaderSwitchTile({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Card(
        color: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40)
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: child,
        )
      )
    );
  }
}
