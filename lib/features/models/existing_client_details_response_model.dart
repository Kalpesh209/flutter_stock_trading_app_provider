import 'package:freezed_annotation/freezed_annotation.dart';

part 'existing_client_details_response_model.freezed.dart';
part 'existing_client_details_response_model.g.dart';

@freezed
class ExistingClientDetailsResponseModel
    with _$ExistingClientDetailsResponseModel {
  const factory ExistingClientDetailsResponseModel({
    @JsonKey(name: 'success') required bool success,
    @JsonKey(name: 'data') required ResponseData data,
  }) = _ExistingClientDetailsResponseModel;

  factory ExistingClientDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ExistingClientDetailsResponseModelFromJson(json);
}

@freezed
class ResponseData with _$ResponseData {
  const factory ResponseData({
    @JsonKey(name: 'recordsets')
    required List<List<ExistingClientRecordModel>> recordsets,

    @JsonKey(name: 'recordset')
    @Default([])
    List<ExistingClientRecordModel> recordset,

    @JsonKey(name: 'output') Map<String, dynamic>? output,

    @JsonKey(name: 'rowsAffected') @Default([]) List<dynamic> rowsAffected,

    @JsonKey(name: 'returnValue') @Default(0) int returnValue,
  }) = _ResponseData;

  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);
}

