import 'package:Self.Tube/features/videos/ui/sections/video_list_section.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class ContinueWatchingList extends StatelessWidget {
  final int? itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  final String? title;

  const ContinueWatchingList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final queryContinue = "?order=asc&watch=continue";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50,
          child: ListTile(
            title: Text(
              title!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (_) {
                  return SingleChildScrollView(
                    child: VideoListSection(
                     hideChannel: false,
                     title: localizations.homeContinueWatching,
                     query: queryContinue
                   )
                  );
                }
              );
            },
          ),
        ),
        if (itemBuilder != null || itemCount != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(right: 2.5),
                    shape: _buildShape(index, itemCount!),
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    child: itemBuilder!(context, index),
                  );
                },
              ) ,
            ),
          )
        else 
         SizedBox()
      ],
    );
  }

  RoundedRectangleBorder _buildShape(int index, int total) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(
        left: index == 0
            ? const Radius.circular(12)
            : const Radius.circular(4),
        right: index == total - 1
            ? const Radius.circular(12)
            : const Radius.circular(4),
      ),
    );
  }
}
