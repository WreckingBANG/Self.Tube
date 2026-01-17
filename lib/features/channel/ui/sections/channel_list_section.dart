import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/channel/data/api/channel_api.dart';
import 'package:Self.Tube/features/channel/ui/tiles/channel_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class ChannelListSection extends StatefulWidget {
  final String title;
  final String query;
  final bool hideIfEmpty;

  const ChannelListSection({
    super.key,
    required this.query,
    this.title = "",
    this.hideIfEmpty = false,
  });

  @override
  State<ChannelListSection> createState() => _ChannelListSectionState();
}

class _ChannelListSectionState extends State<ChannelListSection> {
  List channels = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchChannels(); 
  }

  Future<void> fetchChannels() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final newChannels = await ChannelApi().fetchChannelList("${widget.query}&page=$currentPage");

      if (newChannels != null) {
        setState(() {
          channels.addAll(newChannels.data);
          if (currentPage >= newChannels.lastPage) {
            hasMore = false;
          } else {
            currentPage++;
          }
        });
      } else {
        setState(() => hasMore = false);
      }
    } catch (e) {
      print("Error fetching channels: $e");
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
        if (channels.isEmpty && !widget.hideIfEmpty && !isLoading)
          Center(child: Text(localizations.errorNoDataFound))
        else
          ListSectionContainer(
            title: widget.title,
            children: [
              ...List.generate(channels.length, (index) {
                final channel = channels[index];
                return ChannelListTile(channel: channel,);
              })
            ]
          ),
          
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (!isLoading && hasMore && channels.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TextButton(
                onPressed: fetchChannels,
                child: Text(localizations.listShowMore),
              ),
            ),
          ),
      ],
    );
  }
}
