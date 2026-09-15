import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'fetch_kra_agency_detail_models.freezed.dart';
part 'fetch_kra_agency_detail_models.g.dart';

FetchKraAgencyDetailModels fetchKraAgencyDetailModelsFromJson(String str) =>
    FetchKraAgencyDetailModels.fromJson(Map<String, dynamic>.from(json.decode(str) as Map));

String fetchKraAgencyDetailModelsToJson(FetchKraAgencyDetailModels data) =>
    json.encode(data.toJson());

@freezed
class FetchKraAgencyDetailModels with _$FetchKraAgencyDetailModels {
  const factory FetchKraAgencyDetailModels({
    @JsonKey(name: 'success') required bool success,

    @JsonKey(name: 'data') FetchKraAgencyDetailModelsData? data,
  }) = _FetchKraAgencyDetailModels;

  factory FetchKraAgencyDetailModels.fromJson(Map<String, dynamic> json) =>
      _$FetchKraAgencyDetailModelsFromJson(json);
}

@freezed
class FetchKraAgencyDetailModelsData with _$FetchKraAgencyDetailModelsData {
  const factory FetchKraAgencyDetailModelsData({
    @JsonKey(name: 'StatusMessage') dynamic statusMessage,

    @JsonKey(name: 'StatusCode') required int statusCode,

    @JsonKey(name: 'errorCode') dynamic errorCode,

    @JsonKey(name: 'data') DataData? data,

    @JsonKey(name: 'KRAAgencyFile') String? kraAgencyFile,
  }) = _FetchKraAgencyDetailModelsData;

  factory FetchKraAgencyDetailModelsData.fromJson(Map<String, dynamic> json) =>
      _$FetchKraAgencyDetailModelsDataFromJson(json);
}

@freezed
class DataData with _$DataData {
  const factory DataData({
    @JsonKey(name: 'APP_PAN_NO') String? appPanNo,

    @JsonKey(name: 'APP_NAME') String? appName,

    @JsonKey(name: 'APP_STATUS') String? appStatus,

    @JsonKey(name: 'APP_STATUSDT') String? appStatusdt,

    @JsonKey(name: 'APP_ENTRYDT') String? appEntrydt,

    @JsonKey(name: 'APP_MODDT') String? appModdt,

    @JsonKey(name: 'APP_STATUS_DELTA') String? appStatusDelta,

    @JsonKey(name: 'APP_UPDT_STATUS') String? appUpdtStatus,

    @JsonKey(name: 'APP_HOLD_DEACTIVE_RMKS') String? appHoldDeactiveRmks,

    @JsonKey(name: 'APP_UPDT_RMKS') String? appUpdtRmks,

    @JsonKey(name: 'APP_KYC_MODE') String? appKycMode,

    @JsonKey(name: 'APP_IPV_FLAG') String? appIpvFlag,

    @JsonKey(name: 'APP_UBO_FLAG') String? appUboFlag,

    @JsonKey(name: 'APP_PER_ADD_PROOF') String? appPerAddProof,

    @JsonKey(name: 'APP_COR_ADD_PROOF') String? appCorAddProof,
  }) = _DataData;

  factory DataData.fromJson(Map<String, dynamic> json) => _$DataDataFromJson(json);
}

// FetchKraAgencyDetailModels fetchKraAgencyDetailModelsFromJson(String str) =>
//     FetchKraAgencyDetailModels.fromJson(
//       Map<String, dynamic>.from(json.decode(str) as Map),
//     );

// String fetchKraAgencyDetailModelsToJson(FetchKraAgencyDetailModels data) =>
//     json.encode(data.toJson());

// @freezed
// class FetchKraAgencyDetailModels with _$FetchKraAgencyDetailModels {
//   const factory FetchKraAgencyDetailModels({
//     @JsonKey(name: 'success') required bool success,
//     @JsonKey(name: 'data') required FetchKraAgencyDetailModelsData data,
//   }) = _FetchKraAgencyDetailModels;

//   factory FetchKraAgencyDetailModels.fromJson(Map<String, dynamic> json) =>
//       _$FetchKraAgencyDetailModelsFromJson(json);
// }

// @freezed
// class FetchKraAgencyDetailModelsData with _$FetchKraAgencyDetailModelsData {
//   const factory FetchKraAgencyDetailModelsData({
//     @JsonKey(name: 'StatusMessage') required dynamic statusMessage,
//     @JsonKey(name: 'StatusCode') required int statusCode,
//     @JsonKey(name: 'data') required DataData data,
//     @JsonKey(name: 'KRAAgencyFile') required String kraAgencyFile,
//   }) = _FetchKraAgencyDetailModelsData;

//   factory FetchKraAgencyDetailModelsData.fromJson(Map<String, dynamic> json) =>
//       _$FetchKraAgencyDetailModelsDataFromJson(json);
// }

// @freezed
// class DataData with _$DataData {
//   const factory DataData({
//     @JsonKey(name: 'APP_PAN_NO') required String appPanNo,
//     @JsonKey(name: 'APP_NAME') required String appName,
//     @JsonKey(name: 'APP_STATUS') required String appStatus,
//     @JsonKey(name: 'APP_STATUSDT') required String appStatusdt,
//     @JsonKey(name: 'APP_ENTRYDT') required String appEntrydt,
//     @JsonKey(name: 'APP_MODDT') required String appModdt,
//     @JsonKey(name: 'APP_STATUS_DELTA') required String appStatusDelta,
//     @JsonKey(name: 'APP_UPDT_STATUS') required String appUpdtStatus,
//     @JsonKey(name: 'APP_HOLD_DEACTIVE_RMKS')
//     required String appHoldDeactiveRmks,
//     @JsonKey(name: 'APP_UPDT_RMKS') required String appUpdtRmks,
//     @JsonKey(name: 'APP_KYC_MODE') required String appKycMode,
//     @JsonKey(name: 'APP_IPV_FLAG') required String appIpvFlag,
//     @JsonKey(name: 'APP_UBO_FLAG') required String appUboFlag,
//     @JsonKey(name: 'APP_PER_ADD_PROOF') required String appPerAddProof,
//     @JsonKey(name: 'APP_COR_ADD_PROOF') required String appCorAddProof,
//   }) = _DataData;

//   factory DataData.fromJson(Map<String, dynamic> json) =>
//       _$DataDataFromJson(json);
// }
