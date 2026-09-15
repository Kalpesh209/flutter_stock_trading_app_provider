import 'package:flutter_stock_trading_app_provider/core/appUtils/app_enums.dart';
import 'package:flutter_stock_trading_app_provider/features/models/client_step_config_model.dart';

class AppConstants {
  // Base Image Path
  static const String baseImagePath = 'assets/images';
  static const String baseLottiePath = 'assets/lottie';

  // PDF Path
  static const String basePDFPath = 'assets/pdfs';

  static const String emailRegex = r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String nameRegex = r'^[A-Za-z]+(?: [A-Za-z]+)*$';

  static final RegExp gstRegex = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
  );

  static final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
  static final micrRegex = RegExp(r'^[0-9]{9}$');
  static final individualPANRegex = RegExp(r'^[A-Z]{3}P[A-Z][0-9]{4}[A-Z]$');

  static const Map<String, String> USER_TYPE_MAP = {
    'c': 'Client',
    'b': 'Branch',
    'e': 'Branch',
    'p': 'EasyPartner',
    'r': 'Remisar',
  };

  static const Map<int, String> SEGMENT_FLAG_MAP = {
    17: 'ocrNSEEQ',
    18: 'ocrBSEEQ',
    19: 'ocrNSEFO',
    20: 'ocrBSEFO',
    21: 'ocrNSECD',
    63: 'ocrNSECO',
    64: 'ocrMCXCO',
  };

  static const Map<String, Map<String, dynamic>> SEGMENT_CONFIG = {
    'NSDL': {'ids': <int>[], 'defaultSelected': true},
    'Equity': {
      'ids': <int>[17, 18],
      'defaultSelected': true,
    },
    'Equity Derivatives': {
      'ids': <int>[19, 20],
      'defaultSelected': false,
    },
    'Currency': {
      'ids': <int>[21],
      'defaultSelected': false,
    },
    'Commodities': {
      'ids': <int>[64],
      'defaultSelected': false,
    },
    'SLBM': {'ids': <int>[], 'defaultSelected': true},
  };

  static const List<String> LEFT_COLUMN_SEGMENTS = ['NSDL', 'Equity', 'SLBM'];

  static const ACCOUNT_OPTION_TRADING = '1';

  static const List<AdditionalStep> ADDITIONAL_STEPS = [
    AdditionalStep.occupation,
    AdditionalStep.income,
    AdditionalStep.country,
    AdditionalStep.city,
    AdditionalStep.gender,
    AdditionalStep.marital,
    AdditionalStep.residentialStatus,
    AdditionalStep.placeOfDeclaration,
    AdditionalStep.pepAndSettlementCycle,
    AdditionalStep.noOfDocuments,
    AdditionalStep.nsdlClientType,
    AdditionalStep.nsdlSubClientType,
  ];

  static const List<ClientStepConfigModel> clientStepConfigs = [
    ClientStepConfigModel(
      id: 1,
      name: 'HUF',
      steps: [
        AdditionalStep.occupation,
        AdditionalStep.income,
        AdditionalStep.gender,
        AdditionalStep.residentialStatus,
        AdditionalStep.placeOfDeclaration,
        AdditionalStep.pepAndSettlementCycle,
      ],
    ),
    ClientStepConfigModel(
      id: 2,
      name: 'Corporate',
      steps: [
        AdditionalStep.occupation,
        AdditionalStep.income,
        AdditionalStep.gender,
        AdditionalStep.residentialStatus,
        AdditionalStep.placeOfDeclaration,
        AdditionalStep.pepAndSettlementCycle,
        AdditionalStep.nsdlClientType,
        AdditionalStep.nsdlSubClientType,
      ],
    ),
    ClientStepConfigModel(
      id: 3,
      name: 'Trust',
      steps: [
        AdditionalStep.occupation,
        AdditionalStep.income,
        AdditionalStep.gender,
        AdditionalStep.residentialStatus,
        AdditionalStep.placeOfDeclaration,
        AdditionalStep.pepAndSettlementCycle,
        AdditionalStep.nsdlClientType,
        AdditionalStep.nsdlSubClientType,
      ],
    ),
    ClientStepConfigModel(
      id: 4,
      name: 'Partnership',
      steps: [
        AdditionalStep.occupation,
        AdditionalStep.income,
        AdditionalStep.gender,
        AdditionalStep.residentialStatus,
        AdditionalStep.placeOfDeclaration,
        AdditionalStep.pepAndSettlementCycle,
      ],
    ),
    ClientStepConfigModel(
      id: 5,
      name: 'Minor',
      steps: [
        AdditionalStep.occupation,
        AdditionalStep.income,
        AdditionalStep.city,
        AdditionalStep.gender,
        AdditionalStep.marital,
        AdditionalStep.residentialStatus,
        AdditionalStep.placeOfDeclaration,
        AdditionalStep.pepAndSettlementCycle,
      ],
    ),
    ClientStepConfigModel(
      id: 6,
      name: 'NRI',
      steps: [
        AdditionalStep.occupation,
        AdditionalStep.income,
        AdditionalStep.country,
        AdditionalStep.city,
        AdditionalStep.gender,
        AdditionalStep.marital,
        AdditionalStep.residentialStatus,
        AdditionalStep.placeOfDeclaration,
        AdditionalStep.pepAndSettlementCycle,
        AdditionalStep.nsdlClientType,
        AdditionalStep.nsdlSubClientType,
      ],
    ),
    ClientStepConfigModel(
      id: 7,
      name: 'MultiHolder',
      steps: [
        AdditionalStep.occupation,
        AdditionalStep.income,
        AdditionalStep.city,
        AdditionalStep.gender,
        AdditionalStep.marital,
        AdditionalStep.residentialStatus,
        AdditionalStep.placeOfDeclaration,
        AdditionalStep.pepAndSettlementCycle,
      ],
    ),
    ClientStepConfigModel(
      id: 8,
      name: 'Individual',
      steps: [
        AdditionalStep.occupation,
        AdditionalStep.income,
        AdditionalStep.city,
        AdditionalStep.gender,
        AdditionalStep.marital,
        AdditionalStep.pepAndSettlementCycle,
      ],
    ),
  ];

  static const Map<String, List<String>> guardianRelationMap = {
    '3': ['0', '1', '12', '13', '9', '8'], // SON
    '6': ['0', '1', '12', '13', '9', '8'], // DAUGHTER
    // Grandchildren
    '10': ['0', '1', '12', '13', '9', '8'], // GRANDSON
    '11': ['0', '1', '12', '13', '9', '8'], // GRANDDAUGHTER
    // Parents
    '0': ['3', '6', '9', '8'], // FATHER
    '1': ['3', '6', '9', '8'], // MOTHER
    // Grandparents
    '12': ['3', '6', '10', '11', '0', '1', '9', '8'], // GRANDFATHER
    '13': ['3', '6', '10', '11', '0', '1', '9', '8'], // GRANDMOTHER
    // Siblings
    '9': ['0', '1', '12', '13', '9', '8'], // BROTHER
    '8': ['0', '1', '12', '13', '9', '8'], // SISTER
    // Spouse
    '2': ['2', '0', '1', '3', '6', '12', '13', '9', '8'], // SPOUSE
    // Son-in-law
    '4': ['2', '15', '14', '0', '1', '12', '13', '9', '8'],

    // Daughter-in-law
    '5': ['2', '15', '14', '0', '1', '12', '13', '9', '8'],

    // Father-in-law
    '15': ['3', '6', '10', '11', '4', '5', '2', '9', '8'],

    // Mother-in-law
    '14': ['3', '6', '10', '11', '4', '5', '2', '9', '8'],

    // Brother-in-law
    '16': ['2', '0', '1', '12', '13', '16', '17', '9', '8'],

    // Sister-in-law
    '17': ['2', '0', '1', '12', '13', '16', '17', '9', '8'],
  };
}
