import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';
import 'package:flutter/material.dart';

class AddPlaylistDialog extends StatefulWidget {
  @override
  State<AddPlaylistDialog> createState() => _AddPlaylistDialogState();
}

class _AddPlaylistDialogState extends State<AddPlaylistDialog> with TickerProviderStateMixin{
  late TabController _tabController;
  final TextEditingController _playlistUrlController = TextEditingController();
  final TextEditingController _playlistNameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add Playlist", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: "Regular",
                ),
                Tab(
                  text: "Custom",
                )
              ]
            ),
            SizedBox(
              height: 100,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListSectionContainer(
                    children: [
                      TextField(
                        controller: _playlistUrlController,
                        decoration: InputDecoration(
                          labelText: "Playlist URL",
                          hint: Text("https://youtube.com/playlist..."),
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
                          labelText: "Playlist Name",
                          hint: Text("Watch Later ..."),
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
                _handlePlaylists(context);
              },
              child: Text("Add")
            )
          ],
        ),
      ),
    );
  }


  Future<void> _handlePlaylists(BuildContext context) async {
    print(_playlistUrlController.text);

    if (_tabController.index == 0) {
      await PlaylistApi.addRegularPlaylist(_playlistUrlController.text);
    } else {
      await PlaylistApi.createCustomPlaylist(_playlistNameController.text);
    }
    Navigator.pop(context);
  }

}
