import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shahinvestor/core/appUtils/app_enums.dart';

part 'static_data_model.freezed.dart';
part 'static_data_model.g.dart';

// ============================================================================
// Main Model Classes
// ============================================================================

@freezed
class StaticDataModel with _$StaticDataModel {
  const factory StaticDataModel({
    required List<List<FluffyRecordset>> recordsets,
    required List<PurpleRecordset> recordset,
    required Output output,
    required List<int> rowsAffected,
    required int returnValue,
  }) = _StaticDataModel;

  factory StaticDataModel.fromJson(Map<String, dynamic> json) => _$StaticDataModelFromJson(json);
}

@freezed
class Output with _$Output {
  const factory Output() = _Output;

  factory Output.fromJson(Map<String, dynamic> json) => _$OutputFromJson(json);
}

@freezed
class PurpleRecordset with _$PurpleRecordset {
  const factory PurpleRecordset({
    required int id,
    required String name,

    // Country
    @JsonKey(name: 'CVLValue') String? cvlValue,

    @JsonKey(name: 'InternationalDialingCode') String? internationalDialingCode,

    // Relations
    String? countryId,
    String? stateId,
    String? cityId,
  }) = _PurpleRecordset;

  factory PurpleRecordset.fromJson(Map<String, dynamic> json) => _$PurpleRecordsetFromJson(json);
}

@freezed
class FluffyRecordsets with _$FluffyRecordsets {
  const FluffyRecordsets._();

  const factory FluffyRecordsets({required List<FluffyRecordset> items}) = _FluffyRecordsets;

  factory FluffyRecordsets.fromJson(Map<String, dynamic> json) => _$FluffyRecordsetsFromJson(json);

  /// Factory constructor from a list of records
  factory FluffyRecordsets.fromList(List<FluffyRecordset> records) => FluffyRecordsets(items: records);

  /// Get first item safely
  FluffyRecordset? get first => items.isNotEmpty ? items.first : null;

  /// Get last item safely
  FluffyRecordset? get last => items.isNotEmpty ? items.last : null;

  /// Get item at index safely
  FluffyRecordset? getAt(int index) => index >= 0 && index < items.length ? items[index] : null;
}

@freezed
class FluffyRecordset with _$FluffyRecordset {
  const factory FluffyRecordset({
    // ─── Account ───────────────────────────────────────────
    @JsonKey(name: 'accountOption') int? accountOption,
    @JsonKey(name: 'accountSubCategory') int? accountSubCategory,
    @JsonKey(name: 'accountSubCategoryName') AccountSubCategoryName? accountSubCategoryName,
    @JsonKey(name: 'accountType') int? accountType,
    @JsonKey(name: 'billingCategory') int? billingCategory,
    @JsonKey(name: 'businessCode') String? businessCode,
    @JsonKey(name: 'clientRiskCategory') int? clientRiskCategory,
    @JsonKey(name: 'clientType') int? clientType,

    // ─── KRA / API Config ──────────────────────────────────
    @JsonKey(name: 'URL') String? url,
    @JsonKey(name: 'GetPasswordURL') String? getPasswordUrl,
    @JsonKey(name: 'GetPanStatusURL') String? getPanStatusUrl,
    @JsonKey(name: 'FetchKRAURL') String? fetchKraurl,
    @JsonKey(name: 'FetchType') String? fetchType,
    @JsonKey(name: 'Flag') String? flag,
    @JsonKey(name: 'EnvelopeURL') String? envelopeUrl,
    @JsonKey(name: 'KRARequestURL') String? kraRequestUrl,
    @JsonKey(name: 'UserName') String? userName,
    @JsonKey(name: 'Password') String? password,
    @JsonKey(name: 'PassKey') String? passKey,
    @JsonKey(name: 'POSCode') String? posCode,
    @JsonKey(name: 'RTACode') String? rtaCode,
    @JsonKey(name: 'encryptionKey') String? encryptionKey,
    @JsonKey(name: 'apiKey') String? apiKey,

    // ─── Personal / KYC ────────────────────────────────────
    @JsonKey(name: 'branchId') dynamic branchId,
    @JsonKey(name: 'cityId') String? cityId,
    @JsonKey(name: 'countryBirth') int? countryBirth,
    @JsonKey(name: 'countryId') String? countryId,
    @JsonKey(name: 'cvlValue') String? cvlValue,
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'designation') Designation? designation,
    @JsonKey(name: 'empCode') String? empCode,
    @JsonKey(name: 'groupName') String? groupName,
    @JsonKey(name: 'gstNo') dynamic gstNo,
    @JsonKey(name: 'id') dynamic id,
    @JsonKey(name: 'internationalDialingCode') String? internationalDialingCode,
    @JsonKey(name: 'isMandatory') bool? isMandatory,
    @JsonKey(name: 'isZeroBrkScheme') bool? isZeroBrkScheme,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'Nationality') int? nationality,
    @JsonKey(name: 'NoOfDocuments') int? noOfDocuments,
    @JsonKey(name: 'NoOfDocumentsSubmitted') int? noOfDocumentsSubmitted,
    @JsonKey(name: 'nriPisNo') dynamic nriPisNo,
    @JsonKey(name: 'nriType') dynamic nriType,
    @JsonKey(name: 'ResidentialStatus') int? residentialStatus,
    @JsonKey(name: 'stateId') String? stateId,
    @JsonKey(name: 'UserType') String? userType,

