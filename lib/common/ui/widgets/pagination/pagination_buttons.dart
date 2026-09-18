import 'package:Self.Tube/common/data/services/settings/settings_service.dart';
import 'package:Self.Tube/common/ui/widgets/pagination/go_to_page_dialog.dart';
import 'package:Self.Tube/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaginationButtons extends StatelessWidget {
  final bool enforcePages;
  final int currentPage;
  final int lastPage;
  final bool hasMore;
  final ValueChanged<int> goToPage;
  final VoidCallback fetchNext;

  const PaginationButtons({
    super.key,
    required this.currentPage,
    required this.lastPage,
    required this.hasMore,
    required this.goToPage,
    required this.fetchNext,
    this.enforcePages = false
  });
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final paginationStyle = SettingsService.paginationStyle;
    
    if (paginationStyle == 0 || enforcePages) {
      
      if (currentPage == 1 && !hasMore) {
        return SizedBox.shrink();
      }

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
                  onPressed: () => goToPage(currentPage - 1),
                  child: Text(localizations!.paginationPrevious),
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
              onPressed: () => GoToPageDialog(
                context: context, 
                lastPage: lastPage, 
                goToPage: goToPage
              ),
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
                  onPressed: () => goToPage(currentPage + 1),
                  child: Text(localizations.paginationNext),
                ),
              ),
            ),
          ],
        ),
      );
        
    } else if (paginationStyle == 1 && hasMore) {
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
