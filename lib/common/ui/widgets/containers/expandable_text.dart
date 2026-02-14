import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final int? maxLines;
  final bool? showMoreText;

  const ExpandableText(
    this.text, {
    super.key,
    this.maxLines,
    this.textStyle,
    this.showMoreText
  });

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
            style: widget.textStyle,
            maxLines: _expanded ? null : widget.maxLines ?? 2,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (widget.showMoreText ?? true)
            Text(
              _expanded ? localizations.expandableTextLess : localizations.expandableTextMore,
            ),
        ],
      ),
    );
  }
}
