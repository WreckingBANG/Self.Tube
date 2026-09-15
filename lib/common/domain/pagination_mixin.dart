
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationModel {

  int currentPage;
  int lastPage;
  bool hasMore;
  String query;
  String sortOptions;
  String filter;

  PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.hasMore,
    required this.query,
    this.sortOptions = "",
    this.filter = ""
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
    lastPage: 1,
    hasMore: true,
    query: "",
    filter: "",
  );

  Future<PageResult> getData() async {
    final result = await apiLoader(
      "?page=${pagination.currentPage}"
      "${pagination.query}"
      "${pagination.sortOptions}"
      "${pagination.filter}" 
    );
   
    if (result.hasError == false) {
      
      // Fix for Issue where the lastPage value is 0,
      // when the API hits the last Page
      if (result.lastPage == 0) {
        pagination.lastPage = pagination.currentPage;
      } else {
        pagination.lastPage = result.lastPage;
      }
      
      if (pagination.currentPage >= result.lastPage) {
        pagination.hasMore = false;
      } else {
        pagination.hasMore = true;
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

  Future<void> goToPage(int pagenum) async {
    if ((pagenum > 0) && (pagenum <= pagination.lastPage)) {
      pagination.currentPage = pagenum;

      final newPage = await getData();
      
      if (newPage.hasError == false) {
        state = AsyncData(
          newPage.data
        );
      }
    }
  } 

}
