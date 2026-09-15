import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_duplicate_pan_model.freezed.dart';
part 'check_duplicate_pan_model.g.dart';

@freezed
class CheckDuplicatePanModel with _$CheckDuplicatePanModel {
  const factory CheckDuplicatePanModel({@Default(false) bool isDuplicate, String? message}) = _CheckDuplicatePanModel;

  factory CheckDuplicatePanModel.fromJson(Map<String, dynamic> json) => _$CheckDuplicatePanModelFromJson(json);
}