    // ─── Flags / Booleans ──────────────────────────────────
    @JsonKey(name: 'chkBSDAFlag') bool? chkBsdaFlag,
    @JsonKey(name: 'chkDDPIFlag') bool? chkDdpiFlag,
    @JsonKey(name: 'chkDISIssueFlag') bool? chkDisIssueFlag,
    @JsonKey(name: 'chkInPersonVerifiedFlag') int? chkInPersonVerifiedFlag,
    @JsonKey(name: 'ECN') bool? ecn,
    @JsonKey(name: 'FATCA') bool? fatca,
    @JsonKey(name: 'PEP') bool? pep,
    @JsonKey(name: 'RoundFlag') RoundFlag? roundFlag,

    // ─── FATCA ─────────────────────────────────────────────
    @JsonKey(name: 'FATCACountryCitizenship') dynamic fatcaCountryCitizenship,
    @JsonKey(name: 'FATCACountryResidency') dynamic fatcaCountryResidency,
    @JsonKey(name: 'FATCADoD') dynamic fatcaDoD,
    @JsonKey(name: 'FATCATaxExemptFlag') dynamic fatcaTaxExemptFlag,
    @JsonKey(name: 'FATCATaxExemptReason') dynamic fatcaTaxExemptReason,
    @JsonKey(name: 'taxApplicableOutsideIndia') int? taxApplicableOutsideIndia,
    @JsonKey(name: 'taxEligibleCountry') dynamic taxEligibleCountry,
    @JsonKey(name: 'taxIndificationNumber') dynamic taxIndificationNumber,
    @JsonKey(name: 'taxPayableAddressFlag') dynamic taxPayableAddressFlag,

    // ─── Delivery ──────────────────────────────────────────
    @JsonKey(name: 'DelDescription') String? delDescription,
    @JsonKey(name: 'DeliveryDesc') String? deliveryDesc,
    @JsonKey(name: 'Deltype') String? deltype,

    // ─── Execution ─────────────────────────────────────────
    @JsonKey(name: 'exeDesc') dynamic exeDesc,
    @JsonKey(name: 'ExeDescription') String? exeDescription,
    @JsonKey(name: 'ExeType') String? exeType,

    // ─── Futures ───────────────────────────────────────────
    @JsonKey(name: 'FutDesc') String? futDesc,
    @JsonKey(name: 'FutDescription') String? futDescription,
    @JsonKey(name: 'FutType') String? futType,

    // ─── Intraday ──────────────────────────────────────────
    @JsonKey(name: 'IntradayDesc') String? intradayDesc,

    // ─── Job ───────────────────────────────────────────────
    @JsonKey(name: 'JobDescription') String? jobDescription,
    @JsonKey(name: 'JobType') String? jobType,

