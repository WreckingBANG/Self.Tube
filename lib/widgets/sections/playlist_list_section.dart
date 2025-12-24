import 'package:Self.Tube/services/api/playlist_api.dart';
import 'package:flutter/material.dart';
import '../tiles/playlist_list_tile.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:Self.Tube/widgets/containers/list_section_container.dart';

class PlaylistListSection extends StatefulWidget {
  final String title;
  final bool hideIfEmpty;

  const PlaylistListSection({
    super.key,
    this.title = "",
    this.hideIfEmpty = false,
  });

  @override
  State<PlaylistListSection> createState() => _PlaylistListSectionState();
}

class _PlaylistListSectionState extends State<PlaylistListSection> {
  List playlists = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchplaylists(); 
  }

  Future<void> fetchplaylists() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final newplaylists = await PlaylistApi().fetchPlaylistList();

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
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (playlists.isEmpty && !widget.hideIfEmpty && !isLoading)
          Center(child: Text(localizations.errorNoDataFound))
        else
          ListSectionContainer(
            title: widget.title,
            children: [
              ...List.generate(playlists.length, (index) {
                final playlist = playlists[index];
                return PlaylistListTile(playlist: playlist);
              })
            ]
          ),
          
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (!isLoading && hasMore && playlists.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TextButton(
                onPressed: fetchplaylists,
                child: Text(localizations.listShowMore),
              ),
            ),
          ),
      ],
    );
  }
}
