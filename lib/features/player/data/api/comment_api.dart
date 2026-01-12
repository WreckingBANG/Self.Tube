import 'api_service.dart';
import 'package:Self.Tube/data/models/comment/commentlist_model.dart';

class CommentApi {
  Future<List<CommentListItemModel>?> fetchCommentList(String id) {
    return ApiService.request(
      url: '/api/video/$id/comment/',
      method: 'GET',
      parser: (json) => CommentListItemModel.fromJsonList(json),
    );
  } 
}