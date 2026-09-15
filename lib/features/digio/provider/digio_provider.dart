import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/digio/repository/digio_repository.dart';
import 'package:flutter_stock_trading_app_provider/features/models/fetch_digi_locker_response_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/send_digilocker_request_model.dart';

class DigioProvider extends ChangeNotifier {
  AuthProvider? authProvider;

  final DigioRepository digioRepository = DigioRepository();
  bool _isInitialized = false;
  DigioProvider();

  void update(AuthProvider auth) {
    authProvider = auth;
    if (!_isInitialized) {
      _isInitialized = true;
      init();
    }
  }

  Future<void> init() async {
    startMessageAnimation();
    await sendDigiLockerRequest();
  }

  final List<String> loadingMessages = [
    AppStrings.fetchUserData,
    AppStrings.encryptingInformation,
    AppStrings.transferringDataSecurely,
    AppStrings.dumpingDataFromDigio,
    AppStrings.doneHeadingNextStep,
  ];

  int currentMessageIndex = 0;
  bool isLoading = false;
  Timer? messageTimer;
  SendDigilockerRequestDataModel? digiLockerData;

  FetchDigiLockerResponseModel? fetchDigiLockerResponse;
  String? get panPdf => fetchDigiLockerResponse?.panPdf;
  String? get panImage => fetchDigiLockerResponse?.panImage;
  String? get aadharPdf => fetchDigiLockerResponse?.aadharPdf;
  String? get aadharXml => fetchDigiLockerResponse?.aadharXml;
  String? get signImg => fetchDigiLockerResponse?.signImg;

