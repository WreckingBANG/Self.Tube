import 'videolist_model.dart';

class VideoListWrapperModel {
  final List<VideoListItemModel> data;
  final int pageSize;
  final int pageFrom;
  final List<int>? prevPages;
  final int currentPage;
  final bool maxHits;
  final String params;
  final int lastPage;
  final List<int> nextPages;
  final int totalHits;

  VideoListWrapperModel({
    required this.data,
    required this.pageSize,
    required this.pageFrom,
    required this.prevPages,
    required this.currentPage,
    required this.maxHits,
    required this.params,
    required this.lastPage,
    required this.nextPages,
    required this.totalHits,
  });

  factory VideoListWrapperModel.fromJson(dynamic json) {
    
    if (json is List) {
      return VideoListWrapperModel(
        data: [],
        pageSize: 0,
        pageFrom: 0,
        prevPages: [],
        currentPage: 0,
        maxHits: false,
        params: "",
        lastPage: 0,
        nextPages: [],
        totalHits: 0,
      );
    }

    final paginate = json['paginate'] ?? {};

    return VideoListWrapperModel(
      data: (json['data'] as List<dynamic>)
          .map((item) => VideoListItemModel.fromJson(item))
          .toList(),
      pageSize: paginate['page_size'] ?? 0,
      pageFrom: paginate['page_from'] ?? 0,
      prevPages: (paginate['prev_pages'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      currentPage: paginate['current_page'] ?? 0,
      maxHits: paginate['max_hits'] ?? false,
      params: paginate['params'] ?? '',
      lastPage: paginate['last_page'] ?? 0,
      nextPages: (paginate['next_pages'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      totalHits: paginate['total_hits'] ?? 0,
    );
  }
}
