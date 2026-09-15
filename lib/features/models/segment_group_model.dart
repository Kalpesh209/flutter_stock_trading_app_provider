import 'package:freezed_annotation/freezed_annotation.dart';

import 'segment_data_model.dart';
part 'segment_group_model.freezed.dart';

@freezed
class SegmentGroupModel with _$SegmentGroupModel {
  const factory SegmentGroupModel({
    required String header,
    @Default(false) bool selected,
    @Default(false) bool disabled,

    @Default(<SegmentDataModel>[])
    List<SegmentDataModel> items,
  }) = _SegmentGroupModel;
}
