import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shahinvestor/features/models/static_data_model.dart';
part 'segment_data_model.freezed.dart';
part 'segment_data_model.g.dart';

@freezed
class SegmentDataModel with _$SegmentDataModel {
  const factory SegmentDataModel({
    required FluffyRecordset segment,
    @Default('') String header,
    @Default(false) bool selected,
    @Default(false) bool isSLBM,
    @Default(false) bool disabled,
    @Default('') String displayDescription,
  }) = _SegmentDataModel;

  factory SegmentDataModel.fromJson(
    Map<String, dynamic> json,
  ) => _$SegmentDataModelFromJson(json);
}
