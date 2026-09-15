import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'fetch_kra_details_models.freezed.dart';
part 'fetch_kra_details_models.g.dart';

// FetchKraDetailsModels fetchKraDetailsModelsFromJson(
//   String str,
// ) => FetchKraDetailsModels.fromJson(
//   json.decode(str) as Map<String, dynamic>,
// );

// String fetchKraDetailsModelsToJson(
//   FetchKraDetailsModels data,
// ) => json.encode(data.toJson());

// @freezed
// class FetchKraDetailsModels with _$FetchKraDetailsModels {
//   const factory FetchKraDetailsModels({
//     @JsonKey(name: 'success') required bool success,

//     @JsonKey(name: 'data')
//     required FetchKraDetailsModelsData data,
//   }) = _FetchKraDetailsModels;

//   factory FetchKraDetailsModels.fromJson(
//     Map<String, dynamic> json,
//   ) => _$FetchKraDetailsModelsFromJson(json);
// }

// @freezed
// class FetchKraDetailsModelsData
//     with _$FetchKraDetailsModelsData {
//   const factory FetchKraDetailsModelsData({
//     @JsonKey(name: 'StatusMessage')
//     required dynamic statusMessage,

//     @JsonKey(name: 'StatusCode') required int statusCode,

//     @JsonKey(name: 'errorCode') required dynamic errorCode,

//     @JsonKey(name: 'data') required DataData data,

//     @JsonKey(name: 'promoterDetails')
//     required dynamic promoterDetails,

//     @JsonKey(name: 'KRAFile') required String kraFile,
//   }) = _FetchKraDetailsModelsData;

//   factory FetchKraDetailsModelsData.fromJson(
//     Map<String, dynamic> json,
//   ) => _$FetchKraDetailsModelsDataFromJson(json);
// }

// @freezed
// class DataData with _$DataData {
//   const factory DataData({
//     @JsonKey(name: 'APP_POS_CODE')
//     required String appPosCode,

//     @JsonKey(name: 'APP_TYPE') required dynamic appType,

//     @JsonKey(name: 'APP_NO') required dynamic appNo,

//     @JsonKey(name: 'APP_PAN_NO') required String appPanNo,

//     @JsonKey(name: 'APP_STATUS') required String appStatus,

//     @JsonKey(name: 'APP_DUMP_TYPE')
//     required String appDumpType,

//     @JsonKey(name: 'APP_DNLDDT') required String appDnlddt,

//     @JsonKey(name: 'APP_VER_NO') required String appVerNo,

//     @JsonKey(name: 'APP_KRA_INFO')
//     required String appKraInfo,

//     @JsonKey(name: 'APP_IOP_FLG') required String appIopFlg,

//     @JsonKey(name: 'APP_FATCA_APPLICABLE_FLAG')
//     required String appFatcaApplicableFlag,

//     @JsonKey(name: 'KRANo') required String kraNo,
//   }) = _DataData;

//   factory DataData.fromJson(Map<String, dynamic> json) =>
//       _$DataDataFromJson(json);
// }

// Existing

FetchKraDetailsModels fetchKraDetailsModelsFromJson(
  String str,
) => FetchKraDetailsModels.fromJson(
  json.decode(str) as Map<String, dynamic>,
);

String fetchKraDetailsModelsToJson(
  FetchKraDetailsModels data,
) => json.encode(data.toJson());

@freezed
class FetchKraDetailsModels with _$FetchKraDetailsModels {
  const factory FetchKraDetailsModels({
    @JsonKey(name: "success") required bool success,

    @JsonKey(name: "data")
    required FetchKraDetailsModelsData data,
  }) = _FetchKraDetailsModels;

  factory FetchKraDetailsModels.fromJson(
    Map<String, dynamic> json,
  ) => _$FetchKraDetailsModelsFromJson(json);
}

@freezed
class FetchKraDetailsModelsData
    with _$FetchKraDetailsModelsData {
  const factory FetchKraDetailsModelsData({
    @JsonKey(name: "StatusMessage")
    required dynamic statusMessage,
    @JsonKey(name: "StatusCode") required int statusCode,
    @JsonKey(name: "errorCode") required dynamic errorCode,
    @JsonKey(name: "data") required DataData data,
    @JsonKey(name: "promoterDetails")
    required dynamic promoterDetails,
    @JsonKey(name: "KRAFile") required String kraFile,
  }) = _FetchKraDetailsModelsData;

  factory FetchKraDetailsModelsData.fromJson(
    Map<String, dynamic> json,
  ) => _$FetchKraDetailsModelsDataFromJson(json);
}

@freezed
class DataData with _$DataData {
  const factory DataData({
    @JsonKey(name: "APP_POS_CODE")
    required String appPosCode,
    @JsonKey(name: "APP_TYPE") required dynamic appType,
    @JsonKey(name: "APP_NO") required dynamic appNo,
    @JsonKey(name: "APP_PAN_NO") required String appPanNo,
    @JsonKey(name: "APP_STATUS") required String appStatus,
    @JsonKey(name: "APP_DUMP_TYPE")
    required String appDumpType,
    @JsonKey(name: "APP_DNLDDT") required String appDnlddt,
    @JsonKey(name: "APP_VER_NO") required String appVerNo,
    @JsonKey(name: "APP_KRA_INFO")
    required String appKraInfo,
    @JsonKey(name: "APP_IOP_FLG") required String appIopFlg,
    @JsonKey(name: "APP_FATCA_APPLICABLE_FLAG")
    required String appFatcaApplicableFlag,
    @JsonKey(name: "GDNDIS_SPLABLD_DTLS")
    required GdndisSplabldDtls gdndisSplabldDtls,
    @JsonKey(name: "KRANo") required String kraNo,
  }) = _DataData;

  factory DataData.fromJson(Map<String, dynamic> json) =>
      _$DataDataFromJson(json);
}

@freezed
class GdndisSplabldDtls with _$GdndisSplabldDtls {
  const factory GdndisSplabldDtls({
    @JsonKey(name: "GDNDIS_SPLABLD_PAN")
    required dynamic gdndisSplabldPan,
    @JsonKey(name: "GDNDIS_SPLABLD_NAME")
    required dynamic gdndisSplabldName,
    @JsonKey(name: "GDNDIS_SPLABLD_POI_TYPE")
    required dynamic gdndisSplabldPoiType,
    @JsonKey(name: "GDNDIS_SPLABLD_POI_NO")
    required dynamic gdndisSplabldPoiNo,
    @JsonKey(name: "GDNDIS_SPLABLD_COUNTRY")
    required dynamic gdndisSplabldCountry,
  }) = _GdndisSplabldDtls;

  factory GdndisSplabldDtls.fromJson(
    Map<String, dynamic> json,
  ) => _$GdndisSplabldDtlsFromJson(json);
}
