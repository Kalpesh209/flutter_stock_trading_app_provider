import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'fetch_digi_locker_response_model.freezed.dart';
part 'fetch_digi_locker_response_model.g.dart';

FetchDigiLockerResponseModel fetchDigiLockerResponseModelFromJson(String str) =>
    FetchDigiLockerResponseModel.fromJson(json.decode(str) as Map<String, dynamic>);

String fetchDigiLockerResponseModelToJson(FetchDigiLockerResponseModel data) => json.encode(data.toJson());

@freezed
class FetchDigiLockerResponseModel with _$FetchDigiLockerResponseModel {
  const factory FetchDigiLockerResponseModel({
    @JsonKey(name: 'success') bool? success,
    @JsonKey(name: 'data') FetchDigiLockerData? data,
    @JsonKey(name: 'panPDF') String? panPdf,
    @JsonKey(name: 'panImage') String? panImage,
    @JsonKey(name: 'aadharPDF') String? aadharPdf,
    @JsonKey(name: 'aadharXML') String? aadharXml,
    @JsonKey(name: 'signImg') String? signImg,
  }) = _FetchDigiLockerResponseModel;

  factory FetchDigiLockerResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FetchDigiLockerResponseModelFromJson(json);
}

@freezed
class FetchDigiLockerData with _$FetchDigiLockerData {
  const factory FetchDigiLockerData({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'customer_identifier') String? customerIdentifier,
    @JsonKey(name: 'actions') List<DigiLockerAction>? actions,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'transaction_id') String? transactionId,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'expire_in_days') int? expireInDays,
    @JsonKey(name: 'reminder_registered') bool? reminderRegistered,
    @JsonKey(name: 'workflow_name') String? workflowName,
    @JsonKey(name: 'auto_approved') bool? autoApproved,
    @JsonKey(name: 'template_id') String? templateId,
  }) = _FetchDigiLockerData;

  factory FetchDigiLockerData.fromJson(Map<String, dynamic> json) => _$FetchDigiLockerDataFromJson(json);
}

@freezed
class DigiLockerAction with _$DigiLockerAction {
  const factory DigiLockerAction({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'action_ref') String? actionRef,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'execution_request_id') String? executionRequestId,
    @JsonKey(name: 'details') DigiLockerDetails? details,
    @JsonKey(name: 'validation_result') Map<String, dynamic>? validationResult,
    @JsonKey(name: 'completed_at') String? completedAt,
    @JsonKey(name: 'face_match_obj_type') String? faceMatchObjType,
    @JsonKey(name: 'face_match_status') String? faceMatchStatus,
    @JsonKey(name: 'obj_analysis_status') String? objAnalysisStatus,
    @JsonKey(name: 'processing_done') bool? processingDone,
    @JsonKey(name: 'retry_count') int? retryCount,
    @JsonKey(name: 'rules_data') DigiLockerRulesData? rulesData,
  }) = _DigiLockerAction;

  factory DigiLockerAction.fromJson(Map<String, dynamic> json) => _$DigiLockerActionFromJson(json);
}

@freezed
class DigiLockerDetails with _$DigiLockerDetails {
  const factory DigiLockerDetails({
    @JsonKey(name: 'aadhaar') DigiLockerAadhaar? aadhaar,
    @JsonKey(name: 'pan') DigiLockerPan? pan,
  }) = _DigiLockerDetails;

  factory DigiLockerDetails.fromJson(Map<String, dynamic> json) => _$DigiLockerDetailsFromJson(json);
}

@freezed
class DigiLockerAadhaar with _$DigiLockerAadhaar {
  const factory DigiLockerAadhaar({
    @JsonKey(name: 'id_number') String? idNumber,
    @JsonKey(name: 'document_type') String? documentType,
    @JsonKey(name: 'id_proof_type') String? idProofType,
    @JsonKey(name: 'gender') String? gender,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'last_refresh_date') String? lastRefreshDate,
    @JsonKey(name: 'dob') String? dob,
    @JsonKey(name: 'current_address') String? currentAddress,
    @JsonKey(name: 'permanent_address') String? permanentAddress,
    @JsonKey(name: 'current_address_details') DigiLockerAddressDetails? currentAddressDetails,
    @JsonKey(name: 'permanent_address_details') DigiLockerAddressDetails? permanentAddressDetails,
  }) = _DigiLockerAadhaar;

  factory DigiLockerAadhaar.fromJson(Map<String, dynamic> json) => _$DigiLockerAadhaarFromJson(json);
}

