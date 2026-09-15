enum LoginType {
  individual('Individual', '1'),
  others('Others', '2');

  final String label;
  final String value;

  // Key - Value pair
  const LoginType(this.label, this.value);
}

enum RelationType {
  father('Father', '1'),
  spouse('Spouse', '2');

  final String label;
  final String value;

  const RelationType(this.label, this.value);
}

enum LoginValidationStatus { valid, validWithoutReferral, invalid }

enum AdditionalStep {
  occupation,
  income,
  country,
  city,
  gender,
  marital,
  residentialStatus,
  placeOfDeclaration,
  pepAndSettlementCycle,
  noOfDocuments,
  nsdlClientType,
  nsdlSubClientType,
}

enum AccountSubCategoryName { CORPORATE, HUF, MINOR, NRI, PARTNERSHIP, PARTNERSHIP_FIRM, TRUST }

enum DelDescription { FFFFF_DELI_050003, IIII_DELI_020002 }

enum DeliveryDesc { THE_02_ON_TRADE_PRICE, THE_05_ON_TRADE_PRIC, THE_05_ON_TRADE_PRICE }

enum Type { FIXED, PER_LOTWISE }

enum RoundFlag { NONE }

enum Designation {
  ACCOUNTS_EXECUTIVE,
  ADMIN,
  AUTHORIZED_PERSON,
  BACKOFFICE_EXECUTIVE,
  EMPTY,
  MANAGER,
  POSITION,
  RELATIONSHIP_OFFICER,
}

enum UserType { B, BRANCH_OWN, BRANCH_REMISAR, CLIENT, EASY_PARTNER, EMPTY, R, REMISAR }

enum JobDescription { FFF_JOBB_005005, III_JOBB_002002 }

enum Description {
  HHH_003003,
  HHH_JOBB_003003,
  STK_10000_NIFTY_10000_BANKNIFTY_10000,
  STK_5000_NIFTY_5000_BANKNIFTY_5000,
}

enum IntradayDesc { THE_002_ON_TRADE_PRICE, THE_005_ON_TRADE_PRICE }

enum FutDesc { FUT_DESC_002_PER_TRANSACTION_VALUE_EACH_SIDE, THE_002_PER_TRANSACTION_VALUE_EACH_SIDE }

enum FutDescription { HHH_003003, HHH_JOBB_003003, III_JOBB_002002 }

enum OptDesc {
  THE_100_RS_PER_LOT_EACH_SIDE_75_RS_PER_LOT_EACH_SIDE,
  THE_50_RS_PER_LOT_EACH_SIDE,
  THE_50_RS_PER_LOT_EACH_SIDE_50_RS_PER_LOT_EACH_SIDE,
}

enum SlbmDescription { SLBM_15 }
