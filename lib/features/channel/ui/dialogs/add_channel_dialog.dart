import 'package:Self.Tube/features/channel/domain/channellist_provider.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddChannelDialog extends ConsumerWidget{
  final String query;

  AddChannelDialog({
    super.key,
    required this.query
  });


  final TextEditingController _channelUrlController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    
    final provider = ref.read(channelListProvider(query).notifier);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(localizations.channelAdd, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            ListSectionContainer(
              children: [
                TextField(
                  controller: _channelUrlController,
                  decoration: InputDecoration(
                    labelText: localizations.channelUrl,
                    border: InputBorder.none
                  )
                )
              ]
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.addChannel(_channelUrlController.text);
                Navigator.pop(context);
              },
              child: Text(localizations.channelAdd)
            )
          ],
        ), 
      )
    );
  }
}
