import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_selfie_request_model.freezed.dart';
part 'send_selfie_request_model.g.dart';

@freezed
class SendSelfieRequestModel with _$SendSelfieRequestModel {
  const factory SendSelfieRequestModel({
    @Default(false) bool success,
    SendSelfieMessage? message,
    SendSelfieData? data,
  }) = _SendSelfieRequestModel;

  factory SendSelfieRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendSelfieRequestModelFromJson(json);
}

@freezed
class SendSelfieMessage with _$SendSelfieMessage {
  const factory SendSelfieMessage({
    @Default('') String id,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @Default('') String status,
    @JsonKey(name: 'customer_identifier') @Default('') String customerIdentifier,
    @JsonKey(name: 'reference_id') @Default('') String referenceId,
    @JsonKey(name: 'transaction_id') @Default('') String transactionId,
    @JsonKey(name: 'customer_name') @Default('') String customerName,
    @JsonKey(name: 'expire_in_days') @Default(0) int expireInDays,
    @JsonKey(name: 'reminder_registered') @Default(false) bool reminderRegistered,
    @JsonKey(name: 'access_token') SendSelfieAccessToken? accessToken,
    @JsonKey(name: 'workflow_name') @Default('') String workflowName,
    @JsonKey(name: 'auto_approved') @Default(false) bool autoApproved,
    @JsonKey(name: 'template_id') @Default('') String templateId,
  }) = _SendSelfieMessage;

  factory SendSelfieMessage.fromJson(Map<String, dynamic> json) =>
      _$SendSelfieMessageFromJson(json);
}

@freezed
class SendSelfieAccessToken with _$SendSelfieAccessToken {
  const factory SendSelfieAccessToken({
    @JsonKey(name: 'entity_id') @Default('') String entityId,
    @Default('') String id,
    @JsonKey(name: 'valid_till') @Default('') String validTill,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
  }) = _SendSelfieAccessToken;

  factory SendSelfieAccessToken.fromJson(Map<String, dynamic> json) =>
      _$SendSelfieAccessTokenFromJson(json);
}

@freezed
class SendSelfieData with _$SendSelfieData {
  const factory SendSelfieData({@Default(false) bool success, SendSelfieResponseData? data}) =
      _SendSelfieData;

  factory SendSelfieData.fromJson(Map<String, dynamic> json) => _$SendSelfieDataFromJson(json);
}

@freezed
class SendSelfieResponseData with _$SendSelfieResponseData {
  const factory SendSelfieResponseData({
    @Default([]) List<dynamic> recordsets,
    SendSelfieOutput? output,
    @Default([]) List<dynamic> rowsAffected,
    @Default(0) int returnValue,
  }) = _SendSelfieResponseData;

  factory SendSelfieResponseData.fromJson(Map<String, dynamic> json) =>
      _$SendSelfieResponseDataFromJson(json);
}

@freezed
class SendSelfieOutput with _$SendSelfieOutput {
  const factory SendSelfieOutput({
    @JsonKey(name: 'return_Message') @Default('') String returnMessage,
    @JsonKey(name: 'return_Value') @Default(0) int returnValue,
    @JsonKey(name: 'return_FormNo') @Default(0) int returnFormNo,
    @JsonKey(name: 'return_imageSizeCheck') @Default('') String returnImageSizeCheck,
    @JsonKey(name: 'return_TradingCode') String? returnTradingCode,
  }) = _SendSelfieOutput;

  factory SendSelfieOutput.fromJson(Map<String, dynamic> json) => _$SendSelfieOutputFromJson(json);
}
