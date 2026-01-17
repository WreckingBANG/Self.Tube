import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectableLinkText extends StatelessWidget {
  final String text;

  const SelectableLinkText({
    super.key,
    required this.text,
  });


  Future<void> _onOpen(LinkableElement link) async {
    final Uri url = Uri.parse(link.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectableLinkify(
      text: text,
      linkStyle: const TextStyle(decoration: TextDecoration.underline),
      onOpen: _onOpen,
    );
  }
}
