import 'package:Self.Tube/common/ui/widgets/containers/list_section_container.dart';
import 'package:Self.Tube/common/ui/widgets/pagination/pagination_buttons.dart';
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
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator()
        ),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Center(
          child: Text(localizations.errorFailedToLoadData)
        ),
      ),
      data: (queue) {
        return SliverMainAxisGroup(
          slivers: [
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 14, right: 14),
                child: Text(
                  localizations.taskQueue,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, 
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: SwitchListTile(
                thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Icon(Icons.check);
                    }
                    return const Icon(Icons.close);
                  },
                ),
                title: Text(localizations.taskShowIgnored),
                value: provider.pagination.filter == "&filter=ignore",
                onChanged: (bool value) {
                  provider.changeHidden(value);
                },
              ),
            ),
            
            if (queue!.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Text(localizations.taskQueueEmpty)
                )
              )
            else
              ListSectionContainer(
                returnSliver: true,
                itemCount: queue.length,
                itemBuilder: (context, index) {
                  final video = queue[index];
                  return QueueListTile(
                    video: video
                  );
                },
              ),
            
            SliverToBoxAdapter(
              child: PaginationButtons(
                enforcePages: true,
                currentPage: provider.pagination.currentPage,
                lastPage: provider.pagination.lastPage,
                hasMore: provider.pagination.hasMore,
                goToPage: (page) => provider.goToPage(page),
                fetchNext: () => provider.fetchNext()
              ),
            )

          ],
        );
      }
    );
  }
}
