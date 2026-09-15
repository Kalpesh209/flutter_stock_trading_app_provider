import 'package:freezed_annotation/freezed_annotation.dart';

part 'brokerage_info_model.freezed.dart';
part 'brokerage_info_model.g.dart';

@freezed
class BrokerageInfoModel with _$BrokerageInfoModel {
  const factory BrokerageInfoModel({
    required String header,
    @Default([]) List<String> lines,
  }) = _BrokerageInfoModel;

  factory BrokerageInfoModel.fromJson(
    Map<String, dynamic> json,
  ) => _$BrokerageInfoModelFromJson(json);
}
