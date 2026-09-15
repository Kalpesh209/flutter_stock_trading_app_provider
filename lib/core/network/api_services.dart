import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/api_constants.dart';

class ApiService {
  static ApiService? _apiService;
  Dio? dio;

  final CookieJar _cookieJar = CookieJar();
  final Duration timeOut = kReleaseMode
      ? const Duration(minutes: 1)
      : const Duration(minutes: 1);

  factory ApiService.getInstance() {
    _apiService ??= ApiService._internal();
    return _apiService!;
  }

  ApiService._internal() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: ApiConstants.sihlUATBaseURL,
      connectTimeout: timeOut,
      receiveTimeout: Duration(minutes: 2),
      receiveDataWhenStatusError: true,
      sendTimeout: timeOut,
    );
    dio = Dio(baseOptions);
    dio!.options.headers['Accept-Encoding'] = 'gzip, deflate, br';
    dio!.interceptors.add(CookieManager(_cookieJar));

    // dio!.interceptors.add(
    //   InterceptorsWrapper(
    //     onResponse: (response, handler) {
    //       debugPrint('✅ STATUS : ${response.statusCode}');

    //       return handler.next(response);
    //     },
    //     onError: (DioException e, handler) {
    //       debugPrint('❌ ERROR TYPE : ${e.type}');

    //       return handler.next(e);
    //     },
    //   ),
    // );
  }

  // To Get Requested Data with Token
  Future<Response?> getRequestedData(String path, {String? authToken}) async {
    Response? response;
    try {
      var options = Options(
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null && authToken.isNotEmpty)
            'Authorization': 'Bearer $authToken',
        },
      );
      response = await dio!.get(path, options: options);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return response;
  }

  // To Post Data with Token
  Future<Response?> postRequestedData(
    String path,
    Map<String, dynamic>? data, {
    String? authToken,
  }) async {
    Response? response;
    try {
      response = await dio?.post(
        path,
        data: data,
        options: Options(
          headers: authToken != null
              ? {'Authorization': 'Bearer $authToken'}
              : null,
        ),
      );
    } on DioException catch (e, s) {
      if (e.response != null) {
        response = e.response;
      } else {
        debugPrint('Network Error: ${e.message}');
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return response;
  }

  // Interactive

  // Future<Response?> postRequestWithTokenData(
  //   String path,
  //   String token,
  //   Map<String, dynamic> data,
  // ) async {
  //   Response? response;
  //   try {
  //     var options = Options(
  //       headers: {'Authorization': token, 'Content-Type': 'application/json'},
  //     );
  //     response = await dio.post(
  //       '${ApiConstants.sihlUATBaseURL}$path',
  //       data: data,
  //       options: options,
  //     );

  //     return response;
  //   } on DioException catch (dioError, e) {
  //     print('DioError in PostRequestWithData: ${dioError.error}');
  //     print('DioError in PostRequestWithData Response: ${dioError.response}');
  //     print('DioError in PostRequestWithData Stacktrace: ${e.toString()}');
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print('Error in PostRequestWithData: ${error.toString()}');
  //     }
  //   }
  //   return response;
  // }

  // // To get a Data With Query Params

  // Future<Response?> securePutRequest(
  //   String path,
  //   String token,
  //   Map<String, dynamic> data,
  // ) async {
  //   Response? response;
  //   try {
  //     var options = Options(headers: {'Authorization': token});
  //     var dataToSend = data;
  //     if (kDebugMode) {}
  //     response = await dio.put(path, data: dataToSend, options: options);
  //     if (kDebugMode) {}

  //     return response;
  //   } on DioException catch (dioError, e) {
  //     if (kDebugMode) {}
  //   } catch (error) {}
  //   return response;
  // }

  // Future<Response?> putRequestWithData(
  //   String path,
  //   Map<String, dynamic> data,
  // ) async {
  //   Response? response;
  //   try {
  //     response = await dio.put(path, data: data);
  //     return response;
  //   } catch (error) {}
  //   return response;
  // }

  // Future<Response?> putRequest(String path, Map<String, dynamic> data) async {
  //   Response? response;
  //   try {
  //     var dataToSend = jsonEncode(data);
  //     response = await dio.put(path, data: dataToSend);
  //     return response;
  //   } on DioException catch (dioError, e) {
  //   } catch (error) {}
  //   return response;
  // }

  // Future<Response?> deleteRequest(String path) async {
  //   Response? response;
  //   try {
  //     response = await dio.delete(path);
  //     return response;
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print('Error in deleteRequest: $error');
  //     }
  //   }
  //   return response;
  // }

  // Future<Response?> getRequest(String path) async {
  //   Response? response;
  //   try {
  //     response = await dio.get(path);
  //     return response;
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print('Error in getRequest: $error');
  //     }
  //   }
  //   return response;
  // }

  // // Original Get Method
  // Future<Response?> getRequestData(String path, String? token) async {
  //   Response? response;
  //   try {
  //     var options = Options(
  //       headers: {'Authorization': token, 'Content-Type': 'application/json'},
  //     );

  //     response = await dio.get(
  //       '${ApiConstants.sihlUATBaseURL}$path',
  //       options: options,
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }

  //   return response;
  // }

  // Future<Response?> patchRequestWithData12(
  //   String path,
  //   Map<String, dynamic> data,
  //   String token,
  // ) async {
  //   Response? response;
  //   try {
  //     var options = Options(headers: {'Authorization': 'Bearer $token'});

  //     response = await dio.patch(path, data: data, options: options);

  //     return response;
  //   } on DioException catch (dioError, e) {
  //   } catch (error) {}
  //   return response;
  // }

  // Future<Response?> patchRequestWithData(
  //   String path,
  //   FormData data,
  //   String token,
  // ) async {
  //   Response? response;
  //   try {
  //     var options = Options(headers: {'Authorization': 'Bearer $token'});

  //     response = await dio.patch(path, data: data, options: options);

  //     return response;
  //   } on DioException catch (dioError, e) {
  //   } catch (error) {}
  //   return response;
  // }

  // Future<Response?> securePostRequestWithFormData(
  //   String path,
  //   FormData data,
  //   String token,
  // ) async {
  //   Response? response;
  //   try {
  //     var options = Options(headers: {'Authorization': 'Bearer $token'});
  //     //  var dataToSend = jsonEncode(data);

  //     response = await dio.post(path, data: data, options: options);

  //     return response;
  //   } on DioException catch (dioError, e) {
  //   } catch (error) {}
  //   return response;
  // }

  // Future<Response?> securePostRequestWithData(
  //   String path,
  //   Map<String, dynamic> data,
  //   String token,
  // ) async {
  //   Response? response;
  //   try {
  //     var options = Options(headers: {'Authorization': 'Bearer $token'});
  //     var dataToSend = jsonEncode(data);

  //     response = await dio.post(path, data: dataToSend, options: options);
  //     if (kDebugMode) {}

  //     return response;
  //   } on DioException catch (dioError, e) {
  //   } catch (error) {}
  //   return response;
  // }

  // // Original Put Request
  // Future<Response?> postRequestWithStringOfArrayData(
  //   String path,
  //   List<String> data,
  //   String token,
  // ) async {
  //   Response? response;
  //   try {
  //     var options = Options(headers: {'Authorization': 'Bearer $token'});
  //     var dataToSend = jsonEncode(data);
  //     response = await dio.post(path, data: dataToSend, options: options);
  //     if (kDebugMode) {}
  //     return response;
  //   } on DioException catch (dioError, e) {
  //   } catch (error) {}
  //   return response;
  // }

  // Delete using a Query Params

  // Future<Response?> secureDeleteRequestUsingQueryParams(
  //   String path,
  //   Map<String, dynamic> queryParam,
  // ) async {
  //   Response? response;
  //   try {
  //     response = await dio.delete(
  //       path,
  //       // options: options,
  //       queryParameters: queryParam,
  //     );

  //     return response;
  //   } on DioException catch (dioError, e) {
  //     return dioError.response;
  //   } catch (error) {}

  //   return response;
  // }

  // //  To Delete a Specific item in a Parameter
  // Future<Response?> secureDeleteRequest(String path, String token) async {
  //   Response? response;
  //   try {
  //     var options = Options(
  //       headers: {'Authorization': token, 'Content-Type': 'application/json'},
  //     );

  //     response = await dio.delete(path, options: options);

  //     return response;
  //   } on DioException catch (dioError, e) {
  //   } catch (error) {}
  //   return response;
  // }
}
