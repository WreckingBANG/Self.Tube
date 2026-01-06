class CommentListItemModel {
  final String commentId;
  final String commentText;
  final int commentTimestamp;
  final String commentTimeText;
  final int commentLikeCount;
  final bool commentIsFavorited;
  final String commentAuthor;
  final String commentAuthorId;
  final String commentAuthorThumbnail;
  final bool commentAuthorIsUploader;
  final String commentParent;
  final List<CommentListItemModel> commentReplies;

  CommentListItemModel({
    required this.commentId,
    required this.commentText,
    required this.commentTimestamp,
    required this.commentTimeText,
    required this.commentLikeCount,
    required this.commentIsFavorited,
    required this.commentAuthor,
    required this.commentAuthorId,
    required this.commentAuthorThumbnail,
    required this.commentAuthorIsUploader,
    required this.commentParent,
    required this.commentReplies,
  });

  factory CommentListItemModel.fromJson(Map<String, dynamic> json) {
    return CommentListItemModel(
      commentId: json['comment_id'] ?? '',
      commentText: json['comment_text'] ?? '',
      commentTimestamp: json['comment_timestamp'] ?? 0,
      commentTimeText: json['comment_time_text'] ?? '',
      commentLikeCount: json['comment_likecount'] ?? 0,
      commentIsFavorited: json['comment_is_favorited'] ?? false,
      commentAuthor: json['comment_author'] ?? '',
      commentAuthorId: json['comment_author_id'] ?? '',
      commentAuthorThumbnail: json['comment_author_thumbnail'] ?? '',
      commentAuthorIsUploader: json['comment_author_is_uploader'] ?? false,
      commentParent: json['comment_parent'] ?? '',
      commentReplies: (json['comment_replies'] as List<dynamic>?)
              ?.map((item) => CommentListItemModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  static List<CommentListItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => CommentListItemModel.fromJson(item)).toList();
  }
}