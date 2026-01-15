import 'package:flutter/material.dart';

class RefreshContainer extends StatefulWidget {
  final Widget child;

  const RefreshContainer({
    super.key,
    required this.child,
  });

  @override
  State<RefreshContainer> createState() => _RefreshContainerState();
}

class _RefreshContainerState extends State<RefreshContainer> {
  Key contentKey = UniqueKey();

  Future<void> _refreshContent() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      contentKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshContent,
      child: Container(
        key: contentKey,
        child: widget.child,
      ),
    );
  }
}
