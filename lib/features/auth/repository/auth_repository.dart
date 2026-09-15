import 'package:dio/dio.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/api_constants.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/api_end_points.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_storage_helper.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/core/network/api_services.dart';

/*
Title: AuthRepository 
Purpose: To perform AuthOpertation
Created On:
Edited On:
Author: 
*/

class AuthRepository {
  final ApiService apiService = ApiService.getInstance();
  final appStorageHelper = AppStorageHelper.getInstance();

  // getAccessToken
  Future<String?> getAccessToken() async {
    final getAccessToken = await appStorageHelper.getData(
      key: AppStrings.accessToken,
    );
    return getAccessToken;
  }

  // To get Static Data
  Future<Response?> getStaticData({String isReload = 'N'}) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.getStaticDataURL}'
        '$isReload';
    try {
      return await apiService.getRequestedData(url);
    } catch (e) {
      LogHelper.errorLog('getStaticData Exception: $e');
      rethrow;
    }
  }

  //To check checkMobileExists
  Future<Response?> checkMobileExist({required String mobile}) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.checkMobileExistURL}'
        '$mobile';

    try {
      return await apiService.getRequestedData(url);
    } catch (e) {
      LogHelper.errorLog('checkMobileExist: $e');
      rethrow;
    }
  }

  // To check existing Client or not ?
  Future<Response?> fetchExistingClientDetails({required String mobile}) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.fetchExistingClientDetailsURL}'
        '$mobile';

    try {
      final token = await getAccessToken();
      final response = await apiService.getRequestedData(url, authToken: token);
      return response;
    } catch (e) {
      LogHelper.errorLog('fetchExistingClientDetails: $e');
      rethrow;
    }
  }

  // To Send OTP
  Future<Response?> sendOTP({sendOTPRequestData}) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.sendOTPURL}';

    try {
      final response = await apiService.postRequestedData(
        url,
        sendOTPRequestData,
      );
      return response;
    } catch (e) {
      LogHelper.errorLog('Send OTP Exception: $e');
      rethrow;
    }
  }

  Future<Response?> verifyOTP({
    required Map<String, dynamic> verifyOTPRequestData,
  }) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.verifyOTPURL}';

    try {
      final response = await apiService.postRequestedData(
        url,
        verifyOTPRequestData,
      );
      return response;
    } catch (e) {
      LogHelper.errorLog('Verify OTP Exception: $e');
      rethrow;
    }
  }

  // Referral Code API
  Future<Response?> getReferralCode({required String referralCode}) async {
    final finalReferralCode = referralCode.isEmpty ? 'null' : referralCode;

    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.referralCodeURL}'
        '$finalReferralCode';

    try {
      final response = await apiService.getRequestedData(url);
      return response;
    } catch (e) {
      LogHelper.errorLog('Referral Code Exception: $e');
      rethrow;
    }
  }

  // Insert Data
  Future<Response?> insertDataRepo({
    required Map<String, dynamic> requestData,
  }) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.insertDataIntoDBURL}';

    try {
      final token = await getAccessToken();
      final response = await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
      return response;
    } catch (e) {
      LogHelper.errorLog('Insert Data Exception: $e');
      rethrow;
    }
  }

  Future<Response?> deleteFormDetailsForMinorAndOnlyDematCases({
    required String ocrPanNo,
    required int ocrFormNo,
    required String deleteReason,
  }) async {
    final String deleteFinalPath =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.deleteFormDetailsForMinorAndOnlyDematCasesURL}';

    final Map<String, dynamic> requestData = {
      'ocrPanNo': ocrPanNo.trim().toUpperCase(),
      'ocrFormNo': ocrFormNo,
      'DeleteReason': deleteReason,
    };

    try {
      final token = await getAccessToken();
      final response = await apiService.postRequestedData(
        deleteFinalPath,
        requestData,
        authToken: token,
      );
      return response;
    } catch (e, stackTrace) {
      LogHelper.errorLog(
        'deleteFormDetailsForMinorAndOnlyDematCases Exception: $e',
      );
      LogHelper.errorLog(stackTrace.toString());
      return null;
    }
  }

  // To CheckBanPancard
  Future<Response?> checkBanPanCard({
    required String panNo,
    required String branchId,
    required String userType,
  }) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.checkBanPanCardURL}'
        '$panNo/$branchId/$userType';

    try {
      final token = await getAccessToken();
      // LogHelper.infoLog('checkBanPanCard TOKEN:: $token');
      final response = await apiService.getRequestedData(url, authToken: token);
      return response;
    } catch (e) {
      LogHelper.errorLog('checkBanPanCard Exception: $e');
      rethrow;
    }
  }

  // newPanVerification
  Future<Response?> newPanVerification({
    required Map<String, dynamic> requestData,
  }) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.newPanVerificationURL}';

    try {
      final token = await getAccessToken();
      return await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
    } catch (e) {
      LogHelper.errorLog('newPanVerification Exception: $e');
      rethrow;
    }
  }

  //fetchKRAAgencyDetails
  Future<Response?> fetchKRAAgencyDetails({
    required Map<String, dynamic> requestData,
  }) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.fetchKRAAgencyDetailsURL}';

    // LogHelper.infoLog('fetchKRAAgencyDetails Request: $requestData');

    try {
      final token = await getAccessToken();
      return await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
    } catch (e) {
      LogHelper.errorLog('fetchKRAAgencyDetails Exception: $e');

      rethrow;
    }
  }

  // FetchKRADetails
  Future<Response?> fetchKRADetails({
    required Map<String, dynamic> requestData,
  }) async {
    final String url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.fetchKRADetailsURL}';

    try {
      final token = await getAccessToken();
      return await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
    } catch (e) {
      LogHelper.errorLog('fetchKRADetails Exception: $e');

      rethrow;
    }
  }

  // Insert AddressInfo
  Future<Response?> insertAddressInfo({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final token = await getAccessToken();
      final String url =
          '${ApiConstants.sihlUATBaseURL}${ApiEndPoints.insertDataIntoDBURL}';
      final response = await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
      return response;
    } catch (e) {
      LogHelper.errorLog('insertAddressInfo Exception: $e');
      return null;
    }
  }

  // Get Bank Details by IFSC
  Future<Response?> getBankDetailsByIFSC({required String searchedIFSC}) async {
    final finalSearchedIFSCCode = searchedIFSC.isEmpty ? 'null' : searchedIFSC;

    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.getBankDetailsURL}'
        '$finalSearchedIFSCCode';

    // LogHelper.infoLog('GET BANK DEtails: $url');
    try {
      final token = await getAccessToken();
      final response = await apiService.getRequestedData(url, authToken: token);
      return response;
    } catch (e) {
      LogHelper.errorLog('Get Bank Details By IFSC Exception: $e');
      rethrow;
    }
  }

  // Get NSDL SubTypes
  Future<Response?> getNSDLSubTypes({required String nsdlClientId}) async {
    final url =
        '${ApiConstants.sihlUATBaseURL}'
        '${ApiEndPoints.getNSDLSubTypeURL}'
        '$nsdlClientId';

    try {
      final token = await getAccessToken();
      final response = await apiService.getRequestedData(url, authToken: token);
      return response;
    } catch (e) {
      LogHelper.errorLog('Get NSDL Sub Types Exception: $e');
      rethrow;
    }
  }

  // NewCashfreeBankAccountVerificationAPI
  Future<Response?> newCashfreeBankAccountVerification({
    required Map<String, dynamic> requestPayLoad,
  }) async {
    try {
      final token = await getAccessToken();
      // LogHelper.infoLog('NEW CASH FREE TOKEN :::  $token');
      final String url =
          '${ApiConstants.sihlUATBaseURL}${ApiEndPoints.newCashfreeBankAccountVerificationAPIURL}';
      final response = await apiService.postRequestedData(
        url,
        requestPayLoad,
        authToken: token,
      );
      return response;
    } catch (e) {
      LogHelper.errorLog('insertAddressInfo Exception: $e');
      return null;
    }
  }

  //saveBankAccountVerificationAPI
  Future<Response?> saveBankAccountVerificationLog({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final token = await getAccessToken();
      final String url =
          '${ApiConstants.sihlUATBaseURL}${ApiEndPoints.saveBankAccountVerificationLogURL}';
      final response = await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
      // LogHelper.infoLog('saveBankAccountVerificationLog : ${response?.data}');
      return response;
    } catch (e) {
      LogHelper.errorLog('saveBankAccountVerificationLog Exception: $e');
      return null;
    }
  }

  Future<Response?> resizeImageRepo({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final token = await getAccessToken();
      final url =
          '${ApiConstants.sihlUATBaseURL}${ApiEndPoints.selfieResizeURL}';
      final response = await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );

      return response;
    } catch (e, s) {
      LogHelper.errorLog('resizeImageRepo Exception: $e');
      LogHelper.errorLog(s.toString());
      return null;
    }
  }

  //sendSelfieRequestRepo
  Future<Response?> sendSelfieRequestRepo({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final token = await getAccessToken();
      final url =
          '${ApiConstants.sihlUATBaseURL}${ApiEndPoints.sendSelfieRequestURL}';
      final response = await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
      return response;
    } catch (e, s) {
      LogHelper.errorLog('sendSelfieRequestRepo Exception: $e');
      LogHelper.errorLog(s.toString());
      return null;
    }
  }

  //fetchSelfieResponseRepo
  Future<Response?> fetchSelfieResponseRepo({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final token = await getAccessToken();
      final url =
          '${ApiConstants.sihlUATBaseURL}${ApiEndPoints.fetchSelfieRequestURL}';
      final response = await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
      return response;
    } catch (e, s) {
      LogHelper.errorLog('fetchSelfieResponseRepo Exception: $e');
      LogHelper.errorLog(s.toString());
      return null;
    }
  }

  //generateCKYCRequestRepo
  Future<Response?> generateCKYCDocRequestRepo({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final token = await getAccessToken();
      final url =
          '${ApiConstants.sihlUATBaseURL}${ApiEndPoints.generateCKYCDOCURL}';
      final response = await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
      return response;
    } catch (e, s) {
      LogHelper.errorLog('generateCKYCRequestRepo Exception: $e');
      LogHelper.errorLog(s.toString());
      return null;
    }
  }

  // CAMS API
  //importIncomeProofRequestRepo
  Future<Response?> importIncomeProofRepo({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final url =
          '${ApiConstants.camsUATBaseURL}${ApiEndPoints.importIncomeProofURL}';
      final response = await apiService.postRequestedData(url, requestData);
      return response;
    } catch (e, s) {
      LogHelper.errorLog('importIncomeProofRepo Exception: $e');
      LogHelper.errorLog(s.toString());
      return null;
    }
  }

  // CAMS API
  //getIncomeProofRepo
  Future<Response?> getIncomeProofRepo({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final url =
          '${ApiConstants.camsUATBaseURL}${ApiEndPoints.getIncomeProofURL}';
      final response = await apiService.postRequestedData(url, requestData);
      return response;
    } catch (e, s) {
      LogHelper.errorLog('getIncomeProofRepo Exception: $e');
      LogHelper.errorLog(s.toString());
      return null;
    }
  }

  //checkIncomeProofIsEncryptedOrPasswordProtectedRepo
  Future<Response?> checkIncomeProofIsEncryptedOrPasswordProtectedRepo({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final token = await getAccessToken();
      final url =
          '${ApiConstants.sihlUATBaseURL}${ApiEndPoints.checkIncomeProofIsEncryptedOrPasswordProtectedURL}';

      final response = await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
      return response;
    } catch (e, s) {
      LogHelper.errorLog(
        'checkIncomeProofIsEncryptedOrPasswordProtectedRepo Exception: $e',
      );
      LogHelper.errorLog(s.toString());
      return null;
    }
  }

  //PDFResizeRepo
  Future<Response?> pdfResizeRepo({
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final token = await getAccessToken();
      final url = '${ApiConstants.sihlUATBaseURL}${ApiEndPoints.pdfResizeURL}';
      final response = await apiService.postRequestedData(
        url,
        requestData,
        authToken: token,
      );
      // LogHelper.infoLog('PDF RESIZE REPO:::  $response');
      return response;
    } catch (e, s) {
      LogHelper.errorLog('pdfResizeRepo Exception: $e');
      LogHelper.errorLog(s.toString());
      return null;
    }
  }
}
