import 'package:Self.Tube/models/comment/commentlist_model.dart';
import 'api_service.dart';

class CommentApi {
  Future<List<CommentListItemModel>?> fetchCommentList(String id) {
    return ApiService.request(
      url: '/api/video/$id/comment/',
      method: 'GET',
      parser: (json) => CommentListItemModel.fromJsonList(json),
    );
  } 
}