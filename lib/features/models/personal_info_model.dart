import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_info_model.freezed.dart';
part 'personal_info_model.g.dart';

@freezed
class PersonalInfoModel with _$PersonalInfoModel {
  const factory PersonalInfoModel({
    @Default('') String relationType,
    @Default('') String fatherOrSpouseFirstName,
    @Default('') String fatherOrSpouseMiddleName,
    @Default('') String fatherOrSpouseLastName,

    @Default('') String motherFirstName,
    @Default('') String motherMiddleName,
    @Default('') String motherLastName,
  }) = _PersonalInfoModel;

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoModelFromJson(json);
}
