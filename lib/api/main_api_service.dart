import 'dart:convert';
import 'api_constants.dart';
import 'dio_utils.dart';
import 'package:dio/dio.dart';

class MainApiService {
  static String uuid = "";
  // 呼叫Api
  Future<Map<String, dynamic>> _request<T>(
      String url, Map<String, dynamic> dataMap) async {
    if (dataMap["data"] != null) {
      dataMap["data"] = json.encode(dataMap["data"]);
    }
    FormData formData = FormData.fromMap(dataMap);
    try {
      var response =
          await DioUtils.request(Domain.DOMAIN, Method.POST, url, formData);

      // TEST 專用，於偵錯模式下，顯示請求狀態(沒注掉會影響大頭貼功能)
      // if (kDebugMode) {
      //   log('\n- domain: ${Domain.DOMAIN}\n'
      //       '\n==== $url ====\n'
      //       '\n- request : \n ${json.encode(dataMap)}}\n'
      //       '\n- response : \n ${jsonDecode(EncryptUtil().aesDecrypted(response))}\n'
      //       '\n- time : \n ${DateTime.now()}\n');
      // }

      return jsonDecode(response);
    } catch (e) {
      print('操作失敗: $e');
      return Future.error(e);
    }
  }

  /// 裝置驗證
  Future<Map<String, dynamic>> iOS() async {
    return await _request(Api.IOS, {

    });
  }
}
