import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/request_util.dart';
import 'package:twixer/DataModel/search_model.dart';
import 'package:http/http.dart' as http;

final requester = RequesterWithCacheInterceptor();

Future<(bool, List<SearchModel>?, String?)> getRecentSearch(Connection connection) async {
  final result =
      await requester.request(http.get, "/search/history", {"token": connection.token}, cacheResponse: false);

  return handleListResponse(result, "searches", SearchModel.fromJson);
}

Future<(bool, void, String?)> postSearch(Connection connection, String content) async {
  final result = await requester.request(http.post, "/search/history", {"token": connection.token, "content": content});
  if (result.$1) {
    return (true, null, null);
  } else {
    return (false, null, result.$2["error"] as String);
  }
}
