import 'package:flutter_stock_trading_app_provider/core/appUtils/app_enums.dart';

extension OptDescExtension on OptDesc {
  String get displayValue {
    switch (this) {
      case OptDesc.THE_100_RS_PER_LOT_EACH_SIDE_75_RS_PER_LOT_EACH_SIDE:
        return '100rs per lot(each side) | 75rs per lot(each side)';

      case OptDesc.THE_50_RS_PER_LOT_EACH_SIDE:
        return '50rs per lot(each side)';

      case OptDesc.THE_50_RS_PER_LOT_EACH_SIDE_50_RS_PER_LOT_EACH_SIDE:
        return '50rs per lot(each side) | 50rs per lot(each side)';
    }
  }
}

extension AdditionalStepX on AdditionalStep {
  String get value => switch (this) {
    AdditionalStep.occupation => 'occupation',
    AdditionalStep.income => 'income',
    AdditionalStep.country => 'country',
    AdditionalStep.city => 'city',
    AdditionalStep.gender => 'gender',
    AdditionalStep.marital => 'marital',
    AdditionalStep.residentialStatus => 'residentialStatus',
    AdditionalStep.placeOfDeclaration => 'placeOfDeclaration',
    AdditionalStep.pepAndSettlementCycle => 'PEPAndSettlementCycle',
    AdditionalStep.noOfDocuments => 'noOfDocuments',
    AdditionalStep.nsdlClientType => 'nsdlClientType',
    AdditionalStep.nsdlSubClientType => 'nsdlSubClientType',
  };

  static AdditionalStep fromString(String value) {
    return AdditionalStep.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdditionalStep.occupation,
    );
  }
}
