import 'package:Self.Tube/features/playlist/data/api/playlist_api.dart';
import 'package:flutter/material.dart';

class AddToPlaylistDialog extends StatefulWidget {
  final String videoId;

  const AddToPlaylistDialog({
    super.key,
    required this.videoId
  });

  @override
  State<AddToPlaylistDialog> createState() => _AddToPlaylistDialogState();
}

class _AddToPlaylistDialogState extends State<AddToPlaylistDialog> {
  String? selectedPlaylist;
  List playlists = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  void initState() {
    super.initState();
    fetchplaylists();
  }

  Future<void> fetchplaylists() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final newplaylists = await PlaylistApi().fetchPlaylistList("?type=custom");

      if (newplaylists != null) {
        setState(() {
          playlists.addAll(newplaylists.data);
          if (currentPage >= newplaylists.lastPage) {
            hasMore = false;
          } else {
            currentPage++;
          }
        });
      } else {
        setState(() => hasMore = false);
      }
    } catch (e) {
      print("Error fetching playlists: $e");
    } finally {
      setState(() => isLoading = false);
    }
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
            Text("Add to Playlist", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),

            DropdownButton<String>(
              value: selectedPlaylist,
              hint: const Text("Select a playlist"),
              isExpanded: true,
              items: List.generate(playlists.length, (index) {
                final playlist = playlists[index];
                return DropdownMenuItem(
                  value: playlist.playlistId,
                  child: Text(playlist.playlistName),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedPlaylist = value;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                print(selectedPlaylist);
                print(widget.videoId);
                PlaylistApi.modifyCustomPlaylistItems(selectedPlaylist!, widget.videoId, "create");
                Navigator.pop(context, selectedPlaylist);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
