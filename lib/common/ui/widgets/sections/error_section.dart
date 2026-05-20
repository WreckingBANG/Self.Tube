import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class ErrorSection extends StatelessWidget {
  final WidgetRef ref;
  final ProviderOrFamily provider;

  const ErrorSection({
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
        const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
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
