import 'package:dio/dio.dart';

import 'dio_client.dart';

class ApiClient {
  Future get(String path, {query}) async {}
  Future post(String path, body, {query}) async {}
}

final apiClient = DioClient();
var dio = Dio();

//  String token = await Candidate().getToken();
//     final response = await http.get(url, headers: {
      // 'Content-Type': 'application/json',
      // 'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     });
//     print('Token : ${token}');
//     print(response);