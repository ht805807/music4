import 'dart:convert';
import 'package:dio/dio.dart';

import 'error_handle.dart';

const int _connectTimeout = 15000; //15s
const int _receiveTimeout = 15000;
const int _sendTimeout = 10000;

typedef Success<T> = Function(T data);
typedef Fail = Function(String code, String msg);
class DioUtils {
  // default options
  static const String TOKEN = '';

  static Map<String,Dio> _dioMap = {};

  /// 當前請求的路徑
  static String? _baseUrl;

  // DIO
  static Dio createInstance(String baseUrl) {
    _baseUrl = baseUrl;
    if (_dioMap[baseUrl] == null) {
      var options = BaseOptions(
        responseType: ResponseType.json,
        validateStatus: (status) {
          return true;
        },
        baseUrl: baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
      );
      _dioMap[baseUrl] = Dio(options);
    }
    return _dioMap[baseUrl]!;
  }

  // 清空 dio 对象
  static clear() {
    _dioMap.clear();
  }

  /// 請求回調
  /// domain : Domain.DOMAIN_VOUCHER、Domain.DOMAIN
  static Future<T> request<T>(String domain, Method method, String path, dynamic params, {Map<String, String>? headers}) async {
    try {
      var dio = createInstance(domain);
      Response response = await dio.post(path,
          data: params, options: Options(method: MethodValues[method],headers:headers));
      return response.data;
    } on DioError catch (e) {
      final NetError netError = ExceptionHandle.handleException(e);
      return Future.error({'code':netError.code, 'msg':netError.msg});
    }
  }

  /// 結束當前 DIO 請求
  static void close(){
    _dioMap[_baseUrl]?.close();
    _dioMap.remove(_baseUrl);
  }

}

/// 自定义Header
Map<String, dynamic> httpHeaders = {
  'Accept': 'application/json,*/*',
  'Content-Type': 'application/json',
  'token': DioUtils.TOKEN
};

void _onError(int code, String msg, Fail fail) {
  if (code == null) {
    code = ExceptionHandle.unknown_error;
    msg = '未知異常';
  }
}

Map<String, dynamic> parseData(String data) {
  return jsonDecode(data) as Map<String, dynamic>;
}

enum Method { GET, POST, DELETE, PUT, PATCH, HEAD }
//使用：MethodValues[Method.POST]
const MethodValues = {
  Method.GET: "get",
  Method.POST: "post",
  Method.DELETE: "delete",
  Method.PUT: "put",
  Method.PATCH: "patch",
  Method.HEAD: "head",
};