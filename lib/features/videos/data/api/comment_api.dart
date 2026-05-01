import 'package:Self.Tube/common/data/services/api/api_service.dart';
import 'package:Self.Tube/features/videos/data/models/commentlist_model.dart';

class CommentApi {
  Future<CommentListModel?> fetchCommentList(String id) {
    return ApiService.request(
      url: '/api/video/$id/comment/',
      method: 'GET',
      showError: false,
      parser: (json) => CommentListModel.fromJson(json),
    );
  } 
}
