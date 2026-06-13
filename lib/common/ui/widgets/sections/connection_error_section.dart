import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_m3shapes_extended/flutter_m3shapes_extended.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ConnectionErrorSection extends StatelessWidget {
  final WidgetRef ref;
  final ProviderOrFamily provider;

  const ConnectionErrorSection({
    super.key,
    required this.provider,
    required this.ref
  }); 

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        M3EContainer.arrow(
          width: 100,
          height: 100,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Icon(
              Symbols.cloud_off,
              size: 40,
            )
          )
        ),
        const SizedBox(height: 16),
        Text(localizations.errorConnectionFailed),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => ref.invalidate(provider),
          child: Text(localizations.errorTryAgain),
        ),
      ],
    );
  }
}
