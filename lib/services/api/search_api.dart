import 'package:Self.Tube/models/search/searchwrapper_model.dart';
import 'api_service.dart';

class SearchApi {
  Future<SearchWrapperModel?> fetchSearch(String query) {
    return ApiService.request(
      url: '/api/search/?query=$query',
      method: 'GET',
      parser: (json) => SearchWrapperModel.fromJson(json),
    );
  }
}