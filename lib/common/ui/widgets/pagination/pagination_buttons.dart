import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PaginationButtons extends StatelessWidget {
  final bool enforcePages;
  final int currentPage;
  final bool hasMore;
  final VoidCallback next;
  final VoidCallback previous;
  final VoidCallback fetchNext;

  const PaginationButtons({
    super.key,
    required this.currentPage,
    required this.hasMore,
    required this.next,
    required this.previous,
    required this.fetchNext,
    this.enforcePages = false
  });
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final paginationStyle = 1;
    
    if (paginationStyle == 1 || enforcePages) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            
            IgnorePointer(
              ignoring: currentPage == 1,
              child: Opacity(
                opacity: currentPage == 1 ? 0.4 : 1.0,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(5),
                      )
                    ) 
                  ),
                  onPressed: () => previous.call(),
                  child: Text("Previous"),
                ),
              ),
            ),
            SizedBox(width: 5), 
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ) 
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("WIP"),
                    );
                  }
                );
              },
              child: Text(currentPage.toString()),
            ),
            SizedBox(width: 5),
            IgnorePointer(
              ignoring: !hasMore,
              child: Opacity(
                opacity: !hasMore ? 0.4 : 1.0,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(24),
                      )
                    ) 
                  ),
                  onPressed: () => next.call(),
                  child: Text("Forward"),
                ),
              ),
            ),
          ],
        ),
      );
        
    } else if (paginationStyle == 2 && hasMore) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: TextButton(
            onPressed: () => fetchNext.call(),
            child: Text(localizations!.listShowMore),
          ),
        ),
      );
    }

    return SizedBox.shrink();

  }
}
