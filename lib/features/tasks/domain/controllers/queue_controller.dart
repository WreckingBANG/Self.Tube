import 'package:Self.Tube/features/tasks/data/api/task_api.dart';
import 'package:media_kit/ffi/src/arena.dart';

class QueueController {
  int _currentPage = 1;
  bool _hasMore = true;
  String _sortOptions = "";

  bool get hasMore => _hasMore;

  void reset({String sort = ""}) {
    _currentPage = 1;
    _hasMore = true;
    _sortOptions = sort;
  }

  Future<List> fetchVideos(String baseQuery) async {
    if (!_hasMore) return [];

    final query = "$baseQuery$_sortOptions&page=$_currentPage";

    final response = await TaskApi().fetchQueue(query);

    if (response == null) {
      _hasMore = false;
      return [];
    }

    if (_currentPage >= response.lastPage) {
      _hasMore = false;
    } else {
      _currentPage++;
    }

    return response.data;
  }
}
