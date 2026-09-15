import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_bank_details_model.freezed.dart';
part 'get_bank_details_model.g.dart';


@freezed
class GetBankDetailsModel with _$GetBankDetailsModel {
  const factory GetBankDetailsModel({
    required bool success,
    required GetBankDetailsData data,
  }) = _GetBankDetailsModel;

  factory GetBankDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$GetBankDetailsModelFromJson(json);
}

@freezed
class GetBankDetailsData with _$GetBankDetailsData {
  const factory GetBankDetailsData({
    @Default(<List<BankDetails>>[])
    List<List<BankDetails>> recordsets,

    @Default(<BankDetails>[])
    List<BankDetails> recordset,

    @Default(<String, dynamic>{})
    Map<String, dynamic> output,

    @Default(<dynamic>[])
    List<dynamic> rowsAffected,

    @Default(0)
    int returnValue,
  }) = _GetBankDetailsData;

  factory GetBankDetailsData.fromJson(Map<String, dynamic> json) =>
      _$GetBankDetailsDataFromJson(json);
}

@freezed
class BankDetails with _$BankDetails {
  const factory BankDetails({
    String? MICRCode,
    String? IFSCCode,
    String? bankName,
    String? bankBranchName,
    String? branchAdd1,
    String? branchAdd2,
    String? branchAdd3,
    String? branchAdd4,

    int? bankId,

    @JsonKey(name: 'BranchCountry')
    int? branchCountry,

    @JsonKey(name: 'BranchState')
    int? branchState,

    @JsonKey(name: 'BranchCity')
    int? branchCity,

    @JsonKey(name: 'BranchPinCode')
    int? branchPinCode,

    @JsonKey(name: 'CAMSfipId')
    String? camsFipId,
  }) = _BankDetails;

  factory BankDetails.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsFromJson(json);
}

// @freezed
// class GetBankDetailsModel with _$GetBankDetailsModel {
//   const factory GetBankDetailsModel({required bool success, required GetBankDetailsData data}) = _GetBankDetailsModel;

//   factory GetBankDetailsModel.fromJson(Map<String, dynamic> json) => _$GetBankDetailsModelFromJson(json);
// }

// @freezed
// class GetBankDetailsData with _$GetBankDetailsData {
//   const factory GetBankDetailsData({
//     @Default([]) List<List<GetBankDetailsRecord>> recordsets,
//     @Default([]) List<GetBankDetailsRecord> recordset,
//     @Default({}) Map<String, dynamic> output,
//     @Default([]) List<dynamic> rowsAffected,
//     @Default(0) int returnValue,
//   }) = _GetBankDetailsData;

//   factory GetBankDetailsData.fromJson(Map<String, dynamic> json) => _$GetBankDetailsDataFromJson(json);
// }

// @freezed
// class GetBankDetailsRecord with _$GetBankDetailsRecord {
//   const factory GetBankDetailsRecord({
//     String? MICRCode,
//     String? IFSCCode,
//     String? bankName,
//     String? bankBranchName,
//     String? branchAdd1,
//     String? branchAdd2,
//     String? branchAdd3,
//     String? branchAdd4,
//     int? bankId,
//     int? BranchCountry,
//     int? BranchState,
//     int? BranchCity,
//     int? BranchPinCode,
//     String? CAMSfipId,
//   }) = _GetBankDetailsRecord;

//   factory GetBankDetailsRecord.fromJson(Map<String, dynamic> json) => _$GetBankDetailsRecordFromJson(json);
// }
