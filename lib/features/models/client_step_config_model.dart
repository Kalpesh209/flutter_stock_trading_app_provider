import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shahinvestor/core/appUtils/app_enums.dart';

part 'client_step_config_model.freezed.dart';
part 'client_step_config_model.g.dart';

@freezed
abstract class ClientStepConfigModel with _$ClientStepConfigModel {
  const factory ClientStepConfigModel({required int id, required String name, required List<AdditionalStep> steps}) =
      _ClientStepConfigModel;

  factory ClientStepConfigModel.fromJson(Map<String, dynamic> json) => _$ClientStepConfigModelFromJson(json);
}
