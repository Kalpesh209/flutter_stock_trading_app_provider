import 'package:dio/dio.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/api_constants.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/api_end_points.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_storage_helper.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/core/network/api_services.dart';
import 'package:flutter_stock_trading_app_provider/features/digio/service/digio_service.dart';

/*
Title: DigioRepository 
Purpose: To perform AuthOpertation
Created On:
Edited On:
Author: 
*/

class DigioRepository {
  final ApiService apiService = ApiService.getInstance();
  final appStorageHelper = AppStorageHelper.getInstance();
  final DigioService digioService = DigioService();

  // getAccessToken
  Future<String?> getAccessToken() async {
    final getAccessToken = await appStorageHelper.getData(
      key: AppStrings.accessToken,
    );
    // LogHelper.infoLog('GET Access Token: $getAccessToken');
    return getAccessToken;
  }

  Future<Response?> sendDigiLockerRequest({
    required Map<String, dynamic> requestData,
  }) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.sendDigiLockerRequestURL}';
    final token = await getAccessToken();
    final response = await apiService.postRequestedData(
      url,
      requestData,
      authToken: token,
    );
    return response;
  }

  Future<Response?> fetchDigiLockerResponse({
    required Map<String, dynamic> requestData,
  }) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.fetchDigiLockerResponseURL}';
    final token = await getAccessToken();
    final response = await apiService.postRequestedData(
      url,
      requestData,
      authToken: token,
    );
    return response;
  }

  Future<int?> startDigioKyc({
    required String documentId,
    required String identifier,
    required String tokenId,
  }) async {
    try {
      final response = await digioService.startKyc(
        documentId: documentId,
        identifier: identifier,
        tokenId: tokenId,
      );
      return response.code;
    } catch (e) {
      LogHelper.errorLog('startDigioKyc Exception: $e');
      return null;
    }
  }
}
