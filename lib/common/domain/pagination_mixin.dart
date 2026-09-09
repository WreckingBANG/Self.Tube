
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationModel {

  int currentPage;
  bool hasMore;
  String query;
  String sortOptions;

  PaginationModel({
    required this.currentPage,
    required this.hasMore,
    required this.query,
    this.sortOptions = "",
  });
}

class PageResult {
  final dynamic data;
  final int lastPage;
  final bool hasError;

  const PageResult({
    this.data,
    this.lastPage = 0,
    this.hasError = false
  });
}

mixin PaginationMixin on AsyncNotifier<List?>  {
  Future<PageResult> apiLoader(String query);

  PaginationModel pagination = PaginationModel(
    currentPage: 1,
    hasMore: true,
    query: "",
  );

  Future<PageResult> getData() async {
    final result = await apiLoader(
      "?page=${pagination.currentPage}"
      "${pagination.query}"
      "${pagination.sortOptions}"
      
    );
    
    if (result.hasError == false) {
      if (pagination.currentPage >= result.lastPage) {
        pagination.hasMore = false;
      }

      return PageResult(
        data: result.data,
        lastPage: result.lastPage
      );
    } 

    return PageResult(
      hasError: true
    );
  } 

  Future<void> refresh() async {
    pagination.hasMore = true;
    pagination.currentPage = 1;
    ref.invalidateSelf();
  }

  Future<void> setSorting(String value) async {
    pagination.sortOptions = value;
    await refresh();
  }

  Future<void> fetchNext() async {
    final current = state.value ?? [];

    pagination.currentPage++;

    final newPage = await getData();
    
    if (newPage.hasError == false) {

      final merged = [
        ...current,
        ...newPage.data,
      ];

      state = AsyncData(merged);
    }
  }


}
