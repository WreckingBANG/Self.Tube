import 'package:Self.Tube/core/data/services/api/api_service.dart';
import 'package:Self.Tube/features/search/data/models/searchwrapper_model.dart';

class SearchApi {
  Future<SearchWrapperModel?> fetchSearch(String query) {
    return ApiService.request(
      url: '/api/search/?query=$query',
      method: 'GET',
      parser: (json) => SearchWrapperModel.fromJson(json),
    );
  }
}