@freezed
class ExistingClientRecordModel with _$ExistingClientRecordModel {
  const factory ExistingClientRecordModel({
    // OCR Stage and Datetime
    @JsonKey(name: 'ocrstage') String? ocrstage,
    @JsonKey(name: 'ocrStageDateTime') String? ocrStageDateTime,

    // Account Category and Subcategory
    @JsonKey(name: 'ocrAccountCategory') int? ocrAccountCategory,
    @JsonKey(name: 'ocrAccountSubCategory') int? ocrAccountSubCategory,

    // Referral and Form Information
    @JsonKey(name: 'ocrReferralCode') String? ocrReferralCode,
    @JsonKey(name: 'ocrFormNo') int? ocrFormNo,

    // PAN and Personal Details
    @JsonKey(name: 'ocrPanNo') String? ocrPanNo,
    @JsonKey(name: 'ocrDateOfBirth') String? ocrDateOfBirth,

    // Branch and Group Information
    @JsonKey(name: 'ocrBranch') int? ocrBranch,
    @JsonKey(name: 'Branch') String? branch,
    @JsonKey(name: 'ocrGroup') dynamic ocrGroup,
    @JsonKey(name: 'Group') dynamic group,
    @JsonKey(name: 'GroupName') dynamic groupName,

    // Employee Information
    @JsonKey(name: 'ocrEmployee') int? ocrEmployee,
    @JsonKey(name: 'ocrUserType') String? ocrUserType,
    @JsonKey(name: 'Employee') String? employee,
    @JsonKey(name: 'userName') String? userName,
    @JsonKey(name: 'UserType') String? userType,

    // KRA Information
    @JsonKey(name: 'ocrKRAMode') String? ocrKRAMode,
    @JsonKey(name: 'ocrKRANo') dynamic ocrKRANo,
    @JsonKey(name: 'ocrKRADate') dynamic ocrKRADate,
    @JsonKey(name: 'ocrKRAAgency') String? ocrKRAAgency,

    // Account Options and Types
    @JsonKey(name: 'ocrAccountOption') int? ocrAccountOption,
    @JsonKey(name: 'AccountOption') String? accountOption,
    @JsonKey(name: 'ocrAccountType') int? ocrAccountType,
    @JsonKey(name: 'AccountType') String? accountType,

    // Client Type and NRI Type
    @JsonKey(name: 'ocrClientType') int? ocrClientType,
    @JsonKey(name: 'ClientType') String? clientType,
    @JsonKey(name: 'ocrNRIType') dynamic ocrNRIType,
    @JsonKey(name: 'NRIType') dynamic nriType,

    // Trading Information
    @JsonKey(name: 'ocrTradingCode') String? ocrTradingCode,
    @JsonKey(name: 'ocrTradingType') int? ocrTradingType,
    @JsonKey(name: 'TradingType') String? tradingType,

    // Billing and Risk Category
    @JsonKey(name: 'ocrBillingCategory') int? ocrBillingCategory,
    @JsonKey(name: 'BillingCategory') String? billingCategory,
    @JsonKey(name: 'ocrClientRiskCategory') int? ocrClientRiskCategory,
    @JsonKey(name: 'ClientRiskCategory') String? clientRiskCategory,

    // GST and Verification
    @JsonKey(name: 'ocrGstNumber') dynamic ocrGstNumber,
    @JsonKey(name: 'ocrInPersonVerificationFlag')
    bool? ocrInPersonVerificationFlag,

    // Name Information
    @JsonKey(name: 'ocrKRAName') dynamic ocrKRAName,
    @JsonKey(name: 'ocrFirstName') dynamic ocrFirstName,
    @JsonKey(name: 'ocrMiddleName') dynamic ocrMiddleName,
    @JsonKey(name: 'ocrLastName') dynamic ocrLastName,
    @JsonKey(name: 'ocrFullName') String? ocrFullName,

    // Gender and Marital Status
    @JsonKey(name: 'ocrGender') int? ocrGender,
    @JsonKey(name: 'Gender') String? gender,
    @JsonKey(name: 'ocrMaritalStatus') dynamic ocrMaritalStatus,
    @JsonKey(name: 'MaritalStatus') dynamic maritalStatus,

    // Father/Husband Information
    @JsonKey(name: 'ocrFatherHusbandFlag') int? ocrFatherHusbandFlag,
    @JsonKey(name: 'FatherHusbandFlag') String? fatherHusbandFlag,
    @JsonKey(name: 'ocrFathersFirstName') dynamic ocrFathersFirstName,
    @JsonKey(name: 'ocrFathersMiddleName') dynamic ocrFathersMiddleName,
    @JsonKey(name: 'ocrFathersLastName') dynamic ocrFathersLastName,

    // Mother Information
    @JsonKey(name: 'ocrMothersFirstName') dynamic ocrMothersFirstName,
    @JsonKey(name: 'ocrMothersMiddleName') dynamic ocrMothersMiddleName,
    @JsonKey(name: 'ocrMothersLastName') dynamic ocrMothersLastName,

    // Mobile Contact Information
    @JsonKey(name: 'ocrMobileNo') String? ocrMobileNo,
    @JsonKey(name: 'ocrMobileOTP') String? ocrMobileOTP,
    @JsonKey(name: 'ocrMobileOTPAddedTime') String? ocrMobileOTPAddedTime,
    @JsonKey(name: 'ocrMobileOTPVerifiedTime') String? ocrMobileOTPVerifiedTime,
    @JsonKey(name: 'ocrMobileOTPFlag') bool? ocrMobileOTPFlag,
    @JsonKey(name: 'ocrFamilyFlagForMobile') bool? ocrFamilyFlagForMobile,
    @JsonKey(name: 'ocrFamilyRelationshipForMobile')
    int? ocrFamilyRelationshipForMobile,
    @JsonKey(name: 'FamilyRelationshipForMobile')
    String? familyRelationshipForMobile,

    // Email Contact Information
    @JsonKey(name: 'ocrEmailId') String? ocrEmailId,
    @JsonKey(name: 'ocrEmailOTP') String? ocrEmailOTP,
    @JsonKey(name: 'ocrEmailOTPAddedTime') String? ocrEmailOTPAddedTime,
    @JsonKey(name: 'ocrEmailOTPVerifiedTime') String? ocrEmailOTPVerifiedTime,
    @JsonKey(name: 'ocrEmailOTPFlag') bool? ocrEmailOTPFlag,
    @JsonKey(name: 'ocrFamilyFlagForEmail') bool? ocrFamilyFlagForEmail,
    @JsonKey(name: 'ocrFamilyRelationshipForEmail')
    int? ocrFamilyRelationshipForEmail,
    @JsonKey(name: 'FamilyRelationshipForEmail')
    String? familyRelationshipForEmail,

    // Correspondence Address
    @JsonKey(name: 'ocrCorrAddress1') String? ocrCorrAddress1,
    @JsonKey(name: 'ocrCorrAddress2') String? ocrCorrAddress2,
    @JsonKey(name: 'ocrCorrAddress3') String? ocrCorrAddress3,
    @JsonKey(name: 'ocrCorrAddress4') String? ocrCorrAddress4,
    @JsonKey(name: 'ocrCorrCountry') int? ocrCorrCountry,
    @JsonKey(name: 'CorrCountry') String? corrCountry,
    @JsonKey(name: 'ocrCorrState') int? ocrCorrState,
    @JsonKey(name: 'CorrState') String? corrState,
    @JsonKey(name: 'ocrCorrCity') int? ocrCorrCity,
    @JsonKey(name: 'CorrCity') String? corrCity,
    @JsonKey(name: 'ocrCorrPinCode') int? ocrCorrPinCode,
    @JsonKey(name: 'CorrPinCode') String? corrPinCode,
    @JsonKey(name: 'ocrCorrAddressProof') int? ocrCorrAddressProof,
    @JsonKey(name: 'CorrAddressProof') String? corrAddressProof,
    @JsonKey(name: 'ocrCorrAddressType') int? ocrCorrAddressType,
    @JsonKey(name: 'CorrAddressType') String? corrAddressType,
    @JsonKey(name: 'ocrCorrPerAddressFlag') bool? ocrCorrPerAddressFlag,

    // Phone and Fax
    @JsonKey(name: 'ocrPhone') dynamic ocrPhone,
    @JsonKey(name: 'ocrFax') dynamic ocrFax,
    // Permanent Address
    @JsonKey(name: 'ocrPerAddress1') String? ocrPerAddress1,
    @JsonKey(name: 'ocrPerAddress2') String? ocrPerAddress2,
    @JsonKey(name: 'ocrPerAddress3') String? ocrPerAddress3,
    @JsonKey(name: 'ocrPerAddress4') String? ocrPerAddress4,
    @JsonKey(name: 'ocrPerCountry') int? ocrPerCountry,
    @JsonKey(name: 'PerCountry') String? perCountry,
    @JsonKey(name: 'ocrPerState') int? ocrPerState,
    @JsonKey(name: 'PerState') String? perState,
    @JsonKey(name: 'ocrPerCity') int? ocrPerCity,
    @JsonKey(name: 'PerCity') String? perCity,
    @JsonKey(name: 'ocrPerPinCode') int? ocrPerPinCode,
    @JsonKey(name: 'PerPinCode') String? perPinCode,
    @JsonKey(name: 'ocrPerAddressProof') int? ocrPerAddressProof,
    @JsonKey(name: 'PerAddressProof') String? perAddressProof,
    @JsonKey(name: 'ocrPerAddressType') int? ocrPerAddressType,
    @JsonKey(name: 'PerAddressType') String? perAddressType,

    // Nationality Information
    @JsonKey(name: 'ocrNationality') int? ocrNationality,
    @JsonKey(name: 'Nationality') String? nationality,
    @JsonKey(name: 'ocrCountryBirth') dynamic ocrCountryBirth,
    @JsonKey(name: 'CountryBirth') dynamic countryBirth,
    @JsonKey(name: 'ocrCityBirth') dynamic ocrCityBirth,
    @JsonKey(name: 'CityBirth') dynamic cityBirth,

    // Declaration Information
    @JsonKey(name: 'ocrDateOfDeclaration') String? ocrDateOfDeclaration,
    @JsonKey(name: 'ocrPlaceOfDeclaration') String? ocrPlaceOfDeclaration,
    @JsonKey(name: 'ocrNumberOfDocument') int? ocrNumberOfDocument,

    // PEP and Income Information
    @JsonKey(name: 'ocrPEP') bool? ocrPEP,
    @JsonKey(name: 'ocrAnnualIncome') int? ocrAnnualIncome,
    @JsonKey(name: 'AnnualIncome') String? annualIncome,
    @JsonKey(name: 'ocrAnnualIncomeDate') String? ocrAnnualIncomeDate,

    // Occupation
    @JsonKey(name: 'ocrOccupation') int? ocrOccupation,
    @JsonKey(name: 'Occupation') String? occupation,
    @JsonKey(name: 'ocrOccupationDetail') dynamic ocrOccupationDetail,

    // RBI and NRI Information
    @JsonKey(name: 'ocrRbiRefNumber') dynamic ocrRbiRefNumber,
    @JsonKey(name: 'ocrRbiApprovaleDate') dynamic ocrRbiApprovaleDate,
    @JsonKey(name: 'ocrNriPisNo') dynamic ocrNriPisNo,

    // Tax Information
    @JsonKey(name: 'ocrTaxApplicableOutside') int? ocrTaxApplicableOutside,
    @JsonKey(name: 'TaxApplicableOutside') String? taxApplicableOutside,
    @JsonKey(name: 'ocrTaxPayableAddressFlag') dynamic ocrTaxPayableAddressFlag,
    @JsonKey(name: 'TaxPayableAddressFlag') dynamic taxPayableAddressFlag,
    @JsonKey(name: 'ocrTaxIdentificationNumber')
    dynamic ocrTaxIdentificationNumber,
    @JsonKey(name: 'ocrTaxEligibleCountry') dynamic ocrTaxEligibleCountry,
    @JsonKey(name: 'TaxEligibleCountry') dynamic taxEligibleCountry,

    // FATCA and Compliance Flags
    @JsonKey(name: 'ocrAppForFatca') bool? ocrAppForFatca,
    @JsonKey(name: 'ocrEcnFlag') bool? ocrEcnFlag,
    @JsonKey(name: 'ocrDDPIFlag') bool? ocrDDPIFlag,
    @JsonKey(name: 'ocrBSDAFlag') bool? ocrBSDAFlag,

    // NSDL Information
    @JsonKey(name: 'ocrNSDLClientType') int? ocrNSDLClientType,
    @JsonKey(name: 'NSDLClientType') String? nsdlClientType,
    @JsonKey(name: 'ocrNSDLClientSubType') int? ocrNSDLClientSubType,
    @JsonKey(name: 'NSDLClientSubType') String? nsdlClientSubType,
    @JsonKey(name: 'ocrNSDLScheme') int? ocrNSDLScheme,
    @JsonKey(name: 'NSDLScheme') String? nsdlScheme,

    // Depository Information
    @JsonKey(name: 'ocrDepository') dynamic ocrDepository,
    @JsonKey(name: 'Depository') dynamic depository,
    @JsonKey(name: 'ocrDPID') dynamic ocrDPID,
    @JsonKey(name: 'ocrDPName') dynamic ocrDPName,
    @JsonKey(name: 'ocrClientID') dynamic ocrClientID,
    @JsonKey(name: 'ocrDematAccProofSubmitted')
    dynamic ocrDematAccProofSubmitted,
    @JsonKey(name: 'DematAccProofSubmitted') dynamic dematAccProofSubmitted,

    // Identity Information
    @JsonKey(name: 'ocrIdentityProof') dynamic ocrIdentityProof,
    @JsonKey(name: 'IdentityProof') dynamic identityProof,
    @JsonKey(name: 'ocrIdentityNo') dynamic ocrIdentityNo,
    @JsonKey(name: 'ocrIdentityExpiryDate') dynamic ocrIdentityExpiryDate,

    // Market Access Flags
    @JsonKey(name: 'ocrNSDL') bool? ocrNSDL,
    @JsonKey(name: 'ocrNSEEQ') bool? ocrNSEEQ,
    @JsonKey(name: 'ocrBSEEQ') bool? ocrBSEEQ,
    @JsonKey(name: 'ocrNSEFO') bool? ocrNSEFO,
    @JsonKey(name: 'ocrBSEFO') bool? ocrBSEFO,
    @JsonKey(name: 'ocrNSECD') bool? ocrNSECD,
    @JsonKey(name: 'ocrNSECO') bool? ocrNSECO,
    @JsonKey(name: 'ocrSLBM') bool? ocrSLBM,
    @JsonKey(name: 'ocrMCXCO') bool? ocrMCXCO,

    // Guardian Information
    @JsonKey(name: 'ocrGuardianPrefix') dynamic ocrGuardianPrefix,
    @JsonKey(name: 'ocrGuardianFirstName') dynamic ocrGuardianFirstName,
    @JsonKey(name: 'ocrGuardianMiddleName') dynamic ocrGuardianMiddleName,
    @JsonKey(name: 'ocrGuardianLastName') dynamic ocrGuardianLastName,
    @JsonKey(name: 'ocrGuardianRelation') dynamic ocrGuardianRelation,
    @JsonKey(name: 'GuardianRelation') dynamic guardianRelation,
    @JsonKey(name: 'ocrGuardianPan') dynamic ocrGuardianPan,
    @JsonKey(name: 'ocrGuardianDateOfBirth') dynamic ocrGuardianDateOfBirth,
    @JsonKey(name: 'ocrGuardianGender') dynamic ocrGuardianGender,
    @JsonKey(name: 'GuardianGender') dynamic guardianGender,
    @JsonKey(name: 'ocrGuardianFatherHusbandFlag')
    dynamic ocrGuardianFatherHusbandFlag,
    @JsonKey(name: 'GuardianFatherHusbandFlag')
    dynamic guardianFatherHusbandFlag,
    @JsonKey(name: 'ocrGuardianFatherFirstName')
    dynamic ocrGuardianFatherFirstName,
    @JsonKey(name: 'ocrGuardianFatherMiddleName')
    dynamic ocrGuardianFatherMiddleName,
    @JsonKey(name: 'ocrGuardianFatherLastName')
    dynamic ocrGuardianFatherLastName,

    // Document Fields
    @JsonKey(name: 'ocrDDPIDocumentID') dynamic ocrDDPIDocumentID,
    @JsonKey(name: 'ocrIsDDPISigned') dynamic ocrIsDDPISigned,
    @JsonKey(name: 'DDPIDoc') dynamic ddpiDoc,
    @JsonKey(name: 'ocrStdNo') dynamic ocrStdNo,
    @JsonKey(name: 'ocrSecHolStdNo') dynamic ocrSecHolStdNo,
    @JsonKey(name: 'ocrThiHolStdNo') dynamic ocrThiHolStdNo,

    // Account Type Flags
    @JsonKey(name: 'MinorAcc') int? minorAcc,
    @JsonKey(name: 'NRIAcc') int? nriAcc,
    @JsonKey(name: 'NonIndividualAcc') int? nonIndividualAcc,
    @JsonKey(name: 'IsDigiLockerEntry') int? isDigiLockerEntry,

    // FATCA Country Information
    @JsonKey(name: 'ocrFATCACountryCitizenship')
    dynamic ocrFATCACountryCitizenship,
    @JsonKey(name: 'FATCACountryCitizenship') dynamic fatcaCountryCitizenship,
    @JsonKey(name: 'ocrFATCADoD') dynamic ocrFATCADoD,
    @JsonKey(name: 'FATCADoD') dynamic fatcaDoD,
    @JsonKey(name: 'ocrFATCACountryResidency') dynamic ocrFATCACountryResidency,
    @JsonKey(name: 'FATCACountryResidency') dynamic fatcaCountryResidency,
    @JsonKey(name: 'ocrFATCATaxExemptFlag') dynamic ocrFATCATaxExemptFlag,
    @JsonKey(name: 'FATCATaxExemptFlag') dynamic fatcaTaxExemptFlag,
    @JsonKey(name: 'ocrFATCATaxExemptReason') dynamic ocrFATCATaxExemptReason,
    @JsonKey(name: 'FATCATaxExemptReason') dynamic fatcaTaxExemptReason,

    // Secondary Holder FATCA Information
    @JsonKey(name: 'ocrSecHolFATCACountryCitizenship')
    dynamic ocrSecHolFATCACountryCitizenship,
    @JsonKey(name: 'SecHolFATCACountryCitizenship')
    dynamic secHolFATCACountryCitizenship,
    @JsonKey(name: 'ocrSecHolFATCADoD') dynamic ocrSecHolFATCADoD,
    @JsonKey(name: 'SecHolFATCADoD') dynamic secHolFATCADoD,
    @JsonKey(name: 'ocrSecHolFATCACountryResidency')
    dynamic ocrSecHolFATCACountryResidency,
    @JsonKey(name: 'SecHolFATCACountryResidency')
    dynamic secHolFATCACountryResidency,
    @JsonKey(name: 'ocrSecHolFATCATaxExemptFlag')
    dynamic ocrSecHolFATCATaxExemptFlag,
    @JsonKey(name: 'SecHolFATCATaxExemptFlag') dynamic secHolFATCATaxExemptFlag,
    @JsonKey(name: 'ocrSecHolFATCATaxExemptReason')
    dynamic ocrSecHolFATCATaxExemptReason,
    @JsonKey(name: 'SecHolFATCATaxExemptReason')
    dynamic secHolFATCATaxExemptReason,

    // Third Holder FATCA Information
    @JsonKey(name: 'ocrThiHolFATCACountryCitizenship')
    dynamic ocrThiHolFATCACountryCitizenship,
    @JsonKey(name: 'ThiHolFATCACountryCitizenship')
    dynamic thiHolFATCACountryCitizenship,
    @JsonKey(name: 'ocrThiHolFATCADoD') dynamic ocrThiHolFATCADoD,
    @JsonKey(name: 'ThiHolFATCADoD') dynamic thiHolFATCADoD,
    @JsonKey(name: 'ocrThiHolFATCACountryResidency')
    dynamic ocrThiHolFATCACountryResidency,
    @JsonKey(name: 'ThiHolFATCACountryResidency')
    dynamic thiHolFATCACountryResidency,
    @JsonKey(name: 'ocrThiHolFATCATaxExemptFlag')
    dynamic ocrThiHolFATCATaxExemptFlag,
    @JsonKey(name: 'ThiHolFATCATaxExemptFlag') dynamic thiHolFATCATaxExemptFlag,
    @JsonKey(name: 'ocrThiHolFATCATaxExemptReason')
    dynamic ocrThiHolFATCATaxExemptReason,
    @JsonKey(name: 'ThiHolFATCATaxExemptReason')
    dynamic thiHolFATCATaxExemptReason,

    // Digio Selfie Information
    @JsonKey(name: 'ocrDigioSelfieRefId') dynamic ocrDigioSelfieRefId,
    @JsonKey(name: 'ocrDigioSelfieLatitude') dynamic ocrDigioSelfieLatitude,
    @JsonKey(name: 'ocrDigioSelfieLongitude') dynamic ocrDigioSelfieLongitude,
    @JsonKey(name: 'ocrSecHolDigioSelfieRefId')
    dynamic ocrSecHolDigioSelfieRefId,
    @JsonKey(name: 'ocrSecHolDigioSelfieLatitude')
    dynamic ocrSecHolDigioSelfieLatitude,
    @JsonKey(name: 'ocrSecHolDigioSelfieLongitude')
    dynamic ocrSecHolDigioSelfieLongitude,
    @JsonKey(name: 'ocrThiHolDigioSelfieRefId')
    dynamic ocrThiHolDigioSelfieRefId,
    @JsonKey(name: 'ocrThiHolDigioSelfieLatitude')
    dynamic ocrThiHolDigioSelfieLatitude,
    @JsonKey(name: 'ocrThiHolDigioSelfieLongitude')
    dynamic ocrThiHolDigioSelfieLongitude,

    // DIS Issuance
    @JsonKey(name: 'ocrDISIssuance') bool? ocrDISIssuance,
    @JsonKey(name: 'DISIssuanceDescription') String? disIssuanceDescription,

    // Address Proof Details
    @JsonKey(name: 'ocrPerAddressProofNo') dynamic ocrPerAddressProofNo,
    @JsonKey(name: 'ocrPerAddressProofExpiryDate')
    dynamic ocrPerAddressProofExpiryDate,
    @JsonKey(name: 'ocrCorrAddressProofNo') dynamic ocrCorrAddressProofNo,
    @JsonKey(name: 'ocrCorrAddressProofExpiryDate')
    dynamic ocrCorrAddressProofExpiryDate,
    @JsonKey(name: 'ocrSecHolPerAddressProofNo')
    dynamic ocrSecHolPerAddressProofNo,
    @JsonKey(name: 'ocrSecHolPerAddressProofExpiryDate')
    dynamic ocrSecHolPerAddressProofExpiryDate,
    @JsonKey(name: 'ocrSecHolCorrAddressProofNo')
    dynamic ocrSecHolCorrAddressProofNo,
    @JsonKey(name: 'ocrSecHolCorrAddressProofExpiryDate')
    dynamic ocrSecHolCorrAddressProofExpiryDate,
    @JsonKey(name: 'ocrThiHolPerAddressProofNo')
    dynamic ocrThiHolPerAddressProofNo,
    @JsonKey(name: 'ocrThiHolPerAddressProofExpiryDate')
    dynamic ocrThiHolPerAddressProofExpiryDate,
    @JsonKey(name: 'ocrThiHolCorrAddressProofNo')
    dynamic ocrThiHolCorrAddressProofNo,
    @JsonKey(name: 'ocrThiHolCorrAddressProofExpiryDate')
    dynamic ocrThiHolCorrAddressProofExpiryDate,

    // Employee and Partner Information
    @JsonKey(name: 'ocrEmployeeId') int? ocrEmployeeId,
    @JsonKey(name: 'EmployeeName') String? employeeName,
    @JsonKey(name: 'ocrEasyPartnerId') dynamic ocrEasyPartnerId,
    @JsonKey(name: 'EasyPartner') dynamic easyPartner,

    // Intermediary Information
    @JsonKey(name: 'IntCode') dynamic intCode,
    @JsonKey(name: 'IntSignature') dynamic intSignature,
    @JsonKey(name: 'IntName') dynamic intName,
    @JsonKey(name: 'IntPan') dynamic intPan,
    @JsonKey(name: 'IntAddress') String? intAddress,
    @JsonKey(name: 'IntPhone') String? intPhone,

    // Additional Flags and Details
    @JsonKey(name: 'ocrAutoDebitFlag') bool? ocrAutoDebitFlag,
    @JsonKey(name: 'CAMSfipId') String? camsfiId,
    @JsonKey(name: 'ocrHolder') String? ocrHolder,
    @JsonKey(name: 'ocrDDPISignMode') dynamic ocrDDPISignMode,
    @JsonKey(name: 'ocrPISType') dynamic ocrPISType,
    @JsonKey(name: 'PISType') dynamic pisType,
    @JsonKey(name: 'ocrDDPIIssueType') int? ocrDDPIIssueType,
    @JsonKey(name: 'ocrIsBrkConfirm') bool? ocrIsBrkConfirm,
    @JsonKey(name: 'UserEmail') String? userEmail,
    @JsonKey(name: 'DDPIIssueTypeDesc') String? ddpiIssueTypeDesc,

    // KRA Document Type
    @JsonKey(name: 'ocrKRADocumentType') dynamic ocrKRADocumentType,
    @JsonKey(name: 'ocrKRAAgencyDocumentType') dynamic ocrKRAAgencyDocumentType,
    @JsonKey(name: 'ocrSecHolKRADocumentType') dynamic ocrSecHolKRADocumentType,
    @JsonKey(name: 'ocrSecHolKRAAgencyDocumentType')
    dynamic ocrSecHolKRAAgencyDocumentType,
    @JsonKey(name: 'ocrThiHolKRADocumentType') String? ocrThiHolKRADocumentType,
    @JsonKey(name: 'ocrThiHolKRAAgencyDocumentType')
    String? ocrThiHolKRAAgencyDocumentType,

    // Settlement Cycle
    @JsonKey(name: 'SettlementCycle') String? settlementCycle,
    @JsonKey(name: 'ocrSettlementCycle') int? ocrSettlementCycle,

    // Dialog Messages
    @JsonKey(name: 'Message') String? message,
    @JsonKey(name: 'Type') int? type,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'ocrMode') String? ocrMode,
    @JsonKey(name: 'ocrModeOfOperation') int? ocrModeOfOperation,
    @JsonKey(name: 'ModeOfOperation') String? modeOfOperation,
    @JsonKey(name: 'ocrModeOfCommunication') int? ocrModeOfCommunication,
    @JsonKey(name: 'ModeOfCommunication') String? modeOfCommunication,
    @JsonKey(name: 'ocrBusinessId') int? ocrBusinessId,
    @JsonKey(name: 'ocrJobtype') int? ocrJobtype,
    @JsonKey(name: 'ocrJobCode') int? ocrJobCode,
    @JsonKey(name: 'JobType') String? jobType,
    @JsonKey(name: 'JobDescription') String? jobDescription,
    @JsonKey(name: 'ocrDeltype') int? ocrDeltype,
    @JsonKey(name: 'ocrDelCode') int? ocrDelCode,
    @JsonKey(name: 'Deltype') String? deltype,
    @JsonKey(name: 'DelDescription') String? delDescription,
    @JsonKey(name: 'ocrOptType') int? ocrOptType,
    @JsonKey(name: 'ocrOptCode') int? ocrOptCode,
    @JsonKey(name: 'OptType') String? optType,
    @JsonKey(name: 'OptDescription') String? optDescription,
    @JsonKey(name: 'ocrFutType') int? ocrFutType,
    @JsonKey(name: 'ocrFutCode') int? ocrFutCode,
    @JsonKey(name: 'FutType') String? futType,
    @JsonKey(name: 'FutDescription') String? futDescription,
    @JsonKey(name: 'ocrExeType') int? ocrExeType,
    @JsonKey(name: 'ocrExeCode') int? ocrExeCode,
    @JsonKey(name: 'ExeType') String? exeType,
    @JsonKey(name: 'ExeDescription') String? exeDescription,
    @JsonKey(name: 'ocrOneSideBrk') dynamic ocrOneSideBrk,
    @JsonKey(name: 'ocrOneSidecode') dynamic ocrOneSidecode,
    @JsonKey(name: 'ocrRoundFlag') int? ocrRoundFlag,
    @JsonKey(name: 'ocrSLBMType') int? ocrSLBMType,
    @JsonKey(name: 'ocrSLBMCode') int? ocrSLBMCode,
    @JsonKey(name: 'SLBMType') String? slbmType,
    @JsonKey(name: 'SLBMDescription') String? slbmDescription,
    @JsonKey(name: 'ProDateOfBirth') String? proDateOfBirth,
    @JsonKey(name: 'ProCountryId') int? proCountryId,
    @JsonKey(name: 'ProStateId') int? proStateId,
    @JsonKey(name: 'ProCityId') int? proCityId,
    @JsonKey(name: 'ProPinCodeId') int? proPinCodeId,
    @JsonKey(name: 'ProGenderId') int? proGenderId,
    @JsonKey(name: 'ProRelationWithApplicantId')
    int? proRelationWithApplicantId,
    @JsonKey(name: 'ProRelationWithMemOrCopId') int? proRelationWithMemOrCopId,
    @JsonKey(name: 'agHolder') String? agHolder,
    @JsonKey(name: 'agDocTypeNm') String? agDocTypeNm,
    @JsonKey(name: 'ocrImageType') String? ocrImageType,
    @JsonKey(name: 'ocrImage') BufferModel? ocrImage,
    // @JsonKey(name: 'ocrImage') dynamic ocrImage,
    @JsonKey(name: 'SecondHolderMobileRelation')
    String? secondHolderMobileRelation,
    @JsonKey(name: 'SecondHolderEmailRelation')
    String? secondHolderEmailRelation,
    @JsonKey(name: 'ThirdHolderMobileRelation')
    String? thirdHolderMobileRelation,
    @JsonKey(name: 'ThirdHolderEmailRelation') String? thirdHolderEmailRelation,
    @JsonKey(name: 'ocrPersonalDetailAddedTime')
    String? ocrPersonalDetailAddedTime,
    @JsonKey(name: 'ocrBankDetailAddedTime') String? ocrBankDetailAddedTime,

    @JsonKey(name: 'ocrOtherDetailsTime') String? ocrOtherDetailsTime,

    @JsonKey(name: 'ocrDocumentDetailsTime') String? ocrDocumentDetailsTime,

    @JsonKey(name: 'ocrPlanDetailsTime') String? ocrPlanDetailsTime,

    @JsonKey(name: 'ocrNomineeDetailsTime') String? ocrNomineeDetailsTime,

    @JsonKey(name: 'ocrPreviewTime') String? ocrPreviewTime,

    @JsonKey(name: 'ocrRecId') int? ocrRecId,

    @JsonKey(name: 'ocrDDPIRecId') int? ocrDDPIRecId,

    @JsonKey(name: 'ocrRecDate') String? ocrRecDate,

    @JsonKey(name: 'ocrPlanId') String? ocrPlanId,

    @JsonKey(name: 'ocrRejectionFlag') dynamic ocrRejectionFlag,

    @JsonKey(name: 'ocrIsDigitallySigned') dynamic ocrIsDigitallySigned,
    @JsonKey(name: 'ocrDigitalSignMode') dynamic ocrDigitalSignMode,

    // Third Holder Personal Details
    @JsonKey(name: 'ocrThiHolPan') String? ocrThiHolPan,

    @JsonKey(name: 'ocrThiHolDateOfBirth') String? ocrThiHolDateOfBirth,

    @JsonKey(name: 'ocrThiHolFirstName') String? ocrThiHolFirstName,

    @JsonKey(name: 'ocrThiHolMiddleName') String? ocrThiHolMiddleName,

    @JsonKey(name: 'ocrThiHolLastName') String? ocrThiHolLastName,

    @JsonKey(name: 'ocrThiHolKRAName') String? ocrThiHolKRAName,

    @JsonKey(name: 'ocrThiHolGender') int? ocrThiHolGender,
    @JsonKey(name: 'ThiHolGender') String? thiHolGender,

    @JsonKey(name: 'ocrThiHolMaritalStatus') int? ocrThiHolMaritalStatus,

    @JsonKey(name: 'ThiHolMaritalStatus') String? thiHolMaritalStatus,

    // Third Holder Address
    @JsonKey(name: 'ocrThiHolCorrAddress1') String? ocrThiHolCorrAddress1,

    @JsonKey(name: 'ocrThiHolCorrAddress2') String? ocrThiHolCorrAddress2,

    @JsonKey(name: 'ocrThiHolCorrAddress3') String? ocrThiHolCorrAddress3,

    @JsonKey(name: 'ocrThiHolCorrAddress4') String? ocrThiHolCorrAddress4,

    @JsonKey(name: 'ocrThiHolCorrCountry') int? ocrThiHolCorrCountry,

    @JsonKey(name: 'ThiHolCorrCountry') String? thiHolCorrCountry,

    @JsonKey(name: 'ocrThiHolCorrState') int? ocrThiHolCorrState,

    @JsonKey(name: 'ThiHolCorrState') String? thiHolCorrState,

    @JsonKey(name: 'ocrThiHolCorrCity') int? ocrThiHolCorrCity,

    @JsonKey(name: 'ThiHolCorrCity') String? thiHolCorrCity,

    @JsonKey(name: 'ocrThiHolCorrPinCode') int? ocrThiHolCorrPinCode,

    @JsonKey(name: 'ThiHolCorrPinCode') String? thiHolCorrPinCode,
    // Third Holder Permanent Address
    @JsonKey(name: 'ocrThiHolPerAddress1') String? ocrThiHolPerAddress1,

    @JsonKey(name: 'ocrThiHolPerAddress2') String? ocrThiHolPerAddress2,

    @JsonKey(name: 'ocrThiHolPerAddress3') String? ocrThiHolPerAddress3,

    @JsonKey(name: 'ocrThiHolPerAddress4') String? ocrThiHolPerAddress4,

    @JsonKey(name: 'ocrThiHolPerCountry') int? ocrThiHolPerCountry,

    @JsonKey(name: 'ThiHolPerCountry') String? thiHolPerCountry,

    @JsonKey(name: 'ocrThiHolPerState') int? ocrThiHolPerState,

    @JsonKey(name: 'ThiHolPerState') String? thiHolPerState,

    @JsonKey(name: 'ocrThiHolPerCity') int? ocrThiHolPerCity,

    @JsonKey(name: 'ThiHolPerCity') String? thiHolPerCity,

    @JsonKey(name: 'ocrThiHolPerPinCode') int? ocrThiHolPerPinCode,

    @JsonKey(name: 'ThiHolPerPinCode') String? thiHolPerPinCode,
    // Third Holder Identity
    @JsonKey(name: 'ocrThiHolIdentityProof') dynamic ocrThiHolIdentityProof,

    @JsonKey(name: 'ThiHolIdentityProof') dynamic thiHolIdentityProof,

    @JsonKey(name: 'ocrThiHolIdentityNo') String? ocrThiHolIdentityNo,

    @JsonKey(name: 'ocrThiHolIdentityExpiryDate')
    dynamic ocrThiHolIdentityExpiryDate,
    @JsonKey(name: 'ocrThiHolFullName') String? ocrThiHolFullName,
    // Third Holder KRA Information
    @JsonKey(name: 'ocrThiHolKRAMode') String? ocrThiHolKRAMode,

    @JsonKey(name: 'ocrThiHolKRANo') String? ocrThiHolKRANo,

    @JsonKey(name: 'ocrThiHolKRADate') String? ocrThiHolKRADate,

    @JsonKey(name: 'ocrThiHolKRAAgency') String? ocrThiHolKRAAgency,

    // Third Holder Parent Information
    @JsonKey(name: 'ocrThiHolFatherHusbandFlag')
    int? ocrThiHolFatherHusbandFlag,

    @JsonKey(name: 'ThiHolFatherHusbandFlag') String? thiHolFatherHusbandFlag,

    @JsonKey(name: 'ocrThiHolFathersFirstName')
    String? ocrThiHolFathersFirstName,

    @JsonKey(name: 'ocrThiHolFathersMiddleName')
    String? ocrThiHolFathersMiddleName,

    @JsonKey(name: 'ocrThiHolFathersLastName') String? ocrThiHolFathersLastName,

    @JsonKey(name: 'ocrThiHolMothersFirstName')
    String? ocrThiHolMothersFirstName,

    @JsonKey(name: 'ocrThiHolMothersMiddleName')
    String? ocrThiHolMothersMiddleName,

    @JsonKey(name: 'ocrThiHolMothersLastName') String? ocrThiHolMothersLastName,
    // Third Holder Contact Information
    @JsonKey(name: 'ocrThiHolMobile') String? ocrThiHolMobile,

    @JsonKey(name: 'ocrThiHolMobileOTP') String? ocrThiHolMobileOTP,

    @JsonKey(name: 'ocrThiHolMobileOTPAddedTime')
    String? ocrThiHolMobileOTPAddedTime,

    @JsonKey(name: 'ocrThiHolMobileOTPVerifiedTime')
    String? ocrThiHolMobileOTPVerifiedTime,

    @JsonKey(name: 'ocrThiHolMobileOTPFlag') bool? ocrThiHolMobileOTPFlag,

    @JsonKey(name: 'ocrThiHolFamilyFlagForMobile')
    bool? ocrThiHolFamilyFlagForMobile,

    @JsonKey(name: 'ocrThiHolFamilyRelationshipForMobile')
    int? ocrThiHolFamilyRelationshipForMobile,

    @JsonKey(name: 'ocrThiHolEmail') String? ocrThiHolEmail,

    @JsonKey(name: 'ocrThiHolEmailOTP') String? ocrThiHolEmailOTP,

    @JsonKey(name: 'ocrThiHolEmailOTPAddedTime')
    String? ocrThiHolEmailOTPAddedTime,

    @JsonKey(name: 'ocrThiHolEmailOTPVerifiedTime')
    String? ocrThiHolEmailOTPVerifiedTime,

    @JsonKey(name: 'ocrThiHolEmailOTPFlag') bool? ocrThiHolEmailOTPFlag,

    @JsonKey(name: 'ocrThiHolFamilyFlagForEmail')
    bool? ocrThiHolFamilyFlagForEmail,

    @JsonKey(name: 'ocrThiHolFamilyRelationshipForEmail')
    int? ocrThiHolFamilyRelationshipForEmail,

    // Third Holder Occupation & Income
    @JsonKey(name: 'ocrThiHolOccupation') int? ocrThiHolOccupation,

    @JsonKey(name: 'ThiHolOccupation') String? thiHolOccupation,

    @JsonKey(name: 'ocrThiHolAnnualIncome') int? ocrThiHolAnnualIncome,

    @JsonKey(name: 'ThiHolAnnualIncome') String? thiHolAnnualIncome,

    @JsonKey(name: 'ocrThiHolAnnualIncomeDate')
    String? ocrThiHolAnnualIncomeDate,

    @JsonKey(name: 'ocrThiHolNumberOfDocument') int? ocrThiHolNumberOfDocument,

    @JsonKey(name: 'ocrThiHolInPersonVerificationFlag')
    bool? ocrThiHolInPersonVerificationFlag,

    // Third Holder Tax Information
    @JsonKey(name: 'ocrThiHolTaxApplicableOutside')
    int? ocrThiHolTaxApplicableOutside,

    @JsonKey(name: 'ThiHolTaxApplicableOutside')
    String? thiHolTaxApplicableOutside,

    @JsonKey(name: 'ocrThiHolTaxPaybleAddFlag')
    dynamic ocrThiHolTaxPaybleAddFlag,

    @JsonKey(name: 'ThiHolTaxPayableAddFlag') dynamic thiHolTaxPayableAddFlag,

    @JsonKey(name: 'ocrThiHolTaxIndificationNo')
    dynamic ocrThiHolTaxIndificationNo,

    @JsonKey(name: 'ocrThiHolTaxEligibleCountry')
    dynamic ocrThiHolTaxEligibleCountry,

    @JsonKey(name: 'ThiHolTaxEligibleCountry') dynamic thiHolTaxEligibleCountry,

    // Third Holder Birth & Nationality
    @JsonKey(name: 'ocrThiHolCountryBirth') int? ocrThiHolCountryBirth,

    @JsonKey(name: 'ThiHolCountryBirth') String? thiHolCountryBirth,

    @JsonKey(name: 'ocrThiHolCityBirth') int? ocrThiHolCityBirth,

    @JsonKey(name: 'ThiHolCityBirth') String? thiHolCityBirth,

    @JsonKey(name: 'ocrThiHolNationality') int? ocrThiHolNationality,

    @JsonKey(name: 'ThiHolNationality') String? thiHolNationality,

    // Third Holder Correspondence Address Details
    @JsonKey(name: 'ocrThiHolCorrAddressProof') int? ocrThiHolCorrAddressProof,

    @JsonKey(name: 'ThiHolCorrAddressProof') String? thiHolCorrAddressProof,

    @JsonKey(name: 'ocrThiHolCorrAddressType') int? ocrThiHolCorrAddressType,

    @JsonKey(name: 'ThiHolCorrAddressType') String? thiHolCorrAddressType,

    @JsonKey(name: 'ocrThiHolCorrPerAddressFlag')
    bool? ocrThiHolCorrPerAddressFlag,

    // Third Holder Permanent Address Details
    @JsonKey(name: 'ocrThiHolPerAddressProof') int? ocrThiHolPerAddressProof,

    @JsonKey(name: 'ThiHolPerAddressProof') String? thiHolPerAddressProof,

    @JsonKey(name: 'ocrThiHolPerAddressType') int? ocrThiHolPerAddressType,

    @JsonKey(name: 'ThiHolPerAddressType') String? thiHolPerAddressType,

    @JsonKey(name: 'ocrThiHolPhone') dynamic ocrThiHolPhone,

    // Second Holder KRA Information
    @JsonKey(name: 'ocrSecHolPan') String? ocrSecHolPan,

    @JsonKey(name: 'ocrSecHolKRAMode') String? ocrSecHolKRAMode,

    @JsonKey(name: 'ocrSecHolKRANo') dynamic ocrSecHolKRANo,

    @JsonKey(name: 'ocrSecHolKRADate') dynamic ocrSecHolKRADate,

    @JsonKey(name: 'ocrSecHolKRAAgency') String? ocrSecHolKRAAgency,

    // Second Holder Personal Information
    @JsonKey(name: 'ocrSecHolDateOfBirth') String? ocrSecHolDateOfBirth,

    @JsonKey(name: 'ocrSecHolFirstName') String? ocrSecHolFirstName,

    @JsonKey(name: 'ocrSecHolMiddleName') String? ocrSecHolMiddleName,

    @JsonKey(name: 'ocrSecHolLastName') String? ocrSecHolLastName,

    @JsonKey(name: 'ocrSecHolKRAName') dynamic ocrSecHolKRAName,

    @JsonKey(name: 'ocrSecHolGender') int? ocrSecHolGender,

    @JsonKey(name: 'SecHolGender') String? secHolGender,

    @JsonKey(name: 'ocrSecHolMaritalStatus') int? ocrSecHolMaritalStatus,

    @JsonKey(name: 'SecHolMaritalStatus') String? secHolMaritalStatus,

    // Second Holder Birth & Nationality
    @JsonKey(name: 'ocrSecHolCountryBirth') int? ocrSecHolCountryBirth,

    @JsonKey(name: 'SecHolCountryBirth') String? secHolCountryBirth,

    @JsonKey(name: 'ocrSecHolCityBirth') int? ocrSecHolCityBirth,

    @JsonKey(name: 'SecHolCityBirth') String? secHolCityBirth,

    @JsonKey(name: 'ocrSecHolNationality') int? ocrSecHolNationality,

    @JsonKey(name: 'SecHolNationality') String? secHolNationality,

    // Second Holder Parent Information
    @JsonKey(name: 'ocrSecHolFatherHusbandFlag')
    int? ocrSecHolFatherHusbandFlag,

    @JsonKey(name: 'SecHolFatherHusbandFlag') String? secHolFatherHusbandFlag,

    @JsonKey(name: 'ocrSecHolFathersFirstName')
    String? ocrSecHolFathersFirstName,

    @JsonKey(name: 'ocrSecHolFathersMiddleName')
    String? ocrSecHolFathersMiddleName,

    @JsonKey(name: 'ocrSecHolFathersLastName') String? ocrSecHolFathersLastName,

    @JsonKey(name: 'ocrSecHolMothersFirstName')
    String? ocrSecHolMothersFirstName,

    @JsonKey(name: 'ocrSecHolMothersMiddleName')
    String? ocrSecHolMothersMiddleName,

    @JsonKey(name: 'ocrSecHolMothersLastName') String? ocrSecHolMothersLastName,

    // Second Holder Mobile Information
    @JsonKey(name: 'ocrSecHolMobile') String? ocrSecHolMobile,

    @JsonKey(name: 'ocrSecHolMobileOTP') String? ocrSecHolMobileOTP,

    @JsonKey(name: 'ocrSecHolMobileOTPAddedTime')
    String? ocrSecHolMobileOTPAddedTime,

    @JsonKey(name: 'ocrSecHolMobileOTPVerifiedTime')
    String? ocrSecHolMobileOTPVerifiedTime,

    @JsonKey(name: 'ocrSecHolMobileOTPFlag') bool? ocrSecHolMobileOTPFlag,

    @JsonKey(name: 'ocrSecHolFamilyFlagForMobile')
    bool? ocrSecHolFamilyFlagForMobile,

    @JsonKey(name: 'ocrSecHolFamilyRelationshipForMobile')
    int? ocrSecHolFamilyRelationshipForMobile,

    // Second Holder Email Information
    @JsonKey(name: 'ocrSecHolEmail') String? ocrSecHolEmail,

    @JsonKey(name: 'ocrSecHolEmailOTP') String? ocrSecHolEmailOTP,

    @JsonKey(name: 'ocrSecHolEmailOTPAddedTime')
    String? ocrSecHolEmailOTPAddedTime,

    @JsonKey(name: 'ocrSecHolEmailOTPVerifiedTime')
    String? ocrSecHolEmailOTPVerifiedTime,

    @JsonKey(name: 'ocrSecHolEmailOTPFlag') bool? ocrSecHolEmailOTPFlag,

    @JsonKey(name: 'ocrSecHolFamilyFlagForEmail')
    bool? ocrSecHolFamilyFlagForEmail,

    @JsonKey(name: 'ocrSecHolFamilyRelationshipForEmail')
    int? ocrSecHolFamilyRelationshipForEmail,

    // Second Holder Occupation & Income
    @JsonKey(name: 'ocrSecHolOccupation') int? ocrSecHolOccupation,

    @JsonKey(name: 'SecHolOccupation') String? secHolOccupation,

    @JsonKey(name: 'ocrSecHolAnnualIncome') int? ocrSecHolAnnualIncome,

    @JsonKey(name: 'SecHolAnnualIncome') String? secHolAnnualIncome,

    @JsonKey(name: 'ocrSecHolAnnualIncomeDate')
    String? ocrSecHolAnnualIncomeDate,

    @JsonKey(name: 'ocrSecHolNumberOfDocument') int? ocrSecHolNumberOfDocument,

    @JsonKey(name: 'ocrSecHolInPersonVerificationFlag')
    bool? ocrSecHolInPersonVerificationFlag,

    // Second Holder Tax Information
    @JsonKey(name: 'ocrSecHolTaxApplicableOutside')
    int? ocrSecHolTaxApplicableOutside,

    @JsonKey(name: 'SecHolTaxApplicableOutside')
    String? secHolTaxApplicableOutside,

    @JsonKey(name: 'ocrSecHolTaxPayableAddFlag')
    dynamic ocrSecHolTaxPayableAddFlag,

    @JsonKey(name: 'SecHolTaxPaybleAddFlag') dynamic secHolTaxPaybleAddFlag,

    @JsonKey(name: 'ocrSecHolTaxIndentificationNo')
    dynamic ocrSecHolTaxIndentificationNo,

    @JsonKey(name: 'ocrSecHolTaxEligibleCountry')
    dynamic ocrSecHolTaxEligibleCountry,

    @JsonKey(name: 'SecHolTaxAligibleCountry') dynamic secHolTaxAligibleCountry,

    // Second Holder Correspondence Address
    @JsonKey(name: 'ocrSecHolCorrAddress1') String? ocrSecHolCorrAddress1,

    @JsonKey(name: 'ocrSecHolCorrAddress2') String? ocrSecHolCorrAddress2,

    @JsonKey(name: 'ocrSecHolCorrAddress3') String? ocrSecHolCorrAddress3,

    @JsonKey(name: 'ocrSecHolCorrAddress4') String? ocrSecHolCorrAddress4,

    @JsonKey(name: 'ocrSecHolCorrCountry') int? ocrSecHolCorrCountry,

    @JsonKey(name: 'SecHolCorrCountry') String? secHolCorrCountry,

    @JsonKey(name: 'ocrSecHolCorrState') int? ocrSecHolCorrState,

    @JsonKey(name: 'SecHolCorrState') String? secHolCorrState,

    @JsonKey(name: 'ocrSecHolCorrCity') int? ocrSecHolCorrCity,

    @JsonKey(name: 'SecHolCorrCity') String? secHolCorrCity,

    @JsonKey(name: 'ocrSecHolCorrPinCode') int? ocrSecHolCorrPinCode,

    @JsonKey(name: 'SecHolCorrPinCode') String? secHolCorrPinCode,

    @JsonKey(name: 'ocrSecHolCorrAddressProof') int? ocrSecHolCorrAddressProof,

    @JsonKey(name: 'SecHolCorrAddressProof') String? secHolCorrAddressProof,

    @JsonKey(name: 'ocrSecHolCorrAddressType') int? ocrSecHolCorrAddressType,

    @JsonKey(name: 'SecHolCorrAddressType') String? secHolCorrAddressType,

    @JsonKey(name: 'ocrSecHolCorrPerAddressFlag')
    bool? ocrSecHolCorrPerAddressFlag,

    // Second Holder Permanent Address
    @JsonKey(name: 'ocrSecHolPerAddress1') String? ocrSecHolPerAddress1,

    @JsonKey(name: 'ocrSecHolPerAddress2') String? ocrSecHolPerAddress2,

    @JsonKey(name: 'ocrSecHolPerAddress3') String? ocrSecHolPerAddress3,

    @JsonKey(name: 'ocrSecHolPerAddress4') String? ocrSecHolPerAddress4,

    @JsonKey(name: 'ocrSecHolPerCountry') int? ocrSecHolPerCountry,

    @JsonKey(name: 'SecHolPerCountry') String? secHolPerCountry,

    @JsonKey(name: 'ocrSecHolPerState') int? ocrSecHolPerState,

    @JsonKey(name: 'SecHolPerState') String? secHolPerState,

    @JsonKey(name: 'ocrSecHolPerCity') int? ocrSecHolPerCity,

    @JsonKey(name: 'SecHolPerCity') String? secHolPerCity,

    @JsonKey(name: 'ocrSecHolPerPinCode') int? ocrSecHolPerPinCode,

    @JsonKey(name: 'SecHolPerPinCode') String? secHolPerPinCode,

    @JsonKey(name: 'ocrSecHolPerAddressProof') int? ocrSecHolPerAddressProof,

    @JsonKey(name: 'SecHolPerAddressProof') String? secHolPerAddressProof,

    @JsonKey(name: 'ocrSecHolPerAddressType') int? ocrSecHolPerAddressType,

    @JsonKey(name: 'SecHolPerAddressType') String? secHolPerAddressType,

    // Second Holder Phone & Identity
    @JsonKey(name: 'ocrSecHolPhone') dynamic ocrSecHolPhone,
    @JsonKey(name: 'ocrSecHolIdentityProof') dynamic ocrSecHolIdentityProof,
    @JsonKey(name: 'SecHolIdentityProof') dynamic secHolIdentityProof,
    @JsonKey(name: 'ocrSecHolIdentityNo') dynamic ocrSecHolIdentityNo,
    @JsonKey(name: 'ocrSecHolIdentityExpiryDate')
    dynamic ocrSecHolIdentityExpiryDate,

    // Bank Information
    @JsonKey(name: 'ocrBankId') int? ocrBankId,
    @JsonKey(name: 'ocrBankIFSCCode') String? ocrBankIFSCCode,
    @JsonKey(name: 'ocrBankMICR') String? ocrBankMICR,
    @JsonKey(name: 'ocrBankType') int? ocrBankType,
    @JsonKey(name: 'BankType') String? bankType,
    @JsonKey(name: 'ocrBankModeOfOperation') String? ocrBankModeOfOperation,
    @JsonKey(name: 'ocrBankAccountNo') String? ocrBankAccountNo,
    @JsonKey(name: 'ocrBankName') String? ocrBankName,
    @JsonKey(name: 'ocrBankBranchName') String? ocrBankBranchName,
    @JsonKey(name: 'ocrNameAsperBank') dynamic ocrNameAsperBank,
    @JsonKey(name: 'ocrBankUTRNo') dynamic ocrBankUTRNo,

    // Bank Address
    @JsonKey(name: 'ocrBankAddress1') String? ocrBankAddress1,
    @JsonKey(name: 'ocrBankAddress2') String? ocrBankAddress2,
    @JsonKey(name: 'ocrBankAddress3') String? ocrBankAddress3,
    @JsonKey(name: 'ocrBankAddress4') String? ocrBankAddress4,
    @JsonKey(name: 'ocrBankCountry') int? ocrBankCountry,
    @JsonKey(name: 'BankCountry') String? bankCountry,
    @JsonKey(name: 'ocrBankState') int? ocrBankState,
    @JsonKey(name: 'BankState') String? bankState,
    @JsonKey(name: 'ocrBankCity') int? ocrBankCity,
    @JsonKey(name: 'BankCity') String? bankCity,
    @JsonKey(name: 'ocrBankPinCode') int? ocrBankPinCode,
    @JsonKey(name: 'BankPinCode') String? bankPinCode,
    // UPI Information
    @JsonKey(name: 'ocrUPIID') dynamic ocrUPIID,
    @JsonKey(name: 'ocrUPIHolderName') dynamic ocrUPIHolderName,
    @JsonKey(name: 'ocrUPIVerifiedStatus') dynamic ocrUPIVerifiedStatus,
    @JsonKey(name: 'ocrBankOTP') dynamic ocrBankOTP,
    // Other Details / Non-Individual Information
    @JsonKey(name: 'ocrMultiHolderDetailTime') dynamic ocrMultiHolderDetailTime,
    @JsonKey(name: 'ocrNetworth') int? ocrNetworth,
    @JsonKey(name: 'ocrNetworthDate') String? ocrNetworthDate,
    @JsonKey(name: 'ocrInCorporationDate') String? ocrInCorporationDate,
    @JsonKey(name: 'ocrInCorporationPlace') String? ocrInCorporationPlace,
    @JsonKey(name: 'ocrCommencementDate') String? ocrCommencementDate,
    @JsonKey(name: 'ocrCinNumber') String? ocrCinNumber,

    // Primary Nominee Information
    @JsonKey(name: 'ocrNomOptOutFlag') bool? ocrNomOptOutFlag,
    @JsonKey(name: 'ocrNomFlag') bool? ocrNomFlag,
    @JsonKey(name: 'ocrNomPercentage') dynamic ocrNomPercentage,
    @JsonKey(name: 'ocrNomEqualDistributionFlag')
    dynamic ocrNomEqualDistributionFlag,
    @JsonKey(name: 'ocrNomName') dynamic ocrNomName,
    @JsonKey(name: 'ocrNomPan') dynamic ocrNomPan,
    @JsonKey(name: 'ocrNomDateOfBirth') dynamic ocrNomDateOfBirth,
    @JsonKey(name: 'ocrNomRelation') dynamic ocrNomRelation,
    @JsonKey(name: 'NomRelation') dynamic nomRelation,
    @JsonKey(name: 'ocrNomPhone') dynamic ocrNomPhone,

    @JsonKey(name: 'ocrNomMobile') dynamic ocrNomMobile,

    @JsonKey(name: 'ocrNomEmail') dynamic ocrNomEmail,

    // Nominee Address
    @JsonKey(name: 'ocrNomAddress1') dynamic ocrNomAddress1,

    @JsonKey(name: 'ocrNomAddress2') dynamic ocrNomAddress2,

    @JsonKey(name: 'ocrNomAddress3') dynamic ocrNomAddress3,

    @JsonKey(name: 'ocrNomAddress4') dynamic ocrNomAddress4,

    @JsonKey(name: 'ocrNomCountry') dynamic ocrNomCountry,

    @JsonKey(name: 'NomCountry') dynamic nomCountry,

    @JsonKey(name: 'ocrNomState') dynamic ocrNomState,

    @JsonKey(name: 'NomState') dynamic nomState,

    @JsonKey(name: 'ocrNomCity') dynamic ocrNomCity,

    @JsonKey(name: 'NomCity') dynamic nomCity,

    @JsonKey(name: 'ocrNomPinCode') dynamic ocrNomPinCode,

    @JsonKey(name: 'NomPinCode') dynamic nomPinCode,

    // Nominee Proof Details
    @JsonKey(name: 'ocrNomProof') dynamic ocrNomProof,
    @JsonKey(name: 'NomProof') dynamic nomProof,
    @JsonKey(name: 'ocrNomProofNo') dynamic ocrNomProofNo,
    @JsonKey(name: 'ocrNomProofImageType') dynamic ocrNomProofImageType,
    @JsonKey(name: 'ocrNomProofImage') dynamic ocrNomProofImage,

    // Minor Nominee Guardian Details
    @JsonKey(name: 'ocrNomMinorFlag') bool? ocrNomMinorFlag,
    @JsonKey(name: 'ocrNomGuaName') dynamic ocrNomGuaName,
    @JsonKey(name: 'ocrNomGuaDateOfBirth') dynamic ocrNomGuaDateOfBirth,
    @JsonKey(name: 'ocrNomWithGuaRelation') dynamic ocrNomWithGuaRelation,
    @JsonKey(name: 'NomWithGuaRelation') dynamic nomWithGuaRelation,
    @JsonKey(name: 'ocrNomGuaAddress1') dynamic ocrNomGuaAddress1,
    @JsonKey(name: 'ocrNomGuaAddress2') dynamic ocrNomGuaAddress2,
    @JsonKey(name: 'ocrNomGuaAddress3') dynamic ocrNomGuaAddress3,
    @JsonKey(name: 'ocrNomGuaAddress4') dynamic ocrNomGuaAddress4,
    @JsonKey(name: 'ocrNomGuaCountry') dynamic ocrNomGuaCountry,
    @JsonKey(name: 'NomGuaCountry') dynamic nomGuaCountry,
    @JsonKey(name: 'ocrNomGuaState') dynamic ocrNomGuaState,
    @JsonKey(name: 'NomGuaState') dynamic nomGuaState,
    @JsonKey(name: 'ocrNomGuaCity') dynamic ocrNomGuaCity,
    @JsonKey(name: 'NomGuaCity') dynamic nomGuaCity,
    @JsonKey(name: 'ocrNomGuaPinCode') dynamic ocrNomGuaPinCode,
    @JsonKey(name: 'NomGuaPinCode') dynamic nomGuaPinCode,
    @JsonKey(name: 'ocrNomGuaPhone') dynamic ocrNomGuaPhone,
    @JsonKey(name: 'ocrNomGuaMobile') dynamic ocrNomGuaMobile,
    @JsonKey(name: 'ocrNomGuaEmail') dynamic ocrNomGuaEmail,
    @JsonKey(name: 'ocrNomGuaProof') dynamic ocrNomGuaProof,
    @JsonKey(name: 'NomGuaProof') dynamic nomGuaProof,
    @JsonKey(name: 'ocrNomGuaProofNo') dynamic ocrNomGuaProofNo,
    @JsonKey(name: 'ocrNomGuaProofImageType') dynamic ocrNomGuaProofImageType,
    @JsonKey(name: 'ocrNomGuaProofImage') dynamic ocrNomGuaProofImage,

    // Secondary Nominee Information
    @JsonKey(name: 'ocrSecNomFlag') bool? ocrSecNomFlag,
    @JsonKey(name: 'ocrSecNomPercentage') dynamic ocrSecNomPercentage,
    @JsonKey(name: 'ocrSecNomName') dynamic ocrSecNomName,
    @JsonKey(name: 'ocrSecNomPan') dynamic ocrSecNomPan,
    @JsonKey(name: 'ocrSecNomDateOfBirth') dynamic ocrSecNomDateOfBirth,
    @JsonKey(name: 'ocrSecNomRelation') dynamic ocrSecNomRelation,
    @JsonKey(name: 'SecNomRelation') dynamic secNomRelation,
    @JsonKey(name: 'ocrSecNomPhone') dynamic ocrSecNomPhone,
    @JsonKey(name: 'ocrSecNomMobile') dynamic ocrSecNomMobile,
    @JsonKey(name: 'ocrSecNomEmail') dynamic ocrSecNomEmail,

    // Secondary Nominee Address
    @JsonKey(name: 'ocrSecNomAddress1') dynamic ocrSecNomAddress1,
    @JsonKey(name: 'ocrSecNomAddress2') dynamic ocrSecNomAddress2,
    @JsonKey(name: 'ocrSecNomAddress3') dynamic ocrSecNomAddress3,
    @JsonKey(name: 'ocrSecNomAddress4') dynamic ocrSecNomAddress4,
    @JsonKey(name: 'ocrSecNomCountry') dynamic ocrSecNomCountry,
    @JsonKey(name: 'SecNomCountry') dynamic secNomCountry,
    @JsonKey(name: 'ocrSecNomState') dynamic ocrSecNomState,
    @JsonKey(name: 'SecNomState') dynamic secNomState,
    @JsonKey(name: 'ocrSecNomCity') dynamic ocrSecNomCity,
    @JsonKey(name: 'SecNomCity') dynamic secNomCity,
    @JsonKey(name: 'ocrSecNomPinCode') dynamic ocrSecNomPinCode,
    @JsonKey(name: 'SecNomPinCode') dynamic secNomPinCode,
    // Secondary Nominee Proof Details
    @JsonKey(name: 'ocrSecNomProof') dynamic ocrSecNomProof,
    @JsonKey(name: 'SecNomProof') dynamic secNomProof,
    @JsonKey(name: 'ocrSecNomProofNo') dynamic ocrSecNomProofNo,
    @JsonKey(name: 'ocrSecNomProofImageType') dynamic ocrSecNomProofImageType,
    @JsonKey(name: 'ocrSecNomProofImage') dynamic ocrSecNomProofImage,
    // Secondary Nominee Minor Guardian Details
    @JsonKey(name: 'ocrSecNomMinorFlag') bool? ocrSecNomMinorFlag,
    @JsonKey(name: 'ocrSecNomGuaName') dynamic ocrSecNomGuaName,
    @JsonKey(name: 'ocrSecNomGuaDateOfBirth') dynamic ocrSecNomGuaDateOfBirth,
    @JsonKey(name: 'ocrSecNomWithGuaRelation') dynamic ocrSecNomWithGuaRelation,
    @JsonKey(name: 'SecNomWithGuaRelation') dynamic secNomWithGuaRelation,
    @JsonKey(name: 'ocrSecNomGuaAddress1') dynamic ocrSecNomGuaAddress1,
    @JsonKey(name: 'ocrSecNomGuaAddress2') dynamic ocrSecNomGuaAddress2,
    @JsonKey(name: 'ocrSecNomGuaAddress3') dynamic ocrSecNomGuaAddress3,
    @JsonKey(name: 'ocrSecNomGuaAddress4') dynamic ocrSecNomGuaAddress4,
    @JsonKey(name: 'ocrSecNomGuaCountry') dynamic ocrSecNomGuaCountry,
    @JsonKey(name: 'SecNomGuaCountry') dynamic secNomGuaCountry,
    @JsonKey(name: 'ocrSecNomGuaState') dynamic ocrSecNomGuaState,
    @JsonKey(name: 'SecNomGuaState') dynamic secNomGuaState,
    @JsonKey(name: 'ocrSecNomGuaCity') dynamic ocrSecNomGuaCity,
    @JsonKey(name: 'SecNomGuaCity') dynamic secNomGuaCity,
    @JsonKey(name: 'ocrSecNomGuaPinCode') dynamic ocrSecNomGuaPinCode,
    @JsonKey(name: 'SecNomGuaPinCode') dynamic secNomGuaPinCode,
    @JsonKey(name: 'ocrSecNomGuaPhone') dynamic ocrSecNomGuaPhone,
    @JsonKey(name: 'ocrSecNomGuaMobile') dynamic ocrSecNomGuaMobile,
    @JsonKey(name: 'ocrSecNomGuaEmail') dynamic ocrSecNomGuaEmail,
    @JsonKey(name: 'ocrSecNomGuaProof') dynamic ocrSecNomGuaProof,
    @JsonKey(name: 'SecNomGuaProof') dynamic secNomGuaProof,
    @JsonKey(name: 'ocrSecNomGuaProofNo') dynamic ocrSecNomGuaProofNo,
    @JsonKey(name: 'ocrSecNomGuaProofImageType')
    dynamic ocrSecNomGuaProofImageType,
    @JsonKey(name: 'ocrSecNomGuaProofImage') dynamic ocrSecNomGuaProofImage,

    // Third Nominee Information
    @JsonKey(name: 'ocrThiNomFlag') bool? ocrThiNomFlag,
    @JsonKey(name: 'ocrThiNomPercentage') dynamic ocrThiNomPercentage,
    @JsonKey(name: 'ocrThiNomName') dynamic ocrThiNomName,
    @JsonKey(name: 'ocrThiNomPan') dynamic ocrThiNomPan,
    @JsonKey(name: 'ocrThiNomDateOfBirth') dynamic ocrThiNomDateOfBirth,
    @JsonKey(name: 'ocrThiNomRelation') dynamic ocrThiNomRelation,
    @JsonKey(name: 'ThiNomRelation') dynamic thiNomRelation,
    @JsonKey(name: 'ocrThiNomPhone') dynamic ocrThiNomPhone,
    @JsonKey(name: 'ocrThiNomMobile') dynamic ocrThiNomMobile,
    @JsonKey(name: 'ocrThiNomEmail') dynamic ocrThiNomEmail,

    // Third Nominee Address
    @JsonKey(name: 'ocrThiNomAddress1') dynamic ocrThiNomAddress1,
    @JsonKey(name: 'ocrThiNomAddress2') dynamic ocrThiNomAddress2,
    @JsonKey(name: 'ocrThiNomAddress3') dynamic ocrThiNomAddress3,
    @JsonKey(name: 'ocrThiNomAddress4') dynamic ocrThiNomAddress4,
    @JsonKey(name: 'ocrThiNomCountry') dynamic ocrThiNomCountry,
    @JsonKey(name: 'ThiNomCountry') dynamic thiNomCountry,
    @JsonKey(name: 'ocrThiNomState') dynamic ocrThiNomState,
    @JsonKey(name: 'ThiNomState') dynamic thiNomState,
    @JsonKey(name: 'ocrThiNomCity') dynamic ocrThiNomCity,
    @JsonKey(name: 'ThiNomCity') dynamic thiNomCity,
    @JsonKey(name: 'ocrThiNomPinCode') dynamic ocrThiNomPinCode,
    @JsonKey(name: 'ThiNomPinCode') dynamic thiNomPinCode,

    // Third Nominee Proof Details
    @JsonKey(name: 'ocrThiNomProof') dynamic ocrThiNomProof,
    @JsonKey(name: 'ThiNomProof') dynamic thiNomProof,
    @JsonKey(name: 'ocrThiNomProofNo') dynamic ocrThiNomProofNo,
    @JsonKey(name: 'ocrThiNomProofImageType') dynamic ocrThiNomProofImageType,
    @JsonKey(name: 'ocrThiNomProofImage') dynamic ocrThiNomProofImage,

    // Third Nominee Minor Guardian Details
    @JsonKey(name: 'ocrThiNomMinorFlag') bool? ocrThiNomMinorFlag,
    @JsonKey(name: 'ocrThiNomGuaName') dynamic ocrThiNomGuaName,
    @JsonKey(name: 'ocrThiNomGuaDateOfBirth') dynamic ocrThiNomGuaDateOfBirth,
    @JsonKey(name: 'ocrThiNomWithGuaRelation') dynamic ocrThiNomWithGuaRelation,
    @JsonKey(name: 'ThiNomWithGuaRelation') dynamic thiNomWithGuaRelation,
    @JsonKey(name: 'ocrThiNomGuaAddress1') dynamic ocrThiNomGuaAddress1,
    @JsonKey(name: 'ocrThiNomGuaAddress2') dynamic ocrThiNomGuaAddress2,
    @JsonKey(name: 'ocrThiNomGuaAddress3') dynamic ocrThiNomGuaAddress3,
    @JsonKey(name: 'ocrThiNomGuaAddress4') dynamic ocrThiNomGuaAddress4,
    @JsonKey(name: 'ocrThiNomGuaCountry') dynamic ocrThiNomGuaCountry,
    @JsonKey(name: 'ThiNomGuaCountry') dynamic thiNomGuaCountry,
    @JsonKey(name: 'ocrThiNomGuaState') dynamic ocrThiNomGuaState,
    @JsonKey(name: 'ThiNomGuaState') dynamic thiNomGuaState,
    @JsonKey(name: 'ocrThiNomGuaCity') dynamic ocrThiNomGuaCity,
    @JsonKey(name: 'ThiNomGuaCity') dynamic thiNomGuaCity,

    @JsonKey(name: 'ocrThiNomGuaPinCode') dynamic ocrThiNomGuaPinCode,

    @JsonKey(name: 'ThiNomGuaPinCode') dynamic thiNomGuaPinCode,

    @JsonKey(name: 'ocrThiNomGuaPhone') dynamic ocrThiNomGuaPhone,

    @JsonKey(name: 'ocrThiNomGuaMobile') dynamic ocrThiNomGuaMobile,

    @JsonKey(name: 'ocrThiNomGuaEmail') dynamic ocrThiNomGuaEmail,

    @JsonKey(name: 'ocrThiNomGuaProof') dynamic ocrThiNomGuaProof,

    @JsonKey(name: 'ThiNomGuaProof') dynamic thiNomGuaProof,

    @JsonKey(name: 'ocrThiNomGuaProofNo') dynamic ocrThiNomGuaProofNo,

    @JsonKey(name: 'ocrThiNomGuaProofImageType')
    dynamic ocrThiNomGuaProofImageType,
    @JsonKey(name: 'ocrThiNomGuaProofImage') dynamic ocrThiNomGuaProofImage,

    @JsonKey(name: 'ocrGuardianMotherFirstName')
    dynamic ocrGuardianMotherFirstName,
    @JsonKey(name: 'ocrGuardianMotherMiddleName')
    dynamic ocrGuardianMotherMiddleName,
    @JsonKey(name: 'ocrGuardianMotherLastName')
    dynamic ocrGuardianMotherLastName,
    @JsonKey(name: 'ocrGuardianPhone') dynamic ocrGuardianPhone,

    @JsonKey(name: 'ocrGuardianMobile') dynamic ocrGuardianMobile,

    @JsonKey(name: 'ocrGuardianEmail') dynamic ocrGuardianEmail,

    @JsonKey(name: 'ocrGuardianAddress1') dynamic ocrGuardianAddress1,

    @JsonKey(name: 'ocrGuardianAddress2') dynamic ocrGuardianAddress2,

    @JsonKey(name: 'ocrGuardianAddress3') dynamic ocrGuardianAddress3,

    @JsonKey(name: 'ocrGuardianAddress4') dynamic ocrGuardianAddress4,

    @JsonKey(name: 'ocrGuardianCountry') dynamic ocrGuardianCountry,

    @JsonKey(name: 'GuardianCountry') dynamic guardianCountry,

    @JsonKey(name: 'ocrGuardianState') dynamic ocrGuardianState,

    @JsonKey(name: 'GuardianState') dynamic guardianState,

    @JsonKey(name: 'ocrGuardianCity') dynamic ocrGuardianCity,

    @JsonKey(name: 'GuardianCity') dynamic guardianCity,

    @JsonKey(name: 'ocrGuardianPinCode') dynamic ocrGuardianPinCode,

    @JsonKey(name: 'GuardianPinCode') dynamic guardianPinCode,

    @JsonKey(name: 'ocrGuardianIdentityProof') dynamic ocrGuardianIdentityProof,

    @JsonKey(name: 'GuardianIdentityProof') dynamic guardianIdentityProof,

    @JsonKey(name: 'ocrGuardianIdentityNo') dynamic ocrGuardianIdentityNo,

    @JsonKey(name: 'ocrGuardianIdentityExpiryDate')
    dynamic ocrGuardianIdentityExpiryDate,
    @JsonKey(name: 'ocrKRADocument') dynamic ocrKRADocument,
    @JsonKey(name: 'ocrKRAAgencyDocument') dynamic ocrKRAAgencyDocument,
    @JsonKey(name: 'ocrSecHolKRADocument') dynamic ocrSecHolKRADocument,
    @JsonKey(name: 'ocrSecHolKRAAgencyDocument')
    dynamic ocrSecHolKRAAgencyDocument,
    @JsonKey(name: 'ocrThiHolKRADocument') dynamic ocrThiHolKRADocument,
    @JsonKey(name: 'ocrThiHolKRAAgencyDocument')
    dynamic ocrThiHolKRAAgencyDocument,
    @JsonKey(name: 'ocrPan') dynamic ocrPan,
    @JsonKey(name: 'ocrProDateOfBirth') dynamic ocrProDateOfBirth,
    @JsonKey(name: 'Designation') String? designation,
    @JsonKey(name: 'BranchName') String? branchName,
    @JsonKey(name: 'BranchContactNo') String? branchContactNo,
    @JsonKey(name: 'BranchEmail') String? branchEmail,
    // Agreement Document Details
    @JsonKey(name: 'agHolderNm') String? agHolderNm,
    @JsonKey(name: 'agDocType') String? agDocType,
    @JsonKey(name: 'agImageType') String? agImageType,
    @JsonKey(name: 'agImage') dynamic agImage,
    @JsonKey(name: 'agDocName') String? agDocName,
    @JsonKey(name: 'bratype') int? bratype,
    @JsonKey(name: 'braBranchCat') int? braBranchCat,
    @JsonKey(name: 'UserSign') BufferModel? userSign,
  }) = _ExistingClientRecordModel;

  factory ExistingClientRecordModel.fromJson(Map<String, dynamic> json) =>
      _$ExistingClientRecordModelFromJson(json);
}

@freezed
class BufferModel with _$BufferModel {
  const factory BufferModel({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'data') @Default([]) List<int> data,
  }) = _BufferModel;

  factory BufferModel.fromJson(Map<String, dynamic> json) =>
      _$BufferModelFromJson(json);
}
