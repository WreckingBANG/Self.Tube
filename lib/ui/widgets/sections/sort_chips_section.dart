import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';

class SortChipsSection extends StatefulWidget{
  final ValueChanged<String> sortOptions;

  const SortChipsSection({
    super.key,
    required this.sortOptions,
  });

  @override
  State<SortChipsSection> createState() => _SortChipsSectionState();
} 

class _SortChipsSectionState extends State<SortChipsSection> {

  String order = "desc";
  String sort = "published";
  String type = "";
  String watched = "";

  @override
  void initState() {
    super.initState();
  }

  void compileSortOptions() {
    String query = "";
    if (order.isNotEmpty) query += "&order=$order";
    if (sort.isNotEmpty) query += "&sort=$sort";
    if (type.isNotEmpty) query += "&type=$type";
    if (watched.isNotEmpty) query += "&watch=$watched";
    widget.sortOptions(query);
  }

  Widget build (BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final Map<String, String> orderOptions = {
      "asc": localizations.chipsOrderAsc,
      "desc": localizations.chipsOrderDes,
    };

    final Map<String, String> sortOptions = {
      "published": localizations.chipsSortPub,
      "downloaded": localizations.chipsSortDow,
      "views": localizations.chipsSortVie,
      "likes": localizations.chipsSortLik,
      "duration": localizations.chipsSortDur,
      "mediasize": localizations.chipsSortSiz,
      "width": localizations.chipsSortWid,
      "height": localizations.chipsSortHei
    };

    final Map<String, String> typeOptions = {
      "": localizations.chipsTypeAll,
      "videos": localizations.chipsTypeVid,
      "streams": localizations.chipsTypeStr,
      "shorts": localizations.chipsTypeSho,
    };

    final Map<String, String> watchedOptions = {
      "": localizations.chipsWatchedAll,
      "watched": localizations.chipsWatchedWat,
      "unwatched": localizations.chipsWatchedUnw,
      "continue": localizations.chipsWatchedCon
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(width: 6),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() => order = value);
                compileSortOptions();
              },
              itemBuilder: (context) {
                return orderOptions.entries.map((entry) {
                  return PopupMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList();
              },
              child: Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_list, size: 18),
                    SizedBox(width: 6),
                    Text(orderOptions[order]!),
                  ],
                ),
              ),
            ),
            SizedBox(width: 6),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() => sort = value);
                compileSortOptions();
              },
              itemBuilder: (context) {
                return sortOptions.entries.map((entry) {
                  return PopupMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList();
              },
              child: Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sort, size: 18),
                    SizedBox(width: 6),
                    Text(sortOptions[sort]!),
                  ],
                ),
              ),
            ),
            SizedBox(width: 6),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() => type = value);
                compileSortOptions();
              },
              itemBuilder: (context) {
                return typeOptions.entries.map((entry) {
                  return PopupMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList();
              },
              child: Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_collection_outlined, size: 18),
                    SizedBox(width: 6),
                    Text(typeOptions[type]!),
                  ],
                ),
              ),
            ),
            SizedBox(width: 6),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() => watched = value);
                compileSortOptions();
              },
              itemBuilder: (context) {
                return watchedOptions.entries.map((entry) {
                  return PopupMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList();
              },
              child: Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility_outlined, size: 18),
                    SizedBox(width: 6),
                    Text(watchedOptions[watched]!),
                  ],
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}