import 'package:flutter/material.dart';
import '../utils/number_formatter.dart';

class CommentListTile extends StatelessWidget {
  final dynamic commentText;
  final dynamic commentAuthor;
  final dynamic commentAuthorIsUploader;
  final dynamic commentParent;
  final dynamic commentHasReplys;
  final dynamic commentIsExpanded;
  final dynamic commentLikeCount;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentAuthor,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    Text(commentText),
                    Row(
                      children: [
                        Icon(Icons.thumb_up),
                        SizedBox(width: 5),
                        Text(formatNumberCompact(commentLikeCount, context)),
                      ],
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