@freezed
class DigiLockerPan with _$DigiLockerPan {
  const factory DigiLockerPan({
    @JsonKey(name: 'id_number') String? idNumber,
    @JsonKey(name: 'document_type') String? documentType,
    @JsonKey(name: 'id_proof_type') String? idProofType,
    @JsonKey(name: 'gender') String? gender,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'dob') String? dob,
  }) = _DigiLockerPan;

  factory DigiLockerPan.fromJson(Map<String, dynamic> json) => _$DigiLockerPanFromJson(json);
}

@freezed
class DigiLockerAddressDetails with _$DigiLockerAddressDetails {
  const factory DigiLockerAddressDetails({
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'locality_or_post_office') String? localityOrPostOffice,
    @JsonKey(name: 'district_or_city') String? districtOrCity,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'pincode') String? pincode,
  }) = _DigiLockerAddressDetails;

  factory DigiLockerAddressDetails.fromJson(Map<String, dynamic> json) => _$DigiLockerAddressDetailsFromJson(json);
}

@freezed
class DigiLockerRulesData with _$DigiLockerRulesData {
  const factory DigiLockerRulesData({
    @JsonKey(name: 'approval_rule') List<DigiLockerApprovalRule>? approvalRule,
    @JsonKey(name: 'next_action_rules') List<DigiLockerNextActionRule>? nextActionRules,
    @JsonKey(name: 'strict_validation_types') List<String>? strictValidationTypes,
  }) = _DigiLockerRulesData;

  factory DigiLockerRulesData.fromJson(Map<String, dynamic> json) => _$DigiLockerRulesDataFromJson(json);
}

@freezed
class DigiLockerApprovalRule with _$DigiLockerApprovalRule {
  const factory DigiLockerApprovalRule({
    @JsonKey(name: 'property') String? property,
    @JsonKey(name: 'value') String? value,
  }) = _DigiLockerApprovalRule;

  factory DigiLockerApprovalRule.fromJson(Map<String, dynamic> json) => _$DigiLockerApprovalRuleFromJson(json);
}

@freezed
class DigiLockerNextActionRule with _$DigiLockerNextActionRule {
  const factory DigiLockerNextActionRule({
    @JsonKey(name: 'condition') List<DigiLockerConditionWrapper>? condition,
    @JsonKey(name: 'terminate') bool? terminate,
    @JsonKey(name: 'skip_message') String? skipMessage,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'passed') bool? passed,
    @JsonKey(name: 'skip_current_step') bool? skipCurrentStep,
    @JsonKey(name: 'unique_id') String? uniqueId,
    @JsonKey(name: 'next_action_ref') String? nextActionRef,
  }) = _DigiLockerNextActionRule;

  factory DigiLockerNextActionRule.fromJson(Map<String, dynamic> json) => _$DigiLockerNextActionRuleFromJson(json);
}

@freezed
class DigiLockerConditionWrapper with _$DigiLockerConditionWrapper {
  const factory DigiLockerConditionWrapper({
    @JsonKey(name: 'condition') List<DigiLockerConditionItem>? condition,
    @JsonKey(name: 'unique_id') String? uniqueId,
  }) = _DigiLockerConditionWrapper;

  factory DigiLockerConditionWrapper.fromJson(Map<String, dynamic> json) => _$DigiLockerConditionWrapperFromJson(json);
}

@freezed
class DigiLockerConditionItem with _$DigiLockerConditionItem {
  const factory DigiLockerConditionItem({
    @JsonKey(name: 'condition') DigiLockerCondition? condition,
    @JsonKey(name: 'unique_id') String? uniqueId,
    @JsonKey(name: 'logical_operator') String? logicalOperator,
  }) = _DigiLockerConditionItem;

  factory DigiLockerConditionItem.fromJson(Map<String, dynamic> json) => _$DigiLockerConditionItemFromJson(json);
}

@freezed
class DigiLockerCondition with _$DigiLockerCondition {
  const factory DigiLockerCondition({
    @JsonKey(name: 'operator') String? operator,
    @JsonKey(name: 'reference_value') String? referenceValue,
    @JsonKey(name: 'condition_type') String? conditionType,
    @JsonKey(name: 'input_action_ref') String? inputActionRef,
    @JsonKey(name: 'variable_name') String? variableName,
  }) = _DigiLockerCondition;

  factory DigiLockerCondition.fromJson(Map<String, dynamic> json) => _$DigiLockerConditionFromJson(json);
}