  void startMessageAnimation() {
    messageTimer?.cancel();
    messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      currentMessageIndex = (currentMessageIndex + 1) % loadingMessages.length;
      notifyListeners();
    });
  }

  Future<void> sendDigiLockerRequest() async {
    final accountType = authProvider!.defaultLoginType.value;
    final mobileNo = authProvider!.mobileController.text.trim();
    final formNo = authProvider!.formNo;

    Map<String, dynamic> requestData = {
      'FormName': AppStrings.onlineClientRegistration,
      'ocrAccountType': accountType,
      'ocrFirstName': null,
      'ocrMiddleName': null,
      'ocrLastName': null,
      'ocrFullName': null,
      'ocrEmailId': null,
      'ocrMobileNo': mobileNo,
      'ocrFormNo': formNo.toString(),
      'Flag': null,
      'Holder': null,
      'ocrMode': null,
      'ocrStageFlag': AppStrings.digiLocker,
    };

    try {
      isLoading = true;
      notifyListeners();
      final response = await digioRepository.sendDigiLockerRequest(
        requestData: requestData,
      );
      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          final digiLockerResponse = SendDigilockerRequestModel.fromJson(data);
          if (digiLockerResponse.success == true &&
              digiLockerResponse.data != null) {
            digiLockerData = digiLockerResponse.data;
            notifyListeners();
            AppHelperWidgets.showSnackBar(
              title: AppStrings.success,
              message: AppStrings.digilockerSentSuccess,
              messageType: AppStrings.responseTypeSuccess,
            );

            LogHelper.infoLog('DigiLocker Request: ${digiLockerResponse.data}');
            try {
              final responseCode = await digioRepository.startDigioKyc(
                documentId: digiLockerResponse.data?.digioDocId ?? '',
                identifier: digiLockerResponse.data?.customerIdentifier ?? '',
                tokenId: digiLockerResponse.data?.accessToken ?? '',
              );

              if (responseCode == 1001) {
                AppHelperWidgets.showSnackBar(
                  title: AppStrings.success,
                  message: AppStrings.kycCompleteSuccess,
                  messageType: AppStrings.responseTypeSuccess,
                );

                await fetchDigiLockerResponseAPI(
                  digioDocId: digiLockerResponse.data?.digioDocId ?? '',
                );
                AppNavigator.push(AppRoutes.panCardVerificationScreen);
              } else {
                AppHelperWidgets.showSnackBar(
                  title: AppStrings.error,
                  message: AppStrings.digioVerificationCancelled,
                  messageType: AppStrings.responseTypeError,
                );
                AppNavigator.clearAndGo(AppRoutes.loginScreen);
              }
            } catch (e) {
              LogHelper.errorLog('startDigioKyc Exception: $e');
              AppHelperWidgets.showSnackBar(
                title: AppStrings.error,
                message: AppStrings.pleaseContactAdmin,
                messageType: AppStrings.responseTypeError,
              );
            }
          } else {
            final message = data['message']?.toString() ?? '';
            AppHelperWidgets.showSnackBar(
              title: AppStrings.error,
              message: message,
              messageType: AppStrings.responseTypeError,
            );
          }
        }
      }
    } catch (e) {
      LogHelper.errorLog('sendDigiLockerRequest Exception: $e');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      isLoading = false;
      notifyListeners();
      AppHelperWidgets.hideLoader();
    }
  }

  Future<void> fetchDigiLockerResponseAPI({required String digioDocId}) async {
    final requestData = {'digio_doc_id': digioDocId};

    try {
      isLoading = true;
      notifyListeners();
      final response = await digioRepository.fetchDigiLockerResponse(
        requestData: requestData,
      );
      if (response == null || response.statusCode != 200) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.failedToFetchData,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final data = response.data;

      if (data is! Map<String, dynamic>) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.failedToFetchData,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final fetchResponse = FetchDigiLockerResponseModel.fromJson(data);
      if (fetchResponse.success != true || fetchResponse.data == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.failedToFetchData,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      fetchDigiLockerResponse = fetchResponse;
      final actions = fetchResponse.data?.actions ?? [];

      if (actions.isEmpty) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.failedToFetchData,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final digilockerAction = actions.firstWhere(
        (e) => (e.type ?? '').toLowerCase() == 'digilocker',
        orElse: () => throw Exception('Digilocker action not found'),
      );

      final aadhar = digilockerAction.details?.aadhaar;
      dynamic pan;

      if (actions.first.details?.pan != null) {
        pan = digilockerAction.details?.pan;
      } else if (actions.length > 1) {
        //   pan = digilockerAction.details?.pan;
        //pan = actions[1].idCardDataResponse;
      }

      if (aadhar == null || pan == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.failedToFetchData,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      /// Split PAN name
      String firstName = '';
      String middleName = '';
      String lastName = '';

      final parts = (pan.name ?? '').trim().split(RegExp(r'\s+'));

      if (parts.length == 3) {
        firstName = parts[0];
        middleName = parts[1];
        lastName = parts[2];
      } else if (parts.length == 2) {
        firstName = parts[0];
        lastName = parts[1];
      } else if (parts.length == 1) {
        firstName = parts[0];
      } else if (parts.length > 3) {
        firstName = parts[0];
        middleName = parts[1];
        lastName = parts.sublist(2).join(' ');
      }

      final currentAddress = mapAddress(aadhar.currentAddressDetails);
      final permanentAddress = mapAddress(aadhar.permanentAddressDetails);
      final corrPerAddressFlag = isSameAddress(currentAddress, permanentAddress)
          ? 1
          : 0;

      authProvider!.globalStateProvider.setState({
        'panDetails': {
          'panNumber': pan.idNumber ?? pan.idNo,
          'firstName': firstName,
          'middleName': middleName,
          'lastName': lastName,
          'dob': pan.dob,
          'panImage': fetchResponse.panImage,
          'panPDF': fetchResponse.panPdf,
        },

        'aadharDetails': {
          'aadhar_dob': aadhar.dob,
          'id_number': aadhar.idNumber,
          'document_type': aadhar.documentType,
          'gender': aadhar.gender,
          'nameAsPerAadhar': aadhar.name,
          'currentAddress': currentAddress,
          'permanentAddress': permanentAddress,
          'aadharPDF': fetchResponse.aadharPdf,
          'aadharXML': fetchResponse.aadharXml,
        },
        'corrPerAddressFlag': corrPerAddressFlag,
      });

      notifyListeners();
      AppNavigator.push(AppRoutes.panCardVerificationScreen);
    } catch (e) {
      LogHelper.errorLog('fetchDigiLockerResponse Exception: $e');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.pleaseContactAdmin,
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      isLoading = false;
      notifyListeners();
      AppHelperWidgets.hideLoader();
    }
  }

  bool isSameAddress(
    Map<String, dynamic> current,
    Map<String, dynamic> permanent,
  ) {
    return const DeepCollectionEquality().equals(current, permanent);
  }

  Map<String, dynamic> mapAddress(DigiLockerAddressDetails? address) {
    if (address == null) return {};
    return {
      'address': address.address,
      'localityOrPostOffice': address.localityOrPostOffice,
      'districtOrCity': address.districtOrCity,
      'state': address.state,
      'pincode': address.pincode,
    };
  }

  @override
  void dispose() {
    messageTimer?.cancel();
    super.dispose();
  }
}
