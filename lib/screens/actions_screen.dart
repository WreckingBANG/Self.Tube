import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

class ActionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.actionsTitle)),
      body: 
      Text(localizations.actionsTitle)
    );
  }
}