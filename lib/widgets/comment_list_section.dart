import 'package:flutter/material.dart';
import '../models/commentlist_model.dart';
import '../services/api_service.dart';
import '../widgets/comment_list_tile.dart';
import '../l10n/generated/app_localizations.dart';


class CommentListWidget extends StatefulWidget {
  final String videoId;

  const CommentListWidget({super.key, required this.videoId});

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  late Future<List<CommentListItemModel>?> _commentsFuture;
  final Map<String, bool> _expandedMap = {};

  @override
  void initState() {
    super.initState();
    _commentsFuture = ApiService.fetchCommentList(widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return FutureBuilder<List<CommentListItemModel>?>(
      future: _commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Text(localizations.errorFailedToLoadData));
        }

        final comments = snapshot.data!;
        return ListView(
          children: comments.map((comment) {
            final isExpanded = _expandedMap[comment.commentId] ?? false;
            final hasReplies = comment.commentReplies.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommentListTile(
                  commentAuthor: comment.commentAuthor,
                  commentText: comment.commentText,
                  commentAuthorIsUploader: comment.commentAuthorIsUploader,
                  commentHasReplys: hasReplies,
                  commentLikeCount: comment.commentLikeCount,
                  commentIsExpanded: isExpanded,
                  onPressed: () {
                    setState(() {
                      _expandedMap[comment.commentId] = !isExpanded;
                    });
                  }
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      children: comment.commentReplies.map((reply) {
                        return CommentListTile(
                          commentAuthor: reply.commentAuthor,
                          commentText: reply.commentText,
                          commentAuthorIsUploader: reply.commentAuthorIsUploader,
                          commentLikeCount: reply.commentLikeCount,
                          onPressed: () {
                            setState(() {
                              _expandedMap[comment.commentId] = !isExpanded;
                            });
                          }
                        );
                      }).toList(),
                    ),
                  ),
                const Divider(),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
