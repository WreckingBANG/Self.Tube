import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes_extended/flutter_m3shapes_extended.dart';
import 'package:material_symbols_icons/symbols.dart';

class EmptyErrorSection extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          M3EContainer.pill(
            width: 100,
            height: 100,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            child: Icon(
              Symbols.wb_twilight,
              size: 40,
            ),
          ),
          Text(
            style: TextStyle(
              fontSize: 20
            ),
            localizations!.errorNothingHere
          ),
          Text(localizations.errorCrickets)
        ],
      ), 
    );
  }

}