    // ─── NRI / RBI ─────────────────────────────────────────
    @JsonKey(name: 'nsdlClientSubType') int? nsdlClientSubType,
    @JsonKey(name: 'nsdlClientType') int? nsdlClientType,
    @JsonKey(name: 'nsdlScheme') int? nsdlScheme,
    @JsonKey(name: 'rbiApprovalDate') dynamic rbiApprovalDate,
    @JsonKey(name: 'rbiRefNo') dynamic rbiRefNo,

    // ─── OCR ───────────────────────────────────────────────
    @JsonKey(name: 'ocrAppForFatca') int? ocrAppForFatca,
    @JsonKey(name: 'ocrBillingCategory') int? ocrBillingCategory,
    @JsonKey(name: 'ocrBSDAFlag') int? ocrBsdaFlag,
    @JsonKey(name: 'ocrBusinessId') int? ocrBusinessId,
    @JsonKey(name: 'ocrClientType') int? ocrClientType,
    @JsonKey(name: 'ocrCorrAddressProof') int? ocrCorrAddressProof,
    @JsonKey(name: 'ocrDateOfDeclaration') DateTime? ocrDateOfDeclaration,
    @JsonKey(name: 'ocrDelCode') int? ocrDelCode,
    @JsonKey(name: 'ocrDeltype') int? ocrDeltype,
    @JsonKey(name: 'ocrEcnFlag') int? ocrEcnFlag,
    @JsonKey(name: 'ocrExeCode') int? ocrExeCode,
    @JsonKey(name: 'ocrExeType') int? ocrExeType,
    @JsonKey(name: 'ocrFutCode') int? ocrFutCode,
    @JsonKey(name: 'ocrFutType') int? ocrFutType,
    @JsonKey(name: 'ocrIdentityProof') int? ocrIdentityProof,
    @JsonKey(name: 'ocrInPersonVerificationFlag') int? ocrInPersonVerificationFlag,
    @JsonKey(name: 'ocrJobCode') int? ocrJobCode,
    @JsonKey(name: 'ocrJobtype') int? ocrJobtype,
    @JsonKey(name: 'ocrNsdlScheme') int? ocrNsdlScheme,
    @JsonKey(name: 'ocrOneSideBrk') bool? ocrOneSideBrk,
    @JsonKey(name: 'ocrOneSidecode') int? ocrOneSidecode,
    @JsonKey(name: 'ocrOptCode') int? ocrOptCode,
    @JsonKey(name: 'ocrOptType') int? ocrOptType,
    @JsonKey(name: 'ocrPerAddressProof') int? ocrPerAddressProof,
    @JsonKey(name: 'perAddressProofExpiryDate') DateTime? perAddressProofExpiryDate,

    @JsonKey(name: 'corrAddressProofExpiryDate') DateTime? corrAddressProofExpiryDate,

    @JsonKey(name: 'ocrRoundFlag') int? ocrRoundFlag,

    @JsonKey(name: 'ocrSLBMCode') int? ocrSlbmCode,
    @JsonKey(name: 'ocrSLBMType') int? ocrSlbmType,
    @JsonKey(name: 'ocrTradingType') int? ocrTradingType,
    @JsonKey(name: 'ocrFax') String? ocrFax,

    // ─── Options ───────────────────────────────────────────
    @JsonKey(name: 'OneSideBrk') dynamic oneSideBrk,
    @JsonKey(name: 'OneSideDescription') dynamic oneSideDescription,
    @JsonKey(name: 'OptDesc') String? optDesc,
    @JsonKey(name: 'OptDescription') String? optDescription,
    @JsonKey(name: 'OptType') String? optType,

    // ─── SLBM ──────────────────────────────────────────────
    @JsonKey(name: 'SLBMDescription') String? slbmDescription,
    @JsonKey(name: 'SLBMType') String? slbmType,

    // ─── STA ───────────────────────────────────────────────
    @JsonKey(name: 'staGroupCode') int? staGroupCode,
    @JsonKey(name: 'staTypeCode') int? staTypeCode,

    // ─── Trading ───────────────────────────────────────────
    @JsonKey(name: 'tradingCode') String? tradingCode,
    @JsonKey(name: 'tradingType') int? tradingType,
  }) = _FluffyRecordset;

  factory FluffyRecordset.fromJson(Map<String, dynamic> json) => _$FluffyRecordsetFromJson(json);
}
