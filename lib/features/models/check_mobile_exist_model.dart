import 'package:freezed_annotation/freezed_annotation.dart';
part 'check_mobile_exist_model.freezed.dart';
part 'check_mobile_exist_model.g.dart';

@freezed
class CheckMobileExistModel with _$CheckMobileExistModel {
  const factory CheckMobileExistModel({
    required bool success,
    required bool exists,
    @Default([]) List<MessageRecord> messageRecordSet,
    String? email,
    String? accountSubCategory,
    String? branchEmail,
  }) = _CheckMobileExistModel;

  factory CheckMobileExistModel.fromJson(Map<String, dynamic> json) => _$CheckMobileExistModelFromJson(json);
}

@freezed
class MessageRecord with _$MessageRecord {
  const factory MessageRecord({
    @JsonKey(name: 'Message') required String message,
    @JsonKey(name: 'Type') required int type,
    @JsonKey(name: 'Title') required String title,
  }) = _MessageRecord;

  factory MessageRecord.fromJson(Map<String, dynamic> json) => _$MessageRecordFromJson(json);
}
