import 'package:Self.Tube/core/data/services/settings/settings_service.dart';
import 'package:Self.Tube/core/utils/number_formatter.dart';
import 'package:flutter/material.dart';

class CommentListTile extends StatelessWidget {
  final dynamic commentText;
  final dynamic commentAuthor;
  final dynamic commentAuthorIsUploader;
  final dynamic commentParent;
  final dynamic commentHasReplys;
  final dynamic commentIsExpanded;
  final dynamic commentLikeCount;
  final dynamic commentAuthorThumbnail;
  final VoidCallback? onPressed;

  const CommentListTile({
    super.key, 
    required this.commentAuthor, 
    this.commentText,
    this.commentAuthorIsUploader,
    this.commentParent,
    this.onPressed,
    this.commentIsExpanded,
    this.commentHasReplys,
    this.commentLikeCount,
    this.commentAuthorThumbnail
  });

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: onPressed,
      child: 
        Card(
        elevation: 4,
        child: 
        Padding(
          padding: EdgeInsets.all(8),
          child: 
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(commentAuthorThumbnail!=null && SettingsService.showCommentPics!=false)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:  Image.network(
                          commentAuthorThumbnail,
                          width: 40,
                          height: 40)
                      ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            commentAuthor,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            commentText,
                          ),
                          Row(
                            children: [
                              Icon(Icons.thumb_up, size: 16),
                              SizedBox(width: 5),
                              Text(formatNumberCompact(commentLikeCount, context)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (commentHasReplys == true)
                Icon(commentIsExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ],
          )
        )
      )
    );
  }
}
