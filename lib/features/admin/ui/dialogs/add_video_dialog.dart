import 'package:Self.Tube/features/admin/data/api/admin_api.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';

class AddVideoDialog extends StatelessWidget{
  late TextEditingController _videoUrlController = TextEditingController();

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
            Text("Add Video", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            ListSectionContainer(
              children: [
                TextField(
                  controller: _videoUrlController,
                  decoration: InputDecoration(
                    labelText: "https://youtube.com/watch?v=Yd7v",
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
              child: Text("Add Video")
            )
          ],
        ), 
      )
    );
  }

  Future<void> _hanleChannels(BuildContext context) async {
    await AdminApi().addVideo(_videoUrlController.text);
    Navigator.pop(context);
  }
}
