import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_digilocker_request_model.freezed.dart';
part 'send_digilocker_request_model.g.dart';

@freezed
class SendDigilockerRequestModel with _$SendDigilockerRequestModel {
  const factory SendDigilockerRequestModel({
    bool? success,
    SendDigilockerRequestDataModel? data, // renamed here
  }) = _SendDigilockerRequestModel;

  factory SendDigilockerRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendDigilockerRequestModelFromJson(json);
}

@freezed
class SendDigilockerRequestDataModel with _$SendDigilockerRequestDataModel {
  // renamed here
  const factory SendDigilockerRequestDataModel({
    // renamed here
    @JsonKey(name: 'digio_doc_id') String? digioDocId,
    @JsonKey(name: 'customer_identifier') String? customerIdentifier,
    @JsonKey(name: 'accessToken') String? accessToken,
  }) = _SendDigilockerRequestDataModel; // renamed here

  factory SendDigilockerRequestDataModel.fromJson(Map<String, dynamic> json) =>
      _$SendDigilockerRequestDataModelFromJson(json); // renamed here
}
