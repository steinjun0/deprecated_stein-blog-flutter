import 'dart:convert';

import 'package:http/http.dart' as http;

const serverHost = "http://localhost/api";

Future getAPI(apiUrl, {Map<String, dynamic> queryParameter = const {}}) async {
  var url =
      Uri.parse('$serverHost$apiUrl').replace(queryParameters: queryParameter);
  final response = await http.get(url);
  return response;
}

Future<List> getCategoryFilteredList(List<String> categories) async {
  Map<String, String> queryParameter = {
    for (String category in categories) 'category': category
  };
  http.Response response = await getAPI('/blog/post/get_category_filtered_list',
      queryParameter: queryParameter);

  // print(jsonDecode(utf8.decode(response.bodyBytes)));
  return jsonDecode(utf8.decode(response.bodyBytes)); // jsonDecode는 list를 반환한다.
}

Future getMainPageList() async {
  http.Response response = await getAPI('/blog/post/get_main_page_list');
  // print(jsonDecode(utf8.decode(response.bodyBytes)));
  return jsonDecode(utf8.decode(response.bodyBytes)); // jsonDecode는 list를 반환한다.
}