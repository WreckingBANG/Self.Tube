import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText(this.text, {Key? key}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            maxLines: _expanded ? null : 2,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            _expanded ? localizations.expandableTextLess : localizations.expandableTextMore,
          ),
        ],
      ),
    );
  }
}
