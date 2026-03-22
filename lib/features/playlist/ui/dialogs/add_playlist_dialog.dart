import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/playlist/domain/playlistlist_provider.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaylistDialog extends ConsumerWidget {
  final String query;

  AddPlaylistDialog({
    super.key,
    required this.query
  });

    final TextEditingController _playlistUrlController = TextEditingController();
  final TextEditingController _playlistNameController = TextEditingController();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final provider = ref.read(playlistListProvider(query).notifier);

    late TabController tabController = TabController(
      length: 2, 
      vsync: Navigator.of(context)
    );


    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(localizations.playlistAdd, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            TabBar(
              controller: tabController,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  text: localizations.playlistRegular,
                ),
                Tab(
                  text: localizations.playlistCustom,
                )
              ]
            ),
            SizedBox(
              height: 100,
              child: TabBarView(
                controller: tabController,
                children: [
                  ListSectionContainer(
                    children: [
                      TextField(
                        controller: _playlistUrlController,
                        decoration: InputDecoration(
                          labelText: localizations.playlistUrl,
                          hint: Text(localizations.playlistUrlHint),
                          border: InputBorder.none,
                        )
                      ),
                    ],
                  ),
                  ListSectionContainer(
                    children: [
                      TextField(
                        controller: _playlistNameController,
                        decoration: InputDecoration(
                          labelText: localizations.playlistName,
                          hint: Text(localizations.playlistNameHint),
                          border: InputBorder.none,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ),
            ElevatedButton(
              onPressed: () {
                if (tabController.index == 0) {
                  provider.addPlaylist(_playlistUrlController.text, true);
                } else {
                  provider.addPlaylist(_playlistNameController.text, false);
                }
                Navigator.pop(context);
              },
              child: Text(localizations.playlistAdd)
            )
          ],
        ),
      ),
    );
  }
}
