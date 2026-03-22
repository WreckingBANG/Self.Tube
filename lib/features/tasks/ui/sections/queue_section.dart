import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/features/tasks/domain/queue_provider.dart';
import 'package:Self.Tube/features/tasks/ui/tiles/queue_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QueueSection extends ConsumerWidget {
  final String query;

  QueueSection({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    
    final provider = ref.read(queueProvider(query).notifier);
    final queue = ref.watch(queueProvider(query));
    
    return queue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(localizations.errorFailedToLoadData)),
      data: (queue) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (queue!.isEmpty)
              Center(child: Text(localizations.taskQueueEmpty))
            else
              ListSectionContainer(
                itemCount: queue.length,
                itemBuilder: (context, index) {
                  final video = queue[index];
                  return QueueListTile(
                    video: video
                  );
                },
              ),
            if (provider.hasMore && queue.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextButton(
                    onPressed: provider.fetchNext,
                    child: Text(localizations.listShowMore),
                  ),
                ),
              ),
          ],
        );
      }
    );
  }
}
