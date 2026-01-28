import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';

class AddChannelDialog extends StatelessWidget{
  late TextEditingController _channelUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                _hanleChannels(context);
              },
              child: Text(localizations.channelAdd)
            )
          ],
        ), 
      )
    );
  }

  Future<void> _hanleChannels(BuildContext context) async {
    await ChannelApi().addChannel(_channelUrlController.text);
    Navigator.pop(context);
  }
}
