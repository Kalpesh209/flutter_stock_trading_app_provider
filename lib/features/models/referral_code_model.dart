import 'package:freezed_annotation/freezed_annotation.dart';
part 'referral_code_model.freezed.dart';
part 'referral_code_model.g.dart';

@freezed
class ReferralCodeModel with _$ReferralCodeModel {
  const factory ReferralCodeModel({bool? success, Data? data}) =
      _ReferralCodeModel;

  factory ReferralCodeModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralCodeModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: 'branchId') int? branchId,
    @JsonKey(name: 'userId') int? userId,

    @JsonKey(name: 'UserType') dynamic userType,
    @JsonKey(name: 'TradingCode') dynamic tradingCode,

    @JsonKey(name: 'braBranchCat') int? braBranchCat,
    @JsonKey(name: 'bratype') int? bratype,

    @JsonKey(name: 'groupId') dynamic groupId,
    @JsonKey(name: 'referialId') dynamic referialId,
    @JsonKey(name: 'empUserId') dynamic empUserId,

    @JsonKey(name: 'ReferralCode') String? referralCode,
    @JsonKey(name: 'Signature') String? signature,
    @JsonKey(name: 'BranchName') String? branchName,
    @JsonKey(name: 'RemisarName') dynamic remisarName,
    @JsonKey(name: 'EasyPartnerName') dynamic easyPartnerName,
    @JsonKey(name: 'EmployeeName') String? employeeName,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
