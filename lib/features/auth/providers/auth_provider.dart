import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_constants.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_enums.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_storage_helper.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/core/network/api_services.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/repository/auth_repository.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/global_state_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/digio/provider/digio_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/models/brokerage_info_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/check_duplicate_pan_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/check_mobile_exist_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/client_step_config_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/existing_client_details_response_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/fetch_digi_locker_response_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/fetch_kra_agency_detail_models.dart';
import 'package:flutter_stock_trading_app_provider/features/models/fetch_kra_details_models.dart';
import 'package:flutter_stock_trading_app_provider/features/models/get_bank_details_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/kra_agency_flag_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/kra_agency_result_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/personal_info_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/referral_code_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/segment_data_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/segment_group_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/static_data_model.dart';
import 'package:flutter_stock_trading_app_provider/features/models/verify_otp_response_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kyc_workflow/digio_config.dart';
import 'package:kyc_workflow/environment.dart';
import 'package:kyc_workflow/gateway_event.dart';
import 'package:kyc_workflow/kyc_workflow.dart';
import 'package:kyc_workflow/service_mode.dart';
import 'package:kyc_workflow/stateless/flow_status.dart';
import 'package:kyc_workflow/stateless/selfie_config.dart';
import 'package:kyc_workflow/stateless/stateless_config.dart';
import 'package:kyc_workflow/stateless/stateless_feature.dart';
import 'package:kyc_workflow/stateless/stateless_response.dart';
import 'package:kyc_workflow/workflow_response.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

/*
Title:AuthProvider
Purpose:To Manage Auth
Created On:
Edited On:
Author: 
*/

class AuthProvider extends ChangeNotifier {
  DigioProvider? digioProvider;
  late GlobalStateProvider globalStateProvider;

  static const int minZoom = 50;
  static const int maxZoom = 200;

  int _selectedIndex = 0;
  int _zoomValue = 100;
  bool _isPdfLoading = false;

  int get selectedIndex => _selectedIndex;
  int get zoomValue => _zoomValue;
  bool get isPdfLoading => _isPdfLoading;
  double get zoomScale => _zoomValue / 100;
  LoginType defaultLoginType = LoginType.values.firstWhere(
    (e) => e.value == '1',
  );

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  // PAN Info
  TextEditingController panNoController = TextEditingController();
  TextEditingController fNameAsPanController = TextEditingController();
  TextEditingController mNameAsPanController = TextEditingController();
  TextEditingController lNameAsPanController = TextEditingController();
  TextEditingController panDobController = TextEditingController();

  // PresentAddress info
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController addressLine3Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  // Personal info
  TextEditingController motherFirstNameController = TextEditingController();
  TextEditingController motherMiddleNameController = TextEditingController();
  TextEditingController motherLastNameController = TextEditingController();

  TextEditingController fatherOrSpouceFirstNameController =
      TextEditingController();
  TextEditingController fatherOrSpouceMiddleController =
      TextEditingController();
  TextEditingController fatherOrSpouceLastNameController =
      TextEditingController();

  TextEditingController gstNumberController = TextEditingController();
  TextEditingController birthCityController = TextEditingController();

  // Bank info
  final TextEditingController bankAccountNumberController =
      TextEditingController();
  final TextEditingController bankIFSCController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  final TextEditingController bankMICRCodeController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController branchAddress1Controller =
      TextEditingController();
  final TextEditingController branchAddress2Controller =
      TextEditingController();
  final TextEditingController branchAddress3Controller =
      TextEditingController();
  final TextEditingController branchAddress4Controller =
      TextEditingController();

  bool isNameEditable = false;
  bool isDobEditable = false;
  bool isNRIClient = false;
  bool isOnlyDemat = false;

  bool isAddressEditable = false;
  bool isCityEditable = false;
  bool isStateEditable = false;
  bool isPincodeEditable = false;
  bool isCountryEditable = false;
  bool _mobileHasError = false;
  bool get mobileHasError => _mobileHasError;
  bool _emailHasError = false;
  bool get emailHasError => _emailHasError;
  bool _isTermsAccepted = false;
  bool _termsHasError = false;
  bool get isTermsAccepted => _isTermsAccepted;
  bool get termsHasError => _termsHasError;
  String _mobileError = '';
  String get mobileError => _mobileError;

  String _emailError = '';
  String get emailError => _emailError;
  String _termsError = '';
  String get termsError => _termsError;

  ApiService apiService = ApiService.getInstance();

  bool isExistingDetailLoading = false;
  bool isStaticDataLoading = false;

  ExistingClientDetailsResponseModel? _existingClientResponse;
  ExistingClientDetailsResponseModel? get existingClientResponse =>
      _existingClientResponse;

  CheckMobileExistModel? _checkMobileExistResponse;
  CheckMobileExistModel? get checkMobileExistResponse =>
      _checkMobileExistResponse;

  List<PurpleRecordset> countryList = [];
  List<PurpleRecordset> stateList = [];
  List<PurpleRecordset> cityList = [];
  List<PurpleRecordset> pinCodeList = [];
  List<PurpleRecordset> occupationList = [];
  List<PurpleRecordset> incomeRangeList = [];
  List<PurpleRecordset> genderList = [];
  List<PurpleRecordset> maritalStatusList = [];
  List<PurpleRecordset> settlementCycleList = [];
  List<FluffyRecordset> marketSegmentList = [];
  List<FluffyRecordset> additionalDetailsList = [];
  List<PurpleRecordset> bankAccountTypeList = [];
  List<PurpleRecordset> nomineeRelationShipList = [];
  List<PurpleRecordset> nomineeDocumentTypeList = [];
  //FilteredGuardianRelationsList
  List<PurpleRecordset> filteredGuardianRelationsList = [];

  List<FluffyRecordset> emailMobileRelationshipsList = [];
  List<FluffyRecordset> filteredEmailMobileRelationshipsList = [];

  List<PurpleRecordset> filteredSearchCityList = [];

  //KRA Agency Details
  List<FluffyRecordset> kraConfigData = [];
  String kraAgencyCode = '';
  String kraAgencyFile = '';
  bool isInitialized = false;

  ReferralCodeModel? referralData;

  //
  bool isEmailOtpVerified = false;
  bool isMobileOtpVerified = false;
  String enteredEmailOtp = '';
  String enteredMobileOtp = '';
  // bool isEmailVerified = false;

  // bool isMobileVerified = false;

  int formNo = 0;
  bool isPanVerificationInProgress = false;

  int? ocrCorrAddressProof;
  int? ocrPerAddressProof;
  int? ocrIdentityProof;
  int? accountType;
  int? accountOption;
  //  int? accountSubCategory;
  late int accountSubCategory;
  int? getRelationshipId(dynamic id) => _parseId(id);
  FluffyRecordset? clientData;

  // Mobile
  int selectedMobileRelationshipId = -1;
  FluffyRecordset? selectedMobileRelationship;

  // Email
  int selectedEmailRelationshipId = -1;
  FluffyRecordset? selectedEmailRelationship;

  bool emailRelationshipError = false;
  bool mobileRelationshipError = false;

  final AuthRepository authRepository = AuthRepository();
  bool isInsertDataLoading = false;
  KRAAgencyFlagModel? kraFlag;
  KRAResultModel? kraResult;

  FetchKraAgencyDetailModels? kraAgencyDetails;
  FetchKraDetailsModels? kraDetails;

  PersonalInfoModel? personalInfoModel;

  final List<Map<String, dynamic>> arrDocuments = [];

  String selectedRelationType = RelationType.father.value;

  final ValueNotifier<bool> isOccupationSelectedNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isAnnualRangeSelectedNotifier = ValueNotifier(
    false,
  );
  final ValueNotifier<bool> isBirthCityNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isSelectGenderNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isSelectMaritalStatusNotifier = ValueNotifier(
    false,
  );
  final ValueNotifier<bool> isSelectMarketSegmentNotifier = ValueNotifier(
    false,
  );
  final ValueNotifier<bool> isBankAccountNotifier = ValueNotifier(false);
  final ValueNotifier<String> selectedPEPNotifier = ValueNotifier('0');
  final ValueNotifier<bool> isPEPSelectedNotifier = ValueNotifier(true);
  final ValueNotifier<bool> isSelectedSegmentNotifier = ValueNotifier(true);
  final ValueNotifier<String> selectedSettlementCycleNotifier = ValueNotifier(
    '1',
  );

  final ValueNotifier<bool> isVerifiedBankNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isConfirmNameAsperBankNotifier = ValueNotifier(
    true,
  );
  final ValueNotifier<bool> alwaysEnabledNotifier = ValueNotifier(true);
  final ValueNotifier<bool> isUploadChequeNotifier = ValueNotifier(true);
  final ValueNotifier<bool> isUploadSignatureNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isUploadSelfieNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isUploadIncomeProofNotifier = ValueNotifier(false);
  final ValueNotifier<bool> nomineeDetailNotifier = ValueNotifier(false);
  final ValueNotifier<bool> addNomineeNotifier = ValueNotifier(false);
  final ValueNotifier<bool> disAccountInfoPreviewNotifier = ValueNotifier(
    false,
  );

  PurpleRecordset? selectedOccupation;
  PurpleRecordset? selectedIncomeRange;
  PurpleRecordset? selectedBirthCity;
  PurpleRecordset? selectedGender;
  PurpleRecordset? selectedMaritalStatus;

  bool isGstRegistered = false;
  String? gstNumber;

  String? selectedBankAccountType;
  int? selectedBankAccountTypeId;
  //

  List<SegmentDataModel> segments = [];
  List<List<SegmentGroupModel>> groupedColumns = [];

  String? dob;
  bool brkConfirmed = false;
  List<String> selectedSegmentIds = [];

  Map<String, SegmentGroupModel> groupedSegments = {};
  final LayerLink customDropdownLayerLink = LayerLink();
  bool isCustomDropdownOpen = false;
  bool isBrokerageChecked = false;

  // Bank Details
  List<BankDetails> searchIFSCCodeList = [];
  // List<GetBankDetailsModel> searchIFSCCodeList = [];
  bool isLoadingSearchIFSCCode = false;
  bool isBankDetailsNotFound = false;
  bool isBankDetailsAutoFilled = false;
  bool isVerifyBtnVisible = true;
  bool isAutoDebitEnable = false;
  String bankDetailsValidationMessage = '';
  bool showBankValidationError = false;

  // BankAccount
  bool _bankAccountNumberHasError = false;
  bool get bankAccountNumberHasError => _bankAccountNumberHasError;
  String _bankAccountNumberError = '';
  String get bankAccountNumberError => _bankAccountNumberError;

  // Bank Account Type
  bool _accountTypeHasError = false;
  bool get accountTypeHasError => _accountTypeHasError;
  String _accountTypeError = '';
  String get accountTypeError => _accountTypeError;

  bool _micrCodeHasError = false;
  bool get micrCodeHasError => _micrCodeHasError;
  String _micrCodeError = '';
  String get micrCodeError => _micrCodeError;
  bool _bankNameHasError = false;
  bool get bankNameHasError => _bankNameHasError;
  String _bankNameError = '';
  String get bankNameError => _bankNameError;
  bool _ifscCodeHasError = false;
  bool get ifscCodeHasError => _ifscCodeHasError;
  String _ifscCodeError = '';
  String get ifscCodeError => _ifscCodeError;

  bool _branchNameHasError = false;
  String _branchNameError = '';

  bool get branchNameHasError => _branchNameHasError;
  String get branchNameError => _branchNameError;

  final FocusNode bankAccountNumberFocusNode = FocusNode();
  final FocusNode bankIFSCFocusNode = FocusNode();
  final FocusNode bankNameFocusNode = FocusNode();
  final FocusNode bankMICRCodeFocusNode = FocusNode();

  bool isDigioNavigationInProgress = false;
  bool _isNavigatingAfterOtp = false;
  bool get isNavigatingAfterOtp => _isNavigatingAfterOtp;

  bool _isExistingUser = false;
  bool get isExistingUser => _isExistingUser;

  List<Map<String, dynamic>> filteredNSDLClientTypes = [];
  List<dynamic> filteredNSDLClientSubTypes = [];
  int? subTypesForClientTypeId;

  Map<String, dynamic> registrationDetail = {};
  Map<String, dynamic> panDetails = {};
  Map<String, dynamic> aadharDetails = {};
  Map<String, dynamic> additionalDetails = {};

  Map<String, dynamic> referalDataDetails = {};
  Map<String, dynamic> guardianDetails = {};

  Map<String, dynamic> kRAAgency = {};
  Map<String, dynamic> kRAFlag = {};
  Map<String, dynamic> kRAResponse = {};

  Map<String, dynamic> personalDetails = {};
  Map<String, dynamic> otherAddressDetails = {};
  Map<String, dynamic> nriDetails = {};

  Map<String, dynamic> onlyTradingDetails = {};
  Map<String, dynamic> paymentDetails = {};
  Map<String, dynamic> otherDetails = {};
  Map<String, dynamic> bankDetails = {};

  // SecondHolder Details

  bool isSecondHolderProcessing = false;
  Map<String, dynamic>? secondHolderDetails;

  // ThirdHolder Details
  bool isThirdHolderProcessing = false;
  Map<String, dynamic>? thirdHolderDetails;

  String? step;
  List<dynamic> nsdlClientTypes = <dynamic>[];
  Map<String, dynamic>? selectedNsdlClientType;
  Map<String, dynamic>? selectedNsdlSubClientType;
  // Map<String, dynamic>? selectedResidentialStatus;
  int? selectedResidentialStatus;
  bool _bankFocusListenersRegistered = false;

  // Bank Flags
  String? finalNameAtBank;
  bool isBankOTPVerified = false;
  bool isMatch = false;
  bool isBankDetailsVerified = false;
  bool isShowManualBankEntry = false;
  bool tcAccepted = false;
  bool isEntryRejected = false;
  String? verifiedOTP;

  bool _micrHasError = false;
  String _micrError = '';

  bool get micrHasError => _micrHasError;
  String get micrError => _micrError;

  bool _branchAddress1HasError = false;
  String _branchAddress1Error = '';

  bool get branchAddress1HasError => _branchAddress1HasError;
  String get branchAddress1Error => _branchAddress1Error;

  bool _branchAddress2HasError = false;
  String _branchAddress2Error = '';

  bool get branchAddress2HasError => _branchAddress2HasError;
  String get branchAddress2Error => _branchAddress2Error;

  bool _branchAddress3HasError = false;
  String _branchAddress3Error = '';

  bool get branchAddress3HasError => _branchAddress3HasError;
  String get branchAddress3Error => _branchAddress3Error;

  bool _branchAddress4HasError = false;
  String _branchAddress4Error = '';

  bool get branchAddress4HasError => _branchAddress4HasError;
  String get branchAddress4Error => _branchAddress4Error;

  Map<String, dynamic>? pendingBankVerificationData;
  dynamic pendingBankVerificationStatusCode;

  // Upload Cheque
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? imageBase64;
  bool isImageResizingLoading = false;
  final appStorageHelper = AppStorageHelper.getInstance();
  String? previewImgUrl;
  bool isFileTouched = false;
  String? uploadChequeTitle;

  //Upload Signature
  String? uploadSignatureTitle;
  String? uploadSignatureSecondaryTitle;

  // Upload Selfie
  bool isPhotoCaptured = false;
  Timer? resendTimer;
  int remainingSeconds = 0;
  bool canResendSelfie = false;
  String? selfieReferenceId;
  Map<String, String> selfieDetails = {
    'rawBase64': '',
    'latitude': '',
    'longitude': '',
  };
  String? _fetchedSelfieBase64;

  String? get fetchedSelfieBase64 => _fetchedSelfieBase64;
  bool get hasFetchedSelfie =>
      _fetchedSelfieBase64 != null && _fetchedSelfieBase64!.isNotEmpty;

  String? selfieTitle;
  File? selectedFile;

  //Nominee Details
  bool isAddNomineeChecked = false;

  // incomeProof
  bool isIncomeProofLoading = true;
  bool isIncomeProofCompleted = false;
  WebViewController? incomeProofWebViewController;
  String? fetchedPdfRaw64;
  String? fetchedPdf;
  bool isFadeIn = false;
  bool isUIFrozen = false;
  File? selectedIncomeProofFile;
  String? incomeProofPdfFilePath;

  // Add Nominee
  bool isNomineeAddressSameAsCorrepondence = false;
  TextEditingController firstNomineeNameController = TextEditingController();
  TextEditingController firstNomineePANNumberController =
      TextEditingController();
  TextEditingController firstNomineeDobController = TextEditingController();

  TextEditingController firstNomineeMobileNumberController =
      TextEditingController();

  TextEditingController firstNomineeDocumentNumberController =
      TextEditingController();
  TextEditingController firstNomineeEmailController = TextEditingController();

  TextEditingController firstNomineeDocumentUploadController =
      TextEditingController();

  TextEditingController firstNomineeAddress1Controller =
      TextEditingController();
  TextEditingController firstNomineeAddress2Controller =
      TextEditingController();
  TextEditingController firstNomineeAddress3Controller =
      TextEditingController();

  String? selectedNomineeRelationship;
  bool _nomineeRelationshipHasError = false;
  String? _nomineeRelationshipError;

  bool get nomineeRelationshipHasError => _nomineeRelationshipHasError;
  String? get nomineeRelationshipError => _nomineeRelationshipError;

  PurpleRecordset? selectedCountryItem;
  PurpleRecordset? selectedStateItem;
  PurpleRecordset? selectedCityItem;
  PurpleRecordset? selectedPinCodeItem;

  String? get selectedCountry => selectedCountryItem?.name;
  String? get selectedState => selectedStateItem?.name;
  String? get selectedCity => selectedCityItem?.name;
  String? get selectedPincode => selectedPinCodeItem?.name;

  PurpleRecordset? selectedNomineeDocumentType;
  String? get selectedNomineeDocumentTypeName =>
      selectedNomineeDocumentType?.name;

  bool nomineeDocumentTypeHasError = false;
  String nomineeDocumentTypeError = '';

  bool nomineeDocumentNumberHasError = false;
  String? nomineeDocumentNumberError;

  // Master copies used only for cascading filtering
  List<PurpleRecordset> allStateListForFiltering = [];
  List<PurpleRecordset> allCityListForFiltering = [];
  List<PurpleRecordset> allPinCodeListForFiltering = [];

  List<dynamic> filteredGuardianRelations = [];
  bool isNomineeMinor = false;

  bool showNomineeValidationError = false;
  bool _nomineeNameHasError = false;
  String? _nomineeNameError;

  bool _nomineeDobHasError = false;
  String? _nomineeDobError;

  bool _nomineeAddress1HasError = false;
  String? _nomineeAddress1Error;

  bool _nomineeAddress2HasError = false;
  String? _nomineeAddress2Error;

  bool _nomineeAddress3HasError = false;
  String? _nomineeAddress3Error;

  bool _nomineeCountryHasError = false;
  String? _nomineeCountryError;

  bool _nomineeStateHasError = false;
  String? _nomineeStateError;

  bool _nomineeCityHasError = false;
  String? _nomineeCityError;

  bool _nomineePinCodeHasError = false;
  String? _nomineePinCodeError;

  bool _nomineeDocumentTypeHasError = false;
  String? _nomineeDocumentTypeError;

  bool _nomineeDocumentNumberHasError = false;
  String? _nomineeDocumentNumberError;

  bool _nomineeDocumentImageHasError = false;
  String? _nomineeDocumentImageError;

  bool _nomineeMobileHasError = false;
  String? _nomineeMobileError;

  bool _nomineeEmailHasError = false;
  String? _nomineeEmailError;

  bool get nomineeNameHasError => _nomineeNameHasError;
  String? get nomineeNameError => _nomineeNameError;

  bool get nomineeDobHasError => _nomineeDobHasError;
  String? get nomineeDobError => _nomineeDobError;

  bool get nomineeAddress1HasError => _nomineeAddress1HasError;
  String? get nomineeAddress1Error => _nomineeAddress1Error;

  bool get nomineeAddress2HasError => _nomineeAddress2HasError;
  String? get nomineeAddress2Error => _nomineeAddress2Error;

  bool get nomineeAddress3HasError => _nomineeAddress3HasError;
  String? get nomineeAddress3Error => _nomineeAddress3Error;

  bool get nomineeCountryHasError => _nomineeCountryHasError;
  String? get nomineeCountryError => _nomineeCountryError;

  bool get nomineeStateHasError => _nomineeStateHasError;
  String? get nomineeStateError => _nomineeStateError;

  bool get nomineeCityHasError => _nomineeCityHasError;
  String? get nomineeCityError => _nomineeCityError;

  bool get nomineePinCodeHasError => _nomineePinCodeHasError;
  String? get nomineePinCodeError => _nomineePinCodeError;

  bool get nomineeDocumentImageHasError => _nomineeDocumentImageHasError;
  String? get nomineeDocumentImageError => _nomineeDocumentImageError;

  bool get nomineeMobileHasError => _nomineeMobileHasError;
  String? get nomineeMobileError => _nomineeMobileError;

  bool get nomineeEmailHasError => _nomineeEmailHasError;
  String? get nomineeEmailError => _nomineeEmailError;

  String? nomineeProofPlaceholder = AppStrings.documentNumber;
  int nomineeProofMaxSize = 25;
  int nomineeImageMaxSize = 100;

  String? selectedGuardianRelationship;

  final Map<String, List<String>> nomineeToGuardianRelationMap = {
    // Children - need older family members
    '3': ['0', '1', '12', '13', '9', '8'], // SON

    '6': ['0', '1', '12', '13', '9', '8'], // DAUGHTER
    // Grandchildren - need older family members
    '10': ['0', '1', '12', '13', '9', '8'], // GRANDSON

    '11': ['0', '1', '12', '13', '9', '8'], // GRANDDAUGHTER
    // Parents - can have adult children or siblings
    '0': ['3', '6', '9', '8'], // FATHER

    '1': ['3', '6', '9', '8'], // MOTHER
    // Grandparents - can have children, grandchildren, or siblings
    '12': ['3', '6', '10', '11', '0', '1', '9', '8'], // GRANDFATHER

    '13': ['3', '6', '10', '11', '0', '1', '9', '8'], // GRANDMOTHER
    // Siblings
    '9': ['0', '1', '12', '13', '9', '8'], // BROTHER

    '8': ['0', '1', '12', '13', '9', '8'], // SISTER
    // Spouse
    '2': ['2', '0', '1', '3', '6', '12', '13', '9', '8'], // SPOUSE
    // Son-in-law
    '4': ['2', '15', '14', '0', '1', '12', '13', '9', '8'], // SON-IN-LAW
    // Daughter-in-law
    '5': ['2', '15', '14', '0', '1', '12', '13', '9', '8'], // DAUGHTER-IN-LAW
    // Father-in-law
    '15': ['3', '6', '10', '11', '4', '5', '2', '9', '8'], // FATHER-IN-LAW
    // Mother-in-law
    '14': ['3', '6', '10', '11', '4', '5', '2', '9', '8'], // MOTHER-IN-LAW
    // Brother-in-law
    '16': ['2', '0', '1', '12', '13', '16', '17', '9', '8'], // BROTHER-IN-LAW
    // Sister-in-law
    '17': ['2', '0', '1', '12', '13', '16', '17', '9', '8'], // SISTER-IN-LAW
    // Others
    // '99': ['99'],
  };

  String? resizedNomineeImage;
  // Guradian Details
  bool isGuardianAddressSameAsCorrepondence = false;
  final TextEditingController guardianNameController = TextEditingController();
  final TextEditingController guardianDobController = TextEditingController();
  final TextEditingController guardianRelationController =
      TextEditingController();
  final TextEditingController guardianAddress1Controller =
      TextEditingController();
  final TextEditingController guardianAddress2Controller =
      TextEditingController();
  final TextEditingController guardianAddress3Controller =
      TextEditingController();

  final TextEditingController guardianCountryController =
      TextEditingController();

  final TextEditingController guardianStateController = TextEditingController();
  final TextEditingController guardianCityController = TextEditingController();
  final TextEditingController guardianPinCodeController =
      TextEditingController();

  final TextEditingController guardianDocumentTypeController =
      TextEditingController();

  final TextEditingController guardianDocumentNumberController =
      TextEditingController();

  final TextEditingController guardianDocumentUploadController =
      TextEditingController();

  final TextEditingController guardianMobileNumberController =
      TextEditingController();

  final TextEditingController guardianEmailController = TextEditingController();

  PurpleRecordset? selectedGuardianDocumentType;
  String? get selectedGuardianDocumentTypeName =>
      selectedGuardianDocumentType?.name;

  // List<PurpleRecordset> guardianAllStateListForFiltering = [];
  // List<PurpleRecordset> guardianAllCityListForFiltering = [];
  // List<PurpleRecordset> guardianAllPinCodeListForFiltering = [];

  List<PurpleRecordset> guardianStateList = [];
  List<PurpleRecordset> guardianCityList = [];
  List<PurpleRecordset> guardianPinCodeList = [];

  PurpleRecordset? selectedGuardianCountryItem;
  PurpleRecordset? selectedGuardianStateItem;
  PurpleRecordset? selectedGuardianCityItem;
  PurpleRecordset? selectedGuardianPinCodeItem;

  String? get selectedGuardianCountry => selectedGuardianCountryItem?.name;
  String? get selectedGuardianState => selectedGuardianStateItem?.name;
  String? get selectedGuardianCity => selectedGuardianCityItem?.name;
  String? get selectedGuardianPincode => selectedGuardianPinCodeItem?.name;

  bool showGuardianValidationError = false;
  String pageTitle = '';

  // Guardian Name
  bool guardianNameHasError = false;
  String guardianNameError = '';

  // Guardian DOB
  bool guardianDobHasError = false;
  String guardianDobError = '';

  // Guardian Relationship
  bool guardianRelationshipHasError = false;
  String guardianRelationshipError = '';

  // Guardian Address 1
  bool guardianAddress1HasError = false;
  String guardianAddress1Error = '';

  // Guardian Address 2
  bool guardianAddress2HasError = false;
  String guardianAddress2Error = '';

  // Guardian Address 3
  bool guardianAddress3HasError = false;
  String guardianAddress3Error = '';

  // Guardian Country
  bool guardianCountryHasError = false;
  String guardianCountryError = '';

  // Guardian State
  bool guardianStateHasError = false;
  String guardianStateError = '';

  // Guardian City
  bool guardianCityHasError = false;
  String guardianCityError = '';

  // Guardian Pincode
  bool guardianPinCodeHasError = false;
  String guardianPinCodeError = '';

  // Guardian Document Type
  bool guardianDocumentTypeHasError = false;
  String guardianDocumentTypeError = '';

  // Guardian Document Number
  bool guardianDocumentNumberHasError = false;
  String guardianDocumentNumberError = '';

  // Guardian Document Image
  bool guardianDocumentImageHasError = false;
  String guardianDocumentImageError = '';

  // Guardian Mobile
  bool guardianMobileHasError = false;
  String guardianMobileError = '';

  // Guardian Email
  bool guardianEmailHasError = false;
  String guardianEmailError = '';
  bool isGuardianDocumentUploaded = false;
  String? guardianProofPlaceholder = AppStrings.documentNumber;
  int guardianProofMaxSize = 25;
  int guardianImageMaxSize = 100;

  File? nomineeDocumentFile;
  File? guardianDocumentFile;

  String selectedFileName = '';
  String selectedFileNameGU = '';
  String? selectedGuardianDocumentMimeType;
  String? selectedNomineeDocumentMimeType;
  int? editIndex;
  File? nomineeDocumentImage;
  File? guardianDocumentImage;

  String? nomineeDocumentImageBase64;
  String? guardianDocumentImageBase64;

  // To Check Mobile Exist Or not
  Future<bool> checkMobileExist() async {
    final userEnteredMobile = mobileController.text.trim();
    isExistingDetailLoading = true;
    AppHelperWidgets.showLoader();
    notifyListeners();

    try {
      final response = await authRepository.checkMobileExist(
        mobile: userEnteredMobile,
      );
      if (response == null || response.data == null) {
        _checkMobileExistResponse = null;
        return false;
      }

      final model = CheckMobileExistModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      _checkMobileExistResponse = model;
      final isExistingCustomer = model.success && model.exists;

      // LogHelper.infoLog('EXISTING CUSTOMER CHECK ::: $isExistingCustomer');
      if (isExistingCustomer) {
        await fetchExistingClientDetailsAPI();
      }
      return isExistingCustomer;
    } catch (e, s) {
      LogHelper.errorLog('checkMobileExist: $e');
      debugPrintStack(stackTrace: s);
      _checkMobileExistResponse = null;
      return false;
    } finally {
      AppHelperWidgets.hideLoader();
      isExistingDetailLoading = false;
      notifyListeners();
    }
  }

  // To FetchExistingClient
  Future<bool> fetchExistingClientDetailsAPI() async {
    final userEnteredMobile = mobileController.text.trim();
    isExistingDetailLoading = true;
    // AppHelperWidgets.showLoader();
    notifyListeners();

    try {
      final response = await authRepository.fetchExistingClientDetails(
        mobile: userEnteredMobile,
      );

      // LogHelper.infoLog('fetchExistingClientDetails: ${response?.data}');
      if (response?.data == null) {
        _isExistingUser = false;
        _existingClientResponse = null;
        return false;
      }

      final existingClientResponse =
          ExistingClientDetailsResponseModel.fromJson(
            response!.data as Map<String, dynamic>,
          );

      final recordsets = existingClientResponse.data?.recordsets;
      final isUserExist =
          existingClientResponse.success == true &&
          recordsets != null &&
          recordsets.isNotEmpty &&
          recordsets.first.isNotEmpty;

      // ❌ If no records → new user
      if (recordsets == null ||
          recordsets.isEmpty ||
          recordsets.first.isEmpty) {
        _isExistingUser = false;
        _existingClientResponse = existingClientResponse;
        return false;
      }

      final messageRecordSetLength = recordsets != null && recordsets.isNotEmpty
          ? recordsets.last.length
          : 0;
      _isExistingUser = isUserExist;
      _existingClientResponse = existingClientResponse;
      final segments = existingClientResponse.data?.recordsets[1] ?? [];

      if (isUserExist) {
        await parseExistingUserData();
      }

      // LogHelper.infoLog('IsUserExist: $isUserExist');
      // LogHelper.infoLog('MessageRecordSets: $messageRecordSetLength');
      return isUserExist;
    } catch (e, s) {
      LogHelper.errorLog('fetchExistingClientDetails: $e');
      debugPrint(s.toString());
      _isExistingUser = false;
      _existingClientResponse = null;
      return false;
    } finally {
      AppHelperWidgets.hideLoader();
      isExistingDetailLoading = false;
      notifyListeners();
    }
  }

  //parseExistingUserData
  // Earlier void
  Future<void> parseExistingUserData() async {
    // LogHelper.infoLog('Parsing existing user data...');
    final recordsets = _existingClientResponse?.data?.recordsets;
    if (recordsets!.isEmpty || recordsets.first.isEmpty) {
      return;
    }

    final List<ExistingClientRecordModel> mainRecords =
        List<ExistingClientRecordModel>.from(recordsets.first);

    final mainData = mainRecords.first;
    final nominees = mapDbToStateNominees(mainData);

    final List<ExistingClientRecordModel> documents = recordsets.length > 3
        ? List<ExistingClientRecordModel>.from(recordsets[3])
        : <ExistingClientRecordModel>[];

    final List<ExistingClientRecordModel> segmentDetails = recordsets.length > 1
        ? List<ExistingClientRecordModel>.from(recordsets[1])
        : <ExistingClientRecordModel>[];

    final List<String> selectedSegmentIds = segmentDetails
        .map((seg) => seg.ocrBusinessId?.toString())
        .whereType<String>()
        .toList();

    final hasSLBM = segmentDetails.any((seg) => seg.ocrSLBMCode != null);

    if (hasSLBM) {
      selectedSegmentIds.add('SLBM');
    }

    final arrBrokerageDetails = segmentDetails.map((seg) {
      return {
        'BusinessType': seg.ocrBusinessId,
        'JobType': seg.ocrJobtype,
        'JobCode': seg.ocrJobCode,
        'JobTypeDescription': seg.jobType,
        'JobDescription': seg.jobDescription,

        // Delivery
        'DeliveryType': seg.ocrDeltype,
        'DeliveryCode': seg.ocrDelCode,
        'DeliveryTypeDescription': seg.deltype,
        'DeliveryDescription': seg.delDescription,
        'OptType': seg.ocrOptType,
        'OptCode': seg.ocrOptCode,
        'OptTypeDescription': seg.optType,
        'OptDescription': seg.optDescription,
        'FutType': seg.ocrFutType,
        'FutCode': seg.ocrFutCode,
        'FutTypeDescription': seg.futType,
        'FutDescription': seg.futDescription,
        'ExeType': seg.ocrExeType,
        'ExeCode': seg.ocrExeCode,
        'ExeTypeDescription': seg.exeType,
        'ExeDescription': seg.exeDescription,
        'OneSideBrk': seg.ocrOneSideBrk,
        'OneSideBrkCode': seg.ocrOneSidecode,
        'RoundFlag': seg.ocrRoundFlag,
        'SBLMType': seg.ocrSLBMType,
        'SLBMCode': seg.ocrSLBMCode,
        'SLBMTypeDescription': seg.slbmType,
        'SLBMDescription': seg.slbmDescription,
      };
    }).toList();

    final documentMap = extractDocuments(documents);
    final firstHolderDocs = documentMap['firstHolder'];
    // LogHelper.infoLog('PARSE EXISTING FIRSTHOLDER DOCS ---> $firstHolderDocs');

    final secondHolderDocs = documentMap['secondHolder'];
    // LogHelper.infoLog('→→ secondHolderDocs ---> $secondHolderDocs');

    final thirdHolderDocs = documentMap['thirdHolder'];
    // LogHelper.infoLog('→→ thirdHolderDocs ---> $thirdHolderDocs');

    final List<ExistingClientRecordModel> promoterRecords =
        recordsets.length > 2
        ? List<ExistingClientRecordModel>.from(recordsets[2])
        : <ExistingClientRecordModel>[];

    final promoterDetails = promoterRecords.map((item) {
      return {
        ...item.toJson(),
        'ProDateOfBirth': item.proDateOfBirth != null
            ? DateFormat('dd-MM-yyyy').parse(item.proDateOfBirth!)
            : null,
        'ProCountry': item.proCountryId?.toString(),
        'ProState': item.proStateId?.toString(),
        'ProCity': item.proCityId?.toString(),
        'ProPincode': item.proPinCodeId?.toString(),
        'ProGender': item.proGenderId?.toString(),
        'proRelationWithApplicant': item.proRelationWithApplicantId?.toString(),
        'proRelationWithMemOrCops': item.proRelationWithMemOrCopId?.toString(),
      };
    }).toList();

    // LogHelper.infoLog('PROMOTER DETAILS: $promoterDetails');

    registrationDetail = {
      'loginType': mainData.ocrAccountCategory,
      'accountType': mainData.ocrAccountType,
      'accountOption': mainData.ocrAccountOption,
      'accountSubCategory': mainData.ocrAccountSubCategory,
      'mobile': mainData.ocrMobileNo ?? '',
      'email': mainData.ocrEmailId ?? '',
      'referalCode': mainData.ocrReferralCode,
      'emailRelation': mainData.ocrFamilyRelationshipForEmail,
      'mobileRelation': mainData.ocrFamilyRelationshipForMobile,
      'isemailVerified': mainData.ocrEmailOTPFlag,
      'ismobileVerified': mainData.ocrMobileOTPFlag,
      'emailOTP': mainData.ocrEmailOTP,
      'mobileOTP': mainData.ocrMobileOTP,
    };

    // LogHelper.infoLog('LINE 767:: $registrationDetail');

    panDetails = {
      'panNumber': mainData.ocrPanNo,
      'firstName': mainData.ocrFirstName,
      'middleName': mainData.ocrMiddleName,
      'lastName': mainData.ocrLastName,
      'dob': mainData.ocrDateOfBirth,
      'panImage': firstHolderDocs?['panImage'],
      'panPDF': firstHolderDocs?['panPDF'],
      'panImageOther': {
        'panImage': mainData.isDigiLockerEntry != 1
            ? convertBufferToBase64(firstHolderDocs?['panImage']?['data'])
            : '',
        'panImageType': mainData.isDigiLockerEntry != 1
            ? firstHolderDocs?['panImage']?['mime']
            : '',
      },
      'fullName': mainData.ocrFullName,
    };

    // LogHelper.infoLog('PAN DETAILS: $panDetails');
    aadharDetails = {
      'aadhar_dob': mainData.isDigiLockerEntry == 1
          ? mainData.ocrDateOfBirth
          : '',
      'id_number': mainData.isDigiLockerEntry == 1
          ? mainData.ocrIdentityNo
          : '',
      'document_type': mainData.isDigiLockerEntry == 1 ? 'aadhar' : '',
      'gender': mainData.isDigiLockerEntry == 1 ? mainData.ocrGender : '',
      'nameAsPerAadhar': mainData.isDigiLockerEntry == 1
          ? mainData.ocrFullName
          : '',

      'currentAddress': {
        'address1': mainData.isDigiLockerEntry == 1
            ? mainData.ocrCorrAddress1
            : '',
        'address2': mainData.isDigiLockerEntry == 1
            ? mainData.ocrCorrAddress2
            : '',
        'address3': mainData.isDigiLockerEntry == 1
            ? mainData.ocrCorrAddress3
            : '',
        'country': mainData.isDigiLockerEntry == 1
            ? mainData.ocrCorrCountry
            : null,
        'state': mainData.isDigiLockerEntry == 1 ? mainData.ocrCorrState : null,
        'city': mainData.isDigiLockerEntry == 1 ? mainData.ocrCorrCity : null,
        'pincode': mainData.isDigiLockerEntry == 1
            ? mainData.ocrCorrPinCode
            : null,
      },

      'permanentAddress': {
        'address1': mainData.isDigiLockerEntry == 1
            ? mainData.ocrPerAddress1
            : '',
        'address2': mainData.isDigiLockerEntry == 1
            ? mainData.ocrPerAddress2
            : '',
        'address3': mainData.isDigiLockerEntry == 1
            ? mainData.ocrPerAddress3
            : '',
        'country': mainData.isDigiLockerEntry == 1 ? mainData.ocrPerCountry : 1,
        'state': mainData.isDigiLockerEntry == 1 ? mainData.ocrPerState : null,
        'city': mainData.isDigiLockerEntry == 1 ? mainData.ocrPerCity : null,
        'pincode': mainData.isDigiLockerEntry == 1
            ? mainData.ocrPerPinCode
            : null,
      },

      'aadharPDF': firstHolderDocs?['aadharPDF'],
      'aadharXML': firstHolderDocs?['digiLockerXML'],
    };

    // LogHelper.infoLog('AADHAR DETAILS: $aadharDetails');
    // OtherAddressDetails
    otherAddressDetails = {
      'stdNo': mainData.ocrStdNo,
      'phone': mainData.ocrPhone,
      'currentAddress': {
        'address1': mainData.ocrCorrAddress1,
        'address2': mainData.ocrCorrAddress2,
        'address3': mainData.ocrCorrAddress3,
        'country': mainData.ocrCorrCountry,
        'state': mainData.ocrCorrState,
        'city': mainData.ocrCorrCity,
        'pincode': mainData.ocrCorrPinCode,
      },

      'permanentAddress': {
        'address1': mainData.ocrPerAddress1,
        'address2': mainData.ocrPerAddress2,
        'address3': mainData.ocrPerAddress3,
        'country': mainData.ocrPerCountry,
        'state': mainData.ocrPerState,
        'city': mainData.ocrPerCity,
        'pincode': mainData.ocrPerPinCode,
      },

      'corrDocumentType': mainData.ocrCorrAddressProof?.toString(),
      'corrDocumentNumber': mainData.ocrCorrAddressProofNo,
      'corrDocumentExpiryDate': mainData.ocrCorrAddressProofExpiryDate,
      'corrDocumentImage': convertBufferToBase64(
        firstHolderDocs?['addressImage']?['data'],
      ),
      'corrDocumentImageType': firstHolderDocs?['addressImage']?['mime'],
      'corrDocument1Image': convertBufferToBase64(
        firstHolderDocs?['addressProof1']?['data'],
      ),
      'corrDocument1ImageType': firstHolderDocs?['addressProof1']?['mime'],
      'perDocumentType': mainData.ocrPerAddressProof?.toString(),
      'perDocumentNumber': mainData.ocrPerAddressProofNo,
      'perDocumentExpiryDate': mainData.ocrPerAddressProofExpiryDate,
      'identityProofType': mainData.ocrIdentityProof?.toString(),
      'identityProofNumber': mainData.ocrIdentityNo,
      'identityProofExpiryDate': mainData.ocrIdentityExpiryDate,
      'identityProofImage': convertBufferToBase64(
        firstHolderDocs?['identityProofImage']?['data'],
      ),
      'identityProofImageType': firstHolderDocs?['identityProofImage']?['mime'],
      'identityProof1Image': convertBufferToBase64(
        firstHolderDocs?['identityProof1Image']?['data'],
      ),
      'identityProof1ImageType':
          firstHolderDocs?['identityProof1Image']?['mime'],
    };

    // LogHelper.infoLog('OTHER ADDRESS DETAILS: $otherAddressDetails');

    //nriDetails
    nriDetails = {
      'nriType': mainData.ocrNRIType,
      'nationality': mainData.ocrNationality,
      'rbiRefNo': mainData.ocrRbiRefNumber,
      'rbiApprovalDate': mainData.ocrRbiApprovaleDate,
      'nriPISNo': mainData.ocrNriPisNo,
      'taxApplicableOutsideIndia': mainData.ocrTaxApplicableOutside,
      'taxPayableAddressFlag': mainData.ocrTaxPayableAddressFlag,
      'taxIdentificationNumber': mainData.ocrTaxIdentificationNumber,
      'taxEligibleCountry': mainData.ocrTaxEligibleCountry,
      'FATCACountryCitizenship': mainData.ocrFATCACountryCitizenship,
      'FATCACountryResidency': mainData.ocrFATCACountryResidency,
      'FATCATaxExemptFlag': mainData.ocrFATCATaxExemptFlag,
      'FATCATaxExemptReason': mainData.ocrFATCATaxExemptReason,
      'step': mainData.ocrPISType == null
          ? 1
          : (mainData.ocrTaxApplicableOutside == '1' ? 2 : 1),
      'pisType': mainData.ocrPISType,
    };

    final additionalStep = await identifyAdditionalDetailsStep(
      mainData,
      AppStrings.firstHolder,
    );

    additionalDetails = {
      'selectedGender': {'id': mainData.ocrGender, 'name': mainData.gender},
      'selectedCity': {'id': mainData.ocrCityBirth, 'name': mainData.cityBirth},
      'selectedIncome': {
        'id': mainData.ocrAnnualIncome,
        'name': mainData.annualIncome,
      },
      'selectedMaritalStatus': {
        'id': mainData.ocrMaritalStatus,
        'name': mainData.maritalStatus,
      },
      'selectedOccupation': {
        'id': mainData.ocrOccupation,
        'name': mainData.occupation,
      },
      'selectedCountry': {
        'id': mainData.ocrCountryBirth,
        'name': mainData.countryBirth,
      },
      'gstNo': mainData.ocrGstNumber,
      'placeOfDeclaration': mainData.ocrPlaceOfDeclaration,
      'noOfDocuments': mainData.ocrNumberOfDocument,
      'PEP': mainData.ocrPEP == true ? 1 : 0,
      'SettlementCycle': mainData.ocrSettlementCycle,
      'selectedNsdlClientType': {
        'id': mainData.ocrNSDLClientType,
        'name': mainData.nsdlClientType,
      },
      'selectedNsdlSubClientType': {
        'id': mainData.ocrNSDLClientSubType,
        'name': mainData.nsdlClientSubType,
      },
      'step': additionalStep.name,
    };

    // LogHelper.infoLog('ADDITIONAL DETAILS :::$additionalDetails ::');

    final braBranchCat = recordsets[recordsets.length - 2].isNotEmpty
        ? recordsets[recordsets.length - 2][0].braBranchCat
        : null;

    final braType = recordsets[recordsets.length - 2].isNotEmpty
        ? recordsets[recordsets.length - 2][0].bratype
        : null;

    // LogHelper.infoLog('HHHHHHHH :::: braBranchCat: $braBranchCat, braType: $braType');

    final verifyOption = mainData.ocrBankModeOfOperation == 'UPI'
        ? 0
        : mainData.ocrBankModeOfOperation == 'MANUAL'
        ? 2
        : 1;

    final isBankVerified = verifyOption == 0
        ? (mainData.ocrUPIVerifiedStatus == true)
        : (mainData.ocrBankAccountNo != null &&
              (mainData.ocrBankAccountNo?.toString().isNotEmpty ?? false) &&
              (mainData.ocrBankIFSCCode?.toString().isNotEmpty ?? false) &&
              (mainData.ocrBankName?.toString().isNotEmpty ?? false));

    // LogHelper.infoLog('VERIFY OPTIONS::: $verifyOption');
    // LogHelper.infoLog('BANK VERIFIED STATUS:: $isBankVerified');

    referalDataDetails = {
      'Branch': mainData.ocrBranch,
      'EasyPartnerId': mainData.ocrEasyPartnerId,
      'EmployeeCode': mainData.ocrEmployeeId,
      'Group': mainData.ocrGroup,
      'TradingCode': mainData.ocrTradingCode,
      'UserType': mainData.ocrUserType,
      'referalCode': mainData.ocrReferralCode,
      'userId': mainData.ocrEmployee,
      'Signature': convertBufferToBase64(mainData.userSign),
      'braBranchCat': braBranchCat,
      'bratype': braType,
      'branchEmail': mainData.branchEmail,
      'BranchName': mainData.branch,
      'RemisarName': mainData.group,
      'EasyPartnerName': mainData.easyPartner,
      'EmployeeName': mainData.employeeName,
    };

    // LogHelper.infoLog('referalDataDetails: $referalDataDetails');

    kRAAgency = {
      'agencyCode': mainData.ocrKRAAgency,
      'KRAAgencyFile': mainData.ocrKRAAgencyDocument,
      'KRAFile': mainData.ocrKRADocument,
    };

    kRAFlag = {'holder': AppStrings.firstHolder, 'flag': mainData.ocrKRAMode};

    kRAResponse = {
      'KRAFile': mainData.ocrKRADocument,
      'KRANo': mainData.ocrKRANo,
      'KRADate': mainData.ocrKRADate,
      'KRAName': mainData.ocrKRAName,
    };
    personalDetails = {
      ...?personalDetails,

      'bankDetails': {
        'BankId': mainData.ocrBankId,
        'BankIFSCCode': mainData.ocrBankIFSCCode,
        'BankMICR': mainData.ocrBankMICR,
        'BankType': mainData.ocrBankType,
        'BankAccountNo': mainData.ocrBankAccountNo,
        'BankName': mainData.ocrBankName,
        'BankBranchName': mainData.ocrBankBranchName,
        'NameAsperBank': mainData.ocrNameAsperBank,
        'BankUTRNo': mainData.ocrBankUTRNo,

        'BankAddress1': mainData.ocrBankAddress1,
        'BankAddress2': mainData.ocrBankAddress2,
        'BankAddress3': mainData.ocrBankAddress3,
        'BankAddress4': mainData.ocrBankAddress4,

        'BankCountry': mainData.ocrBankCountry,
        'BankState': mainData.ocrBankState,
        'BankCity': mainData.ocrBankCity,
        'BankPinCode': mainData.ocrBankPinCode,

        'UPIID': mainData.ocrUPIID,
        'UPIHolderName': mainData.ocrUPIHolderName,
        'BankOTP': mainData.ocrBankOTP,
        'UPIVerifiedStatus': mainData.ocrUPIVerifiedStatus,
        'AutoDebitFlag': mainData.ocrAutoDebitFlag,
        'verifyOption': verifyOption,
        'isOTPVerified': isBankVerified,

        // 'verifyOption': mainData.ocrBankModeOfOperation == 'UPI'
        //     ? 0
        //     : mainData.ocrBankModeOfOperation == 'MANUAL'
        //     ? 2
        //     : 1,

        // 'isOTPVerified': mainData.ocrUPIVerifiedStatus,
      },

      'FamilyDetails': {
        'relationFlag': mainData.ocrFatherHusbandFlag,
        'fatherFirstName': mainData.ocrFathersFirstName,
        'fatherMiddleName': mainData.ocrFathersMiddleName,
        'fatherLastName': mainData.ocrFathersLastName,
        'motherFirstName': mainData.ocrMothersFirstName,
        'motherMiddleName': mainData.ocrMothersMiddleName,
        'motherLastName': mainData.ocrMothersLastName,
      },

      'signatureFileString': convertBufferToBase64(
        firstHolderDocs?['sign']?['data'],
      ),
      'selfieDetails': {
        'selfieFile': firstHolderDocs?['selfie'],
        'DigioSelfieLatitude': mainData.ocrDigioSelfieLatitude,
        'DigioSelfieLongitude': mainData.ocrDigioSelfieLongitude,
        'DigioDocId': mainData.ocrDigioSelfieRefId,
      },
      'chequeFileString': convertBufferToBase64(
        firstHolderDocs?['cheque']?['data'],
      ),
      'IPVFileString': convertBufferToBase64(firstHolderDocs?['IPV']?['data']),
    };

    // LogHelper.infoLog('PERSONAL DETAILS:: $personalDetails');

    onlyTradingDetails = {
      'depository': mainData?.ocrDepository,
      'DPID': mainData?.ocrDPID,
      'DPName': mainData?.ocrDPName,
      'ClientID': mainData?.ocrClientID,
      'DematAccProofSubmitted': mainData?.ocrDematAccProofSubmitted,
    };

    // LogHelper.infoLog('ONLY TRADING DETAILS: $onlyTradingDetails');

    guardianDetails = {
      'guardianPrefix': mainData.ocrGuardianPrefix,
      'guardianFirstName': mainData.ocrGuardianFirstName,
      'guardianMiddleName': mainData.ocrGuardianMiddleName,
      'guardianLastName': mainData.ocrGuardianLastName,
      'guardianRelation': mainData.ocrGuardianRelation,
      'guardianGender': mainData.ocrGuardianGender,
      'guardianDob': mainData.ocrGuardianDateOfBirth,
      'panNumber': mainData.ocrGuardianPan,
      'fatherSpouseFlag': mainData.ocrGuardianFatherHusbandFlag,
      'fatherSpouseFirstName': mainData.ocrGuardianFatherFirstName,
      'fatherSpouseMiddleName': mainData.ocrGuardianFatherMiddleName,
      'fatherSpouseLastName': mainData.ocrGuardianFatherLastName,
      'motherFirstName': mainData.ocrGuardianMotherFirstName,
      'motherMiddleName': mainData.ocrGuardianMotherMiddleName,
      'motherLastName': mainData.ocrGuardianMotherLastName,
      'guardianMobile': mainData.ocrGuardianMobile,
      'guardianEmail': mainData.ocrGuardianEmail,
      'addressSameAsCorr': '0',
      'guardianAddress1': mainData.ocrGuardianAddress1,
      'guardianAddress2': mainData.ocrGuardianAddress2,
      'guardianAddress3': mainData.ocrGuardianAddress3,
      'guardianCountry': mainData.ocrGuardianCountry,
      'guardianState': mainData.ocrGuardianState,
      'guardianCity': mainData.ocrGuardianCity,
      'guardianPincode': mainData.ocrGuardianPinCode,
      'guardianDocumentType': mainData.ocrGuardianIdentityProof,
      'guardianDocumentNumber': mainData.ocrGuardianIdentityNo,
      'guardianDocumentExpiry': mainData.ocrGuardianIdentityExpiryDate,
      'guardianDocument': {
        'guardianDocumentImage': convertBufferToBase64(
          firstHolderDocs?['guardianIdentityProof']?.data,
        ),
        'guardianDocumentMimeType':
            firstHolderDocs?['guardianIdentityProof']?.mime,
      },
      'guardianDocument1': {
        'guardianDocumentImage1': convertBufferToBase64(
          firstHolderDocs?['guardianIdentityProof1']?.data,
        ),
        'guardianDocumentMimeType1':
            firstHolderDocs?['guardianIdentityProof1']?.mime,
      },
    };

    // LogHelper.infoLog('GUARDIAN DETAILS: $guardianDetails');
    otherDetails = {
      'netWorth': mainData.ocrNetworth,
      'netWorthDate': mainData.ocrNetworthDate,
      'incorporationDate': mainData.ocrInCorporationDate,
      'incorporationPlace': mainData.ocrInCorporationPlace,
      'commencementDate': mainData.ocrCommencementDate,
      'CINNo': mainData.ocrCinNumber,
    };

    // LogHelper.infoLog('OTHER DETAILS: $otherDetails');

    // additionalDocuments
    final additionalDocuments = (recordsets[4] ?? [])
        .where((x) => (x?.agDocType ?? 0) != 40)
        .map((i) {
          final imageBase64 = convertBufferToBase64(i?.agImage);

          return {
            ...?i?.toJson(),
            'agImage': imageBase64,
            'agImageShow': imageBase64 != null && i?.agImageType != null
                ? 'data:${i!.agImageType};base64,$imageBase64'
                : null,
          };
        })
        .toList();

    // SecondHolder Details
    // ThirdHolder Details

    globalStateProvider.setState({
      'RegistrationDetail': registrationDetail,
      'panDetails': panDetails,
      'aadharDetails': aadharDetails,
      'otherAddressDetails': otherAddressDetails,
      'additionalDetails': additionalDetails,
      'referalData': referalDataDetails,
      'KRAAgency': kRAAgency,
      'KRAFlag': kRAFlag,
      'KRAResponse': kRAResponse,
      'personalDetails': personalDetails,
      'nriDetails': nriDetails,
      'onlyTradingDetails': onlyTradingDetails,
      'guardianDetails': guardianDetails,
      'otherDetails': otherDetails,
      'incomeProofPdf': firstHolderDocs?['incomeProof'],
      'nominees': nominees,
      'selectedSegmentIds': selectedSegmentIds,
      'arrBrokerageDetails': arrBrokerageDetails,
      'promoterCoparcenerMemberDetails': promoterDetails,
      'additionalDocuments': additionalDocuments,
      'documents': documents,
      'segmentDetails': segmentDetails,
      'mainData': mainData,
      'formNumber': mainData.ocrFormNo,
      'stage': mainData.ocrstage,
      'isNRIClient': mainData.nriAcc,
      'brkConfirmed': mainData.ocrIsBrkConfirm,
      'tcAccepted': mainData.ocrNomOptOutFlag ?? false,
      'selectedPlanId': mainData.ocrPlanId,
      'ddpiFlag': mainData.ocrDDPIFlag,
      'eSignKYCisCompleted': mainData.ocrIsDigitallySigned,
      'eSignDDPIisProcess': mainData.ocrIsDDPISigned,
      'paymentRecieptId': mainData.ocrRecId,
      'DDPIRecId': mainData.ocrDDPIRecId,
      'isPaymentSuccess':
          mainData.ocrRecId != null || mainData.ocrDDPIRecId != null,
      'isEntryRejected': mainData.ocrRejectionFlag,
      'disIssurance': mainData.ocrDISIssuance,
      // 'isSecondHolderProcessing': isSecondHolderProcessing,
      // 'secondHolderDetails': secondHolderDetails,
      // 'isThirdHolderProcessing': isThirdHolderProcessing,
      // 'thirdHolderDetails': thirdHolderDetails,
      'tradingCode': mainData.ocrTradingCode,
      'DDPIDocumentID': mainData.ocrDDPIDocumentID,
      'DDPISignMode': mainData.ocrDDPISignMode,
      'ddpiIssueType': mainData.ocrDDPIIssueType,
      'lastStageUpdated': mainData.ocrStageDateTime,
    });
  }

  void initBankValidation() {
    if (_bankFocusListenersRegistered) return;
    _bankFocusListenersRegistered = true;
    registerBankFieldFocusListeners();
  }

  void registerBankFieldFocusListeners() {
    _addFocusListener(bankAccountNumberFocusNode, validateBankAccountNumber);
    _addFocusListener(bankIFSCFocusNode, validateIFSC);
    _addFocusListener(bankNameFocusNode, validateBankName);
  }

  void validateMICR() {
    final value = bankMICRCodeController.text.trim();
    if (value.isEmpty) {
      setMICRCodeError(hasError: true, errorMessage: AppStrings.enterMICRCode);
      return;
    }

    if (!AppConstants.micrRegex.hasMatch(value)) {
      setMICRCodeError(
        hasError: true,
        errorMessage: AppStrings.micrMustof9Digits,
      );
      return;
    }

    setMICRCodeError(hasError: false, errorMessage: '');
  }

  void validateBankName() {
    final value = bankNameController.text.trim();

    if (value.isEmpty) {
      setBankNameError(hasError: true, errorMessage: AppStrings.enterBankName);
      return;
    }

    if (value.length < 3) {
      setBankNameError(hasError: true, errorMessage: AppStrings.minimumOf3Char);
      return;
    }

    if (value.length > 50) {
      setBankNameError(
        hasError: true,
        errorMessage: AppStrings.maximum50Characters,
      );
      return;
    }

    setBankNameError(hasError: false, errorMessage: '');
  }

  void validateIFSC() {
    final value = bankIFSCController.text.trim().toUpperCase();
    if (value.isEmpty) {
      setIFSCCodeError(hasError: true, errorMessage: AppStrings.enterifsc);
      return;
    }

    if (!AppConstants.ifscRegex.hasMatch(value)) {
      setIFSCCodeError(hasError: true, errorMessage: AppStrings.invalidIFSC);
      return;
    }

    setIFSCCodeError(hasError: false, errorMessage: '');
  }

  void _addFocusListener(FocusNode focusNode, VoidCallback validation) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        validation();
      }
    });
  }

  PurpleRecordset? toRecord(dynamic value) {
    if (value == null) return null;

    if (value is PurpleRecordset) {
      return value;
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return PurpleRecordset(id: map['id'], name: map['name']);
    }

    return null;
  }

  // restoreAdditionalDetails
  Future<void> restoreAdditionalDetails(
    GlobalStateProvider globalStateProvider,
  ) async {
    final additionalDetails =
        globalStateProvider.get<Map<String, dynamic>>('additionalDetails') ??
        {};

    // Step
    step = additionalDetails['step'] ?? step;
    final occupation = getRecord(additionalDetails['selectedOccupation']);
    if (occupation != null) {
      selectOccupation(occupation);
    }

    final income = getRecord(additionalDetails['selectedIncome']);
    if (income != null) {
      selectIncomeRange(income);
    }

    final city = getRecord(additionalDetails['selectedCity']);
    if (city != null) {
      selectBirthCity(city);
    }

    final gender = getRecord(additionalDetails['selectedGender']);
    if (gender != null) {
      selectGender(gender);
    }

    final maritalStatus = getRecord(additionalDetails['selectedMaritalStatus']);
    if (maritalStatus != null) {
      selectMaritalStatus(maritalStatus);
    }

    // Controllers
    final country = additionalDetails['selectedCountry'];
    if (country is Map) {
      countryController.text = country['name']?.toString() ?? '';
    } else {
      countryController.text = country?.toString() ?? '';
    }

    birthCityController.text = selectedBirthCity?.name ?? '';
    gstNumberController.text = additionalDetails['gstNo']?.toString() ?? '';

    // Residential Status
    if (additionalDetails['selectedResidentialStatus'] is Map) {
      selectedResidentialStatus =
          additionalDetails['selectedResidentialStatus']['id'] as int?;
    } else {
      selectedResidentialStatus =
          additionalDetails['selectedResidentialStatus'] as int? ?? 2;
    }

    // PEP
    selectedPEPNotifier.value = (additionalDetails['PEP'] ?? 0).toString();

    // Settlement Cycle
    selectedSettlementCycleNotifier.value =
        (additionalDetails['SettlementCycle'] ?? 1).toString();

    // NSDL
    selectedNsdlClientType = additionalDetails['selectedNsdlClientType'];
    selectedNsdlSubClientType = additionalDetails['selectedNsdlSubClientType'];

    if (selectedNsdlClientType?['id'] != null) {
      await getNSDLClientSubTypes(selectedNsdlClientType!['id'].toString());
    }

    notifyListeners();
  }

  //restorePersonalDetails
  Future<void> restorePersonalDetails(
    GlobalStateProvider globalStateProvider,
  ) async {
    final personal =
        globalStateProvider.get<Map<String, dynamic>>('personalDetails') ?? {};
    final family = personal['FamilyDetails'] as Map<String, dynamic>? ?? {};
    selectedRelationType =
        family['relationFlag']?.toString() ?? RelationType.father.value;
    fatherOrSpouceFirstNameController.text =
        family['fatherFirstName']?.toString() ?? '';
    fatherOrSpouceMiddleController.text =
        family['fatherMiddleName']?.toString() ?? '';
    fatherOrSpouceLastNameController.text =
        family['fatherLastName']?.toString() ?? '';
    motherFirstNameController.text =
        family['motherFirstName']?.toString() ?? '';
    motherMiddleNameController.text =
        family['motherMiddleName']?.toString() ?? '';
    motherLastNameController.text = family['motherLastName']?.toString() ?? '';
    notifyListeners();
  }

  PurpleRecordset? getRecord(dynamic value) {
    if (value == null) return null;

    if (value is PurpleRecordset) {
      return value;
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);

      final id = map['id'];
      final name = map['name'];

      if (id == null || name == null) {
        return null;
      }

      return PurpleRecordset(
        id: int.tryParse(id.toString()) ?? 0,
        name: name.toString(),
        cvlValue: map['CVLValue']?.toString(),
        internationalDialingCode: map['InternationalDialingCode']?.toString(),
        countryId: map['countryId']?.toString(),
        stateId: map['stateId']?.toString(),
        cityId: map['cityId']?.toString(),
      );
    }

    return null;
  }

  List<Map<String, dynamic>> mapDbToStateNominees(
    ExistingClientRecordModel? db,
  ) {
    if (db == null) {
      return [];
    }

    final json = db.toJson();
    const prefixes = ['ocrNom', 'ocrSecNom', 'ocrThiNom'];

    final List<Map<String, dynamic>> nomineeList = [];
    for (final p in prefixes) {
      if (!(json['${p}Flag'] ?? false)) {
        continue;
      }

      final proof = json['${p}Proof'];
      final guardianProof = json['${p}GuaProof'];

      final proofImage = json['${p}ProofImage'];
      final guardianProofImage = json['${p}GuaProofImage'];

      final nominee = <String, dynamic>{
        'name': json['${p}Name'] ?? '',
        'relation': json['${p}Relation'] != null ? json['${p}Relation'] : '',
        'panNumber': json['${p}Pan'] ?? '',
        'dob': formatDate(json['${p}DateOfBirth']),
        'share': json['${p}Percentage'] != null
            ? json['${p}Percentage'].toString()
            : '0',

        'mobile': json['${p}Mobile'] ?? '',
        'phone': json['${p}Phone'] ?? '',
        'email': json['${p}Email'] ?? '',
        'address1': json['${p}Address1'] ?? '',
        'address2': json['${p}Address2'] ?? '',
        'address3': json['${p}Address3'] ?? '',

        'country': json['${p}Country'] ?? '',
        'state': json['${p}State'] ?? '',
        'city': json['${p}City'] ?? '',
        'pincode': json['${p}PinCode'] ?? '',
        'documentType': proof != null ? proof : '',
        'documentNumber': proof == 1
            ? extractLast4(json['${p}ProofNo']?.toString() ?? '')
            : json['${p}ProofNo'] ?? '',
        'documentNominee': proofImage != null
            ? {
                'type': json['${p}ProofImageType'] ?? 'image/jpeg',
                'documentImage': convertBufferToBase64(proofImage),
                'documentFileName': generateFileName(
                  json['${p}ProofImageType'],
                  '${p}_nominee',
                ),
              }
            : null,

        'ageChecked': true,
        'minorFlag': json['${p}MinorFlag'] ?? false,
        'guardian': {
          'name': json['${p}GuaName'] ?? '',
          'relation': json['${p}WithGuaRelation'] != null
              ? json['${p}WithGuaRelation']
              : '',
          'dob': formatDate(json['${p}GuaDateOfBirth']),
          'address1': json['${p}GuaAddress1'] ?? '',
          'address2': json['${p}GuaAddress2'] ?? '',
          'address3': json['${p}GuaAddress3'] ?? '',
          'country': json['${p}GuaCountry'] ?? '',
          'state': json['${p}GuaState'] ?? '',
          'city': json['${p}GuaCity'] ?? '',
          'pincode': json['${p}GuaPinCode'] ?? '',
          'phone': json['${p}GuaPhone'] ?? '',
          'mobile': json['${p}GuaMobile'] ?? '',
          'email': json['${p}GuaEmail'] ?? '',
          'documentType': guardianProof != null ? guardianProof : '',
          'documentNumber': guardianProof == 1
              ? extractLast4(json['${p}GuaProofNo']?.toString() ?? '')
              : json['${p}GuaProofNo'] ?? '',
          'documentGuardian': guardianProofImage != null
              ? {
                  'type': json['${p}GuaProofImageType'] ?? 'image/jpeg',
                  'documentImage': convertBufferToBase64(guardianProofImage),
                  'documentFileName': generateFileName(
                    json['${p}GuaProofImageType'],
                    '${p}_guardian',
                  ),
                }
              : null,
        },
      };

      nomineeList.add(nominee);
    }
    return nomineeList;
  }

  String stringValue(dynamic value) {
    return value?.toString() ?? '';
  }

  //
  String formatDate(dynamic value) {
    if (value == null) {
      return '';
    }

    final date = value.toString();
    if (date.isEmpty) {
      return '';
    }

    return date.length >= 10 ? date.substring(0, 10) : date;
  }

  //extractLast4
  String extractLast4(dynamic id) {
    if (id == null) {
      return '';
    }
    final str = id.toString().trim();
    return str.length >= 4 ? str.substring(str.length - 4) : str;
  }

  //generateFileName
  String generateFileName(String? type, String prefix) {
    final ext = type?.split('/').last ?? 'jpg';
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}.$ext';
  }

  //convertBufferToBase64
  String convertBufferToBase64(dynamic bufferObj) {
    if (bufferObj == null) {
      return '';
    }

    List<int>? data;

    if (bufferObj is BufferModel) {
      data = bufferObj.data;
    } else if (bufferObj is Map<String, dynamic>) {
      final rawData = bufferObj['data'];

      if (rawData is List) {
        data = rawData.map((e) => (e as num).toInt()).toList();
      }
    }

    if (data == null || data.isEmpty) {
      return '';
    }

    return base64Encode(data);
  }
  // String convertBufferToBase64(BufferModel? buffer) {
  //   if (buffer == null || buffer.data.isEmpty) {
  //     return '';
  //   }

  //   return base64Encode(buffer.data);
  // }

  //extractDocuments
  Map<String, Map<String, dynamic>> extractDocuments(
    List<ExistingClientRecordModel> fileObj,
  ) {
    Map<String, dynamic> createDocStructure() => {
      'panImage': null,
      'panPDF': null,
      'addressImage': null,
      'addressPDF': null,
      'aadharPDF': null,
      'digiLockerXML': null,
      'sign': null,
      'selfie': null,
      'incomeProof': null,
      'addressProof1': null,
      'identityProof1Image': null,
      'identityProofImage': null,
      'guardianIdentityProof': null,
      'guardianIdentityProof1': null,
      'cheque': null,
      'IPV': null,
    };

    final holders = <String, Map<String, dynamic>>{
      'firstHolder': createDocStructure(),
      'secondHolder': createDocStructure(),
      'thirdHolder': createDocStructure(),
    };

    const holderMap = {
      '1': 'firstHolder',
      '2': 'secondHolder',
      '3': 'thirdHolder',
    };

    for (final doc in fileObj) {
      final json = doc.toJson();
      final holderKey = holderMap[json['agHolder']?.toString()];
      if (holderKey == null) {
        continue;
      }

      final holder = holders[holderKey]!;
      final type = json['agDocTypeNm'] as String?;
      final mime = json['ocrImageType'] as String?;
      final image = json['ocrImage'];
      final isImage = mime?.startsWith('image') ?? false;
      final isPDF = mime == 'application/pdf';
      switch (type) {
        case 'Pan':
          if (isImage) {
            holder['panImage'] = {'data': image, 'mime': mime};
          }
          if (isPDF) {
            holder['panPDF'] = image;
          }
          break;

        case 'Address':
          if (isImage) {
            holder['addressImage'] = {'data': image, 'mime': mime};
          }
          if (isPDF) {
            holder['addressPDF'] = image;
          }
          break;

        case 'Address1':
          if (isImage) {
            holder['addressProof1'] = {'data': image, 'mime': mime};
          }
          break;

        case 'Identity Proof':
          if (isPDF) {
            holder['aadharPDF'] = image;
          }
          if (isImage) {
            holder['identityProofImage'] = {'data': image, 'mime': mime};
          }
          break;

        case 'Identity Proof1':
          if (isImage) {
            holder['identityProof1Image'] = {'data': image, 'mime': mime};
          }
          break;

        case 'DigiLocker XML':
          holder['digiLockerXML'] = image;
          break;

        case 'Sign':
          holder['sign'] = {'data': image, 'mime': mime};
          break;

        case 'Photo':
          holder['selfie'] = {'data': image, 'mime': mime};
          break;

        case 'IncomeProof':
        case 'Future Option Proof':
          holder['incomeProof'] = {'data': image, 'mime': mime};
          break;

        case 'Guardian Identity Proof':
          holder['guardianIdentityProof'] = {'data': image, 'mime': mime};
          break;

        case 'Guardian Identity Proof 1':
          holder['guardianIdentityProof1'] = {'data': image, 'mime': mime};
          break;

        case 'Cheque':
          holder['cheque'] = {'data': image, 'mime': mime};
          break;

        case 'InPersonVerification':
        case 'IPV':
          holder['IPV'] = {'data': image, 'mime': mime};
          break;
      }
    }
    return holders;
  }

  //getNSDLClientTypes
  List<Map<String, dynamic>> getNSDLClientTypes({
    required List<Map<String, dynamic>> nsdlClientTypes,
    required int accountSubCategory,
  }) {
    // LogHelper.infoLog('in getNSDLClientTypes');
    // LogHelper.infoLog(nsdlClientTypes.toString());
    // LogHelper.infoLog(accountSubCategory.toString());

    if (accountSubCategory == 6) {
      return nsdlClientTypes.where((i) => i['id'] == 4).toList();
    } else if (accountSubCategory == 1) {
      return nsdlClientTypes.where((i) => i['id'] == 16).toList();
    } else if (accountSubCategory == 2) {
      return nsdlClientTypes.where((i) => i['id'] == 5).toList();
    } else if (accountSubCategory == 3) {
      return nsdlClientTypes
          .where((i) => i['id'] == 9 || i['id'] == 1)
          .toList();
    } else {
      return nsdlClientTypes.where((i) => i['id'] == 1).toList();
    }
  }

  Future<AdditionalStep> identifyAdditionalDetailsStep(
    ExistingClientRecordModel? mainData,
    String holder,
  ) async {
    final nsdlClientTypes = clientData?.nsdlClientType is List
        ? clientData!.nsdlClientType as List<dynamic>
        : <dynamic>[];

    // final nsdlClientTypes = (clientData?.nsdlClientType as List<dynamic>? ?? []);

    final bool isIndividual = mainData?.ocrAccountCategory?.toString() == '1';

    final int accountSubCategory = isIndividual
        ? 8
        : (mainData?.ocrAccountSubCategory ?? 0);
    final filteredTypes = getNSDLClientTypes(
      nsdlClientTypes: (nsdlClientTypes as List).cast<Map<String, dynamic>>(),
      accountSubCategory: accountSubCategory,
    );

    final List<dynamic> subTypes = mainData?.ocrNSDLClientType != null
        ? await getNSDLClientSubTypes(mainData!.ocrNSDLClientType.toString())
        : <dynamic>[];

    filteredNSDLClientTypes = filteredTypes;
    filteredNSDLClientSubTypes = subTypes;
    subTypesForClientTypeId = mainData?.ocrNSDLClientType;
    notifyListeners();

    final steps = getStepsForClient(
      accountSubCategory,
      mainData?.ocrAccountOption.toString(),
      holder != AppStrings.firstHolder,
      filteredTypes,
      subTypes,
    );

    if (steps.isEmpty) {
      return AdditionalStep.occupation;
    }

    final firstStep = steps.first;
    final lastStep = steps.last;

    if (holder == AppStrings.firstHolder) {
      final shouldStartFromBeginning =
          mainData?.ocrstage == AppStrings.digiLocker ||
          mainData?.ocrstage == AppStrings.insert ||
          mainData?.ocrMode == AppStrings.insert;

      return shouldStartFromBeginning ? firstStep : lastStep;
    }

    final shouldResumeAtLastStep =
        mainData?.ocrstage == AppStrings.photo ||
        mainData?.ocrstage == AppStrings.signature ||
        mainData?.ocrstage == AppStrings.personal;

    return shouldResumeAtLastStep ? lastStep : AdditionalStep.occupation;
  }

  //getNSDLClientSubTypes
  Future<List<dynamic>> getNSDLClientSubTypes(String nsdlClientId) async {
    try {
      // LogHelper.infoLog('Getting NSDL Sub Types for: $nsdlClientId');
      final response = await authRepository.getNSDLSubTypes(
        nsdlClientId: nsdlClientId,
      );
      final subTypes = response?.data['data']?['recordset'] ?? [];
      // LogHelper.infoLog('NSDL Sub Types: $subTypes');
      return subTypes;
    } catch (e) {
      LogHelper.errorLog('getNSDLClientSubTypes Exception: $e');
      return [];
    }
  }

  //getStepsForClient
  List<AdditionalStep> getStepsForClient(
    int clientTypeId,
    String? accountOption,
    bool isMultiHolder, [
    List<dynamic> nsdlClientTypes = const [],
    List<dynamic> nsdlSubClientTypes = const [],
  ]) {
    // LogHelper.infoLog('clientTypeId: $clientTypeId');
    // LogHelper.infoLog('accountOption: $accountOption');
    // LogHelper.infoLog('isMultiHolder: $isMultiHolder');
    // LogHelper.infoLog('nsdlClientTypes: $nsdlClientTypes');
    // LogHelper.infoLog('nsdlSubClientTypes: $nsdlSubClientTypes');

    var baseSteps = List<AdditionalStep>.from(getStepsById(clientTypeId));

    // Multi-holder filtering
    if (isMultiHolder) {
      List<AdditionalStep> multiHolderAllowedSteps;

      if (clientTypeId == 7) {
        multiHolderAllowedSteps = [
          AdditionalStep.occupation,
          AdditionalStep.income,
          AdditionalStep.city,
          AdditionalStep.gender,
          AdditionalStep.marital,
        ];
      } else if (clientTypeId == 6) {
        multiHolderAllowedSteps = [
          AdditionalStep.occupation,
          AdditionalStep.income,
          AdditionalStep.country,
          AdditionalStep.city,
          AdditionalStep.gender,
          AdditionalStep.marital,
          AdditionalStep.residentialStatus,
        ];
      } else {
        multiHolderAllowedSteps = [
          AdditionalStep.occupation,
          AdditionalStep.income,
          AdditionalStep.city,
          AdditionalStep.gender,
          AdditionalStep.marital,
          AdditionalStep.residentialStatus,
        ];
      }

      baseSteps = multiHolderAllowedSteps;
    }

    // Remove NSDL steps completely for Trading accounts
    if (accountOption == AppConstants.ACCOUNT_OPTION_TRADING) {
      return baseSteps
          .where(
            (step) =>
                step != AdditionalStep.nsdlClientType &&
                step != AdditionalStep.nsdlSubClientType,
          )
          .toList();
    }

    // Hide nsdlClientType if only 0 or 1 option
    if (nsdlClientTypes.length <= 1) {
      baseSteps = baseSteps
          .where((step) => step != AdditionalStep.nsdlClientType)
          .toList();
    }

    // Hide nsdlSubClientType if only 0 or 1 option
    // Uncomment if needed
    /*
  if (nsdlSubClientTypes.length <= 1) {
    baseSteps = baseSteps
        .where(
          (step) =>
              step != AdditionalStep.nsdlSubClientType,
        )
        .toList();
  }
  */

    return baseSteps;
  }

  final Map<int, ClientStepConfigModel> clientStepMap = {
    for (final config in AppConstants.clientStepConfigs) config.id: config,
  };

  List<AdditionalStep> getStepsById(int id) {
    return clientStepMap[id]?.steps ?? [];
  }

  List<AdditionalStep> getStepsByName(String name) {
    final config = AppConstants.clientStepConfigs.where(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
    );
    return config.isNotEmpty ? config.first.steps : <AdditionalStep>[];
  }

  String get existingUserTitle {
    final messages = _checkMobileExistResponse?.messageRecordSet;
    if (messages == null || messages.isEmpty) {
      return AppStrings.resumeApp;
    }
    return messages.first.title.trim().isNotEmpty
        ? messages.first.title.trim()
        : AppStrings.resumeApp;
  }

  List<String> get existingUserMessages {
    final messages = _checkMobileExistResponse?.messageRecordSet;
    if (messages == null || messages.isEmpty) {
      return [];
    }

    return messages
        .map((e) => e.message.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void setOtpNavigationInProgress(bool value) {
    _isNavigatingAfterOtp = value;
    notifyListeners();
  }

  // To get Stataic Data
  Future<void> getStaticDataAPI({String isReload = 'N'}) async {
    isStaticDataLoading = true;
    AppHelperWidgets.showLoader();
    notifyListeners();
    try {
      final response = await authRepository.getStaticData(isReload: isReload);
      if (response == null ||
          response.statusCode != 200 ||
          response.data == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final responseMap = Map<String, dynamic>.from(response.data as Map);
      await processStaticData(responseMap);
      notifyListeners();
    } catch (e) {
      LogHelper.errorLog('getStaticData Exception: $e');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      isStaticDataLoading = false;
      AppHelperWidgets.hideLoader();
      notifyListeners();
    }
  }

  //processStaticData
  Future<void> processStaticData(Map<String, dynamic> json) async {
    final staticData = StaticDataModel.fromJson(json);
    if (staticData.recordsets.isEmpty) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
      return;
    }

    //emailMobileRelationshipsList
    emailMobileRelationshipsList = staticData.recordsets.length > 21
        ? List<FluffyRecordset>.from(staticData.recordsets[21])
        : [];

    filteredEmailMobileRelationshipsList = List<FluffyRecordset>.from(
      emailMobileRelationshipsList,
    );

    if (defaultLoginType.value == '1') {
      const excludedIds = [10, 11, 12, 13];

      filteredEmailMobileRelationshipsList = emailMobileRelationshipsList.where(
        (item) {
          final id = item.id is int
              ? item.id as int
              : int.tryParse(item.id.toString());
          return id != null && !excludedIds.contains(id);
        },
      ).toList();
    }

    emailMobileRelationshipsList = filteredEmailMobileRelationshipsList;

    /// Account TypesList
    final accountTypesList = staticData.recordsets.length > 61
        ? List<FluffyRecordset>.from(staticData.recordsets[61])
        : [];

    /// Account OptionsList
    final accountOptionsList = staticData.recordsets.length > 62
        ? List<FluffyRecordset>.from(staticData.recordsets[62])
        : [];

    // LogHelper.infoLog('Account Types: $accountTypesList');
    // LogHelper.infoLog('Account Options: $accountOptionsList');

    if (staticData.recordsets.length > 50) {
      final clientDataList = staticData.recordsets[50];

      if (clientDataList.isNotEmpty) {
        final first = clientDataList.first;
        clientData = first;
        accountType = first.accountType ?? 0;
        accountOption = first.accountOption ?? 0;
        accountSubCategory = first.accountSubCategory ?? 0;

        ocrCorrAddressProof = first.ocrCorrAddressProof;
        ocrPerAddressProof = first.ocrPerAddressProof;
        ocrIdentityProof = first.ocrIdentityProof;
        selectedResidentialStatus = first.residentialStatus;
      }
    }

    // LogHelper.infoLog('ClientData: $clientData');

    // KRA Config Data
    if (staticData.recordsets.length > 57) {
      final kraConfigs = List<FluffyRecordset>.from(staticData.recordsets[57]);
      if (kraConfigs.isNotEmpty) {
        kraConfigData = [kraConfigs.first];
      }
    }

    //kraAgencyCode
    if (staticData.recordsets.length > 58) {
      const String kKRAAgency = '0';
      final agencyDetails = List<FluffyRecordset>.from(
        staticData.recordsets[58],
      );
      final match = agencyDetails
          .where((item) => item.staTypeCode?.toString() == kKRAAgency)
          .toList();
      kraAgencyCode = match.isNotEmpty ? (match.first.description ?? '') : '';
    }

    //IncomeRangeList
    if (staticData.recordsets.length > 7) {
      incomeRangeList = staticData.recordsets[7]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
            ),
          )
          .toList();
      // LogHelper.infoLog('Annual IncomeList: $incomeRangeList');
    }

    //OccupationList
    if (staticData.recordsets.length > 8) {
      occupationList = staticData.recordsets[8]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
            ),
          )
          .toList();
      // LogHelper.infoLog('OccupationList: $occupationList');
    }

    //CountryList
    if (staticData.recordsets.length > 12) {
      countryList = staticData.recordsets[12]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
            ),
          )
          .toList();
      // LogHelper.infoLog('Country List: $countryList');
    }

    /// State List (recordsets[13])
    if (staticData.recordsets.length > 13) {
      stateList = staticData.recordsets[13]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name ?? '',
              countryId: e.countryId?.toString(),
              cvlValue: e.cvlValue,
            ),
          )
          .toList();

      allStateListForFiltering = List<PurpleRecordset>.from(stateList);

      // LogHelper.infoLog('State List: $stateList');
    }

    /// City List (recordsets[14])
    if (staticData.recordsets.length > 14) {
      cityList = staticData.recordsets[14]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name ?? '',
              countryId: e.countryId?.toString(),
              stateId: e.stateId?.toString(),
            ),
          )
          .toList();

      allCityListForFiltering = List<PurpleRecordset>.from(cityList);

      // LogHelper.infoLog('City List: $cityList');
    }

    /// Pin Code List (recordsets[15])
    if (staticData.recordsets.length > 15) {
      pinCodeList = staticData.recordsets[15]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
              cityId: e.cityId,
            ),
          )
          .toList();

      allPinCodeListForFiltering = List<PurpleRecordset>.from(pinCodeList);
      // LogHelper.infoLog('PinCode List: $allPinCodeListForFiltering');
    }
    //Bank Account TypeList
    if (staticData.recordsets.length > 10) {
      bankAccountTypeList = staticData.recordsets[10]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
            ),
          )
          .toList();
      // LogHelper.infoLog('BANK ACCOUNT TYPE :::$bankAccountTypeList');
    }

    // nomineeRelationShipList
    if (staticData.recordsets.length > 56) {
      nomineeRelationShipList = staticData.recordsets[56]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
            ),
          )
          .toList();
    }

    // Gender List (recordsets[59])
    if (staticData.recordsets.length > 59) {
      genderList = staticData.recordsets[59]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
            ),
          )
          .toList();

      // LogHelper.infoLog('Gender List: $genderList');
    }

    // Marital Status List (recordsets[60])
    if (staticData.recordsets.length > 60) {
      maritalStatusList = staticData.recordsets[60]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
            ),
          )
          .toList();
      // LogHelper.infoLog('Marital Status List: $maritalStatusList');
    }

    // Settlement Cycle List (recordsets[19])
    if (staticData.recordsets.length > 19) {
      settlementCycleList = staticData.recordsets[19]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
            ),
          )
          .toList();
      // LogHelper.infoLog('Settlement Cycle List: $settlementCycleList');
    }

    // nomineeDocumentTypeList
    if (staticData.recordsets.length > 33) {
      nomineeDocumentTypeList = staticData.recordsets[33]
          .where((e) => e.id != null && e.name != null)
          .map(
            (e) => PurpleRecordset(
              id: int.tryParse(e.id.toString()) ?? 0,
              name: e.name!,
            ),
          )
          .toList();
    }

    // MarketSegmentList
    if (staticData.recordsets.length > 45) {
      marketSegmentList = List<FluffyRecordset>.from(staticData.recordsets[45]);
      // LogHelper.infoLog('Market SegmentList :: ${marketSegmentList.toString()}');
    }

    // Additional Detail List
    if (staticData.recordsets.length > 65) {
      additionalDetailsList = List<FluffyRecordset>.from(
        staticData.recordsets[65],
      );
      // LogHelper.infoLog('Additional Details List :: ${additionalDetailsList.length}');
    }

    globalStateProvider.setState({
      'staticData': {
        'AllEmailMobileRelationships': emailMobileRelationshipsList,
        'emailMobileRelationShips': filteredEmailMobileRelationshipsList,
        'countryData': staticData.recordsets[12],
        'stateData': staticData.recordsets[13],
        'cityData': staticData.recordsets[14],
        'pinCodeData': staticData.recordsets[15],
        'occupationData': staticData.recordsets[8],
        'incomeRangeData': staticData.recordsets[7],
        'clientData': staticData.recordsets[50],
        'genderData': staticData.recordsets[59],
        'maritalStatusData': staticData.recordsets[60],
        'bankAccountType': staticData.recordsets[10],
        'nomineeRelationShips': staticData.recordsets[56],
        'documentTypes': staticData.recordsets[41],
        'accountTypes': accountTypesList,
        'accountOptions': accountOptionsList,
        'nriTypes': staticData.recordsets[4],
        'nationalities': staticData.recordsets[12],
        'guardianPrefixes': staticData.recordsets[63],
        'addressProofTypes': staticData.recordsets[69],
        'additionalDocumentsTypes': staticData.recordsets[67],
        'taxApplicableOutsideIndias': staticData.recordsets[64],
        'taxPayableAddressFlags': staticData.recordsets[9],
        'FATCACountryCitizenships': staticData.recordsets[51],
        'FATCACountryResidencies': staticData.recordsets[51],
        'FATCATaxExemptFlags': staticData.recordsets[53],
        'FATCATaxExemptReasons': staticData.recordsets[54],
        'depositories': staticData.recordsets[39],
        'dematAccountProofList': staticData.recordsets[40],
        'reloationWithApplicant': staticData.recordsets[66],
        'proRelationWithMemOrCops': staticData.recordsets[55],
        'modeOfCommunications': staticData.recordsets[48],
        'modeOfOperations': staticData.recordsets[47],
        'residentialStatuses': staticData.recordsets[6],
        'nsdlClientTypes': staticData.recordsets[22],
        'additionalDetails': staticData.recordsets[65],
        'billingCategories': staticData.recordsets[20],
        'nomineeDocTypes': staticData.recordsets[33],
        'pisTypes': staticData.recordsets[68],
        'settlementCycles': staticData.recordsets[19],
      },
      'segments': staticData.recordsets[45],
      'KRAConfigDetailsStatic': staticData.recordsets[57],
      'KRAAgencyDetailsStatic': staticData.recordsets[58],
    });
  }

  // selectPEP
  void selectPEP(String value) {
    selectedPEPNotifier.value = value;
    isPEPSelectedNotifier.value = true;
    additionalDetails = {...additionalDetails, 'PEP': int.tryParse(value)};
    globalStateProvider.setState({'additionalDetails': additionalDetails});
    notifyListeners();
  }

  void selectSettlementCycle(String value) {
    selectedSettlementCycleNotifier.value = value;
    additionalDetails = {
      ...additionalDetails,
      'SettlementCycle': int.tryParse(value),
    };
    globalStateProvider.setState({'additionalDetails': additionalDetails});
    notifyListeners();
  }

  // Brokerage Checked
  void toggleBrokerageChecked() {
    isBrokerageChecked = !isBrokerageChecked;
    isSelectMarketSegmentNotifier.value = isBrokerageChecked;
    notifyListeners();
  }

  // Auto Debit
  void isAutoDebitChecked() {
    isAutoDebitEnable = !isAutoDebitEnable;
    notifyListeners();
  }

  void updateCustomDropdownState(bool value) {
    isCustomDropdownOpen = value;
    notifyListeners();
  }

  //Brokerage Info item
  List<BrokerageInfoModel> get selectedBrokerageInfo {
    final result = <BrokerageInfoModel>[];

    const order = ['Equity', 'Equity Derivatives', 'Commodities'];

    /// Check whether user selected any segment
    final hasAnySelection = groupedSegments.values.any(
      (group) => group.selected || group.items.any((item) => item.selected),
    );

    /// Default to Equity if nothing selected
    final groupsToProcess = hasAnySelection
        ? groupedSegments.values
        : groupedSegments.values.where((group) => group.header == 'Equity');

    for (final group in groupsToProcess) {
      final isGroupSelected =
          group.selected || group.items.any((item) => item.selected);

      /// Skip unselected groups only when user has made selection
      if (hasAnySelection &&
          (!isGroupSelected ||
              group.header == 'SLBM' ||
              group.header == 'NSDL')) {
        continue;
      }

      final lines = <String>[];

      for (final item in group.items) {
        final segment = item.segment;
        final id = segment.ocrBusinessId;
        final intradayDesc = segment.intradayDesc ?? '';
        final deliveryDesc = segment.deliveryDesc ?? '';
        final futDesc = segment.futDesc ?? '';
        final optDesc = segment.optDesc ?? '';
        final optDescription = segment.optDescription ?? '';
        final jobDescription = segment.jobDescription ?? '';
        final delDescription = segment.delDescription ?? '';
        final futDescription = segment.futDescription ?? '';
        final exeDescription = segment.exeDescription ?? '';
        final slbmDescription = segment.slbmDescription ?? '';

        /// Equity
        if (id == 17 || id == 18) {
          if (intradayDesc.isNotEmpty) {
            lines.add('Equity Intraday: $intradayDesc');
          }

          if (deliveryDesc.isNotEmpty) {
            lines.add('Equity Delivery: $deliveryDesc');
          }
        }
        /// Equity Derivatives
        else if (id == 19 || id == 20) {
          if (futDesc.isNotEmpty) {
            lines.add('Equity Futures: $futDesc');
            lines.add('Index Futures: $futDesc');
          }

          if (optDesc.isNotEmpty) {
            final parts = optDesc.split('|');

            if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
              lines.add('Equity Options: ${parts[0]}');
            }

            if (parts.length > 1 && parts[1].trim().isNotEmpty) {
              lines.add('Index Options: ${parts[1]}');
            }
          }
        }
        /// Currency
        else if (id == 21) {
          if (optDescription.isNotEmpty) {
            lines.add('Currency Brk: $optDescription');
          }
        }
        /// Commodities
        else if (id == 63 || id == 64) {
          if (futDesc.isNotEmpty) {
            lines.add('Commodities Futures: $futDesc');
          }

          if (optDesc.isNotEmpty) {
            lines.add('Commodities Options: $optDesc');
          }
        }
        /// Others
        else {
          if (jobDescription.isNotEmpty) {
            lines.add('Jobbing Brk: $jobDescription');
          }

          if (delDescription.isNotEmpty) {
            lines.add('Delivery Brk: $delDescription');
          }

          if (optDescription.isNotEmpty) {
            lines.add('Option Brk: $optDescription');
          }

          if (futDescription.isNotEmpty) {
            lines.add('Future Brk: $futDescription');
          }

          if (exeDescription.isNotEmpty) {
            lines.add('Exe Brk: $exeDescription');
          }

          if (slbmDescription.isNotEmpty) {
            lines.add('SLBM Brk: $slbmDescription');
          }
        }
      }

      if (lines.isNotEmpty) {
        result.add(BrokerageInfoModel(header: group.header, lines: lines));
      }
    }

    /// Sort order
    result.sort((a, b) {
      final indexA = order.indexOf(a.header);
      final indexB = order.indexOf(b.header);
      final sortA = indexA == -1 ? order.length : indexA;
      final sortB = indexB == -1 ? order.length : indexB;
      return sortA.compareTo(sortB);
    });

    /// Debug Logs
    return result;
  }

  List<Map<String, dynamic>> buildBrokerageDetailsArray(
    List<SegmentDataModel> segments,
  ) {
    final panDetails = globalStateProvider.get<Map<String, dynamic>>(
      'panDetails',
    );
    final panNumber = panDetails!['panNumber'].toString().trim().toUpperCase();
    // LogHelper.infoLog('buildBrokerageDetailsArray Input :: ${segments.length}');
    final List<Map<String, dynamic>> arrBrokerageDetails = [];
    final isSLBMSelected = segments.any(
      (seg) => seg.isSLBM == true || seg.header == 'SLBM',
    );

    for (final seg in segments) {
      final segment = seg.segment;
      if (seg.isSLBM == true) {
        continue;
      }
      if (seg.header == 'NSDL' && segment.ocrBusinessId == null) {
        continue;
      }
      final includeSLBM = segment.ocrBusinessId == 17 && isSLBMSelected;
      final brokerageDetail = {
        'BusinessType': segment.ocrBusinessId,
        'JobType': segment.ocrJobtype,
        'JobCode': segment.ocrJobCode,
        'JobTypeDescription': segment.jobType,
        'JobDescription': segment.jobDescription,
        'DeliveryType': segment.ocrDeltype,
        'DeliveryCode': segment.ocrDelCode,
        'DeliveryTypeDescription': segment.deltype,
        'DeliveryDescription': segment.delDescription,
        'OptType': segment.ocrOptType,
        'OptCode': segment.ocrOptCode,
        'OptTypeDescription': segment.optType,
        'OptDescription': segment.optDescription,
        'FutType': segment.ocrFutType,
        'FutCode': segment.ocrFutCode,
        'FutTypeDescription': segment.futType,
        'FutDescription': segment.futDescription,
        'ExeType': segment.ocrExeType,
        'ExeCode': segment.ocrExeCode,
        'ExeTypeDescription': segment.exeType,
        'ExeDescription': segment.exeDescription,
        'OneSideBrk': segment.ocrOneSideBrk,
        'OneSideBrkCode': segment.ocrOneSidecode,
        'RoundFlag': segment.ocrRoundFlag,
        'SBLMType': includeSLBM ? segment.ocrSlbmType : null,
        'SLBMCode': includeSLBM ? segment.ocrSlbmCode : null,
        'SLBMTypeDescription': includeSLBM ? segment.slbmType : null,
        'SLBMDescription': includeSLBM ? segment.slbmDescription : null,
        'agbPan': panNumber.toString(),
      };
      arrBrokerageDetails.add(brokerageDetail);
    }

    return arrBrokerageDetails;
  }

  // To Update GST Status
  void updateGSTStatus() {
    isGstRegistered = !isGstRegistered;
    notifyListeners();
  }

  //Update RelationType
  void updateRelationType(String relationType) {
    selectedRelationType = relationType;
    notifyListeners();
  }

  int? _parseId(dynamic id) {
    if (id == null) return null;
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    if (id is double) return id.toInt();
    return null;
  }

  void updateDigioProvider(DigioProvider provider) {
    digioProvider = provider;
  }

  bool validateRelationships() {
    bool isValid = true;
    if (selectedEmailRelationshipId == -1) {
      emailRelationshipError = true;
      isValid = false;
    }

    if (selectedMobileRelationshipId == -1) {
      mobileRelationshipError = true;
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  void toggleTerms() {
    _isTermsAccepted = !_isTermsAccepted;
    if (_isTermsAccepted) {
      _termsHasError = false;
      _termsError = '';
    }
    notifyListeners();
  }

  void setTermsError(String error) {
    _termsHasError = true;
    _termsError = error;
    notifyListeners();
  }

  void setEmailError({required bool hasError, required String errorMessage}) {
    _emailHasError = hasError;
    _emailError = errorMessage;
    notifyListeners();
  }

  void setBankAccountNumberError({
    required bool hasError,
    required String errorMessage,
  }) {
    _bankAccountNumberHasError = hasError;
    _bankAccountNumberError = errorMessage;
    notifyListeners();
  }

  void clearEmailError() {
    _emailHasError = false;
    _emailError = '';
    notifyListeners();
  }

  void setMobileError({required bool hasError, required String errorMessage}) {
    _mobileHasError = hasError;
    _mobileError = errorMessage;
    notifyListeners();
  }

  void clearMobileError() {
    _mobileHasError = false;
    _mobileError = '';
    notifyListeners();
  }

  //validateLoginFields
  LoginValidationStatus validateLoginFields() {
    bool isValid = true;

    if (mobileController.text.trim().isEmpty) {
      _mobileHasError = true;
      _mobileError = '${AppStrings.mobile}${AppStrings.isRequired}';

      isValid = false;
    } else if (mobileController.text.trim().length < 10) {
      _mobileHasError = true;
      _mobileError = AppStrings.enterValidMobile;

      isValid = false;
    } else {
      _mobileHasError = false;
      _mobileError = '';
    }

    if (emailController.text.trim().isEmpty) {
      _emailHasError = true;
      _emailError = '${AppStrings.emailID}${AppStrings.isRequired}';

      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text.trim())) {
      _emailHasError = true;
      _emailError = AppStrings.enterValidEmail;

      isValid = false;
    } else {
      _emailHasError = false;
      _emailError = '';
    }

    if (!_isTermsAccepted) {
      _termsHasError = true;
      _termsError = AppStrings.youMustAccept;

      isValid = false;
    } else {
      _termsHasError = false;
      _termsError = '';
    }

    notifyListeners();

    if (!isValid) {
      return LoginValidationStatus.invalid;
    }

    if (referralController.text.trim().isEmpty) {
      return LoginValidationStatus.validWithoutReferral;
    }
    return LoginValidationStatus.valid;
  }

  @override
  void dispose() {
    mobileController.dispose();
    emailController.dispose();
    referralController.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    if (isInitialized) return;
    isInitialized = true;
    await getStaticDataAPI();
    await loadSegmentTypes();
  }

  List<SegmentDataModel> get displaySegments {
    final List<SegmentDataModel> items = [];

    for (final group in groupedSegments.values) {
      // =========================
      // SKIP CURRENCY
      // =========================
      if (group.header == 'Currency') {
        continue;
      }

      if (group.items.isEmpty) {
        items.add(
          SegmentDataModel(
            segment: FluffyRecordset(),
            header: group.header,
            selected: group.selected,
            disabled: group.disabled,
            isSLBM: group.header == 'SLBM',
          ),
        );

        continue;
      }

      items.addAll(group.items);
    }

    const displayOrder = {
      'NSDL': 0,
      'Equity': 1,
      'Commodities': 2,
      'Equity Derivatives': 3,
      'SLBM': 4,
    };

    items.sort((a, b) {
      final orderA = displayOrder[a.header] ?? 999;
      final orderB = displayOrder[b.header] ?? 999;
      return orderA.compareTo(orderB);
    });

    return items;
  }

  // Select BirthCity
  void selectBirthCity(PurpleRecordset city) {
    selectedBirthCity = city;
    birthCityController.text = city.name ?? '';
    isBirthCityNotifier.value = true;
    notifyListeners();
  }

  // Select Gender
  void selectGender(PurpleRecordset gender) {
    selectedGender = gender;
    isSelectGenderNotifier.value = true;
    notifyListeners();
  }

  // Select Marital Status
  void selectMaritalStatus(PurpleRecordset maritalStatus) {
    selectedMaritalStatus = maritalStatus;
    isSelectMaritalStatusNotifier.value = true;
    notifyListeners();
  }

  // Selected Occupation
  void selectOccupation(PurpleRecordset occupation) {
    selectedOccupation = occupation;
    isOccupationSelectedNotifier.value = true;
    notifyListeners();
  }

  // Selected IncomeRange
  void selectIncomeRange(PurpleRecordset incomeRange) {
    selectedIncomeRange = incomeRange;
    isAnnualRangeSelectedNotifier.value = true;
    notifyListeners();
  }

  // FilterSearchCity
  void searchCity(String query) {
    final searchText = query.trim().toLowerCase();
    if (selectedBirthCity != null &&
        selectedBirthCity!.name?.toLowerCase() != searchText) {
      selectedBirthCity = null;
      isBirthCityNotifier.value = false;
    }
    if (searchText.length < 3) {
      filteredSearchCityList = [];
      notifyListeners();
      return;
    }
    filteredSearchCityList = cityList.where((city) {
      return (city.name ?? '').toLowerCase().startsWith(searchText);
    }).toList();
    notifyListeners();
  }

  //To get Referral Code Details
  Future<bool> getReferralCodeAPI() async {
    final userReferralCode = referralController.text.trim();
    try {
      final response = await authRepository.getReferralCode(
        referralCode: userReferralCode,
      );
      if (response != null && response.data != null) {
        final data = response.data!;
        final bool isSuccess = data['success'] == true;
        if (isSuccess && data['data'] != null) {
          referralData = ReferralCodeModel.fromJson(
            Map<String, dynamic>.from(data as Map),
          );

          final referral = referralData!.data!;
          final referralCodeValue = referral.referralCode ?? '';
          final extractedUserType = referralCodeValue.isNotEmpty
              ? referralCodeValue.substring(0, 1)
              : (referral.userType ?? '');
          // LogHelper.infoLog('REFERRAL CODE ::: $referralCodeValue');
          // LogHelper.infoLog('EXTRACTED USER TYPE::: $extractedUserType');

          globalStateProvider.setState({
            'referalData': {
              'Branch': referral.branchId,
              'EasyPartnerId': referral.referialId,
              'EmployeeCode': referral.empUserId,
              'Group': referral.groupId,
              'TradingCode': referral.tradingCode,
              'UserType': extractedUserType,
              'referalCode': referralCodeValue,
              'userId': referral.userId,
              'Signature': referral.signature,
              'braBranchCat': referral.braBranchCat,
              'bratype': referral.bratype,
              'branchEmail': '',
              'BranchName': referral.branchName,
              'RemisarName': referral.remisarName,
              'EasyPartnerName': referral.easyPartnerName,
              'EmployeeName': referral.employeeName,
            },
          });

          notifyListeners();
          return true;
        } else {
          if (isSuccess && data['data'] == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppHelperWidgets.showSnackBar(
                title: AppStrings.warning,
                message: AppStrings.pleaseProvideValidReferralCode,
                messageType: AppStrings.responseTypeWarning,
              );
            });
          }
          return false;
        }
      }
    } catch (e) {
      LogHelper.errorLog('Referral Code Exception: $e');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      notifyListeners();
    }
    return false;
  }

  // Validate Existing Mobile
  Future<bool> validateExistingMobile() async {
    final isUserExist = await checkMobileExist();
    if (isUserExist) {
      setMobileError(
        hasError: true,
        errorMessage: AppStrings.mobileAlreadyRegistered,
      );
    } else {
      setMobileError(hasError: false, errorMessage: '');
    }
    return isUserExist;
  }

  // To selectedLoginType
  void selectedLoginType(String value) {
    final loginType = LoginType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LoginType.values.first,
    );

    if (defaultLoginType == loginType) {
      return;
    }

    defaultLoginType = loginType;
    notifyListeners();
  }

  void toggleLoginType() {
    final currentIndex = LoginType.values.indexOf(defaultLoginType);
    final nextIndex = (currentIndex + 1) % LoginType.values.length;
    defaultLoginType = LoginType.values[nextIndex];
    notifyListeners();
  }

  void selectOption(int index) {
    _selectedIndex = index;
    _isPdfLoading = true;
    notifyListeners();
  }

  void zoomIn() {
    _zoomValue = (_zoomValue + 10).clamp(minZoom, maxZoom);
    notifyListeners();
  }

  void zoomOut() {
    _zoomValue = (_zoomValue - 10).clamp(minZoom, maxZoom);
    notifyListeners();
  }

  void resetZoom() {
    _zoomValue = 100;
    notifyListeners();
  }

  void setZoom(int value) {
    _zoomValue = value.clamp(minZoom, maxZoom);
    notifyListeners();
  }

  void setPdfLoading(bool value) {
    if (_isPdfLoading == value) {
      return;
    }
    _isPdfLoading = value;
    notifyListeners();
  }

  // To send OTP

  Future<bool> sendOTP({
    required String mobile,
    required String email,
    String type = '',
    bool isResume = false,
    bool isResent = false,
    String loginType = '',
    String messageType = '',
  }) async {
    try {
      notifyListeners();

      final sendOTPRequestPayload = {
        'type': type,
        'isResume': isResume,
        'isResent': isResent,
        'mobile': mobile,
        'email': email,
        'loginType': loginType,
        'messageType': messageType,
      };

      final response = await authRepository.sendOTP(
        sendOTPRequestData: sendOTPRequestPayload,
      );
      if (response != null && response.statusCode == 200) {
        final data = response.data;

        if (data != null && data is Map<String, dynamic>) {
          final bool isSuccess = data['success'] == true;
          final String message =
              data['message']?.toString() ?? AppStrings.somethingWentWrong;

          if (isSuccess) {
            AppHelperWidgets.showSnackBar(
              title: AppStrings.success,
              message: message,
              messageType: AppStrings.responseTypeSuccess,
            );
            return true;
          } else {
            LogHelper.infoLog('Send OTP Error: $message');
            AppHelperWidgets.showSnackBar(
              title: AppStrings.error,
              message: message,
              messageType: AppStrings.responseTypeError,
            );
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      LogHelper.errorLog('Send OTP Exception: $e');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.mobileOTPSendingFailed,
        messageType: AppStrings.responseTypeError,
      );
      return false;
    } finally {
      notifyListeners();
      AppHelperWidgets.hideLoader();
    }
  }

  Future<void> resendEmailOtp() async {
    await sendOTP(
      type: AppStrings.otpTypeEmail,
      isResume: false,
      isResent: true,
      mobile: '',
      email: emailController.text.trim(),
      loginType: defaultLoginType.value,
      messageType: '',
    );
  }

  Future<void> resendMobileOtp() async {
    await sendOTP(
      type: AppStrings.otpTypeMobile,
      isResume: false,
      isResent: true,
      mobile: mobileController.text.trim(),
      email: '',
      loginType: defaultLoginType.value,
      messageType: '',
    );
  }

  Future<bool> verifyEmailOtp(String otp) async {
    final result = await verifyOTP(
      type: AppStrings.otpTypeEmail,
      otp: otp,
      mobile: mobileController.text.trim(),
      email: emailController.text.trim(),
    );
    if (result) {
      enteredEmailOtp = otp;
      isEmailOtpVerified = true;
      notifyListeners();
      await checkIfAllComplete();
    }
    return result;
  }

  Future<bool> verifyMobileOtp(String otp) async {
    final result = await verifyOTP(
      type: AppStrings.otpTypeMobile,
      otp: otp,
      mobile: mobileController.text.trim(),
      email: emailController.text.trim(),
    );
    if (result) {
      enteredMobileOtp = otp;
      isMobileOtpVerified = true;
      notifyListeners();
      await checkIfAllComplete();
    }

    return result;
  }

  Future<bool> verifyBankMobileOtp(String otp) async {
    final result = await verifyOTP(
      type: AppStrings.otpTypeMobile,
      otp: otp,
      mobile: mobileController.text.trim(),
      email: '',
    );
    if (result) {
      notifyListeners();
    }
    return result;
  }

  Future<void> updateEmailRelationship(
    int? selectedId,
    FluffyRecordset? selectedValue,
  ) async {
    selectedEmailRelationshipId = selectedId!;
    selectedEmailRelationship = selectedValue;
    emailRelationshipError = false;
    notifyListeners();
    await checkIfAllComplete();
  }

  Future<void> updateMobileRelationship(
    int? selectedId,
    FluffyRecordset? selectedValue,
  ) async {
    selectedMobileRelationshipId = selectedId!;
    selectedMobileRelationship = selectedValue;
    mobileRelationshipError = false;
    notifyListeners();
    await checkIfAllComplete();
  }

  Future<void> checkIfAllComplete() async {
    if (isDigioNavigationInProgress) return;

    // Validate relationships first
    emailRelationshipError = selectedEmailRelationshipId == -1;
    mobileRelationshipError = selectedMobileRelationshipId == -1;
    notifyListeners();

    if (emailRelationshipError || mobileRelationshipError) {
      return;
    }

    // Then check OTP verification
    if (!isEmailOtpVerified || !isMobileOtpVerified) {
      return;
    }

    isDigioNavigationInProgress = true;
    try {
      final holderState = Map<String, dynamic>.from(
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
            {},
      );

      final updatedRegistration = {
        ...holderState,
        'emailRelation': selectedEmailRelationshipId,
        'mobileRelation': selectedMobileRelationshipId,
        'isemailVerified': isEmailOtpVerified,
        'ismobileVerified': isMobileOtpVerified,
        'emailOTP': enteredEmailOtp,
        'mobileOTP': enteredMobileOtp,
      };

      updateHolderState(updatedRegistration);
      final isDataInserted = await insertDataAPI();
      if (isDataInserted) {
        AppNavigator.popAndPush(AppRoutes.digioLoadingScreen);
      }
    } finally {
      isDigioNavigationInProgress = false;
    }
  }

  // Verify OTP
  Future<bool> verifyOTP({
    required String type,
    required String otp,
    required String mobile,
    required String email,
    String messageType = '',
  }) async {
    try {
      notifyListeners();
      final verifyOTPRequestPayload = {
        'type': type,
        'otp': otp,
        'mobile': mobile,
        'email': email,
      };

      // LogHelper.infoLog('VERIFY OTP PAYLOAD ::: $verifyOTPRequestPayload');
      final response = await authRepository.verifyOTP(
        verifyOTPRequestData: verifyOTPRequestPayload,
      );

      if (response?.statusCode != 200 || response?.data == null) {
        showErrorSnackBar(AppStrings.somethingWentWrong);
        return false;
      }

      final verifyOtpResponse = VerifyOtpResponseModel.fromJson(response!.data);

      // API Failure
      if (!verifyOtpResponse.success) {
        showErrorSnackBar(verifyOtpResponse.message);
        return false;
      }

      verifiedOTP = otp;
      if (verifyOtpResponse.allVerified) {
        if (verifyOtpResponse.token?.isNotEmpty == true) {
          // final getAccessToken = await appStorageHelper.getData(key: AppStrings.accessToken);
          // LogHelper.infoLog('EXISTING TOKEN:: $getAccessToken');
          // LogHelper.infoLog('NEW TOKEN:: ${verifyOtpResponse.token!}');
          await appStorageHelper.setData(
            key: AppStrings.accessToken,
            value: verifyOtpResponse.token!,
          );
        }

        await fetchExistingClientDetailsAPI();
      }

      return true;
    } catch (e) {
      LogHelper.errorLog("Verify OTP Exception: $e");
      showErrorSnackBar(AppStrings.somethingWentWrong);
      return false;
    } finally {
      notifyListeners();
      AppHelperWidgets.hideLoader();
    }
  }

  void showErrorSnackBar(String message) {
    AppHelperWidgets.showSnackBar(
      title: AppStrings.error,
      message: message,
      messageType: AppStrings.responseTypeError,
    );
  }

  // To CheckBanPanCard
  Future<void> checkBanPanCardAPI() async {
    // await getReferralCodeAPI();

    final registrationDetail = globalStateProvider.get<Map<String, dynamic>>(
      'RegistrationDetail',
    );

    final panDetails = globalStateProvider.get<Map<String, dynamic>>(
      'panDetails',
    );
    final referalData = globalStateProvider.get<Map<String, dynamic>>(
      'referalData',
    );
    final bool isSecondHolder =
        globalStateProvider.get<bool>('isSecondHolder') ?? false;
    final bool isThirdHolder =
        globalStateProvider.get<bool>('isThirdHolder') ?? false;
    final String panNo = panDetails!['panNumber']
        .toString()
        .trim()
        .toUpperCase();

    final newFormNumber = globalStateProvider.get<int>('formNumber');
    final String branchId =
        referalData?['Branch']?.toString() ??
        referralData?.data?.branchId?.toString() ??
        '16';

    final String userType = !isSecondHolder && !isThirdHolder
        ? AppStrings.firstHolder
        : (referalData?['UserType']?.toString() ??
              referralData?.data?.userType?.toString() ??
              'C');

    isPanVerificationInProgress = true;
    notifyListeners();

    final duplicateCheck = isPanDuplicateAcrossHolders(panNo);

    if (duplicateCheck.isDuplicate) {
      isPanVerificationInProgress = false;
      notifyListeners();

      AppHelperWidgets.showSnackBar(
        title: AppStrings.warning,
        message: duplicateCheck.message ?? AppStrings.duplicatePANdetected,
        messageType: AppStrings.responseTypeWarning,
      );
      return;
    }

    String subCategory =
        registrationDetail?['accountSubCategory']?.toString() ?? '';
    if (registrationDetail?['loginType']?.toString() == '1') {
      subCategory = '8';
    }

    if (!validatePanBySubCategory(panNo, subCategory)) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.incorrectPAN,
        message:
            'The entered PAN does not match the selected account type (${AppStrings.panTypeValidationMessages[subCategory]}). Please verify and try again.',
        messageType: AppStrings.responseTypeWarning,
      );

      isPanVerificationInProgress = false;
      notifyListeners();
      return;
    }

    /// ------------------------------
    /// Minor Validation
    /// ------------------------------
    ///
    ///

    // final String dob = _isExistingUser ? (panDetails?['dob']?.toString() ?? '') : panDobController.text.trim();
    // final String dob = _isExistingUser ?  panDetails?['dob']?.toString() ?? '': panDobController.text.trim();

    // LogHelper.infoLog('DOB FROM PAN DETAILS ::: $dob');

    // if (dob.isNotEmpty) {
    //   final parts = dob.split('-');

    //   if (parts.length == 3) {
    //     final int year = int.parse(parts[2]);

    //     // Make DOB 18 years newer so the user becomes a minor.
    //     finalDOb = '${parts[0]}-${parts[1]}-${year + 18}';
    //   }
    // }

    // LogHelper.infoLog('Original DOB : ${panDetails?['dob']}');
    // LogHelper.infoLog('Modified DOB : $finalDOb');
    // LogHelper.infoLog('Is Minor : ${AppHelperWidgets.isUserMinor(finalDOb)}');

    if (!isSecondHolder &&
        !isThirdHolder &&
        dob != null &&
        AppHelperWidgets.isUserMinor(dob)) {
      // LogHelper.infoLog('Minor POPUp ::: DOB : $finalDOb');
      AlertBoxWithSingleCenterBtnWidget.show(
        AppNavigator.navigatorKey.currentContext!,
        title: AppStrings.wrongMinorEntry,
        bodyWidget: const Text(AppStrings.minorPANEntered),
        primaryButtonText: AppStrings.okContinue,
        onPrimaryButtonTap: () async {
          AppNavigator.pop();
          await deleteFormDetailsForMinorAndOnlyDematCasesAPI(
            panNumber: panNo,
            formNumber: newFormNumber!,
            deleteReason: AppStrings.wrongMinorEntry,
          );
        },
      );

      isPanVerificationInProgress = false;
      notifyListeners();
      return;
    }

    try {
      final response = await authRepository.checkBanPanCard(
        panNo: panNo,
        branchId: branchId,
        userType: userType,
      );
      if (response == null || response.statusCode != 200) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final bool isSuccess = data['success'] == true;
      if (!isSuccess) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: data['message']?.toString() ?? AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final recordsets = data['data']?['recordsets'] as List<dynamic>? ?? [];

      /// Case 1 : NRI Client Validation
      final nriValue = getRecordValue(recordsets, index: 2, key: '');
      final int nriFlag = int.tryParse(nriValue.toString()) ?? 0;
      isNRIClient = nriFlag > 0;
      globalStateProvider.setState({'isNRIClient': isNRIClient});
      notifyListeners();

      /// Case 2 : PAN Validation Error
      final String panMessage = getRecordValue(
        recordsets,
        index: 1,
        key: 'Message',
      );

      if (panMessage.isNotEmpty) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: panMessage,
        );
        return;
      }

      /// Case 3 : Main PAN Validation
      final mainRecord = getRecordMap(recordsets, index: 0);
      final String msg = mainRecord['Message']?.toString() ?? '';
      final String uniqueExists = mainRecord['UniqueExists']?.toString() ?? '';

      /// Case 3A : PAN Validation Success
      // LogHelper.infoLog('MSG EMPTY  ::: $msg');
      if (msg.isEmpty) {
        await newPanVerificationAPI();
        return;
      }

      // LogHelper.infoLog('MSG ONLY DEMAT  ::: $msg');

      /// Case 3B : Only Demat
      if (msg == AppStrings.onlyDemat) {
        isOnlyDemat = true;
        notifyListeners();

        final String accountOption =
            registrationDetail?['accountOption']?.toString() ?? '';
        final bool isSecondHolder =
            globalStateProvider.get<bool>('isSecondHolder') ?? false;
        final bool isThirdHolder =
            globalStateProvider.get<bool>('isThirdHolder') ?? false;

        if (!isSecondHolder &&
            !isThirdHolder &&
            (accountOption == '1' || accountOption == '2')) {
          AlertBoxWithSingleCenterBtnWidget.show(
            AppNavigator.navigatorKey.currentContext!,
            title: AppStrings.panDetailsAlreadyExists,
            bodyWidget: const Text(AppStrings.aTradingAccount),
            primaryButtonText: AppStrings.okContinue,
            onPrimaryButtonTap: () {
              AppNavigator.pop();

              // LogHelper.infoLog('PANNUMBER $panNo ::: FORMNUMBER :::$newFormNumber');
              deleteFormDetailsForMinorAndOnlyDematCasesAPI(
                panNumber: panNo,
                formNumber: newFormNumber!,
                deleteReason: AppStrings.onlyDemat,
              );
            },
          );
          return;
        }

        LogHelper.infoLog('UNIQUEE ::: $uniqueExists');

        /// Handle Unique Exists
        if (uniqueExists.isNotEmpty) {
          AlertBoxWithTwoBtnWidget.show(
            AppNavigator.navigatorKey.currentContext!,
            title: AppStrings.confirmation,
            bodyWidget: Text(uniqueExists),
            primaryButtonText: AppStrings.okContinue,
            secondaryButtonText: AppStrings.noCancel,
            onPrimaryButtonTap: () async {
              AppNavigator.pop();
              await newPanVerificationAPI();
            },
            onSecondaryButtonTap: () {
              AppNavigator.pop();
            },
          );

          return;
        }

        await newPanVerificationAPI();
        return;
      }

      // LogHelper.infoLog('MSGGG::: $msg');

      /// Case 3C : Pending Unique ID
      if (msg.contains(AppStrings.pendingForUniqueID)) {
        AlertBoxWithSingleCenterBtnWidget.show(
          AppNavigator.navigatorKey.currentContext!,
          title: AppStrings.confirmation,
          bodyWidget: Text(msg),
          primaryButtonText: AppStrings.continueButton,
          onPrimaryButtonTap: () async {
            AppNavigator.pop();
            isOnlyDemat = false;
            globalStateProvider.setState({'isOnlyDemat': false});
            await newPanVerificationAPI();
            notifyListeners();
          },
        );

        return;
      }

      /// Case 3D : Other Error Messages

      // LogHelper.infoLog('Other Error Messages ::: $msg');
      isOnlyDemat = false;
      isPanVerificationInProgress = false;
      globalStateProvider.setState({'isOnlyDemat': false});
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: msg,
        messageType: AppStrings.responseTypeError,
      );
      notifyListeners();
    } catch (e, stackTrace) {
      LogHelper.errorLog('checkBanPanCardAPI Exception: $e');
      LogHelper.errorLog(stackTrace.toString());

      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      isPanVerificationInProgress = false;
      AppHelperWidgets.hideLoader();
      notifyListeners();
    }
  }

  // Validate PAN
  bool validatePanBySubCategory(String? pan, String? subCategory) {
    if (pan == null || pan.length < 4) {
      return false;
    }

    final String fourthChar = pan[3].toUpperCase();

    switch (subCategory) {
      case '1': // HUF
        return fourthChar == 'H';

      case '2': // Corporate
        return fourthChar == 'F' || fourthChar == 'C';

      case '3': // Trust
        return fourthChar == 'T';

      case '5': // Minor
      case '6': // NRI
      case '7': // Multi Holder (Individual)
      case '8': // Individual
        return fourthChar == 'P';

      default:
        return true; // No restriction
    }
  }

  String? normalize(String? pan) {
    if (pan == null || pan.trim().isEmpty) {
      return null;
    }
    return pan.trim().toUpperCase();
  }

  // Check for Duplicate PAN
  CheckDuplicatePanModel isPanDuplicateAcrossHolders(String currentPan) {
    final firstHolderPanDetails = globalStateProvider.get<Map<String, dynamic>>(
      'panDetails',
    );

    // LogHelper.infoLog('First Holder PAN Details: $firstHolderPanDetails');
    final secondHolderDetails = globalStateProvider.get<Map<String, dynamic>>(
      'secondHolderDetails',
    );
    final thirdHolderDetails = globalStateProvider.get<Map<String, dynamic>>(
      'thirdHolderDetails',
    );
    final firstPan = normalize(firstHolderPanDetails?['panNumber']?.toString());
    final secondPan = normalize(
      (secondHolderDetails?['panDetails']
              as Map<String, dynamic>?)?['panNumber']
          ?.toString(),
    );

    final thirdPan = normalize(
      (thirdHolderDetails?['panDetails'] as Map<String, dynamic>?)?['panNumber']
          ?.toString(),
    );

    final pan = normalize(currentPan);

    final bool isSecondHolder =
        globalStateProvider.get<bool>('isSecondHolder') ?? false;
    final bool isThirdHolder =
        globalStateProvider.get<bool>('isThirdHolder') ?? false;

    // LogHelper.infoLog(
    //   'PAN Duplicate Check -> '
    //   'Current: $pan, '
    //   'First: $firstPan, '
    //   'Second: $secondPan, '
    //   'Third: $thirdPan',
    // );

    /// First Holder flow
    if (!isSecondHolder && !isThirdHolder) {
      if (pan != null && (pan == secondPan || pan == thirdPan)) {
        return CheckDuplicatePanModel(
          isDuplicate: true,
          message: AppStrings.panCanNotbeSame,
        );
      }
    }

    /// Second Holder flow
    if (isSecondHolder) {
      if (pan != null && (pan == firstPan || pan == thirdPan)) {
        return const CheckDuplicatePanModel(
          isDuplicate: true,
          message: AppStrings.secondHolderPanCanNotbeSameAsOthers,
        );
      }
    }

    /// Third Holder flow
    if (isThirdHolder) {
      if (pan != null && (pan == firstPan || pan == secondPan)) {
        return const CheckDuplicatePanModel(
          isDuplicate: true,
          message: AppStrings.thirdHolderPanCanNotbeSameAsOthers,
        );
      }
    }

    return const CheckDuplicatePanModel(isDuplicate: false);
  }

  Future<void> newPanVerificationAPI() async {
    // LogHelper.infoLog('NEW PAN API ');

    AppHelperWidgets.showLoader();
    final panDetails =
        globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};
    final panNo = panDetails['panNumber']?.toString() ?? '';

    final firstName = panDetails['firstName']?.toString() ?? '';
    final middleName = panDetails['middleName']?.toString() ?? '';
    final lastName = panDetails['lastName']?.toString() ?? '';

    final fullName = [
      firstName,
      middleName,
      lastName,
    ].where((e) => e.isNotEmpty).join(' ');
    final dob = panDetails['dob']?.toString() ?? '';
    final formatedDob = AppHelperWidgets.formatToDDSlashMMSlashYYYY(dob);

    final referralDataState =
        globalStateProvider.get<Map<String, dynamic>>('referalData') ?? {};
    final accountType = registrationDetail['accountType']?.toString() ?? '';

    final requestData = {
      'panNo': panNo,
      'name': accountType == '2' ? fullName : null,
      'firstName': accountType != '2' ? firstName : null,
      'middleName': accountType != '2' ? middleName : null,
      'lastName': accountType != '2' ? lastName : null,
      'fathername': middleName,
      'dob': formatedDob.toString(),
      'userId': referralDataState['userId'],
      'userType': referralDataState['UserType'] ?? '',
    };

    // LogHelper.infoLog('PAN VERIFICATION PAYLOAD :: $requestData');

    try {
      isPanVerificationInProgress = true;
      notifyListeners();

      final response = await authRepository.newPanVerification(
        requestData: requestData,
      );
      if (response == null || response.statusCode != 200) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      await handleNewPanVerificationResponse(response.data);
    } catch (e) {
      LogHelper.errorLog('newPanVerificationAPI Exception: $e');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: e.toString(),
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      isPanVerificationInProgress = false;
      notifyListeners();
      AppHelperWidgets.hideLoader();
    }
  }

  Future<void> handleNewPanVerificationResponse(dynamic response) async {
    if (response == null) {
      isPanVerificationInProgress = false;
      notifyListeners();
      return;
    }

    final bool isSuccess = response['success'] == true;
    final Map<String, dynamic>? out = response['data'] as Map<String, dynamic>?;

    final String responseCode = out?['response_Code']?.toString() ?? '';

    if (!isSuccess || responseCode != '1') {
      isPanVerificationInProgress = false;
      notifyListeners();

      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: out?['Message']?.toString() ?? AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
      return;
    }

    final List<dynamic> outputData = out?['outputData'] as List<dynamic>? ?? [];

    if (outputData.isEmpty) {
      isPanVerificationInProgress = false;
      notifyListeners();
      return;
    }

    final Map<String, dynamic> data = outputData.first as Map<String, dynamic>;

    final String panStatus = data['pan_status']?.toString() ?? '';
    final String seedingStatus = data['seeding_status']?.toString() ?? '';
    final String nameStatus = data['Name']?.toString() ?? '';
    final String dobStatus = data['Dob']?.toString() ?? '';

    // LogHelper.infoLog('PAN STATUS :: $panStatus');

    if (AppStrings.panStatusMessages.containsKey(panStatus)) {
      isPanVerificationInProgress = false;
      notifyListeners();
      AppHelperWidgets.showSnackBar(
        title: AppStrings.warning,
        message: AppStrings.panStatusMessages[panStatus]!,
        messageType: AppStrings.responseTypeWarning,
      );
      return;
    }

    if (panStatus == 'E') {
      final bool isNRI = globalStateProvider.get<bool>('isNRIClient') ?? false;
      if (!isNRI && (seedingStatus.isEmpty || seedingStatus == 'R')) {
        isPanVerificationInProgress = false;
        notifyListeners();

        AppHelperWidgets.showSnackBar(
          title: AppStrings.validationError,
          message: AppStrings.panNotSeededWithAadhar,
          messageType: AppStrings.responseTypeWarning,
        );
        return;
      }

      if (nameStatus != 'Y') {
        isNameEditable = true;
        isPanVerificationInProgress = false;
        notifyListeners();
        AppHelperWidgets.showSnackBar(
          title: AppStrings.validationError,
          message: AppStrings.nameDoesNotMatchPan,
          messageType: AppStrings.responseTypeWarning,
        );
        return;
      } else {
        final panDetails =
            globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};

        globalStateProvider.setState({
          'panDetails': {
            ...panDetails,
            'panNumber': panDetails['panNumber'],
            'firstName': panDetails['firstName'],
            'middleName': panDetails['middleName'],
            'lastName': panDetails['lastName'],
            'fullName': panDetails['fullName'],
            'dob': panDetails['dob'],
            'panImageOther': panDetails['panImageOther'],
          },
        });
      }

      if (dobStatus != 'Y') {
        isDobEditable = true;
        isPanVerificationInProgress = false;
        notifyListeners();
        AppHelperWidgets.showSnackBar(
          title: AppStrings.validationError,
          message: AppStrings.dobDoesNotMatchPan,
          messageType: AppStrings.responseTypeWarning,
        );
        return;
      } else {
        final panDetails =
            globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
        globalStateProvider.setState({
          'panDetails': {...panDetails, 'dob': panDetails['dob']},
        });
      }

      AppHelperWidgets.showSnackBar(
        title: AppStrings.success,
        message: AppStrings.panVerifiedSuccess,
        messageType: AppStrings.responseTypeSuccess,
      );

      isPanVerificationInProgress = false;
      notifyListeners();
      await fetchKRAAgencyDetails();
    }
  }

  // Fetch KRA Agency Details
  Future<void> fetchKRAAgencyDetails() async {
    try {
      final panDetails =
          globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
      final panNo = (panDetails['panNumber']?.toString() ?? '').toUpperCase();
      final dob = AppHelperWidgets.formatToDDSlashMMSlashYYYY(
        panDetails['dob']?.toString() ?? '',
      );

      final requestData = {
        'PanNo': panNo,
        'DateOfBirth': dob,
        'AgencyCode': kraAgencyCode,
      };
      final response = await authRepository.fetchKRAAgencyDetails(
        requestData: requestData,
      );
      if (response == null || response.statusCode != 200) {
        throw Exception();
      }
      final responseData = response.data as Map<String, dynamic>? ?? {};

      if ((responseData['success'] == true &&
          responseData['data'] != null &&
          responseData['data']['StatusCode'] == 200)) {
        await handleFetchKRAAgencyDetailsResponse(responseData);
      }
    } catch (e) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
      );
    } finally {
      AppHelperWidgets.hideLoader();
    }
  }

  // Original
  // handleFetchKRAAgencyDetailsResponse
  Future<void> handleFetchKRAAgencyDetailsResponse(dynamic responseData) async {
    // LogHelper.infoLog('KRA AGENCY DETAIL RESPONSE DATA ::: $responseData');
    if (responseData == null || responseData is! Map<String, dynamic>) {
      throw Exception();
    }

    /** ─────────────────────────────────────
   * Case 1: Read KRA Agency File
   * ─────────────────────────────────────*/
    kraAgencyFile = responseData['data']?['KRAAgencyFile']?.toString() ?? '';
    globalStateProvider.setState({
      'KRAAgencyResponse': {
        ...(Map<String, dynamic>.from(responseData['data']?['data'] ?? {})),
        'KRAAgencyFile': kraAgencyFile,
      },
    });
    notifyListeners();
    final rawKraData = responseData['data']?['data'];

    /** ─────────────────────────────────────
   * Case 2: Embedded KRA Error
   * ─────────────────────────────────────*/
    final hasKraError =
        rawKraData != null &&
        (rawKraData['Error'] != null ||
            rawKraData['error'] != null ||
            rawKraData['ERROR'] != null ||
            rawKraData['status']?.toString().toUpperCase() == 'ERROR');

    if (hasKraError) {
      LogHelper.errorLog('KRA response error');
      return;
    }

    /** ─────────────────────────────────────
   * Case 3: New KRA Customer
   * ─────────────────────────────────────*/
    if (rawKraData == null) {
      kraFlag = KRAAgencyFlagModel(
        holder: AppStrings.firstHolder,
        flag: AppStrings.newTxt,
      );
      globalStateProvider.setState({
        'KRAFlag': {
          'holder': AppStrings.firstHolder,
          'flag': AppStrings.newTxt,
        },
      });
      notifyListeners();
      return;
    }

    // LogHelper.infoLog('HANDLE FETCH KRA AGENCY::: $responseData');
    final parsed = FetchKraAgencyDetailModels.fromJson(
      Map<String, dynamic>.from(responseData),
    );
    // LogHelper.infoLog('FETCH KRA AGENCY PARSED::: $parsed');
    kraAgencyDetails = parsed;
    globalStateProvider.setState({'KRAAgencyDetails': parsed});
    notifyListeners();

    final data = parsed.data?.data;
    final appStatus = data?.appStatus?.toString() ?? '';
    final appUpdateStatus = data?.appUpdtStatus?.toString() ?? '';
    final kraName = data?.appName?.trim() ?? '';

    final panDetails = globalStateProvider.get<Map<String, dynamic>>(
      'panDetails',
    );
    final panFirstName = panDetails?['firstName']?.toString().trim() ?? '';
    final panMiddleName = panDetails?['middleName']?.toString().trim() ?? '';
    final panLastName = panDetails?['lastName']?.toString().trim() ?? '';
    final panFullName = panDetails?['fullName']?.toString().trim() ?? '';

    final panName = panFullName.isNotEmpty
        ? panFullName
        : [
            panFirstName,
            panMiddleName,
            panLastName,
          ].where((e) => e.isNotEmpty).join(' ');

    final loginType = defaultLoginType;
    final isFirstHolder =
        (kraFlag?.holder ?? AppStrings.firstHolder) == AppStrings.firstHolder;

    /** ─────────────────────────────────────
   * Case 4: New KRA / Redirect To Address
   * ─────────────────────────────────────*/
    if (appStatus == '005' ||
        (appStatus.length > 1 &&
            (appStatus.substring(1) == '13' ||
                appStatus.substring(1) == '02')) ||
        kraName.isEmpty) {
      kraFlag = KRAAgencyFlagModel(
        holder: AppStrings.firstHolder,
        flag: AppStrings.newTxt,
      );
      globalStateProvider.setState({
        'KRAFlag': {
          'holder': AppStrings.firstHolder,
          'flag': AppStrings.newTxt,
        },
      });

      globalStateProvider.setState({'panVerified': true});
      setKRADetailsToState(
        agencyCode: kraAgencyCode,
        agencyFile: kraAgencyFile,
      );
      notifyListeners();

      if (parsed.success == true && parsed.data?.data != null) {
        AppNavigator.push(AppRoutes.presentAddressInfoScreen);
      }
      return;
    }

    /** ─────────────────────────────────────
   * Case 5: KRA Modification Required
   * appUpdateStatus != 07
   * ─────────────────────────────────────*/
    if (appUpdateStatus.isNotEmpty && appUpdateStatus.substring(1) != '07') {
      if (loginType == '1' && isFirstHolder) {
        setKRADetailsToState(
          agencyCode: kraAgencyCode,
          agencyFile: kraAgencyFile,
        );
        await fetchKRADetails(
          agencyCode: kraAgencyCode,
          kraAgencyFile: kraAgencyFile,
        );
      } else {
        kraResult = KRAResultModel(
          type: 'kraModification',
          message: AppStrings.kraModification,
        );
        notifyListeners();
      }

      return;
    }

    /** ─────────────────────────────────────
   * Case 6: Blank Update Status
   * appStatus != 07
   * ─────────────────────────────────────*/
    if (appUpdateStatus.isEmpty &&
        appStatus.length > 1 &&
        appStatus.substring(1) != '07') {
      LogHelper.infoLog('Update Status Blank');

      if (loginType == '1' && isFirstHolder) {
        setKRADetailsToState(
          agencyCode: kraAgencyCode,
          agencyFile: kraAgencyFile,
        );
        await fetchKRADetails(
          agencyCode: kraAgencyCode,
          kraAgencyFile: kraAgencyFile,
        );
      } else {
        kraResult = KRAResultModel(
          type: 'kraModification',
          message: AppStrings.kraModification,
        );
        notifyListeners();
      }

      return;
    }

    /** ─────────────────────────────────────
   * Case 7: KRA Name Mismatch
   * ─────────────────────────────────────*/
    if (kraName.toUpperCase() != panName.toUpperCase()) {
      if (loginType == '1' && isFirstHolder) {
        setKRADetailsToState(
          agencyCode: kraAgencyCode,
          agencyFile: kraAgencyFile,
        );
        await fetchKRADetails(
          agencyCode: kraAgencyCode,
          kraAgencyFile: kraAgencyFile,
        );
      } else {
        kraResult = KRAResultModel(
          type: 'nameMismatch',
          message: AppStrings.kraAndPassDontMatch,
        );
        notifyListeners();
      }

      return;
    }

    /** ─────────────────────────────────────
   * Case 8: KRA Validation Success
   * ─────────────────────────────────────*/
    setKRADetailsToState(agencyCode: kraAgencyCode, agencyFile: kraAgencyFile);
    await fetchKRADetails(
      agencyCode: kraAgencyCode,
      kraAgencyFile: kraAgencyFile,
    );
  }

  //setKRADetailsToState

  void setKRADetailsToState({
    required String? agencyCode,
    required String? agencyFile,
    String? kraFile,
  }) {
    final Map<String, dynamic> data = {
      'agencyCode': agencyCode,
      'KRAAgencyFile': agencyFile,
    };
    if (kraFile != null && kraFile.isNotEmpty) {
      data['KRAFile'] = kraFile;
    }
    globalStateProvider.setState({'KRAAgency': data});
    // LogHelper.infoLog('KRAAgency saved to GlobalState :: $data');
  }

  // Fetch KRA Details
  Future<void> fetchKRADetails({
    required String agencyCode,
    required String kraAgencyFile,
  }) async {
    final panDetails = globalStateProvider.get<Map<String, dynamic>>(
      'panDetails',
    );

    final String panNo = panDetails?['panNumber']?.toString() ?? '';
    final String dob = AppHelperWidgets.formatToDDSlashMMSlashYYYY(
      panDetails?['dob']?.toString() ?? '',
    );

    final Map<String, dynamic> requestData = {
      'PanNo': panNo,
      'DateOfBirth': dob,
      'AgencyCode': agencyCode,
    };

    try {
      final response = await authRepository.fetchKRADetails(
        requestData: requestData,
      );

      if (response == null || response.statusCode != 200) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      if (response.statusCode == 200 && response.data != null) {
        LogHelper.infoLog('fetchKRADetailsResponse Data: ${response.data}');
        await handleFetchKRADetailsResponse(
          response.data,
          agencyCode,
          kraAgencyFile,
        );
      }
    } catch (e) {
      LogHelper.errorLog('fetchKRADetails Exception: $e');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    }
  }

  // Handle KRA Details
  Future<void> handleFetchKRADetailsResponse(
    dynamic responseData,
    String agencyCode,
    String kraAgencyFile,
  ) async {
    LogHelper.infoLog('handleFetchKRADetailsResponse: $responseData');
    /** ─────────────────────────────────────
   * Case 1: Null Response
   * ─────────────────────────────────────*/
    if (responseData == null) {
      return;
    }

    LogHelper.infoLog('fetchKRADetailsResponse: $responseData');
    final bool isSuccess = responseData['success'] == true;
    LogHelper.infoLog('fetchKRADetails isSuccess: $isSuccess');

    /** ─────────────────────────────────────
   * Case 2: API Failure
   * ─────────────────────────────────────*/
    if (!isSuccess) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message:
            responseData['message']?.toString() ??
            AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
      return;
    }

    /** ─────────────────────────────────────
   * Case 3: Successful Response
   * ─────────────────────────────────────*/
    if (responseData['data'] != null) {
      try {
        final kraDetailsResponse = FetchKraDetailsModels.fromJson(
          Map<String, dynamic>.from(responseData),
        );

        if (kraDetailsResponse.success &&
            kraDetailsResponse.data.statusCode == 200) {
          kraDetails = kraDetailsResponse;

          LogHelper.infoLog('KRA FILE :: ${kraDetails?.data?.kraFile}');
          final kraFile = kraDetailsResponse.data?.kraFile ?? '';
          globalStateProvider.setState({
            'KRAResponse': {
              ...(responseData['data'] ?? {}),
              'KRAFile': kraFile,
            },
          });
          setKRADetailsToState(
            agencyCode: agencyCode,
            agencyFile: kraAgencyFile,
            kraFile: kraFile,
          );
          kraFlag = KRAAgencyFlagModel(
            holder: AppStrings.firstHolder,
            flag: AppStrings.modifyTxt,
          );
          globalStateProvider.setState({
            'KRAFlag': {
              'holder': AppStrings.firstHolder,
              'flag': AppStrings.modifyTxt,
            },
          });

          final appType = kraDetailsResponse.data?.data.appType;
          if (appType == 'N') {
            globalStateProvider.setState({'isNonIndividualAccount': true});
          }
          notifyListeners();
          LogHelper.infoLog('KRA Details Loaded Successfully');
        } else {
          /// KRA Flag = New
          kraFlag = KRAAgencyFlagModel(
            holder: AppStrings.firstHolder,
            flag: AppStrings.newTxt,
          );
          globalStateProvider.setState({
            'KRAFlag': {
              'holder': AppStrings.firstHolder,
              'flag': AppStrings.newTxt,
            },
          });

          notifyListeners();

          // Read documents
          // arrDocuments = kraDetailsResponse.data?.documents ?? [];

          LogHelper.infoLog('KRA Details Loaded Successfully');
        }
      } catch (e) {
        LogHelper.errorLog('Error parsing KRA Details: $e');
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      return;
    }

    /** ─────────────────────────────────────
   * Case 4: Success But Empty Data
   * ─────────────────────────────────────*/
    LogHelper.infoLog('fetchKRADetails Success But Data Is Empty');
  }

  String getRecordValue(
    List<dynamic> recordsets, {
    required int index,
    required String key,
  }) {
    if (recordsets.length <= index) return '';
    final record = recordsets[index] as List<dynamic>? ?? [];
    if (record.isEmpty) return '';
    return record[0][key]?.toString() ?? '';
  }

  Map<String, dynamic> getRecordMap(
    List<dynamic> recordsets, {
    required int index,
  }) {
    if (recordsets.length <= index) return {};
    final record = recordsets[index] as List<dynamic>? ?? [];
    if (record.isEmpty) return {};
    return Map<String, dynamic>.from(record[0] as Map? ?? {});
  }

  // Delete For MinorAndOnlyDematCases
  Future<void> deleteFormDetailsForMinorAndOnlyDematCasesAPI({
    required String panNumber,
    required int formNumber,
    required String deleteReason,
  }) async {
    try {
      AppHelperWidgets.showLoader();
      final String ocrPanNo = panNumber;
      final int ocrFormNo = formNumber;
      final response = await authRepository
          .deleteFormDetailsForMinorAndOnlyDematCases(
            ocrPanNo: ocrPanNo,
            ocrFormNo: ocrFormNo,
            deleteReason: deleteReason,
          );

      if (response == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final responseData = response.data;
      final bool isSuccess = responseData?['success'] == true;
      final int returnValue =
          responseData?['data']?['output']?['return_Value'] ?? -1;

      if (isSuccess && returnValue == 0) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.success,
          message: AppStrings.entryDeletedSuccessfully,
          messageType: AppStrings.responseTypeSuccess,
        );

        // LogHelper.infoLog('Minor User Deleted Successfully. Redirecting to Login Screen.');
        AppNavigator.clearAndGo(AppRoutes.loginScreen);
      } else {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
      }
    } catch (e, stackTrace) {
      LogHelper.errorLog(
        'deleteFormDetailsForMinorAndOnlyDematCases Exception: $e',
      );
      LogHelper.errorLog(stackTrace.toString());
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: e.toString().replaceFirst('Exception: ', ''),
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      AppHelperWidgets.hideLoader();
    }
  }

  void updateHolderState(Map<String, dynamic> updatedRegistration) {
    globalStateProvider.setState({'RegistrationDetail': updatedRegistration});
    // LogHelper.infoLog('RegistrationDetail updated :: $updatedRegistration');
  }

  // saveRegistrationDetail
  void saveRegistrationDetail() {
    final referralCode = referralController.text.trim();

    final registrationDetail = {
      'loginType': int.tryParse(defaultLoginType.value) ?? 1,
      'accountType': accountType,
      'accountOption': accountOption,
      'accountSubCategory': accountSubCategory,
      'mobile': mobileController.text.trim(),
      'email': emailController.text.trim(),
      'referalCode': referralCode.isNotEmpty ? referralCode : null,
    };

    globalStateProvider.setState({'RegistrationDetail': registrationDetail});
  }

  // InsertData Api
  Future<bool> insertDataAPI() async {
    final registrationDetail = Map<String, dynamic>.from(
      globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ?? {},
    );

    final referralDataState =
        globalStateProvider.get<Map<String, dynamic>>('referalData') ?? {};

    final staticDataState =
        globalStateProvider.get<Map<String, dynamic>>('staticData') ?? {};
    final newClientData =
        (staticDataState['clientData'] as List?)?.isNotEmpty == true
        ? staticDataState['clientData'].first as FluffyRecordset
        : null;

    // LogHelper.infoLog('RegistrationDetail: $registrationDetail');

    final Map<String, dynamic> requestData = {
      ...registrationDetail,
      'loginType': int.tryParse(defaultLoginType.value) ?? 1,
      'accountType': newClientData?.accountType ?? 0,
      'accountOption': newClientData?.accountOption ?? 0,
      'accountSubCategory': newClientData?.accountSubCategory,
      'ocrMode': AppStrings.insert,
      'ocrStageFlag': '',
      'ocrHolder': AppStrings.firstHolder,
      'ocrBranch': referralDataState['Branch'],
      'ocrGroup': referralDataState['Group'],
      'ocrEmployee':
          referralDataState['EmployeeCode'] ?? referralDataState['userId'],
      'ocrUserType': referralDataState['UserType'],
      'ocrEmployeeId': referralDataState['EmployeeCode'],
      'ocrEasyPartnerId': referralDataState['EasyPartnerId'],
      'referalCode': referralDataState['referalCode'] ?? '',
      'ocrReferralCode': referralDataState['referalCode'] ?? '',
    };

    // LogHelper.infoLog('Insert DATA PAYLOAD:: $requestData');

    try {
      isInsertDataLoading = true;
      notifyListeners();
      final response = await authRepository.insertDataRepo(
        requestData: requestData,
      );
      if (response != null && response.statusCode == 200) {
        final responseData = response.data;

        if (responseData != null && responseData is Map<String, dynamic>) {
          final bool isSuccess = responseData['success'] == true;
          final data = responseData['data'] as Map<String, dynamic>?;
          final output = data?['output'] as Map<String, dynamic>?;
          final String message =
              output?['return_Message']?.toString() ??
              AppStrings.somethingWentWrong;
          formNo =
              int.tryParse(output?['return_FormNo']?.toString() ?? '') ?? 0;
          globalStateProvider.setState({'formNumber': formNo});
          final int returnValue =
              int.tryParse(output?['return_Value']?.toString() ?? '') ?? -1;
          if (isSuccess && output != null && returnValue == 0) {
            AppHelperWidgets.showSnackBar(
              title: AppStrings.success,
              message: message,
              messageType: AppStrings.responseTypeSuccess,
            );
            return true;
          } else {
            LogHelper.infoLog('Error block executed');
            AppHelperWidgets.showSnackBar(
              title: AppStrings.error,
              message: message,
              messageType: AppStrings.responseTypeError,
            );

            return false;
          }
        }
      }
    } on DioException catch (e) {
      LogHelper.errorLog('Insert Data Exception: $e');
      final message =
          e.response?.data?['data']?['output']?['return_Message']?.toString() ??
          e.response?.data?['message']?.toString() ??
          e.message ??
          AppStrings.somethingWentWrong;

      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: message,
        messageType: AppStrings.responseTypeError,
      );

      return false;
    } finally {
      isInsertDataLoading = false;
      notifyListeners();
      AppHelperWidgets.hideLoader();
    }

    AppHelperWidgets.showSnackBar(
      title: AppStrings.error,
      message: AppStrings.somethingWentWrong,
      messageType: AppStrings.responseTypeError,
    );

    return false;
  }

  // insertAddressInfoAPI
  Future<bool> insertAddressInfoAPI() async {
    final panDetails = globalStateProvider.get<Map<String, dynamic>>(
      'panDetails',
    );
    final aadhaarDetails = globalStateProvider.get<Map<String, dynamic>>(
      'aadharDetails',
    );

    final kraResponse = globalStateProvider.get<Map<String, dynamic>>(
      'KRAResponse',
    );
    final kraAgencyResponse = globalStateProvider.get<Map<String, dynamic>>(
      'KRAAgencyResponse',
    );

    final Map<String, dynamic>? kraAgency = globalStateProvider
        .get<Map<String, dynamic>>('KRAAgency');

    final Map<String, dynamic>? kraFlag = globalStateProvider
        .get<Map<String, dynamic>>('KRAFlag');

    final String? kraFile = kraResponse?['KRAFile']?.toString();

    final String? kraAgencyFile = kraAgencyResponse?['KRAAgencyFile']
        ?.toString();
    final int? newCorrPerAddressFlag = globalStateProvider.get<int>(
      'corrPerAddressFlag',
    );

    final String kraMode = kraFlag?['flag']?.toString() ?? '';
    final String kraName = kraResponse?['APP_NAME']?.toString() ?? '';
    final String kraNo = kraResponse?['KRANo']?.toString() ?? '';
    final String? kraDate =
        (kraFlag?['flag']?.toString() == AppStrings.modifyTxt)
        ? (kraAgencyResponse?['APP_STATUSDT']?.toString() ?? '')
        : null;

    final String kraAgencyCode = kraAgency?['agencyCode']?.toString() ?? '';

    final panNumber = panDetails?['panNumber'] ?? '';
    final panDob = panDetails?['dob'] ?? '';
    final panFirstName = panDetails?['firstName'] ?? '';
    final panMiddleName = panDetails?['middleName'] ?? '';
    final panLastName = panDetails?['lastName'] ?? '';

    final Map<String, dynamic> currentAddress =
        (aadhaarDetails?['currentAddress'] as Map<String, dynamic>?) ?? {};
    final String currentAddressText =
        currentAddress['address']?.toString().toUpperCase() ?? '';

    final Map<String, dynamic> permanentAddress =
        (aadhaarDetails?['permanentAddress'] as Map<String, dynamic>?) ?? {};

    final String fullPermAddressText =
        permanentAddress['address']?.toString().toUpperCase() ?? '';

    final ocrCurrAddress1 = currentAddressText.length > 36
        ? currentAddressText.substring(0, 36)
        : currentAddressText.length;

    final ocrCurrAddress2 = currentAddressText.length > 36
        ? currentAddressText.substring(
            36,
            currentAddressText.length > 72 ? 72 : currentAddressText.length,
          )
        : '';

    final ocrCurrAddress3 = currentAddressText.length > 72
        ? currentAddressText.substring(
            72,
            currentAddressText.length > 108 ? 108 : currentAddressText.length,
          )
        : '';

    final String ocrPermAddress1 = fullPermAddressText.length > 36
        ? fullPermAddressText.substring(0, 36)
        : fullPermAddressText;

    final String ocrPermAddress2 = fullPermAddressText.length > 36
        ? fullPermAddressText.substring(
            36,
            fullPermAddressText.length > 72 ? 72 : fullPermAddressText.length,
          )
        : '';

    final String ocrPermAddress3 = fullPermAddressText.length > 72
        ? fullPermAddressText.substring(
            72,
            fullPermAddressText.length > 108 ? 108 : fullPermAddressText.length,
          )
        : '';

    final String currentState =
        aadhaarDetails?['currentAddress']?['state']?.toString() ?? '';
    final String currentCountry =
        aadhaarDetails?['currentAddress']?['country']?.toString() ?? 'India';
    final int ocrCountry =
        countryList
            .firstWhereOrNull(
              (e) => e.name.toUpperCase() == currentCountry.toUpperCase(),
            )
            ?.id ??
        1;

    final int ocrState =
        stateList
            .firstWhereOrNull(
              (e) => e.name.toUpperCase() == currentState.toUpperCase(),
            )
            ?.id ??
        0;

    final String octCurrPinCode =
        aadhaarDetails?['currentAddress']?['pincode']?.toString() ?? '';

    final int ocrCity =
        int.tryParse(
          pinCodeList
                  .firstWhereOrNull(
                    (e) => e.name.trim() == octCurrPinCode.trim(),
                  )
                  ?.cityId ??
              '0',
        ) ??
        0;

    final int ocrCorrPinCode =
        pinCodeList
            .firstWhereOrNull((e) => e.name.trim() == octCurrPinCode.trim())
            ?.id ??
        0;

    final int perCountry =
        countryList.firstWhereOrNull((e) => e.id == 1)?.id ?? 1;
    final int perState =
        stateList
            .firstWhereOrNull(
              (e) =>
                  e.name.toUpperCase() ==
                  (aadhaarDetails?['permanentAddress']?['state']
                          ?.toString()
                          .toUpperCase() ??
                      ''),
            )
            ?.id ??
        0;

    final int perCity =
        int.tryParse(
          pinCodeList
                  .firstWhereOrNull(
                    (e) =>
                        e.name.trim() ==
                        (aadhaarDetails?['permanentAddress']?['pincode']
                                ?.toString()
                                .trim() ??
                            ''),
                  )
                  ?.cityId ??
              '0',
        ) ??
        0;

    final int perPinCode =
        pinCodeList
            .firstWhereOrNull(
              (e) =>
                  e.name.trim() ==
                  (aadhaarDetails?['permanentAddress']?['pincode']
                          ?.toString()
                          .trim() ??
                      ''),
            )
            ?.id ??
        0;

    final formattedDob = AppHelperWidgets.formatToYYYYMMDD(panDob!);
    final digiLockerResponse = digioProvider?.fetchDigiLockerResponse;
    final int? formNumber = globalStateProvider.get<int>('formNumber');

    // PAN PDF
    if (digiLockerResponse?.panPdf?.isNotEmpty == true) {
      arrDocuments.add({
        'agHolder': AppStrings.firstHolder,
        'agDocType': null,
        'agDocName': 'Pan',
        'agImageType': 'application/pdf',
        'agImage': digiLockerResponse!.panPdf,
      });
    }

    // PAN Image
    if (digiLockerResponse?.panImage?.isNotEmpty == true) {
      arrDocuments.add({
        'agHolder': AppStrings.firstHolder,
        'agDocType': null,
        'agDocName': 'Pan',
        'agImageType': 'image/jpeg',
        'agImage': digiLockerResponse!.panImage,
      });
    }

    // Aadhaar PDF
    if (digiLockerResponse?.aadharPdf?.isNotEmpty == true) {
      arrDocuments.add({
        'agHolder': AppStrings.firstHolder,
        'agDocType': null,
        'agDocName': 'AddressProof',
        'agImageType': 'application/pdf',
        'agImage': digiLockerResponse!.aadharPdf,
      });

      arrDocuments.add({
        'agHolder': AppStrings.firstHolder,
        'agDocType': null,
        'agDocName': 'IdentityProof',
        'agImageType': 'application/pdf',
        'agImage': digiLockerResponse.aadharPdf,
      });
    }

    // Aadhaar XML
    if (digiLockerResponse?.aadharXml?.isNotEmpty == true) {
      arrDocuments.add({
        'agHolder': AppStrings.firstHolder,
        'agDocType': null,
        'agDocName': 'DigiLockerXML',
        'agImageType': 'application/xml',
        'agImage': digiLockerResponse!.aadharXml,
      });
    }

    final finalCurrentAddress = aadhaarDetails?['currentAddress'];
    final finalPermanentAddress = aadhaarDetails?['permanentAddress'];

    final Map<String, dynamic> requestData = {
      'ocrStageFlag': AppStrings.digiLocker,
      'ocrHolder': AppStrings.firstHolder,
      'ocrCorrAddress1': ocrCurrAddress1,
      'ocrCorrAddress2': ocrCurrAddress2,
      'ocrCorrAddress3': ocrCurrAddress3,
      'ocrCorrAddress4': '',
      'ocrCorrCountry': ocrCountry,
      'ocrCorrState': ocrState,
      'ocrCorrCity': ocrCity,
      'ocrCorrPinCode': ocrCorrPinCode,
      'ocrCorrAddressProof': ocrCorrAddressProof,
      'ocrPerAddressProof': ocrPerAddressProof,
      'ocrIdentityProof': ocrIdentityProof,
      'currentAddress': finalCurrentAddress,
      'permanentAddress': finalPermanentAddress,
      'ocrCorrPerAddressFlag': newCorrPerAddressFlag,
      'ocrPerAddress1': ocrPermAddress1,
      'ocrPerAddress2': ocrPermAddress2,
      'ocrPerAddress3': ocrPermAddress3,
      'ocrPerAddress4': '',
      'ocrPerCountry': perCountry,
      'ocrPerState': perState,
      'ocrPerCity': perCity,
      'ocrPerPinCode': perPinCode,
      'ocrIdentityNo': aadhaarDetails?['id_number'] ?? '',
      'ocrPerAddressProofNo': aadhaarDetails?['id_number'] ?? '',
      'ocrCorrAddressProofNo': aadhaarDetails?['id_number'] ?? '',
      'ocrPanNo': panNumber,
      'ocrDateOfBirth': formattedDob,
      'ocrFullName': null,
      'ocrFirstName': panFirstName,
      'ocrMiddleName': panMiddleName,
      'ocrLastName': panLastName,
      'ocrKRAMode': kraMode,
      'ocrKRAName': kraName,
      'ocrKRANo': kraNo,
      'ocrKRADate': kraDate,
      'ocrKRAAgency': kraAgencyCode,
      'ocrFormNo': formNumber.toString(),
      'documents': arrDocuments,
      'ocrKRADocumentType': 'application/json',
      'ocrKRADocument': kraFile,
      'ocrKRAAgencyDocumentType': 'application/json',
      'ocrKRAAgencyDocument': kraAgencyFile,
    };
    AppHelperWidgets.hideLoader();

    // LogHelper.infoLog('Insert ADDRESS PAYLOAD ::$requestData');
    try {
      final response = await authRepository.insertAddressInfo(
        requestData: requestData,
      );
      if (response == null || response.statusCode != 200) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: response!.data['message'].toString(),
          messageType: AppStrings.responseTypeError,
        );
        return false;
      }

      final data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return false;
      }

      final bool isSuccess = data['success'] == true;
      final output = data['data']?['output'] as Map<String, dynamic>?;
      final String message =
          output?['return_Message']?.toString() ??
          AppStrings.somethingWentWrong;

      final int returnValue =
          int.tryParse(output?['return_Value']?.toString() ?? '') ?? -1;
      if (isSuccess && output != null && returnValue == 0) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.success,
          message: message,
          messageType: AppStrings.responseTypeSuccess,
        );
        notifyListeners();
        globalStateProvider.setState({'addressConfirmed': true});
        appRouter.push(AppRoutes.personalInfoScreen);
        return true;
      } else {
        LogHelper.errorLog('PRESENT ADDRESS FAILED:::$message');
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: message,
          messageType: AppStrings.responseTypeError,
        );
        return false;
      }
    } catch (e, stackTrace) {
      LogHelper.errorLog('STACK TRACE :::${stackTrace.toString()}');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );

      return false;
    } finally {
      AppHelperWidgets.hideLoader();
    }
  }

  // To get PAN Details
  DigiLockerPan? getPanData() {
    try {
      return digioProvider?.fetchDigiLockerResponse?.data?.actions
          ?.firstWhere((action) => action.details?.pan != null)
          .details
          ?.pan;
    } catch (e) {
      LogHelper.errorLog('getPanData Exception: $e');
      return null;
    }
  }

  // To get Aadhar Details
  DigiLockerAadhaar? getAadhaarData() {
    try {
      return digioProvider?.fetchDigiLockerResponse?.data?.actions
          ?.firstWhere((action) => action.details?.aadhaar != null)
          .details
          ?.aadhaar;
    } catch (e) {
      LogHelper.errorLog('getAadhaarData Exception: $e');
      return null;
    }
  }

  // To Get PAN Details
  bool populatePanDetailsFromDigiLocker() {
    try {
      isPanVerificationInProgress = true;
      notifyListeners();
      final panData = getPanData();
      if (panData == null) {
        LogHelper.errorLog('PAN data not found in DigiLocker response');
        return false;
      }

      // LogHelper.infoLog('PAN DOB:${panData.dob}');

      final nameParts = (panData.name ?? '').trim().split(RegExp(r'\s+'));
      panNoController.text = panData.idNumber ?? '';
      fNameAsPanController.text = nameParts.isNotEmpty ? nameParts[0] : '';
      mNameAsPanController.text = nameParts.length > 2 ? nameParts[1] : '';
      lNameAsPanController.text = nameParts.length > 1 ? nameParts.last : '';
      panDobController.text = AppHelperWidgets.formatToDDMMYYYY(panData.dob);
      return true;
    } catch (e) {
      LogHelper.errorLog('populatePanDetailsFromDigiLocker Exception: $e');
      return false;
    } finally {
      isPanVerificationInProgress = false;
      notifyListeners();
    }
  }

  // To Get Aadhar Details
  bool populateAddressDetailsFromDigiLocker() {
    try {
      final aadhaarData = getAadhaarData();
      if (aadhaarData == null) {
        LogHelper.errorLog('Aadhaar data not found');
        return false;
      }

      final List<String> addressParts = (aadhaarData.currentAddress ?? '')
          .split(',')
          .map((e) => e.trim())
          .toList();

      final String fullAddress = addressParts.join(', ').toUpperCase();
      addressLine1Controller.text = fullAddress.length > 36
          ? fullAddress.substring(0, 36)
          : fullAddress;
      addressLine2Controller.text = fullAddress.length > 36
          ? fullAddress.substring(
              36,
              fullAddress.length > 72 ? 72 : fullAddress.length,
            )
          : '';
      addressLine3Controller.text = fullAddress.length > 72
          ? fullAddress.substring(
              72,
              fullAddress.length > 108 ? 108 : fullAddress.length,
            )
          : '';

      cityController.text =
          aadhaarData.currentAddressDetails?.districtOrCity?.toUpperCase() ??
          '';
      stateController.text =
          aadhaarData.currentAddressDetails?.state?.toUpperCase() ?? '';
      pinCodeController.text =
          aadhaarData.currentAddressDetails?.pincode?.toUpperCase() ?? '';
      countryController.text =
          countryList.firstWhereOrNull((e) => e.id == 1)?.name.toUpperCase() ??
          '';
      notifyListeners();
      return true;
    } catch (e) {
      LogHelper.errorLog('populateAddressDetailsFromDigiLocker Exception: $e');
      return false;
    }
  }

  // To Save Personal Info
  Future<bool> savePersonalInfoLocally() async {
    final fatherOrSpouseFirstName = fatherOrSpouceFirstNameController.text
        .trim();
    final fatherOrSpouseLastName = fatherOrSpouceLastNameController.text.trim();
    final motherFirstName = motherFirstNameController.text.trim();
    final motherLastName = motherLastNameController.text.trim();

    if (fatherOrSpouseFirstName.isEmpty ||
        fatherOrSpouseLastName.isEmpty ||
        motherFirstName.isEmpty ||
        motherLastName.isEmpty) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.required,
        messageType: AppStrings.responseTypeError,
      );
      return false;
    }

    personalInfoModel = PersonalInfoModel(
      relationType: selectedRelationType,
      fatherOrSpouseFirstName: fatherOrSpouseFirstName,
      fatherOrSpouseMiddleName: fatherOrSpouceMiddleController.text.trim(),
      fatherOrSpouseLastName: fatherOrSpouseLastName,
      motherFirstName: motherFirstName,
      motherMiddleName: motherMiddleNameController.text.trim(),
      motherLastName: motherLastName,
    );
    final personalDetails =
        globalStateProvider.get<Map<String, dynamic>>('personalDetails') ?? {};
    globalStateProvider.setState({
      'personalDetails': {
        ...personalDetails,
        'FamilyDetails': {
          'relationFlag': selectedRelationType,
          'fatherFirstName': fatherOrSpouseFirstName,
          'fatherMiddleName': fatherOrSpouceMiddleController.text.trim(),
          'fatherLastName': fatherOrSpouseLastName,
          'motherFirstName': motherFirstName,
          'motherMiddleName': motherMiddleNameController.text.trim(),
          'motherLastName': motherLastName,
        },
      },
    });
    // LogHelper.infoLog(
    //   'SET PERSONAL DETAILS :: '
    //   '${globalStateProvider.get<Map<String, dynamic>>('personalDetails')}',
    // );
    notifyListeners();
    AppNavigator.push(AppRoutes.selectOccupationScreen);
    return true;
  }

  String getUserType({required String? userTypeCode}) {
    final referralData =
        globalStateProvider.get<Map<String, dynamic>>('referalData') ?? {};
    final baseType =
        AppConstants.USER_TYPE_MAP[userTypeCode?.toLowerCase()] ?? '';
    if (baseType == 'Branch') {
      final braBranchCat = referralData['braBranchCat']?.toString();
      final braType = referralData['bratype']?.toString();

      return (braBranchCat == '0' && braType == '0')
          ? 'BranchOwn'
          : 'Branch Remisar';
    }

    return baseType;
  }

  //To get Segment Header
  String getHeaderForSegment(int ocrBusinessId) {
    for (final entry in AppConstants.SEGMENT_CONFIG.entries) {
      final ids = entry.value['ids'] as List<int>;

      if (ids.contains(ocrBusinessId)) {
        return entry.key;
      }
    }

    return '';
  }

  List<SegmentDataModel> loadSegmentsForUserType({
    required List<FluffyRecordset> allSegments,
    required String userType,
  }) {
    final filteredSegments = allSegments.where((segment) {
      final segmentUserType = segment.userType?.trim().toLowerCase() ?? '';
      return segmentUserType == userType.trim().toLowerCase() &&
          segment.ocrBusinessId != 63;
    }).toList();
    return filteredSegments.map((segment) {
      return SegmentDataModel(
        segment: segment,
        header: getHeaderForSegment(segment.ocrBusinessId ?? 0),
        selected: false,
      );
    }).toList();
  }

  void addSLBMSegmentIfExists() {
    final equitySegment = segments.firstWhereOrNull(
      (segment) => segment.segment.ocrBusinessId == 17,
    );
    if (equitySegment == null) {
      return;
    }
    if ((equitySegment.segment.slbmDescription ?? '').isEmpty) {
      return;
    }

    final slbmExists = segments.any((segment) => segment.isSLBM);
    if (!slbmExists) {
      segments.add(equitySegment.copyWith(header: 'SLBM', isSLBM: true));
    }
  }

  void updateAdditionalDetailsState() {
    final aadhaarData = getAadhaarData();
    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};
    final additionalDetails =
        globalStateProvider.get<Map<String, dynamic>>('additionalDetails') ??
        {};
    final accountSubCategory =
        int.tryParse(registrationDetail['accountSubCategory'].toString()) ?? 0;
    final noOfDocuments = clientData?.noOfDocumentsSubmitted;
    final cityId = pinCodeList
        .firstWhereOrNull(
          (e) =>
              e.name.trim() ==
              (aadhaarData?.currentAddressDetails?.pincode ?? '').trim(),
        )
        ?.cityId;

    final placeOfDeclaration =
        cityList.firstWhereOrNull((c) => c.id.toString() == cityId)?.name ??
        additionalDetails['placeOfDeclaration']?.toString() ??
        '';

    // cityList.firstWhereOrNull((c) => c.id.toString() == cityId)?.name;
    final selectedCountry =
        countryList.firstWhereOrNull((e) => e.id == 1)?.name.toUpperCase() ??
        '';

    final nsdlClientType = {
      'id': getNSDLClientType(),
      'name': clientData?.nsdlClientType,
    };
    final nsdlSubClientType = {
      'id': getNSDLSubClientType(),
      'name': clientData?.nsdlClientSubType,
    };

    if (isThirdHolderProcessing) {
    } else if (isSecondHolderProcessing) {
    } else {
      gstNumber = gstNumberController.text.trim() != ''
          ? gstNumberController.text.trim().toUpperCase()
          : '';

      globalStateProvider.setState({
        'additionalDetails': {
          'step': step,
          'selectedOccupation': selectedOccupation,
          'selectedIncome': selectedIncomeRange,
          'selectedCountry': selectedCountry,
          'selectedCity': selectedBirthCity,
          'selectedGender': selectedGender,
          'selectedResidentialStatus': selectedResidentialStatus,
          'selectedMaritalStatus': selectedMaritalStatus,
          'gstNo': gstNumber ?? '',
          'placeOfDeclaration': placeOfDeclaration,
          'noOfDocuments': noOfDocuments,
          'selectedNsdlClientType': nsdlClientType,
          'selectedNsdlSubClientType': nsdlSubClientType,
          'PEP': int.tryParse(selectedPEPNotifier.value),
          'SettlementCycle': int.tryParse(
            selectedSettlementCycleNotifier.value,
          ),
        },
      });
    }

    notifyListeners();
  }

  Future<void> loadSegmentTypes() async {
    await getReferralCodeAPI();

    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};

    final referralDataState =
        globalStateProvider.get<Map<String, dynamic>>('referalData') ?? {};
    final panDetails =
        globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
    final additionalDetailsState =
        globalStateProvider.get<Map<String, dynamic>>('additionalDetails') ??
        {};

    final newAccountOption = registrationDetail['accountOption'];
    final newAccountSubCategory = registrationDetail['accountSubCategory'];

    // LogHelper.infoLog('ACCOUNT OPTION :::$selectedAccountOption');
    // LogHelper.infoLog('ACCOUNT SUB CATEGORY  :::$selectedAccountOption');

    final userType = getUserType(
      userTypeCode: (referralDataState['UserType']?.toString() ?? '').isNotEmpty
          ? referralDataState['UserType'].toString()
          : '',
    );

    // LogHelper.infoLog('USERTYPE LOAD SEGMENT:: $userType');

    /// previousSelections
    final previousSelections =
        globalStateProvider.get<List<String>>('selectedSegmentIds') ?? [];
    // LogHelper.infoLog('PREVIOUS SELECTIONS :: $previousSelections');
    selectedSegmentIds
      ..clear()
      ..addAll(previousSelections);

    final isFirstVisit = previousSelections.isEmpty;
    additionalDetails = additionalDetailsState;
    dob = panDetails['dob'];
    final savedBrkConfirmed = globalStateProvider.get('brkConfirmed');
    isBrokerageChecked = savedBrkConfirmed == true || savedBrkConfirmed == 1;
    isSelectMarketSegmentNotifier.value = isBrokerageChecked;

    /// Step 1
    segments = loadSegmentsForUserType(
      allSegments: marketSegmentList,
      userType: userType,
    );

    /// Step 2
    addSLBMSegmentIfExists();

    /// Step 3
    if (isFirstVisit) {
      applyDefaultSelectionsBasedOnAccountType();
      syncSelectedSegmentIds();
    } else {
      normalizeSelectionsInState();
      final normalizedSelections =
          globalStateProvider.get<List<String>>('selectedSegmentIds') ?? [];
      restorePreviousSelections(normalizedSelections);
      syncSelectedSegmentIds();
    }

    /// Step 4
    segments = consolidateSegmentsForDisplay();

    /// Remove Currency (Flutter-specific)
    segments = segments
        .where((segment) => segment.header != 'Currency')
        .toList();

    /// Step 5
    organizeSegmentsIntoColumns();
    notifyListeners();
  }

  void syncSelectedSegmentIds() {
    selectedSegmentIds = segments
        .where((segment) => segment.selected)
        .map((segment) => segment.segment.ocrBusinessId?.toString())
        .whereType<String>()
        .toSet() // Prevent duplicate IDs
        .toList();

    globalStateProvider.setState({'selectedSegmentIds': selectedSegmentIds});
  }

  // To getHolderState
  Map<String, dynamic>? getHolderState(String key) {
    if (isThirdHolderProcessing) {
      return globalStateProvider.get<Map<String, dynamic>>(
        'thirdHolderDetails',
      )?[key];
    }

    if (isSecondHolderProcessing) {
      return globalStateProvider.get<Map<String, dynamic>>(
        'secondHolderDetails',
      )?[key];
    }

    return globalStateProvider.get<Map<String, dynamic>>(key);
  }

  void onSegmentSelectionChanged(
    SegmentDataModel segmentDataModel,
    bool selected,
  ) {
    final businessId = segmentDataModel.segment.ocrBusinessId?.toString();
    if (businessId == null || businessId.isEmpty) {
      return;
    }

    if (selected) {
      if (!selectedSegmentIds.contains(businessId)) {
        selectedSegmentIds.add(businessId);
      }
    } else {
      selectedSegmentIds.remove(businessId);
    }

    for (var i = 0; i < segments.length; i++) {
      if (segments[i].segment.ocrBusinessId?.toString() == businessId) {
        segments[i] = segments[i].copyWith(selected: selected);
      }
    }

    normalizeSelectionsInState();
    organizeSegmentsIntoColumns();
    notifyListeners();
  }

  void organizeSegmentsIntoColumns() {
    groupedSegments = {};
    for (final segmentDataModel in segments) {
      final header = segmentDataModel.header.isNotEmpty
          ? segmentDataModel.header
          : 'Other';

      /// Skip Currency
      if (header == 'Currency') {
        continue;
      }

      final isLeftColumn = AppConstants.LEFT_COLUMN_SEGMENTS.contains(header);

      if (!groupedSegments.containsKey(header)) {
        groupedSegments[header] = SegmentGroupModel(
          header: header,
          selected: segmentDataModel.selected,
          disabled: isLeftColumn,
          items: [],
        );
      }

      final existingGroup = groupedSegments[header]!;

      groupedSegments[header] = existingGroup.copyWith(
        items: [
          ...existingGroup.items,
          segmentDataModel.copyWith(disabled: isLeftColumn),
        ],
        selected: existingGroup.selected || segmentDataModel.selected,
      );
    }

    ensureMandatorySegmentsExist();
    final groupsArray = groupedSegments.values.toList();
    final sorted = sortSegmentGroups(groupsArray);
    groupedColumns = [
      sorted
          .where((g) => AppConstants.LEFT_COLUMN_SEGMENTS.contains(g.header))
          .toList(),
      sorted
          .where((g) => !AppConstants.LEFT_COLUMN_SEGMENTS.contains(g.header))
          .toList(),
    ];

    /// Apply account type rules LAST
    applyAccountTypeRules();
    notifyListeners();
  }

  void ensureMandatorySegmentsExist() {
    const mandatorySegments = ['NSDL', 'Equity', 'SLBM'];
    for (final header in mandatorySegments) {
      if (groupedSegments.containsKey(header)) {
        final existing = groupedSegments[header]!;
        groupedSegments[header] = existing.copyWith(
          selected: true,
          disabled: true,
        );
        continue;
      }
      groupedSegments[header] = SegmentGroupModel(
        header: header,
        selected: true,
        disabled: true,
        items: [
          SegmentDataModel(
            header: header,
            selected: true,
            disabled: true,
            isSLBM: header == 'SLBM',
            segment: FluffyRecordset(),
          ),
        ],
      );
    }
  }

  List<SegmentGroupModel> sortSegmentGroups(List<SegmentGroupModel> groups) {
    groups.sort((a, b) {
      final indexA = AppConstants.LEFT_COLUMN_SEGMENTS.indexOf(a.header);
      final indexB = AppConstants.LEFT_COLUMN_SEGMENTS.indexOf(b.header);

      if (indexA != -1 && indexB != -1) {
        return indexA - indexB;
      }

      if (indexA != -1) {
        return -1;
      }

      if (indexB != -1) {
        return 1;
      }
      return a.header.compareTo(b.header);
    });
    return groups;
  }

  void applyAccountTypeRules() {
    for (final entry in groupedSegments.entries) {
      final isDisabled = AppConstants.LEFT_COLUMN_SEGMENTS.contains(
        entry.value.header,
      );

      groupedSegments[entry.key] = entry.value.copyWith(
        disabled: isDisabled,
        items: entry.value.items
            .map((item) => item.copyWith(disabled: isDisabled))
            .toList(),
      );
    }
  }

  void restorePreviousSelections(List<dynamic> selectedIds) {
    // LogHelper.infoLog('Restoring selections: $selectedIds');

    final normalizedIds = selectedIds.map((e) => e.toString()).toSet();

    segments = segments.map((segment) {
      final businessId = segment.segment.ocrBusinessId?.toString();

      return segment.copyWith(
        selected:
            normalizedIds.contains(businessId) ||
            (segment.isSLBM && normalizedIds.contains('SLBM')) ||
            (segment.header == 'NSDL' && normalizedIds.contains('NSDL')),
      );
    }).toList();
  }

  void normalizeSelectionsInState() {
    // LogHelper.infoLog('ACCOUNT TYPE:: $accountType');

    final newAccountType = accountOption?.toString();
    final newAccountSubCategory = accountSubCategory?.toString();
    final isUserMinor = AppHelperWidgets.isUserMinor(dob);

    selectedSegmentIds = selectedSegmentIds.map((e) => e.toString()).toList();

    /// AccountSubCategory 5 -> Only Equity
    if (newAccountSubCategory == '5') {
      selectedSegmentIds = ['17', '18'];
    }
    /// AccountType 0 -> Only NSDL
    else if (newAccountType == '0') {
      selectedSegmentIds = ['NSDL'];
    }
    /// AccountType 1 -> Remove NSDL
    else if (newAccountType == '1') {
      selectedSegmentIds.removeWhere((id) => id == 'NSDL');
    }

    /// AccountSubCategory 6
    if (newAccountSubCategory == '6') {
      final nsdlClientTypeId =
          additionalDetails?['selectedNsdlSubClientType']?['id']?.toString();

      LogHelper.infoLog('nsdlClientTypeId :: $nsdlClientTypeId');

      if (newAccountType != '1') {
        if (nsdlClientTypeId == '1') {
          selectedSegmentIds.removeWhere(
            (id) => id == '64' || id == '19' || id == '20',
          );
        } else if (nsdlClientTypeId == '2') {
          selectedSegmentIds.removeWhere((id) => id == '64');
        }
      }

      selectedSegmentIds.remove('SLBM');
    }

    /// Minor restriction
    if (isUserMinor &&
        (newAccountSubCategory == '5' || newAccountSubCategory == '6')) {
      selectedSegmentIds.removeWhere(
        (id) => id == '19' || id == '20' || id == '64' || id == 'SLBM',
      );
    }
    // LogHelper.infoLog('After normalization: $selectedSegmentIds');
    globalStateProvider.setState({'selectedSegmentIds': selectedSegmentIds});
    notifyListeners();
  }

  void toggleSegmentSelection(SegmentDataModel segmentDataModel) {
    onSegmentSelectionChanged(segmentDataModel, !segmentDataModel.selected);
  }

  List<SegmentDataModel> consolidateSegmentsForDisplay() {
    final List<SegmentDataModel> consolidated = [];
    final Set<String> processed = {};

    for (final segment in segments) {
      final header = segment.header.isNotEmpty ? segment.header : 'Other';
      if (processed.contains(header)) continue;
      final groupItems = segments.where((e) => e.header == header);
      final isSelected = groupItems.any((e) => e.selected);
      consolidated.add(
        segment.copyWith(
          header: header,
          selected: isSelected,
          displayDescription: getDisplayDescription(segment),
        ),
      );

      processed.add(header);
    }

    return consolidated;
  }

  String getDisplayDescription(SegmentDataModel segmentDataModel) {
    final businessId = segmentDataModel.segment.ocrBusinessId;
    if (segmentDataModel.isSLBM) {
      return segmentDataModel.segment.slbmDescription != null
          ? 'SLBM Brk: ${segmentDataModel.segment.slbmDescription}'
          : '';
    }

    if (businessId == 17 || businessId == 18) {
      final intraday = segmentDataModel.segment.intradayDesc != null
          ? 'Equity Intraday ${segmentDataModel.segment.intradayDesc}'
          : '';
      final delivery = segmentDataModel.segment.deliveryDesc != null
          ? 'Equity Delivery ${segmentDataModel.segment.deliveryDesc}'
          : '';
      return [intraday, delivery].where((item) => item.isNotEmpty).join(' | ');
    }

    if (businessId == 19 || businessId == 20) {
      final future = segmentDataModel.segment.futDesc != null
          ? 'Equity Futures: ${segmentDataModel.segment.futDesc}'
          : '';
      final indexFuture = segmentDataModel.segment.futDesc != null
          ? 'Index Futures: ${segmentDataModel.segment.futDesc}'
          : '';
      final optDesc = segmentDataModel.segment.optDesc ?? '';
      final option = optDesc.isNotEmpty
          ? 'Equity Options: ${optDesc.split('|').first.trim()}'
          : '';
      final optionParts = optDesc.isNotEmpty ? optDesc.split('|') : <String>[];
      final indexOption = optionParts.length > 1
          ? 'Index Options: ${optionParts[1].trim()}'
          : '';
      return [
        future,
        indexFuture,
        option,
        indexOption,
      ].where((item) => item.isNotEmpty).join(' | ');
    }

    if (businessId == 21) {
      return segmentDataModel.segment.optDescription != null
          ? 'Currency Brk: ${segmentDataModel.segment.optDescription}'
          : '';
    }

    if (businessId == 63 || businessId == 64) {
      final future = segmentDataModel.segment.futDesc != null
          ? 'Commodities Futures: ${segmentDataModel.segment.futDesc}'
          : '';

      final option = segmentDataModel.segment.optDesc != null
          ? 'Commodities Options: ${segmentDataModel.segment.optDesc}'
          : '';

      return [future, option].where((item) => item.isNotEmpty).join(' | ');
    }

    if (segmentDataModel.header == 'NSDL') {
      return '';
    }

    return (segmentDataModel.segment.jobDescription ??
                segmentDataModel.segment.delDescription ??
                segmentDataModel.segment.optDescription ??
                segmentDataModel.segment.futDescription ??
                segmentDataModel.segment.exeDescription ??
                segmentDataModel.segment.slbmDescription)
            ?.toString() ??
        '';
  }

  void applyDefaultSelectionsBasedOnAccountType() {
    final newAccountType = accountType.toString();
    final newAccountSubCategory = accountSubCategory?.toString();
    final isUserMinor = AppHelperWidgets.isUserMinor(dob);

    /// AccountSubCategory 5: Only Equity selected
    if (newAccountSubCategory == '5') {
      segments = segments.map((segment) {
        return segment.copyWith(selected: segment.header == 'Equity');
      }).toList();
    }
    /// AccountType 0: Only NSDL selected
    else if (newAccountType == '0') {
      segments = segments.map((segment) {
        return segment.copyWith(
          selected:
              segment.header == 'NSDL' ||
              segment.header == 'Equity' ||
              segment.header == 'SLBM',
        );
      }).toList();
    } else if (newAccountType == '1') {
      segments = segments.map((segment) {
        return segment.copyWith(
          selected: segment.header != 'NSDL' && isDefaultSelected(segment),
        );
      }).toList();
    }
    /// AccountType 2: Normal defaults for all
    else {
      applyDefaultSelections();
    }

    /// ⭐ AccountSubCategory 6
    if (newAccountSubCategory == '6') {
      final nsdlClientTypeId =
          additionalDetails?['selectedNsdlSubClientType']?['id']?.toString();

      LogHelper.infoLog('nsdlClientTypeId :: $nsdlClientTypeId');

      if (newAccountType != '1') {
        if (nsdlClientTypeId == '1') {
          segments = segments.map((segment) {
            if (segment.header == 'Equity Derivatives' ||
                segment.header == 'Commodities') {
              return segment.copyWith(selected: false);
            }
            return segment;
          }).toList();
        } else if (nsdlClientTypeId == '2') {
          segments = segments.map((segment) {
            if (segment.header == 'Commodities') {
              return segment.copyWith(selected: false);
            }
            return segment;
          }).toList();
        }
      }

      segments = segments.map((segment) {
        if (segment.header == 'SLBM') {
          return segment.copyWith(selected: false);
        }
        return segment;
      }).toList();
    }

    /// ⭐ Apply minor restrictions AFTER defaults are set
    if (isUserMinor &&
        (newAccountSubCategory == '5' || newAccountSubCategory == '6')) {
      segments = segments.map((segment) {
        if (segment.header == 'Equity Derivatives' ||
            segment.header == 'Commodities' ||
            segment.header == 'SLBM') {
          return segment.copyWith(selected: false);
        }
        return segment;
      }).toList();
    }
  }

  void applyDefaultSelections() {
    segments = segments.map((segment) {
      return segment.copyWith(selected: isDefaultSelected(segment));
    }).toList();
  }

  bool isDefaultSelected(SegmentDataModel segment) =>
      AppConstants.SEGMENT_CONFIG[segment.header]?['defaultSelected']
          as bool? ??
      false;

  Map<String, dynamic> getSegmentFlags(List<SegmentDataModel> segments) {
    final Map<String, dynamic> flags = {
      'ocrNSEEQ': false,
      'ocrBSEEQ': false,
      'ocrNSEFO': false,
      'ocrBSEFO': false,
      'ocrNSECD': false,
      'ocrNSECO': false,
      'ocrSLBM': false,
      'ocrMCXCO': false,
      'ocrNSDL': false,
    };

    for (final seg in segments) {
      final header = seg.header;

      // NSDL
      if (header == 'NSDL') {
        flags['ocrNSDL'] = groupedSegments['NSDL']?.selected == true;
        continue;
      }

      // SLBM
      if ((seg.isSLBM == true || header == 'SLBM') && seg.selected == true) {
        flags['ocrSLBM'] = true;
      }

      // Business Flags
      final businessId = seg.segment.ocrBusinessId;
      final flagName = AppConstants.SEGMENT_FLAG_MAP[businessId];
      if (flagName != null && seg.selected == true) {
        flags[flagName] = true;
      }
    }

    // LogHelper.infoLog('SEGMENT FLAGS :: $flags');

    return flags;
  }

  int? getNSDLClientType() {
    int? nsdlClientType;

    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};
    final additionalDetailsState =
        globalStateProvider.get<Map<String, dynamic>>('additionalDetails') ??
        {};
    final loginType = registrationDetail['loginType']?.toString();
    final accountOption = registrationDetail['accountOption']?.toString();
    final accountSubCategory = registrationDetail['accountSubCategory']
        ?.toString();
    final isDefaultNsdlFlow =
        (loginType == '2' &&
            accountSubCategory == '8' &&
            accountOption != '1') ||
        loginType == '1';

    if (isDefaultNsdlFlow) {
      nsdlClientType = clientData?.nsdlClientType;
    } else {
      nsdlClientType =
          additionalDetailsState['selectedNsdlClientType']?['id'] as int?;
    }
    return nsdlClientType;
  }

  int? getNSDLSubClientType() {
    int? nsdlSubClientType;

    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};

    final additionalDetailsState =
        globalStateProvider.get<Map<String, dynamic>>('additionalDetails') ??
        {};

    final loginType = registrationDetail['loginType']?.toString();
    final accountOption = registrationDetail['accountOption']?.toString();
    final accountSubCategory = registrationDetail['accountSubCategory']
        ?.toString();

    final isDefaultNsdlFlow =
        (loginType == '2' &&
            accountSubCategory == '8' &&
            accountOption != '1') ||
        loginType == '1';

    if (isDefaultNsdlFlow) {
      nsdlSubClientType = clientData?.nsdlClientSubType;
    } else {
      nsdlSubClientType =
          additionalDetailsState['selectedNsdlSubClientType']?['id'] as int?;
    }

    return nsdlSubClientType;
  }

  List<SegmentDataModel> expandToFullSegments(
    List<SegmentDataModel> selectedItems,
    List<FluffyRecordset> originalSegments,
  ) {
    final List<SegmentDataModel> payload = [];
    final referralData =
        globalStateProvider.get<Map<String, dynamic>>('referalData') ?? {};
    final userType = getUserType(
      userTypeCode: referralData['UserType']?.toString() ?? '',
    );

    for (final item in selectedItems) {
      final header = item.header;
      final config = AppConstants.SEGMENT_CONFIG[header];
      final ids = (config?['ids'] as List<dynamic>?) ?? [];
      if (ids.isNotEmpty) {
        for (final id in ids) {
          final currentUserType = userType;

          final segment = originalSegments.firstWhereOrNull(
            (s) => s.ocrBusinessId == id && s.userType == currentUserType,
          );

          if (segment != null &&
              !payload.any((p) => p.segment.ocrBusinessId == id)) {
            payload.add(
              item.copyWith(segment: segment, selected: true, isSLBM: false),
            );
          }
        }
      }
      // =========================
      // SLBM
      // =========================
      else if (header == 'SLBM') {
        payload.add(item.copyWith(isSLBM: true, selected: true));
      }
      // =========================
      // NSDL
      // =========================
      else if (header == 'NSDL') {
        payload.add(item.copyWith(selected: true));
      }
    }

    return payload;
  }

  List<SegmentDataModel> getSelectedItems() {
    final List<SegmentDataModel> selectedList = [];

    for (final entry in groupedSegments.entries) {
      final group = entry.value;

      if (group.items.isEmpty && group.selected) {
        selectedList.add(
          SegmentDataModel(
            segment: FluffyRecordset(),
            header: group.header,
            selected: true,
          ),
        );

        continue;
      }

      selectedList.addAll(
        group.items
            .map(
              (item) =>
                  item.copyWith(selected: group.selected || item.selected),
            )
            .where((item) => item.selected),
      );
    }

    return selectedList;
  }

  //
  void saveSelectedMarketSegmentToState({
    required List<SegmentDataModel> payload,
    required List<FluffyRecordset> allSegments,
  }) {
    final selectedIds = payload.map((segment) {
      if (segment.isSLBM == true) {
        return 'SLBM';
      }

      if (segment.header == 'NSDL') {
        return 'NSDL';
      }

      return segment.segment.ocrBusinessId.toString();
    }).toList();

    globalStateProvider.setState({
      'segments': allSegments,
      'selectedSegmentIds': selectedIds,
    });
    // LogHelper.infoLog('Selected Segment IDs :: $selectedIds');
  }

  // Insert Market Segment
  Future<bool> insertMarketSegmentData() async {
    try {
      AppHelperWidgets.showLoader();
      final additionalDetailsState =
          globalStateProvider.get<Map<String, dynamic>>('additionalDetails') ??
          {};

      final registrationDetail =
          globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
          {};
      final panDetails = globalStateProvider.get<Map<String, dynamic>>(
        'panDetails',
      );
      final personalDetails =
          globalStateProvider.get<Map<String, dynamic>>('personalDetails') ??
          {};

      final familyDetails =
          personalDetails['FamilyDetails'] as Map<String, dynamic>? ?? {};
      final newAccountOption = registrationDetail['accountOption'];
      final newAccountSubCategory =
          registrationDetail['accountSubCategory'] ?? null;
      final selectedSegments = getSelectedItems();
      final expandedSegments = expandToFullSegments(
        selectedSegments,
        marketSegmentList,
      );

      final segmentFlags = getSegmentFlags(expandedSegments);
      final brokerageDetailsArray = buildBrokerageDetailsArray(
        expandedSegments,
      );
      saveSelectedMarketSegmentToState(
        payload: expandedSegments,
        allSegments: marketSegmentList,
      );
      globalStateProvider.setState({
        'arrBrokerageDetails': brokerageDetailsArray,
        'brkConfirmed': isBrokerageChecked,
      });
      final nsdlClientType = getNSDLClientType();
      final nsdlSubClientType = getNSDLSubClientType();
      final clientType = clientData?.clientType;
      final selectedNationality = clientData?.nationality;
      final countryBirth = accountType == 2
          ? null
          : countryList
                    .firstWhereOrNull(
                      (e) =>
                          e.name.toUpperCase() ==
                          countryController.text.trim().toUpperCase(),
                    )
                    ?.id ??
                1;

      final String? ocrPlaceOfDeclaration =
          additionalDetailsState['placeOfDeclaration']?.toString();

      final selectedDdpiFlag = defaultLoginType.value == '1'
          ? clientData?.chkDdpiFlag
          : 0;
      final ocrNSDLScheme = defaultLoginType.value == '1'
          ? clientData?.nsdlScheme
          : null;
      final residentialStatus = clientData?.residentialStatus;
      final selectedBsdaFlag = clientData?.chkBsdaFlag;
      final newFormNumber = globalStateProvider.get<int>('formNumber');
      final String panNumber = panDetails!['panNumber']
          .toString()
          .trim()
          .toUpperCase();
      final selectedOccupationId = toRecord(
        additionalDetailsState['selectedOccupation'],
      )?.id;
      final selectedIncomeId = toRecord(
        additionalDetailsState['selectedIncome'],
      )?.id;
      final selectedGenderId = toRecord(
        additionalDetailsState['selectedGender'],
      )?.id;
      final selectedMaritalStatusId = toRecord(
        additionalDetailsState['selectedMaritalStatus'],
      )?.id;

      final selectedBirthCityId = toRecord(
        additionalDetailsState['selectedCity'],
      )?.id;
      final insertedGSTNumber = additionalDetailsState['gstNo'];
      final payload = {
        'ocrClientType': clientType,
        'ocrPerAddressProofExpiryDate':
            clientData?.perAddressProofExpiryDate ?? null,
        'ocrCorrAddressProofExpiryDate':
            clientData?.corrAddressProofExpiryDate ?? null,
        'ocrFatherHusbandFlag': familyDetails['relationFlag'],
        'ocrFathersFirstName': familyDetails['fatherFirstName'] ?? '',
        'ocrFathersMiddleName': familyDetails['fatherMiddleName'] ?? '',
        'ocrFathersLastName': familyDetails['fatherLastName'] ?? '',
        'ocrMothersFirstName': familyDetails['motherFirstName'] ?? '',
        'ocrMothersMiddleName': familyDetails['motherMiddleName'] ?? '',
        'ocrMothersLastName': familyDetails['motherLastName'] ?? '',

        'ocrOccupation': selectedOccupationId,
        'ocrOccupationDetail': null,
        'ocrAnnualIncome': selectedIncomeId,
        'ocrNationality': selectedNationality,
        'ocrCountryBirth': countryBirth,
        'ocrCityBirth': selectedBirthCityId,
        'ocrDateOfDeclaration': DateTime.now().toUtc().toIso8601String(),
        'ocrPlaceOfDeclaration': ocrPlaceOfDeclaration,
        'ocrNumberOfDocument': clientData?.noOfDocumentsSubmitted,
        'ocrPEP': int.tryParse(selectedPEPNotifier.value),
        'ocrSettlementCycle': int.tryParse(
          selectedSettlementCycleNotifier.value,
        ),
        'ocrGender': selectedGenderId,
        'ocrMaritalStatus': selectedMaritalStatusId,
        'ocrTradingType': clientData?.tradingType,
        'ocrBillingCategory': clientData?.billingCategory,
        'ocrClientRiskCategory': clientData?.clientRiskCategory,
        'ocrGstNumber': insertedGSTNumber ?? '',
        'ocrInPersonVerificationFlag': clientData?.chkInPersonVerifiedFlag,
        'ocrFax': clientData?.ocrFax,
        'ocrTaxApplicableOutside': clientData?.taxApplicableOutsideIndia,
        'ocrAppForFatca': clientData?.fatca,
        'ocrEcnFlag': clientData?.ecn,
        'ocrDDPIFlag': selectedDdpiFlag,
        'ocrNSDLClientType': accountOption != 1 ? nsdlClientType : null,
        'ocrNSDLClientSubType': accountOption != 1 ? nsdlSubClientType : null,
        'ocrNSDLScheme': ocrNSDLScheme,
        ...segmentFlags,
        'ocrResidentialStatus': residentialStatus,
        'ocrStageFlag': AppStrings.personal,
        'ocrFormNo': newFormNumber,
        'brokerageDetailsArray': brokerageDetailsArray,
        'ocrBSDAFlag': selectedBsdaFlag,
        'accountOption': newAccountOption,
        'ocrPanNo': panNumber.toString(),
        'ocrHolder': AppStrings.firstHolder,
        'accountSubCategory': newAccountSubCategory,
        'ocrIsBrkConfirm': isBrokerageChecked,
      };

      // LogHelper.infoLog('MARKET SEGMENT PAYLOAD:::$payload ');
      final response = await authRepository.insertDataRepo(
        requestData: payload,
      );
      if (response != null && response.statusCode == 200) {
        final data = response.data;
        final output = data['data']?['output'];
        if (data['success'] == true && output != null) {
          final returnValue =
              int.tryParse(output['return_Value']?.toString() ?? '') ?? -1;
          final message =
              output['return_Message']?.toString() ??
              AppStrings.somethingWentWrong;

          if (returnValue == 0) {
            AppHelperWidgets.showSnackBar(
              title: AppStrings.success,
              message: message,
              messageType: AppStrings.responseTypeSuccess,
            );

            return true;
          }
          AppHelperWidgets.showSnackBar(
            title: AppStrings.error,
            message: message,
            messageType: AppStrings.responseTypeError,
          );
          return false;
        }
      }
    } catch (e, stackTrace) {
      LogHelper.errorLog(
        'insertMarketSegmentData Exception :: '
        '$e',
      );
      LogHelper.errorLog('StackTrace :: $stackTrace');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      AppHelperWidgets.hideLoader();
      notifyListeners();
    }

    return false;
  }

  Future<void> getBankDetailsByIFSC({required String searchedIFSC}) async {
    final searchedValue = searchedIFSC.trim().toUpperCase();
    if (searchedValue.length < 3) {
      searchIFSCCodeList = [];
      isBankDetailsNotFound = false;
      isShowManualBankEntry = false;
      notifyListeners();
      return;
    }

    try {
      isLoadingSearchIFSCCode = true;
      notifyListeners();
      final response = await authRepository.getBankDetailsByIFSC(
        searchedIFSC: searchedValue,
      );

      if (response != null && response.data != null) {
        final getBankDetailModel = GetBankDetailsModel.fromJson(response.data);

        final allBanks = getBankDetailModel.data.recordsets
            .expand((e) => e)
            .toList();

        searchIFSCCodeList = allBanks.where((bank) {
          final ifsc = bank.IFSCCode?.trim().toUpperCase() ?? '';
          return ifsc.contains(searchedValue);
        }).toList();

        if (searchIFSCCodeList.isNotEmpty) {
          isBankDetailsNotFound = false;
          if (isShowManualBankEntry) {
            isShowManualBankEntry = false;
            branchNameController.clear();
            bankMICRCodeController.clear();
            branchAddress1Controller.clear();
            branchAddress2Controller.clear();
            branchAddress3Controller.clear();
            branchAddress4Controller.clear();
            bankNameController.clear();
            setBankNameError(hasError: false, errorMessage: '');
            setMICRCodeError(hasError: false, errorMessage: '');
          }
        } else {
          bankNameController.clear();
          if (searchedValue.length == 11) {
            isBankDetailsNotFound = true;
            isShowManualBankEntry = true;
            bankDetails = {
              "bankId": "",
              "IFSCCode": searchedValue,
              "bankName": "",
              "bankBranchName": "",
              "MICRCode": "",
              "branchAdd1": "",
              "branchAdd2": "",
              "branchAdd3": "",
              "branchAdd4": "",
              "BranchCountry": null,
              "BranchState": null,
              "BranchCity": null,
              "BranchPinCode": null,
            };
          }
        }
      } else {
        searchIFSCCodeList = [];
        isBankDetailsNotFound = searchedValue.length == 11;
        isShowManualBankEntry = isBankDetailsNotFound;
        if (isShowManualBankEntry) {
          bankDetails = {
            "bankId": "",
            "IFSCCode": searchedValue,
            "bankName": "",
            "bankBranchName": "",
            "MICRCode": "",
            "branchAdd1": "",
            "branchAdd2": "",
            "branchAdd3": "",
            "branchAdd4": "",
            "BranchCountry": null,
            "BranchState": null,
            "BranchCity": null,
            "BranchPinCode": null,
          };
        }
      }
    } catch (e) {
      searchIFSCCodeList = [];
      isBankDetailsNotFound = searchedValue.length == 11;
      isShowManualBankEntry = isBankDetailsNotFound;
      if (isShowManualBankEntry) {
        bankDetails = {
          "bankId": "",
          "IFSCCode": searchedValue,
          "bankName": "",
          "bankBranchName": "",
          "MICRCode": "",
          "branchAdd1": "",
          "branchAdd2": "",
          "branchAdd3": "",
          "branchAdd4": "",
          "BranchCountry": null,
          "BranchState": null,
          "BranchCity": null,
          "BranchPinCode": null,
        };
      }

      LogHelper.errorLog('getBankDetailsByIFSC Exception: $e');
    } finally {
      isLoadingSearchIFSCCode = false;
      notifyListeners();
    }
  }

  Future<void> selectSearchIFSCCode(BankDetails bank) async {
    searchIFSCCodeList.clear();
    bankIFSCController.text = (bank.IFSCCode ?? '').trim();
    bankNameController.text = (bank.bankName ?? '').trim();
    bankMICRCodeController.text = (bank.MICRCode ?? '').trim();

    setBankNameError(hasError: false, errorMessage: '');
    setMICRCodeError(hasError: false, errorMessage: '');
    setIFSCCodeError(hasError: false, errorMessage: '');

    isBankDetailsAutoFilled = true;
    isBankDetailsNotFound = false;
    isShowManualBankEntry = false;
    notifyListeners();
    await loadExactBankDetails(
      ifsc: bank.IFSCCode ?? '',
      micrCode: bank.MICRCode,
    );
  }

  //loadExactBankDetails
  Future<BankDetails?> loadExactBankDetails({
    required String ifsc,
    String? micrCode,
  }) async {
    try {
      final response = await authRepository.getBankDetailsByIFSC(
        searchedIFSC: ifsc,
      );
      if (response?.data != null) {
        final model = GetBankDetailsModel.fromJson(response!.data);
        final records = model.data.recordsets.expand((e) => e).toList();
        if (records.isNotEmpty) {
          final bank = micrCode != null
              ? records.firstWhere(
                  (e) => e.MICRCode == micrCode,
                  orElse: () => records.first,
                )
              : records.first;

          bankDetails = {
            "bankId": bank.bankId,
            "IFSCCode": bank.IFSCCode,
            "bankName": bank.bankName,
            "bankBranchName": bank.bankBranchName,
            "MICRCode": bank.MICRCode,
            "branchAdd1": bank.branchAdd1,
            "branchAdd2": bank.branchAdd2,
            "branchAdd3": bank.branchAdd3,
            "branchAdd4": bank.branchAdd4,
            "BranchCountry": bank.branchCountry,
            "BranchState": bank.branchState,
            "BranchCity": bank.branchCity,
            "BranchPinCode": bank.branchPinCode,
            "CAMSfipId": bank.camsFipId,
          };

          bankMICRCodeController.text = bank.MICRCode ?? '';
          isShowManualBankEntry = false;
          notifyListeners();

          return bank;
        }
      }

      searchIFSCCodeList.clear();
      isBankDetailsNotFound = true;
      isShowManualBankEntry = true;

      bankDetails = {
        "bankId": "",
        "IFSCCode": ifsc,
        "bankName": "",
        "bankBranchName": "",
        "MICRCode": "",
        "branchAdd1": "",
        "branchAdd2": "",
        "branchAdd3": "",
        "branchAdd4": "",
        "BranchCountry": null,
        "BranchState": null,
        "BranchCity": null,
        "BranchPinCode": null,
      };

      notifyListeners();
      return null;
    } catch (e) {
      LogHelper.errorLog('loadExactBankDetails: $e');
      rethrow;
    }
  }

  void setMICRError({required bool hasError, required String errorMessage}) {
    _micrHasError = hasError;
    _micrError = errorMessage;
    notifyListeners();
  }

  void setBranchAddress1Error({
    required bool hasError,
    required String errorMessage,
  }) {
    _branchAddress1HasError = hasError;
    _branchAddress1Error = errorMessage;
    notifyListeners();
  }

  void setBranchAddress2Error({
    required bool hasError,
    required String errorMessage,
  }) {
    _branchAddress2HasError = hasError;
    _branchAddress2Error = errorMessage;
    notifyListeners();
  }

  void setBranchAddress3Error({
    required bool hasError,
    required String errorMessage,
  }) {
    _branchAddress3HasError = hasError;
    _branchAddress3Error = errorMessage;
    notifyListeners();
  }

  void setBranchAddress4Error({
    required bool hasError,
    required String errorMessage,
  }) {
    _branchAddress4HasError = hasError;
    _branchAddress4Error = errorMessage;
    notifyListeners();
  }

  void setManualBankValidators(bool isManual) {
    isShowManualBankEntry = isManual;

    // Clear previous validation errors
    setBankNameError(hasError: false, errorMessage: '');
    setBranchNameError(hasError: false, errorMessage: '');
    setMICRError(hasError: false, errorMessage: '');
    setBranchAddress1Error(hasError: false, errorMessage: '');
    setBranchAddress2Error(hasError: false, errorMessage: '');
    setBranchAddress3Error(hasError: false, errorMessage: '');
    setBranchAddress4Error(hasError: false, errorMessage: '');
    notifyListeners();
  }

  void setBranchNameError({
    required bool hasError,
    required String errorMessage,
  }) {
    _branchNameHasError = hasError;
    _branchNameError = errorMessage;
    notifyListeners();
  }

  void setAccountTypeError({
    required bool hasError,
    required String errorMessage,
  }) {
    _accountTypeHasError = hasError;
    _accountTypeError = errorMessage;
    notifyListeners();
  }

  void setIFSCCodeError({
    required bool hasError,
    required String errorMessage,
  }) {
    _ifscCodeHasError = hasError;
    _ifscCodeError = errorMessage;
    notifyListeners();
  }

  void setBankNameError({
    required bool hasError,
    required String errorMessage,
  }) {
    _bankNameHasError = hasError;
    _bankNameError = errorMessage;
    notifyListeners();
  }

  void setMICRCodeError({
    required bool hasError,
    required String errorMessage,
  }) {
    _micrCodeHasError = hasError;
    _micrCodeError = errorMessage;
    notifyListeners();
  }

  bool validateBankDetails() {
    validateBankDetailsErrors();
    final isBankAccountValid = validateBankAccountNumber();
    showBankValidationError = true;
    notifyListeners();

    if (!isBankAccountValid) {
      return false;
    }

    if (selectedBankAccountType == null) {
      return false;
    }

    if (bankAccountNumberController.text.trim().isEmpty) {
      return false;
    }

    if (bankIFSCController.text.trim().isEmpty) {
      return false;
    }

    if (bankNameController.text.trim().isEmpty) {
      return false;
    }

    if (bankMICRCodeController.text.trim().isEmpty) {
      return false;
    }

    if (isShowManualBankEntry) {
      if (branchNameController.text.trim().length < 3) {
        return false;
      }

      final micr = bankMICRCodeController.text.trim();
      if (!RegExp(r'^\d{9}$').hasMatch(micr)) {
        return false;
      }

      if (branchAddress1Controller.text.trim().length < 3) {
        return false;
      }

      if (branchAddress2Controller.text.trim().isNotEmpty &&
          branchAddress2Controller.text.trim().length < 3) {
        return false;
      }

      if (branchAddress3Controller.text.trim().isNotEmpty &&
          branchAddress3Controller.text.trim().length < 3) {
        return false;
      }

      if (branchAddress4Controller.text.trim().isNotEmpty &&
          branchAddress4Controller.text.trim().length < 3) {
        return false;
      }
    }

    return true;
  }

  void validateBankDetailsErrors() {
    /// Account Type
    setAccountTypeError(
      hasError: selectedBankAccountType == null,
      errorMessage: selectedBankAccountType == null
          ? AppStrings.accountTypeRequired
          : '',
    );

    /// Account Number
    setBankAccountNumberError(
      hasError: bankAccountNumberController.text.trim().isEmpty,
      errorMessage: bankAccountNumberController.text.trim().isEmpty
          ? AppStrings.enterAccountNumber
          : '',
    );

    /// IFSC
    setIFSCCodeError(
      hasError: bankIFSCController.text.trim().isEmpty,
      errorMessage: bankIFSCController.text.trim().isEmpty
          ? AppStrings.enterifsc
          : '',
    );

    /// Bank Name
    setBankNameError(
      hasError: bankNameController.text.trim().isEmpty,
      errorMessage: bankNameController.text.trim().isEmpty
          ? AppStrings.enterBankName
          : '',
    );

    /// MICR
    setMICRCodeError(
      hasError: bankMICRCodeController.text.trim().isEmpty,
      errorMessage: bankMICRCodeController.text.trim().isEmpty
          ? AppStrings.enterMICRCode
          : '',
    );

    if (isShowManualBankEntry) {
      setBranchNameError(
        hasError: branchNameController.text.trim().length < 3,
        errorMessage: branchNameController.text.trim().isEmpty
            ? AppStrings.enterBranchName
            : AppStrings.minimumOf3Char,
      );

      setBranchAddress1Error(
        hasError: branchAddress1Controller.text.trim().length < 3,
        errorMessage: branchAddress1Controller.text.trim().isEmpty
            ? AppStrings.enterBranchAddress1
            : AppStrings.minimumOf3Char,
      );

      setBranchAddress2Error(
        hasError:
            branchAddress2Controller.text.trim().isNotEmpty &&
            branchAddress2Controller.text.trim().length < 3,
        errorMessage: AppStrings.minimumOf3Char,
      );

      setBranchAddress3Error(
        hasError:
            branchAddress3Controller.text.trim().isNotEmpty &&
            branchAddress3Controller.text.trim().length < 3,
        errorMessage: AppStrings.minimumOf3Char,
      );

      setBranchAddress4Error(
        hasError:
            branchAddress4Controller.text.trim().isNotEmpty &&
            branchAddress4Controller.text.trim().length < 3,
        errorMessage: AppStrings.minimumOf3Char,
      );

      final micr = bankMICRCodeController.text.trim();

      setMICRCodeError(
        hasError: micr.isEmpty || !RegExp(r'^\d{9}$').hasMatch(micr),
        errorMessage: micr.isEmpty
            ? AppStrings.enterMICRCode
            : AppStrings.micrMustof9Digits,
      );
    }
  }

  bool validateBankAccountNumber() {
    final value = bankAccountNumberController.text.trim();

    if (value.isEmpty) {
      setBankAccountNumberError(
        hasError: true,
        errorMessage: AppStrings.enterAccountNumber,
      );
      return false;
    }

    if (value.length < 10) {
      setBankAccountNumberError(
        hasError: true,
        errorMessage: AppStrings.accountMustMin,
      );
      return false;
    }

    if (value.length > 20) {
      setBankAccountNumberError(
        hasError: true,
        errorMessage: AppStrings.accountMustMax,
      );
      return false;
    }

    setBankAccountNumberError(hasError: false, errorMessage: '');

    return true;
  }

  void updateSelectedBankAccountType(PurpleRecordset selectedItem) {
    selectedBankAccountType = selectedItem.name;
    selectedBankAccountTypeId = selectedItem.id;
    setAccountTypeError(hasError: false, errorMessage: '');
    notifyListeners();
  }

  void updateVerifyButtonVisibility(bool value) {
    isVerifyBtnVisible = value;
    notifyListeners();
  }

  void resetBankDetails() {
    selectedBankAccountType = null;
    selectedBankAccountTypeId = null;
    bankIFSCController.clear();
    bankNameController.clear();
    branchNameController.clear();
    bankMICRCodeController.clear();
    branchAddress1Controller.clear();
    branchAddress2Controller.clear();
    branchAddress3Controller.clear();
    branchAddress4Controller.clear();
    bankAccountNumberController.clear();
    searchIFSCCodeList = [];
    isLoadingSearchIFSCCode = false;
    isBankDetailsNotFound = false;
    isBankDetailsAutoFilled = false;
    isVerifyBtnVisible = true;

    /// Reset Errors
    setAccountTypeError(hasError: false, errorMessage: '');
    setBankAccountNumberError(hasError: false, errorMessage: '');
    setIFSCCodeError(hasError: false, errorMessage: '');
    setBankNameError(hasError: false, errorMessage: '');
    setMICRCodeError(hasError: false, errorMessage: '');

    bankAccountNumberFocusNode.unfocus();
    bankIFSCFocusNode.unfocus();
    bankNameFocusNode.unfocus();
    bankMICRCodeFocusNode.unfocus();
    isNomineeAddressSameAsCorrepondence = false;
    isGuardianAddressSameAsCorrepondence = false;
    notifyListeners();
  }

  //resumeApplication
  void resumeApplication() {
    final stage = globalStateProvider.get<String>('stage');
    final registration = globalStateProvider.get<Map<String, dynamic>>(
      'RegistrationDetail',
    );
    final loginType = registration?['loginType']?.toString();
    final accountType = registration?['accountType']?.toString();
    final accountOption = registration?['accountOption']?.toString();
    final accountSubCategory = registration?['accountSubCategory']?.toString();
    final selectedSegmentIds =
        globalStateProvider.get<List>('selectedSegmentIds') ?? [];
    final isSecondHolderProcessing =
        globalStateProvider.get<bool>('isSecondHolderProcessing') ?? false;
    final isThirdHolderProcessing =
        globalStateProvider.get<bool>('isThirdHolderProcessing') ?? false;

    handleNavigation(
      stage: stage,
      loginType: loginType,
      accountType: accountType,
      accountOption: accountOption,
      accountSubCategory: accountSubCategory,
      selectedSegmentIds: selectedSegmentIds,
      isSecondHolderProcessing: isSecondHolderProcessing,
      isThirdHolderProcessing: isThirdHolderProcessing,
    );
  }

  void handleNavigation({
    required String? stage,
    required String? loginType,
    required String? accountType,
    required String? accountOption,
    required String? accountSubCategory,
    required List<dynamic> selectedSegmentIds,
    required bool isSecondHolderProcessing,
    required bool isThirdHolderProcessing,
  }) {
    if (!isSecondHolderProcessing && !isThirdHolderProcessing) {
      handleFirstHolderFlow(
        stage: stage,
        loginType: loginType,
        accountType: accountType,
        accountOption: accountOption,
        accountSubCategory: accountSubCategory,
        selectedSegmentIds: selectedSegmentIds,
      );
    } else if (isSecondHolderProcessing || isThirdHolderProcessing) {
      handleAdditionalHolderFlow(
        stage: stage,
        accountType: accountType,
        accountSubCategory: accountSubCategory,
      );
    } else {
      AppNavigator.go(AppRoutes.loginScreen);
    }
  }

  // Handle PrimaryHolder Flow
  void handleFirstHolderFlow({
    required String? stage,
    required String? loginType,
    required String? accountType,
    required String? accountOption,
    required String? accountSubCategory,
    required List<dynamic> selectedSegmentIds,
  }) {
    switch (stage) {
      case AppStrings.insert:
        handleFirstHolderInsertNavigation(
          loginType: loginType,
          accountSubCategory: accountSubCategory,
        );
        break;

      case AppStrings.digiLocker:
        handleFirstHolderDigiLockerNavigation(accountType: accountType);
        break;

      case AppStrings.personal:
        handleFirstHolderPersonalNavigation(
          loginType: loginType,
          accountOption: accountOption,
          accountSubCategory: accountSubCategory,
        );
        break;

      case AppStrings.onlyTradingDetails:
        handleFirstHolderOnlyTradingNavigation(
          loginType: loginType,
          accountSubCategory: accountSubCategory,
        );
        break;

      case AppStrings.nriDetails:
        handleFirstHolderNRIDetailsNavigation();
        break;

      case AppStrings.guardian:
        handleFirstHolderGuardianNavigation(
          loginType: loginType,
          accountSubCategory: accountSubCategory,
        );
        break;

      case AppStrings.other:
        handleFirstHolderOtherNavigation();
        break;

      case AppStrings.bank:
        handleFirstHolderBankNavigation();
        break;

      case AppStrings.signature:
        handleFirstHolderSignatureNavigation(
          loginType: loginType,
          accountType: accountType,
          accountOption: accountOption,
          accountSubCategory: accountSubCategory,
          selectedSegmentIds: selectedSegmentIds,
          isSecondHolderProcessing: isSecondHolderProcessing,
          isThirdHolderProcessing: isThirdHolderProcessing,
        );
        break;

      case AppStrings.digioSelfieRequest:
        handleFirstHolderDigioSelfieRequestNavigation();
        break;

      case AppStrings.photo:
        handleFirstHolderPhotoNavigation(
          loginType: loginType,
          accountOption: accountOption,
          accountSubCategory: accountSubCategory,
          selectedSegmentIds: selectedSegmentIds,
        );
        break;

      case AppStrings.income:
        handleFirstHolderIncomeNavigation(
          loginType: loginType,
          accountOption: accountOption,
          accountSubCategory: accountSubCategory,
        );
        break;

      case AppStrings.additionalDocuments:
        handleFirstHolderAdditionalDocumentsNavigation();
        break;

      case AppStrings.nominee:
        handleFirstHolderNomineeNavigation();
        break;

      case AppStrings.preview:
        handleFirstHolderPreviewNavigation();
        break;

      case AppStrings.plans:
        handleFirstHolderPlansNavigation(
          loginType: loginType,
          accountOption: accountOption,
          accountSubCategory: accountSubCategory,
        );
        break;

      case AppStrings.digitalSignKYC:
        handleFirstHolderDigitalSignKYCNavigation(
          accountOption: accountOption,
          accountSubCategory: accountSubCategory,
        );
        break;

      case AppStrings.ddpiRequest:
      case AppStrings.ddpiResponse:
        handleFirstHolderDDPINavigation();
        break;

      default:
        AppNavigator.go(AppRoutes.loginScreen);
    }
  }

  //handleFirstHolderDDPINavigation
  void handleFirstHolderDDPINavigation() {
    // final eSignDDPIisProcess = globalStateProvider.get<bool>('eSignDDPIisProcess') ?? false;
    // if (eSignDDPIisProcess) {
    //   AppNavigator.push(AppRoutes.successScreen);
    //   return;
    // }
    // AppNavigator.push(AppRoutes.ddpiEsignScreen);
  }

  //handleFirstHolderDigitalSignKYCNavigation
  void handleFirstHolderDigitalSignKYCNavigation({
    required String? accountOption,
    required String? accountSubCategory,
  }) {
    // final ddpiFlag = globalStateProvider.get<bool>('ddpiFlag') ?? false;

    // if (accountOption == '1') {
    //   AppNavigator.push(AppRoutes.successScreen);
    // } else if (accountSubCategory == '8' && ddpiFlag == true) {
    //   AppNavigator.push(AppRoutes.ddpiEsignScreen);
    // } else if (accountSubCategory == '8' && ddpiFlag == false) {
    //   AppNavigator.push(AppRoutes.successScreen);
    // } else if (accountSubCategory == '7') {
    //   AppNavigator.push(AppRoutes.successScreen);
    // } else {
    //   AppNavigator.push(AppRoutes.ddpiEsignScreen);
    // }
  }

  //handleFirstHolderPlansNavigation
  void handleFirstHolderPlansNavigation({
    required String? loginType,
    required String? accountOption,
    required String? accountSubCategory,
  }) {
    // getPlanDetails();
    // final eSignKYCisCompleted = globalStateProvider.get<bool>('eSignKYCisCompleted') ?? false;
    // final eSignDDPIisProcess = globalStateProvider.get<bool>('eSignDDPIisProcess') ?? false;
    // final ddpiFlag = globalStateProvider.get<bool>('ddpiFlag') ?? false;
    // if ((loginType == '2' && accountSubCategory == '8') || loginType == '1') {
    //   if (eSignKYCisCompleted) {
    //     LogHelper.infoLog('DDPI FLAG ::: $ddpiFlag');

    //     if (!ddpiFlag) {
    //       AppNavigator.push(AppRoutes.successScreen);
    //     } else {
    //       if (accountOption == '1') {
    //         AppNavigator.push(AppRoutes.successScreen);
    //       } else {
    //         if (!eSignDDPIisProcess) {
    //           AppNavigator.push(AppRoutes.ddpiEsignScreen);
    //         } else {
    //           AppNavigator.push(AppRoutes.successScreen);
    //         }
    //       }
    //     }
    //   } else {
    //     AppNavigator.push(AppRoutes.digitalSignKycScreen);
    //   }
    // } else if (loginType == '2' && accountSubCategory == '7') {
    //   if (eSignKYCisCompleted) {
    //     AppNavigator.push(AppRoutes.successScreen);
    //   } else {
    //     AppNavigator.push(AppRoutes.digitalSignKycScreen);
    //   }
    // } else {
    //   AppNavigator.push(AppRoutes.successScreen);
    // }
  }

  //handleFirstHolderPreviewNavigation
  void handleFirstHolderPreviewNavigation() {
    //checkPlanAndNavigate();
  }

  //handleFirstHolderNomineeNavigation
  void handleFirstHolderNomineeNavigation() {
    AppNavigator.push(AppRoutes.nomineeDetailScreen);
  }

  //handleFirstHolderAdditionalDocumentsNavigation
  void handleFirstHolderAdditionalDocumentsNavigation() {
    AppNavigator.push(AppRoutes.nomineeDetailScreen);
  }

  //handleFirstHolderIncomeNavigation
  void handleFirstHolderIncomeNavigation({
    required String? loginType,
    required String? accountOption,
    required String? accountSubCategory,
  }) {
    AppNavigator.push(AppRoutes.uploadIncomeProofScreen);
    // if (loginType == '2' && (accountSubCategory == '1' || accountSubCategory == '2' || accountSubCategory == '5')) {
    //   AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    // } else if (loginType == '2' &&
    //     (accountSubCategory == '7' ||
    //         accountSubCategory == '4' ||
    //         accountSubCategory == '3' ||
    //         accountSubCategory == '6')) {
    //   if (accountOption == '1') {
    //     AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    //   } else {
    //     final dob = globalStateProvider.get<Map<String, dynamic>>('panDetails')?['dob'];

    //     final additionalDetails = globalStateProvider.get<Map<String, dynamic>>('additionalDetails');

    //     final selectedNsdlClientType = additionalDetails?['selectedNsdlClientType'];
    //     final selectedNsdlSubClientType = additionalDetails?['selectedNsdlSubClientType'];
    //     final clientTypeId = selectedNsdlClientType?.id;
    //     final subClientTypeId = selectedNsdlSubClientType?.id;
    //     if (accountSubCategory == '6' && ageService.isMinor(dob)) {
    //       AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    //     } else if (accountSubCategory == '3' && clientTypeId != 1 && subClientTypeId != '1') {
    //       LogHelper.infoLog('Trust Others');
    //       AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    //     } else {
    //       AppNavigator.push(AppRoutes.multiHolderScreen);
    //     }
    //   }
    // } else {
    //   AppNavigator.push(AppRoutes.nomineeDetailsScreen);
    // }
  }

  //handleFirstHolderPhotoNavigation
  void handleFirstHolderPhotoNavigation({
    required String? loginType,
    required String? accountOption,
    required String? accountSubCategory,
    required List<dynamic> selectedSegmentIds,
  }) {
    AppNavigator.push(AppRoutes.uploadSelfieScreen);
    // if ((selectedSegmentIds.contains(19) && selectedSegmentIds.contains(20)) || selectedSegmentIds.contains(64)) {
    //   AppNavigator.push(AppRoutes.incomeProofScreen);
    // } else if (loginType == '2' &&
    //     (accountSubCategory == '1' || accountSubCategory == '2' || accountSubCategory == '5')) {
    //   AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    // } else if (loginType == '2' &&
    //     (accountSubCategory == '7' ||
    //         accountSubCategory == '4' ||
    //         accountSubCategory == '3' ||
    //         accountSubCategory == '6')) {
    //   if (accountOption == '1') {
    //     AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    //   } else {
    //     final panDetails = globalStateProvider.get<Map<String, dynamic>>('panDetails');

    //     final additionalDetails = globalStateProvider.get<Map<String, dynamic>>('additionalDetails');

    //     final dob = panDetails?['dob'];

    //     final selectedNsdlClientType = additionalDetails?['selectedNsdlClientType'];

    //     final selectedNsdlSubClientType = additionalDetails?['selectedNsdlSubClientType'];

    //     if (accountSubCategory == '6' && ageService.isMinor(dob)) {
    //       AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    //     } else if (accountSubCategory == '3' &&
    //         selectedNsdlClientType?.id != 1 &&
    //         selectedNsdlSubClientType?.id != '1') {
    //       LogHelper.infoLog('Trust Others');

    //       AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    //     } else {
    //       AppNavigator.push(AppRoutes.multiHolderScreen);
    //     }
    //   }
    // } else {
    //   AppNavigator.push(AppRoutes.nomineeDetailsScreen);
    // }
  }

  //handleFirstHolderDigioSelfieRequestNavigation
  void handleFirstHolderDigioSelfieRequestNavigation() {
    AppNavigator.push(AppRoutes.uploadSelfieScreen);
  }

  //handleFirstHolderSignatureNavigation
  void handleFirstHolderSignatureNavigation({
    required String? loginType,
    required String? accountType,
    required String? accountOption,
    required String? accountSubCategory,
    required List<dynamic> selectedSegmentIds,
    required bool isSecondHolderProcessing,
    required bool isThirdHolderProcessing,
  }) {
    if (loginType == '1' ||
        (loginType == '2' &&
            (accountSubCategory == '7' || accountSubCategory == '8')) ||
        isThirdHolderProcessing ||
        isSecondHolderProcessing) {
      AppNavigator.push(AppRoutes.uploadSelfieScreen);
    } else if (accountType == '1') {
      AppNavigator.push(AppRoutes.uploadSelfieScreen);
    }
    // else if (accountType == '2') {
    //   if ((selectedSegmentIds.contains(19) && selectedSegmentIds.contains(20)) || selectedSegmentIds.contains(64)) {
    //     AppNavigator.push(AppRoutes.incomeProofScreen);
    //   } else if (loginType == '2' && (accountSubCategory == '1' || accountSubCategory == '2')) {
    //     AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    //   } else if (loginType == '2' && (accountSubCategory == '3' || accountSubCategory == '4')) {
    //     if (accountOption == '1') {
    //       AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    //     } else {
    //       final additionalDetails = globalStateProvider.get<Map<String, dynamic>>('additionalDetails');

    //       final selectedNsdlClientType = additionalDetails?['selectedNsdlClientType'];

    //       final selectedNsdlSubClientType = additionalDetails?['selectedNsdlSubClientType'];

    //       if (accountSubCategory == '3' && selectedNsdlClientType?.id != 1 && selectedNsdlSubClientType?.id != '1') {
    //         LogHelper.infoLog('Trust Others');
    //         AppNavigator.push(AppRoutes.additionalDocumentsScreen);
    //       } else {
    //         AppNavigator.push(AppRoutes.multiHolderScreen);
    //       }
    //     }
    //   }
    // } else if (loginType == '2') {
    //   AppNavigator.push(AppRoutes.inPersonVerificationScreen);
    // }
  }

  //handleFirstHolderBankNavigation
  void handleFirstHolderBankNavigation() {
    // LogHelper.infoLog('UPLOAD CHEQUE NAVIGATION');
    AppNavigator.push(AppRoutes.uploadChequeScreen);
  }

  //handleFirstHolderOtherNavigation
  void handleFirstHolderOtherNavigation() {
    AppNavigator.push(AppRoutes.bankInfoScreen);
  }

  // handleFirstHolderInsertNavigation
  void handleFirstHolderInsertNavigation({
    required String? loginType,
    required String? accountSubCategory,
  }) {
    if (loginType == '2' &&
        accountSubCategory != '7' &&
        accountSubCategory != '8') {
      AppNavigator.push(AppRoutes.panCardVerificationScreen);
      return;
    }
    // LogHelper.infoLog('START DIGIO');
    AppNavigator.push(AppRoutes.digioLoadingScreen);
    //  startDigio();
  }

  //handleFirstHolderDigiLockerNavigation
  void handleFirstHolderDigiLockerNavigation({required String? accountType}) {
    // LogHelper.infoLog('ACCOUNT TYPE :::${accountType.toString()}');
    if (accountType == '2') {
      LogHelper.infoLog('Navigate to AdditionalDetails');
      // AppNavigator.push(AppRoutes.additionalDetailsScreen);
    } else {
      // LogHelper.infoLog('PERSONAL INFO SCREEN :::');
      AppNavigator.push(AppRoutes.personalInfoScreen);
    }
  }

  // handleFirstHolderPersonalNavigation
  void handleFirstHolderPersonalNavigation({
    required String? loginType,
    required String? accountOption,
    required String? accountSubCategory,
  }) {
    // if (loginType == '2' && accountOption == '1') {
    //   AppNavigator.push(AppRoutes.onlyTradingDetailsScreen);
    //   return;
    // }

    // if (loginType == '2' && accountSubCategory == '6') {
    //   final dob = globalStateProvider.get<Map<String, dynamic>>('panDetails')?['dob'];

    //   if (ageService.shouldOpenGuardianFlow(dob)) {
    //     AppNavigator.push(AppRoutes.guardianDetailsScreen);
    //   } else {
    //     AppNavigator.push(AppRoutes.nriDetailsScreen);
    //   }
    //   return;
    // }

    // if (loginType == '2' && accountSubCategory == '5') {
    //   AppNavigator.push(AppRoutes.guardianDetailsScreen);
    //   return;
    // }

    // if (loginType == '2' && const ['1', '2', '3', '4'].contains(accountSubCategory)) {
    //   AppNavigator.push(AppRoutes.otherDetailsScreen);
    //   return;
    // }

    AppNavigator.push(AppRoutes.bankInfoScreen);
  }

  // handleFirstHolderOnlyTradingNavigation
  void handleFirstHolderOnlyTradingNavigation({
    required String? loginType,
    required String? accountSubCategory,
  }) {
    // if (loginType == '2' && accountSubCategory == '6') {
    //   final dob = globalStateProvider.get<Map<String, dynamic>>('panDetails')?['dob'];

    //   if (ageService.shouldOpenGuardianFlow(dob)) {
    //     AppNavigator.push(AppRoutes.guardianDetailsScreen);
    //   } else {
    //     AppNavigator.push(AppRoutes.nriDetailsScreen);
    //   }
    // } else if (loginType == '2' && accountSubCategory == '5') {
    //   AppNavigator.push(AppRoutes.guardianDetailsScreen);
    // } else if (loginType == '2' &&
    //     (accountSubCategory == '1' ||
    //         accountSubCategory == '2' ||
    //         accountSubCategory == '3' ||
    //         accountSubCategory == '4')) {
    //   AppNavigator.push(AppRoutes.otherDetailsScreen);
    // } else {
    //   AppNavigator.push(AppRoutes.bankInfoScreen);
    // }
  }

  // handleFirstHolderNRIDetailsNavigation
  void handleFirstHolderNRIDetailsNavigation() {
    AppNavigator.push(AppRoutes.bankInfoScreen);
  }

  //handleFirstHolderGuardianNavigation
  void handleFirstHolderGuardianNavigation({
    required String? loginType,
    required String? accountSubCategory,
  }) {
    // final dob = globalStateProvider.get<Map<String, dynamic>>('panDetails')?['dob'];

    // if (loginType == '2' && accountSubCategory == '6' && ageService.shouldOpenGuardianFlow(dob)) {
    //   AppNavigator.push(AppRoutes.nriDetailsScreen);
    // } else {
    //   AppNavigator.push(AppRoutes.bankInfoScreen);
    // }
  }

  //  Handle AdditionalHolder Flow
  void handleAdditionalHolderFlow({
    required String? stage,
    required String? accountType,
    required String? accountSubCategory,
  }) {
    switch (stage) {
      case AppStrings.multiHolderInsert:
        handleAdditionalHolderMultiHolderInsertNavigation();
        break;

      case AppStrings.digiLocker:
        handleAdditionalHolderDigiLockerNavigation();
        break;

      case AppStrings.personal:
        handleAdditionalHolderPersonalNavigation(
          accountSubCategory: accountSubCategory,
        );
        break;

      case AppStrings.nriDetails:
        handleAdditionalHolderNRIDetailsNavigation();
        break;

      case AppStrings.signature:
        handleAdditionalHolderSignatureNavigation(accountType: accountType);
        break;

      case AppStrings.digioSelfieRequest:
        handleAdditionalHolderDigioSelfieRequestNavigation();
        break;

      case AppStrings.photo:
        handleAdditionalHolderPhotoNavigation();
        break;

      default:
        AppNavigator.go(AppRoutes.loginScreen);
    }
  }

  void handleAdditionalHolderPhotoNavigation() {
    // AppNavigator.push(AppRoutes.multiHolderScreen);
  }

  void handleAdditionalHolderDigioSelfieRequestNavigation() {
    AppNavigator.push(AppRoutes.uploadSelfieScreen);
  }

  // handleAdditionalHolderSignatureNavigation
  void handleAdditionalHolderSignatureNavigation({
    required String? accountType,
  }) {
    if (accountType == '2') {
      ///AppNavigator.push(AppRoutes.multiHolderScreen);
    } else {
      AppNavigator.push(AppRoutes.uploadSelfieScreen);
      // AppNavigator.push(AppRoutes.selfiePhotoUploadScreen);
    }
  }

  // handleAdditionalHolderNRIDetailsNavigation
  void handleAdditionalHolderNRIDetailsNavigation() {
    // AppNavigator.push(AppRoutes.signatureUploadScreen);
  }

  //handleAdditionalHolderPersonalNavigation
  void handleAdditionalHolderPersonalNavigation({
    required String? accountSubCategory,
  }) {
    // if (accountSubCategory == '6') {
    //   AppNavigator.push(AppRoutes.nriDetailsScreen);
    // } else {
    //   AppNavigator.push(AppRoutes.signatureUploadScreen);
    // }
  }

  //handleAdditionalHolderDigiLockerNavigation
  void handleAdditionalHolderDigiLockerNavigation() {
    AppNavigator.push(AppRoutes.personalInfoScreen);
  }

  //handleAdditionalHolderMultiHolderInsertNavigation
  void handleAdditionalHolderMultiHolderInsertNavigation() {
    // AppNavigator.push(AppRoutes.addHolderScreen);
  }

  void validateIFSCCode() {
    final value = bankIFSCController.text.trim().toUpperCase();
    if (value.isEmpty) {
      setIFSCCodeError(hasError: true, errorMessage: AppStrings.enterifsc);
      return;
    }
    if (!AppConstants.ifscRegex.hasMatch(value)) {
      setIFSCCodeError(hasError: true, errorMessage: AppStrings.invalidIFSC);
      return;
    }
    setIFSCCodeError(hasError: false, errorMessage: '');
  }

  //NewCashfreeBankAccountVerificationAPI
  Future<bool> newCashfreeBankAccountVerificationAPI() async {
    try {
      notifyListeners();
      final registrationDetail =
          globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
          {};
      final panDetails =
          globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
      final accountType = registrationDetail['accountType']?.toString();
      final mobileNumber = registrationDetail['mobile']?.toString() ?? '';
      final rawName = accountType != '2'
          ? '${panDetails['firstName'] ?? ''} '
                '${panDetails['middleName'] ?? ''} '
                '${panDetails['lastName'] ?? ''}'
          : (panDetails['fullName'] ?? '');

      final nameAtBank = rawName
          .replaceAll(RegExp(r'[()]'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      final requestPayLoad = {
        'nameAtBank': nameAtBank,
        'bankAccount': bankAccountNumberController.text.trim().toString(),
        'IFSC': bankIFSCController.text.trim().toString(),
        'mobile': mobileNumber,
      };

      // LogHelper.infoLog('NEW CASHFREE REQUEST PAYLOAD ::: $requestPayLoad');
      final response = await authRepository.newCashfreeBankAccountVerification(
        requestPayLoad: requestPayLoad,
      );

      if (response == null) {
        enableRetryAfterFailure();
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );

        return false;
      }

      final data = response.data?['data'];
      final success = response.data?['success'] ?? false;
      final statusCode = response.statusCode;

      if (!success || data == null) {
        enableRetryAfterFailure();
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return false;
      }

      if (data['account_status'] == 'VALID' &&
          data['account_status_code'] == 'ACCOUNT_IS_VALID') {
        finalNameAtBank = data['name_at_bank'] ?? '';

        final isDirectMatch =
            data['name_match_result'] == 'DIRECT_MATCH' ||
            data['name_match_result'] == 'GOOD_PARTIAL_MATCH';

        if (isDirectMatch) {
          AppHelperWidgets.showSnackBar(
            title: AppStrings.success,
            message: AppStrings.bankVerifiedSuccess,
            messageType: AppStrings.responseTypeSuccess,
          );

          pendingBankVerificationData = null;
          pendingBankVerificationStatusCode = null;
          isVerifiedBankNotifier.value = true;

          await saveBankVerificationDataLogAPI(data, statusCode);
        } else {
          pendingBankVerificationData = Map<String, dynamic>.from(data);
          pendingBankVerificationStatusCode = statusCode;
        }

        return true;
      }

      // -----------------------
      // FAILURE CASES
      // -----------------------
      enableRetryAfterFailure();

      if (data['account_status_code'] == 'INSUFFICIENT_BALANCE') {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.technicalIssuesPennyDrop,
          messageType: AppStrings.responseTypeError,
        );
      } else {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message:
              data['account_status_code'] ??
              data['message'] ??
              AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
      }

      await saveBankVerificationDataLogAPI(data, statusCode);
      return false;
    } on DioException catch (e) {
      enableRetryAfterFailure();
      final errorData = e.response?.data;
      if (errorData?['data']?['code'] == 'failed_at_bank') {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.invalidBankDetails,
          messageType: AppStrings.responseTypeError,
        );
      } else {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message:
              errorData?['message'] ??
              errorData?['data']?['message'] ??
              AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
      }

      await saveBankVerificationDataLogAPI(
        errorData?['data'],
        errorData?['code'],
      );
      return false;
    } catch (e) {
      enableRetryAfterFailure();
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
      LogHelper.errorLog('verifyBankAccount Exception : $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  // To save BankAccountVerificationLog
  Future<void> saveBankVerificationDataLogAPI(
    Map<String, dynamic>? data,
    dynamic status,
  ) async {
    final referralData =
        globalStateProvider.get<Map<String, dynamic>>('referalData') ?? {};
    final panDetails =
        globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
    final String panNumber = panDetails['panNumber']
        .toString()
        .trim()
        .toUpperCase();
    final userId = referralData['userId'];
    final userType = referralData['UserType'];

    try {
      notifyListeners();

      final Map<String, dynamic> saveBankVerificationPayload = {
        ...?data,
        "ProjectIndicator": AppStrings.onlineClientRegistration,
        "ModeOfOperation": AppStrings.pennyDrop,
        "VerificationOTP": verifiedOTP,
        "UserId": userId,
        "UserType": userType,
        "PanNo": panNumber,
        "BankAccountNo": bankAccountNumberController.text.trim(),
        "SubCode": status,
        "Message":
            "${data?['name_at_bank'] ?? ''} "
            "${data?['name_match_result'] ?? ''} "
            "${data?['status'] ?? ''} "
            "${data?['upi'] ?? ''}",
      };

      if (saveBankVerificationPayload['ModeOfOperation']?.toString() ==
          AppStrings.upi) {
        saveBankVerificationPayload["ifscCode"] =
            data?['ifsc'] ?? bankIFSCController.text.trim();
        saveBankVerificationPayload["refID"] = data?['ref_id'];
        saveBankVerificationPayload["STATUS"] = data?['status'] ?? 'ERROR';
      } else {
        saveBankVerificationPayload["ifscCode"] =
            data?['ifsc_details']?['ifsc'] ?? bankIFSCController.text.trim();
        saveBankVerificationPayload["refID"] = data?['reference_id'];
        saveBankVerificationPayload["STATUS"] =
            data?['account_status'] == 'VALID'
            ? 'SUCCESS'
            : (data?['account_status'] ?? 'ERROR');
      }

      saveBankVerificationPayload["accountExists"] =
          ((data?['account_status'] == 'VALID' &&
                  data?['account_status_code'] == 'ACCOUNT_IS_VALID') ||
              (data?['status'] == 'SUCCESS'))
          ? 'YES'
          : 'NO';

      if (saveBankVerificationPayload["accountExists"] == 'NO') {
        saveBankVerificationPayload["Message"] =
            saveBankVerificationPayload["account_status_code"] ??
            saveBankVerificationPayload["message"] ??
            '';
      }

      saveBankVerificationPayload["SubCode"] =
          saveBankVerificationPayload["STATUS"] != 'SUCCESS' ? status : 200;

      // LogHelper.infoLog('SAVE BANK VERIFICATION PAYLOAD::: $saveBankVerificationPayload ');
      final response = await authRepository.saveBankAccountVerificationLog(
        requestData: saveBankVerificationPayload,
      );
      final responseData = response?.data;
      if (responseData?['success'] == true &&
          responseData?['data']?['output']?['return_Value'] == 0 &&
          saveBankVerificationPayload["STATUS"] == 'SUCCESS') {
        // LogHelper.infoLog('SAVE BANK VERIFICATION PAYLOAD ::: $saveBankVerificationPayload');
        setBankDataToState(saveBankVerificationPayload);
      } else {
        LogHelper.infoLog('saveBankVerificationDataLog ELSE PART');
        await enableRetryAfterFailure();
      }
    } catch (e) {
      LogHelper.errorLog('saveBankVerificationDataLog Exception => $e');
      await enableRetryAfterFailure();
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: e.toString(),
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> setBankDataToState(Map<String, dynamic> data) async {
    // LogHelper.infoLog('SET BANK DATA:::: $data');
    final newFormNumber = globalStateProvider.get<int>('formNumber');

    try {
      notifyListeners();

      // -----------------------------
      // Manual Bank Entry
      // -----------------------------
      if (isShowManualBankEntry) {
        bankDetails = {
          "bankId": "",
          "IFSCCode": bankIFSCController.text.trim(),
          "bankName": bankNameController.text.trim(),
          "bankBranchName": branchNameController.text.trim(),
          "MICRCode": bankMICRCodeController.text.trim(),
          "branchAdd1": branchAddress1Controller.text.trim(),
          "branchAdd2": branchAddress2Controller.text.trim(),
          "branchAdd3": branchAddress3Controller.text.trim(),
          "branchAdd4": branchAddress4Controller.text.trim(),
          // "BranchCountry": selectedBranchCountry,
          // "BranchState": selectedBranchState,
          // "BranchCity": selectedBranchCity,
          // "BranchPinCode": branchPinCodeController.text.trim(),
        };
      }

      // -----------------------------
      // Account Type
      // -----------------------------
      final accountTypeId =
          selectedBankAccountTypeId ??
          bankAccountTypeList
              .where(
                (e) =>
                    e.name.toLowerCase().trim().replaceAll(RegExp(r's$'), '') ==
                    (data['account_type'] ?? '')
                        .toString()
                        .toLowerCase()
                        .trim()
                        .replaceAll(RegExp(r's$'), ''),
              )
              .firstOrNull
              ?.id;

      final bool isFreshUPIVerification =
          data['ModeOfOperation'] == AppStrings.upi &&
          data['STATUS'] == 'SUCCESS' &&
          data['upi'] != null;

      // -----------------------------
      // Payload for Insert API
      // -----------------------------
      final bankDetailsRequestPayload = {
        "ocrBankId": bankDetails["bankId"],
        "ocrBankIFSCCode": data["ifscCode"],
        "ocrBankMICR": bankDetails["MICRCode"],
        // "ocrBankMICR": bankMICRCodeController.text.trim(),
        "ocrBankType": accountTypeId,
        "ocrBankAccountNo": data["BankAccountNo"],
        "ocrBankName": bankDetails["bankName"],
        // "ocrBankName": bankNameController.text.trim(),
        "ocrBankBranchName": bankDetails["bankBranchName"],
        "ocrNameAsperBank": data["name_at_bank"],
        "ocrBankUTRNo": data["utr"],
        "ocrBankAddress1": bankDetails["branchAdd1"],
        "ocrBankAddress2": bankDetails["branchAdd2"],
        "ocrBankAddress3": bankDetails["branchAdd3"],
        "ocrBankAddress4": bankDetails["branchAdd4"],
        "ocrBankCountry": bankDetails["BranchCountry"],
        "ocrBankState": bankDetails["BranchState"],
        "ocrBankCity": bankDetails["BranchCity"],
        "ocrBankPinCode": bankDetails["BranchPinCode"],
        "ocrBankOTP": data["VerificationOTP"] ?? '',
        // "ocrUPIID": isFreshUPIVerification ? data["upi"] : null,
        // "ocrUPIHolderName": isFreshUPIVerification ? data["name_at_bank"] : null,
        // "ocrBankOTP": data["VerificationOTP"] ?? "",
        // "ocrUPIVerifiedStatus": isFreshUPIVerification ? true : null,
        "ocrAutoDebitFlag": isAutoDebitEnable,
        "ocrStageFlag": AppStrings.bank,
        "ocrFormNo": newFormNumber,
        "ocrBankModeOfOperation": data["ModeOfOperation"],
      };

      // -----------------------------
      // Save Bank Details
      // -----------------------------
      final bankDataToSave = {
        "isOTPVerified": true,
        "BankId": bankDetails["bankId"] ?? "",
        "BankIFSCCode": data["ifscCode"] ?? "",
        "BankMICR": bankDetails["MICRCode"],
        // "BankMICR": bankMICRCodeController.text.trim() ?? "",
        "BankType": accountTypeId,
        "BankAccountNo": data["BankAccountNo"] ?? "",
        "BankName": bankDetails["bankName"],
        // "BankName": bankNameController.text.trim() ?? "",
        "BankBranchName": bankDetails["bankBranchName"] ?? "",
        "NameAsperBank": data["name_at_bank"] ?? "",
        "BankUTRNo": data["utr"] ?? "",
        "BankAddress1": bankDetails["branchAdd1"] ?? "",
        "BankAddress2": bankDetails["branchAdd2"] ?? "",
        "BankAddress3": bankDetails["branchAdd3"] ?? "",
        "BankAddress4": bankDetails["branchAdd4"] ?? "",
        "BankCountry": bankDetails["BranchCountry"] ?? "",
        "BankState": bankDetails["BranchState"] ?? "",
        "BankCity": bankDetails["BranchCity"] ?? "",
        "BankPinCode": bankDetails["BranchPinCode"] ?? "",
        // "UPIID": isFreshUPIVerification ? data["upi"] : oldBankDetails["UPIID"],
        // "UPIHolderName": isFreshUPIVerification ? data["name_at_bank"] : oldBankDetails["UPIHolderName"],
        // "UPIVerifiedStatus": isFreshUPIVerification ? true : oldBankDetails["UPIVerifiedStatus"],
        "BankOTP": data["VerificationOTP"] ?? "",
        "AutoDebitFlag": isAutoDebitEnable,
        "verifyOption": data["ModeOfOperation"] == AppStrings.upi
            ? 0
            : data["ModeOfOperation"] == AppStrings.manual
            ? 2
            : 1,
      };

      // LogHelper.infoLog('SET BANK DETAILS:::: $bankDataToSave');

      // -----------------------------
      // Update Global State
      // -----------------------------
      globalStateProvider.setState({
        "personalDetails": {...personalDetails, "bankDetails": bankDataToSave},
      });

      // LogHelper.infoLog('INSERT BANK DATA PAYLOAD ::: $bankDetailsRequestPayload');
      final response = await authRepository.insertDataRepo(
        requestData: bankDetailsRequestPayload,
      );
      final responseData = response?.data;
      if (responseData?["success"] == true &&
          responseData?["data"]?["output"]?["return_Value"] == 0) {
        isBankDetailsVerified = true;
        isVerifiedBankNotifier.value = true;
        isMatch = true;
        notifyListeners();

        AppHelperWidgets.showSnackBar(
          title: AppStrings.success,
          message:
              responseData["data"]["output"]["return_Message"] ??
              "Moving to next step",
          messageType: AppStrings.responseTypeSuccess,
        );
        await navigateAfterBankSave();
      } else {
        LogHelper.infoLog(
          'MSG ::: $responseData?["data"]?["output"]?["return_Message"]',
        );
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message:
              responseData?["data"]?["output"]?["return_Message"] ??
              AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeWarning,
        );
      }
    } catch (e) {
      LogHelper.errorLog("setBankDataToState Exception => $e");
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: e.toString(),
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      notifyListeners();
    }
  }

  //restoreBankDetailsState
  Future<void> restoreBankDetailsState(
    GlobalStateProvider globalStateProvider,
  ) async {
    final personal =
        globalStateProvider.get<Map<String, dynamic>>('personalDetails') ?? {};
    final bankDetails = personal['bankDetails'] as Map<String, dynamic>? ?? {};
    final verifyOption = bankDetails['verifyOption'] as int? ?? 1;
    final isVerified =
        bankDetails['isOTPVerified'] == true ||
        verifyOption == 1 ||
        verifyOption == 2;
    isBankDetailsVerified = isVerified;
    isVerifiedBankNotifier.value = isVerified;
    isBankDetailsAutoFilled = isVerified;
    selectedBankAccountTypeId = bankDetails['BankType'] as int?;
    final selectedItem = bankAccountTypeList
        .where((item) => item.id == selectedBankAccountTypeId)
        .firstOrNull;
    if (selectedItem != null) {
      selectedBankAccountType = selectedItem.name;
    }

    // Controllers
    bankAccountNumberController.text =
        bankDetails['BankAccountNo']?.toString() ?? '';
    bankIFSCController.text = bankDetails['BankIFSCCode']?.toString() ?? '';
    bankNameController.text = bankDetails['BankName']?.toString() ?? '';
    branchNameController.text = bankDetails['BankBranchName']?.toString() ?? '';
    bankMICRCodeController.text = bankDetails['BankMICR']?.toString() ?? '';
    branchAddress1Controller.text =
        bankDetails['BankAddress1']?.toString() ?? '';
    branchAddress2Controller.text =
        bankDetails['BankAddress2']?.toString() ?? '';
    branchAddress3Controller.text =
        bankDetails['BankAddress3']?.toString() ?? '';
    branchAddress4Controller.text =
        bankDetails['BankAddress4']?.toString() ?? '';

    notifyListeners();
  }

  Future<void> enableRetryAfterFailure() async {
    LogHelper.infoLog('Retrying Bank Verification...');

    isMatch = false;
    isBankOTPVerified = false;
    isBankDetailsVerified = false;

    /// Show Verify button again & hide OTP
    updateVerifyButtonVisibility(true);

    /// Clear fetched bank details
    bankNameController.clear();
    bankMICRCodeController.clear();

    branchNameController.clear();
    branchAddress1Controller.clear();
    branchAddress2Controller.clear();
    branchAddress3Controller.clear();
    branchAddress4Controller.clear();

    // branchCountryController.clear();
    // branchStateController.clear();
    // branchCityController.clear();
    // branchPinCodeController.clear();

    /// Reset OTP
    // otpController.clear();

    /// Re-check current IFSC
    final currentIFSC = bankIFSCController.text.trim().toUpperCase();

    if (currentIFSC.length == 11) {
      isBankDetailsNotFound = false;
      isBankDetailsAutoFilled = false;
      await getBankDetailsByIFSC(searchedIFSC: currentIFSC);
    } else {
      isBankDetailsNotFound = false;
      isBankDetailsAutoFilled = false;
    }

    notifyListeners();
  }

  Future<void> navigateAfterBankSave() async {
    // if (isEntryRejected) {
    //   final throughPennDrop =
    //       selectedThroughPennDrop?.id ?? int.tryParse(selectedThroughPennDrop?.toString() ?? '0') ?? 0;

    //   if (throughPennDrop == 1) {
    //     globalStateProvider.setState({'isReturnFromBank': true});
    //     //AppNavigator.clearAndGo(AppRoutes.rejectionDetailsScreen);
    //   } else {
    //     AppNavigator.push(AppRoutes.uploadChequeScreen);
    //   }

    //   return;
    // }

    // AppNavigator.push(AppRoutes.uploadChequeScreen);
  }

  // To pick image
  Future<void> pickImageFromSource({
    required ImageSource source,
    ValueNotifier<bool>? buttonNotifier,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );
      if (image == null) return;
      final extension = image.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.invalidFormat,
          messageType: AppStrings.responseTypeError,
          message: AppStrings.allowedFormat,
        );
        return;
      }
      selectedImage = File(image.path);
      notifyListeners();
      final fileSize = await selectedImage!.length();
      String base64 = await fileToBase64(selectedImage!);
      if (fileSize > 300 * 1024) {
        final resizedBase64 = await resizeImageAPI();
        if (resizedBase64 == null) {
          AppHelperWidgets.showSnackBar(
            title: AppStrings.invalidFileSize,
            messageType: AppStrings.responseTypeError,
            message: AppStrings.fileSizeExceeded,
          );
          return;
        }
        base64 = resizedBase64;
      }
      imageBase64 = base64;
      final mimeType = extension == 'jpg' ? 'image/jpeg' : 'image/$extension';
      previewImgUrl = 'data:$mimeType;base64,$base64';
      buttonNotifier?.value = true;

      notifyListeners();
    } catch (e) {
      LogHelper.errorLog('Pick Image Error: $e');
    }
  }

  // To Remove Image
  void removeSelectedImage({ValueNotifier<bool>? buttonNotifier}) {
    selectedImage = null;
    previewImgUrl = null;
    imageBase64 = null;
    buttonNotifier?.value = false;
    notifyListeners();
  }

  // To Resize Uploaded File
  Future<String?> resizeImageAPI({
    File? imageFile,
    int maxFileSize = 300,
  }) async {
    final file = imageFile ?? selectedImage;

    if (file == null) {
      return null;
    }

    try {
      final fileBase64 = await fileToBase64(file);
      final resizeImageRequestPayLoad = {
        'fileData': fileBase64,
        'maxFileSize': maxFileSize,
      };

      final response = await authRepository.resizeImageRepo(
        requestData: resizeImageRequestPayLoad,
      );
      if (response != null && response.data != null) {
        final fileSizeHeader = response.headers.value('File-Size');
        final receivedSize = int.tryParse(fileSizeHeader ?? '0') ?? 0;
        if (receivedSize > maxFileSize ||
            response.data.toString().trim().isEmpty) {
          return null;
        }

        return response.data.toString();
      }

      return null;
    } catch (e) {
      LogHelper.errorLog('Resize Image API Error: $e');
      return null;
    }
  }

  Future<String> fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  //updateUploadChequeDetails
  void updateUploadChequeDetails() {
    isFileTouched = true;
    if (previewImgUrl == null && (isShowManualBankEntry)) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.uploadCheque,
        messageType: AppStrings.responseTypeError,
      );
      return;
    }
    final personalDetails =
        globalStateProvider.get<Map<String, dynamic>>('personalDetails') ?? {};
    personalDetails['chequeFileString'] = previewImgUrl != null
        ? previewImgUrl!.split(',').last
        : null;
    globalStateProvider.setState({'personalDetails': personalDetails});
  }

  // insertSignatureData
  Future<void> insertSignatureData() async {
    isFileTouched = true;
    notifyListeners();
    if (selectedImage == null && previewImgUrl == null) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.pleaseUploadSignatureFile,
        messageType: AppStrings.responseTypeError,
      );
      return;
    }

    AppHelperWidgets.showLoader();
    try {
      final String? resizedBase64 = await resizeImageAPI();
      // LogHelper.infoLog('RESIZED IMAGE SIZE :: $resizedBase64');
      if (resizedBase64 == null || resizedBase64.isEmpty) {
        AppHelperWidgets.hideLoader();
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.failedToProcessSignatureImage,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final registrationDetails =
          globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
          {};
      final newFormNumber = globalStateProvider.get<int>('formNumber');
      final panDetails =
          globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
      final String panNumber = panDetails['panNumber']
          .toString()
          .trim()
          .toUpperCase();

      final secondHolder =
          globalStateProvider.get<Map<String, dynamic>>(
            'secondHolderDetails',
          ) ??
          {};
      final thirdHolder =
          globalStateProvider.get<Map<String, dynamic>>('thirdHolderDetails') ??
          {};
      final isSecondHolder =
          globalStateProvider.get<bool>('isSecondHolderProcessing') ?? false;
      final isThirdHolder =
          globalStateProvider.get<bool>('isThirdHolderProcessing') ?? false;

      String holder = AppStrings.firstHolder;
      if (isThirdHolder) {
        holder = AppStrings.thirdHolder;
      } else if (isSecondHolder) {
        holder = AppStrings.secondHolder;
      }

      final List<Map<String, dynamic>> documents = [];
      documents.add({
        'agHolder': holder,
        'agDocType': null,
        'agDocName': 'Signature',
        'agImageType': 'image/jpeg',
        'agImage': resizedBase64,
      });

      if (!isSecondHolder && !isThirdHolder) {
        final personalDetails =
            globalStateProvider.get<Map<String, dynamic>>('personalDetails') ??
            {};

        final cheque = personalDetails['chequeFileString']?.toString();

        if (cheque != null && cheque.isNotEmpty) {
          documents.add({
            'agHolder': AppStrings.firstHolder,
            'agDocType': null,
            'agDocName': AppStrings.cheque,
            'agImageType': 'image/jpeg',
            'agImage': cheque,
          });
        }
      }

      final insertSignatureRequestPayload = {
        'documents': documents,
        'ocrStageFlag': AppStrings.signature,
        'ocrFormNo': newFormNumber,
        'ocrPanNo': panNumber,
        'ocrSecHolPanNo':
            (secondHolder['panDetails'] as Map<String, dynamic>?)?['panNumber'],
        'ocrThiHolPanNo':
            (thirdHolder['panDetails'] as Map<String, dynamic>?)?['panNumber'],
        'ocrHolder': holder,
      };

      // LogHelper.infoLog('Insert Signature API::: $insertSignatureRequestPayload');
      final response = await authRepository.insertDataRepo(
        requestData: insertSignatureRequestPayload,
      );
      AppHelperWidgets.hideLoader();
      if (response == null ||
          response.statusCode != 200 ||
          response.data == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final responseData = response?.data as Map<String, dynamic>;
      final success = responseData['success'] == true;
      final output = responseData['data']?['output'] as Map<String, dynamic>?;
      final returnValue = int.tryParse(
        output?['return_Value'].toString() ?? '',
      );
      final returnMessage =
          output?['return_Message']?.toString() ?? 'Something went wrong.';

      // LogHelper.infoLog('RETURN VALUE:::: $returnValue');

      if (!success || returnValue != 0) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: returnMessage,
          messageType: AppStrings.responseTypeError,
        );

        return;
      }

      if (isThirdHolder) {
        final holderData = Map<String, dynamic>.from(
          globalStateProvider.get<Map<String, dynamic>>('thirdHolderDetails') ??
              {},
        );

        final personal = Map<String, dynamic>.from(
          holderData['personalDetails'] ?? {},
        );
        personal['signatureFile'] = selectedImage;
        personal['signatureFileString'] = resizedBase64;
        holderData['personalDetails'] = personal;
        globalStateProvider.setState({'thirdHolderDetails': holderData});
      } else if (isSecondHolder) {
        final holderData = Map<String, dynamic>.from(
          globalStateProvider.get<Map<String, dynamic>>(
                'secondHolderDetails',
              ) ??
              {},
        );
        final personal = Map<String, dynamic>.from(
          holderData['personalDetails'] ?? {},
        );
        personal['signatureFile'] = selectedImage;
        personal['signatureFileString'] = resizedBase64;
        holderData['personalDetails'] = personal;
        globalStateProvider.setState({'secondHolderDetails': holderData});
      } else {
        final personalDetails = Map<String, dynamic>.from(
          globalStateProvider.get<Map<String, dynamic>>('personalDetails') ??
              {},
        );
        personalDetails['signatureFile'] = selectedImage;
        personalDetails['signatureFileString'] = resizedBase64;
        globalStateProvider.setState({'personalDetails': personalDetails});
      }

      if (isThirdHolder) {
        globalStateProvider.setState({
          'stage': AppStrings.signature,
          'isThirdHolderProcessing': false,
        });
      } else if (isSecondHolder) {
        globalStateProvider.setState({
          'stage': AppStrings.signature,
          'isSecondHolderProcessing': false,
        });
      }

      // LogHelper.infoLog('REGISTRATION DETAILS:::: $registrationDetails');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.success,
        message: returnMessage,
        messageType: AppStrings.responseTypeSuccess,
      );

      handleNavigation(
        stage: AppStrings.signature,
        loginType: registrationDetails['loginType']?.toString(),
        accountType: registrationDetails['accountType']?.toString(),
        accountOption: registrationDetails['accountOption']?.toString(),
        accountSubCategory: registrationDetails['accountSubCategory']
            ?.toString(),
        selectedSegmentIds:
            globalStateProvider.get<List>('selectedSegmentIds') ?? [],
        isSecondHolderProcessing:
            globalStateProvider.get<bool>('isSecondHolderProcessing') ?? false,
        isThirdHolderProcessing:
            globalStateProvider.get<bool>('isThirdHolderProcessing') ?? false,
      );
    } catch (e, s) {
      AppHelperWidgets.hideLoader();
      LogHelper.errorLog('Submit Signature Exception: $e');
      LogHelper.errorLog('StackTrace:\n$s');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.failedToProcessImage,
        messageType: AppStrings.responseTypeError,
      );
    }
  }

  //RestoreChequeImageState
  Future<void> restoreChequeImageState(
    GlobalStateProvider globalStateProvider,
  ) async {
    final personalDetails =
        globalStateProvider.get<Map<String, dynamic>>('personalDetails') ?? {};

    final bankDetails =
        personalDetails['bankDetails'] as Map<String, dynamic>? ?? {};
    // selectedBankVerifyOption = bankDetails['verifyOption']?.toString() ?? '';
    final bankId = bankDetails['BankId']?.toString();
    isShowManualBankEntry = bankId == null || bankId.trim().isEmpty;

    selectedImage = null;
    previewImgUrl = null;

    final chequeFileString = personalDetails['chequeFileString']?.toString();

    if (chequeFileString != null && chequeFileString.isNotEmpty) {
      previewImgUrl = 'data:image/jpeg;base64,$chequeFileString';
      imageBase64 = chequeFileString;
    }

    final registration =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};
    final accountSubCategory = registration['accountSubCategory']?.toString();
    final panDetails =
        globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
    final panNumber = panDetails['panNumber']?.toString() ?? '';
    uploadChequeTitle =
        accountSubCategory == '5' ||
            (accountSubCategory == '6' &&
                AppHelperWidgets.isUserMinor(panNumber))
        ? AppStrings.minorBankChequePhoto
        : AppStrings.uploadOriginalChequeImage;

    notifyListeners();
  }

  // RestoreSignatureState
  Future<void> restoreSignatureState(
    GlobalStateProvider globalStateProvider,
  ) async {
    final registration =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};
    final isThirdHolder =
        globalStateProvider.get<bool>('isThirdHolderProcessing') ?? false;
    final isSecondHolder =
        globalStateProvider.get<bool>('isSecondHolderProcessing') ?? false;
    final accountSubCategory =
        registration['accountSubCategory']?.toString() ?? '';
    Map<String, dynamic> personalDetails;
    Map<String, dynamic> panDetails;
    String holderLabel;

    if (isThirdHolder) {
      uploadSignatureTitle = AppStrings.uploadSignatureForThirdHolder;
      final thirdHolder =
          globalStateProvider.get<Map<String, dynamic>>('thirdHolderDetails') ??
          {};
      personalDetails =
          thirdHolder['personalDetails'] as Map<String, dynamic>? ?? {};
      panDetails = thirdHolder['panDetails'] as Map<String, dynamic>? ?? {};
      holderLabel = 'third holder';
    } else if (isSecondHolder) {
      uploadSignatureTitle = AppStrings.uploadSignatureForSecondHolder;
      final secondHolder =
          globalStateProvider.get<Map<String, dynamic>>(
            'secondHolderDetails',
          ) ??
          {};
      personalDetails =
          secondHolder['personalDetails'] as Map<String, dynamic>? ?? {};
      panDetails = secondHolder['panDetails'] as Map<String, dynamic>? ?? {};
      holderLabel = 'second holder';
    } else {
      uploadSignatureTitle = AppStrings.uploadSignaturePhoto;
      personalDetails =
          globalStateProvider.get<Map<String, dynamic>>('personalDetails') ??
          {};
      panDetails =
          globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
      holderLabel = 'account holder';
    }

    uploadSignatureSecondaryTitle = 'Upload your signature by selecting a\nsaved signature file from your device';

    if (accountSubCategory == '1') {
      uploadSignatureSecondaryTitle = AppStrings.uploadKartaSignaturewithHUF;
    } else if (accountSubCategory == '5' || accountSubCategory == '6') {
      final dob = panDetails['dob']?.toString() ?? '';

      if (AppHelperWidgets.isUserMinor(dob)) {
        uploadSignatureSecondaryTitle =
            'Since the $holderLabel is minor,\nUpload Minor signature with guardian stamp.';
      }
    }

    selectedImage = null;
    previewImgUrl = null;
    imageBase64 = null;

    final signatureFileString = personalDetails['signatureFileString']
        ?.toString();
    if (signatureFileString != null && signatureFileString.isNotEmpty) {
      previewImgUrl = 'data:image/jpeg;base64,$signatureFileString';
      imageBase64 = signatureFileString;
      try {
        final bytes = base64Decode(signatureFileString);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/signature.jpg');
        await file.writeAsBytes(bytes);
        selectedImage = file;
        // LogHelper.infoLog('Signature restored successfully: ${file.path}');
      } catch (e) {
        LogHelper.errorLog('Restore Signature File Exception: $e');
      }
    }

    isUploadSignatureNotifier.value =
        previewImgUrl != null || selectedImage != null;
    notifyListeners();
  }

  // To Capture Photo
  Future<void> capturePhotoRequest() async {
    try {
      final registration =
          globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
          {};

      final isSecondHolder =
          globalStateProvider.get<bool>('isSecondHolderProcessing') ?? false;
      final isThirdHolder =
          globalStateProvider.get<bool>('isThirdHolderProcessing') ?? false;
      final formNumber = globalStateProvider.get<int>('formNumber');
      Map<String, dynamic> panDetails = {};
      Map<String, dynamic> holderRegistration = {};

      String holderType = AppStrings.firstHolder;

      if (isThirdHolder) {
        final holder =
            globalStateProvider.get<Map<String, dynamic>>(
              'thirdHolderDetails',
            ) ??
            {};
        panDetails = holder['panDetails'] as Map<String, dynamic>? ?? {};
        holderRegistration =
            holder['RegistrationDetail'] as Map<String, dynamic>? ?? {};
        holderType = AppStrings.thirdHolder;
      } else if (isSecondHolder) {
        final holder =
            globalStateProvider.get<Map<String, dynamic>>(
              'secondHolderDetails',
            ) ??
            {};
        panDetails = holder['panDetails'] as Map<String, dynamic>? ?? {};
        holderRegistration =
            holder['RegistrationDetail'] as Map<String, dynamic>? ?? {};
        holderType = AppStrings.secondHolder;
      } else {
        panDetails =
            globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
        holderRegistration = registration;
        holderType = AppStrings.firstHolder;
      }

      final fullName =
          [
                panDetails['firstName'],
                panDetails['middleName'],
                panDetails['lastName'],
              ]
              .where(
                (value) => value != null && value.toString().trim().isNotEmpty,
              )
              .map((value) => value.toString().trim())
              .join(' ');

      final sendSelfieRequestPayload = <String, dynamic>{
        'ocrAccountType': registration['loginType'],
        'ocrFirstName': panDetails['firstName'],
        'ocrMiddleName': panDetails['middleName'],
        'ocrLastName': panDetails['lastName'],
        'ocrFullName': fullName,
        'ocrEmailId': holderRegistration['email'],
        'ocrMobileNo': holderRegistration['mobile']?.toString() ?? '',
        'FormName': AppStrings.onlineClientRegistration,
        'ocrPanNo': panDetails['panNumber'],
        'ocrMode': AppStrings.update,
        'ocrStageFlag': AppStrings.digioSelfieRequest,
        'ocrFormNo': formNumber,
        'Holder': holderType,
      };

      AppHelperWidgets.showLoader();
      final response = await authRepository.sendSelfieRequestRepo(
        requestData: sendSelfieRequestPayload,
      );
      AppHelperWidgets.hideLoader();

      if (response?.data == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final data = response!.data as Map<String, dynamic>;
      final isSuccess = data['success'] == true;
      final returnValue = data['data']?['data']?['output']?['return_Value'];

      if (isSuccess && returnValue == 0) {
        final message = data['message'] as Map<String, dynamic>?;
        if (message != null && (message['id']?.toString() ?? '').isNotEmpty) {
          final documentId = message['id']?.toString() ?? '';
          final identifier = message['customer_identifier']?.toString() ?? '';
          final accessToken = message['access_token'] as Map<String, dynamic>?;
          final tokenId = accessToken?['id']?.toString() ?? '';
          selfieReferenceId = documentId;

          final workflowResponse = await launchDigioSelfieWorkflow(
            documentId: documentId,
            identifier: identifier,
            tokenId: tokenId,
          );

          if (workflowResponse != null) {
            await handleDigioWorkflowResponse(
              workflowResponse: workflowResponse,
              documentId: documentId,
            );
          } else {
            isPhotoCaptured = false;
            isUploadSelfieNotifier.value = false;
            AppHelperWidgets.showSnackBar(
              title: AppStrings.error,
              message: AppStrings.somethingWentWrong,
              messageType: AppStrings.responseTypeError,
            );
          }

          isPhotoCaptured = true;
          globalStateProvider.setState({
            'lastStageUpdated': DateTime.now().toIso8601String(),
          });
          checkResendAvailability();
          notifyListeners();
        } else {
          selfieReferenceId = '';
          notifyListeners();
          return;
        }
      } else {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: data['message']?.toString() ?? AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeWarning,
        );
      }
    } catch (e, s) {
      AppHelperWidgets.hideLoader();
      LogHelper.errorLog('Capture Photo Exception ::: $e\n$s');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    }
  }

  Future<void> handleDigioWorkflowResponse({
    required WorkflowResponse workflowResponse,
    required String documentId,
  }) async {
    try {
      final responseDocumentId = workflowResponse.documentId?.toString() ?? '';
      final code = workflowResponse.code;
      final message = workflowResponse.message?.toString() ?? '';

      LogHelper.infoLog(
        'DIGIO CALLBACK RESPONSE ::: '
        'expectedDocumentId=$documentId, '
        'responseDocumentId=$responseDocumentId, '
        'errorCode=${workflowResponse.errorCode}, '
        'code=$code, '
        'message=$message, '
        'screen=${workflowResponse.screen}, '
        'step=${workflowResponse.step}, '
        'permissions=${workflowResponse.permissions}',
      );

      if (responseDocumentId != documentId) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.somethingWentWrong,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );

        return;
      }

      if (code == 1001) {
        LogHelper.infoLog('success - Fetch Response');
        isPhotoCaptured = true;
        notifyListeners();
        await fetchSelfieResponse(documentId: documentId);

        return;
      }

      if (code == -1000) {
        isPhotoCaptured = true;
        isUploadSelfieNotifier.value = false;
        notifyListeners();

        final now = DateTime.now();
        final requestedAt =
            '${now.hour.toString().padLeft(2, '0')}:'
            '${now.minute.toString().padLeft(2, '0')}';

        AppHelperWidgets.showSnackBar(
          title: AppStrings.yourSelfieVerificationSent,
          message:
              '${AppStrings.selfieVerificationLinkMessage} '
              '$requestedAt.',
          messageType: AppStrings.responseTypeSuccess,
        );

        return;
      }

      if (code == 1002) {
        return;
      }

      if (code == 1003) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.somethingWentWrong,
          message: message.isNotEmpty ? message : AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );

        return;
      }

      if (code == 1004) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.somethingWentWrong,
          message: message.isNotEmpty ? message : AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );

        return;
      }

      AppHelperWidgets.showSnackBar(
        title: AppStrings.somethingWentWrong,
        message: message.isNotEmpty ? message : AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    } catch (e, s) {
      LogHelper.errorLog(
        'HANDLE DIGIO WORKFLOW RESPONSE EXCEPTION ::: '
        '$e\n$s',
      );

      AppHelperWidgets.showSnackBar(
        title: AppStrings.somethingWentWrong,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    }
  }

  //Submit Selfie Details
  Future<void> submitSelfieDetails() async {
    AppHelperWidgets.showLoader();
    try {
      final currentRegistration =
          globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
          {};
      final panDetails =
          globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
      final secondHolderDetails =
          globalStateProvider.get<Map<String, dynamic>>(
            'secondHolderDetails',
          ) ??
          {};
      final thirdHolderDetails =
          globalStateProvider.get<Map<String, dynamic>>('thirdHolderDetails') ??
          {};
      final additionalDetails =
          globalStateProvider.get<Map<String, dynamic>>('additionalDetails') ??
          {};
      final personalDetails =
          globalStateProvider.get<Map<String, dynamic>>('personalDetails') ??
          {};
      final selectedSegmentIds =
          globalStateProvider.get<List>('selectedSegmentIds') ?? [];
      final referalData =
          globalStateProvider.get<Map<String, dynamic>>('referalData') ?? {};

      final formNumber = globalStateProvider.get<int>('formNumber');
      final isSecondHolderProcessing =
          globalStateProvider.get<bool>('isSecondHolderProcessing') ?? false;
      final isThirdHolderProcessing =
          globalStateProvider.get<bool>('isThirdHolderProcessing') ?? false;

      final secondHolderPanDetails =
          secondHolderDetails['panDetails'] as Map<String, dynamic>? ?? {};

      final secondHolderAadharDetails =
          secondHolderDetails['aadharDetails'] as Map<String, dynamic>? ?? {};

      final secondHolderAddressDetails =
          secondHolderDetails['otherAddressDetails'] as Map<String, dynamic>? ??
          {};

      final thirdHolderPanDetails =
          thirdHolderDetails['panDetails'] as Map<String, dynamic>? ?? {};

      final thirdHolderAadharDetails =
          thirdHolderDetails['aadharDetails'] as Map<String, dynamic>? ?? {};

      final thirdHolderAddressDetails =
          thirdHolderDetails['otherAddressDetails'] as Map<String, dynamic>? ??
          {};

      final loginType = currentRegistration['loginType']?.toString() ?? '';
      final List<Map<String, dynamic>> documentDetails = [];

      if ((panDetails['panPDF']?.toString() ?? '').isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'Pan',
          'agImageType': 'application/pdf',
          'agImage': panDetails['panPDF'],
        });
      }

      final firstHolderPanImageOther =
          panDetails['panImageOther'] as Map<String, dynamic>?;

      if ((firstHolderPanImageOther?['panImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'Pan',
          'agImageType': 'image/jpeg',
          'agImage': firstHolderPanImageOther!['panImage'],
        });
      } else if ((panDetails['panImage']?.toString() ?? '').isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'Pan',
          'agImageType': 'image/jpeg',
          'agImage': panDetails['panImage'],
        });
      }

      if ((aadharDetails['aadharPDF']?.toString() ?? '').isNotEmpty) {
        documentDetails.addAll([
          {
            'agHolder': AppStrings.firstHolder,
            'agDocType': null,
            'agDocName': 'AddressProof',
            'agImageType': 'application/pdf',
            'agImage': aadharDetails['aadharPDF'],
          },
          {
            'agHolder': AppStrings.firstHolder,
            'agDocType': null,
            'agDocName': 'IdentityProof',
            'agImageType': 'application/pdf',
            'agImage': aadharDetails['aadharPDF'],
          },
        ]);
      }

      if ((otherAddressDetails['corrDocumentImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'AddressProof',
          'agImageType': 'image/jpeg',
          'agImage': otherAddressDetails['corrDocumentImage'],
        });
      }

      if ((otherAddressDetails['corrDocument1Image']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'AddressProof1',
          'agImageType': 'image/jpeg',
          'agImage': otherAddressDetails['corrDocument1Image'],
        });
      }

      if ((otherAddressDetails['identityProofImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'IdentityProof',
          'agImageType': 'image/jpeg',
          'agImage': otherAddressDetails['identityProofImage'],
        });
      }

      if ((otherAddressDetails['identityProof1Image']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'IdentityProof1',
          'agImageType': 'image/jpeg',
          'agImage': otherAddressDetails['identityProof1Image'],
        });
      }

      if ((secondHolderPanDetails['panPDF']?.toString() ?? '').isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.secondHolder,
          'agDocType': null,
          'agDocName': 'Pan',
          'agImageType': 'application/pdf',
          'agImage': secondHolderPanDetails['panPDF'],
        });
      }

      final secondHolderPanImageOther =
          secondHolderPanDetails['panImageOther'] as Map<String, dynamic>?;

      if ((secondHolderPanImageOther?['panImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'Pan',
          'agImageType': 'image/jpeg',
          'agImage': secondHolderPanImageOther!['panImage'],
        });
      } else if ((secondHolderPanDetails['panImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.secondHolder,
          'agDocType': null,
          'agDocName': 'Pan',
          'agImageType': 'image/jpeg',
          'agImage': secondHolderPanDetails['panImage'],
        });
      }

      if ((secondHolderAadharDetails['aadharPDF']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.addAll([
          {
            'agHolder': AppStrings.secondHolder,
            'agDocType': null,
            'agDocName': 'AddressProof',
            'agImageType': 'application/pdf',
            'agImage': secondHolderAadharDetails['aadharPDF'],
          },
          {
            'agHolder': AppStrings.secondHolder,
            'agDocType': null,
            'agDocName': 'IdentityProof',
            'agImageType': 'application/pdf',
            'agImage': secondHolderAadharDetails['aadharPDF'],
          },
        ]);
      }

      if ((secondHolderAddressDetails['corrDocumentImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.secondHolder,
          'agDocType': null,
          'agDocName': 'AddressProof',
          'agImageType': 'image/jpeg',
          'agImage': secondHolderAddressDetails['corrDocumentImage'],
        });
      }

      if ((secondHolderAddressDetails['corrDocument1Image']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.secondHolder,
          'agDocType': null,
          'agDocName': 'AddressProof1',
          'agImageType': 'image/jpeg',
          'agImage': secondHolderAddressDetails['corrDocument1Image'],
        });
      }

      if ((secondHolderAddressDetails['identityProofImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.secondHolder,
          'agDocType': null,
          'agDocName': 'IdentityProof',
          'agImageType': 'image/jpeg',
          'agImage': secondHolderAddressDetails['identityProofImage'],
        });
      }

      if ((secondHolderAddressDetails['identityProof1Image']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.secondHolder,
          'agDocType': null,
          'agDocName': 'IdentityProof1',
          'agImageType': 'image/jpeg',
          'agImage': secondHolderAddressDetails['identityProof1Image'],
        });
      }

      if ((thirdHolderPanDetails['panPDF']?.toString() ?? '').isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.thirdHolder,
          'agDocType': null,
          'agDocName': 'Pan',
          'agImageType': 'application/pdf',
          'agImage': thirdHolderPanDetails['panPDF'],
        });
      }

      final thirdHolderPanImageOther =
          thirdHolderPanDetails['panImageOther'] as Map<String, dynamic>?;

      if ((thirdHolderPanImageOther?['panImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'Pan',
          'agImageType': 'image/jpeg',
          'agImage': thirdHolderPanImageOther!['panImage'],
        });
      } else if ((thirdHolderPanDetails['panImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.thirdHolder,
          'agDocType': null,
          'agDocName': 'Pan',
          'agImageType': 'image/jpeg',
          'agImage': thirdHolderPanDetails['panImage'],
        });
      }

      if ((thirdHolderAadharDetails['aadharPDF']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.addAll([
          {
            'agHolder': AppStrings.thirdHolder,
            'agDocType': null,
            'agDocName': 'AddressProof',
            'agImageType': 'application/pdf',
            'agImage': thirdHolderAadharDetails['aadharPDF'],
          },
          {
            'agHolder': AppStrings.thirdHolder,
            'agDocType': null,
            'agDocName': 'IdentityProof',
            'agImageType': 'application/pdf',
            'agImage': thirdHolderAadharDetails['aadharPDF'],
          },
        ]);
      }

      if ((thirdHolderAddressDetails['corrDocumentImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.thirdHolder,
          'agDocType': null,
          'agDocName': 'AddressProof',
          'agImageType': 'image/jpeg',
          'agImage': thirdHolderAddressDetails['corrDocumentImage'],
        });
      }

      if ((thirdHolderAddressDetails['corrDocument1Image']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.thirdHolder,
          'agDocType': null,
          'agDocName': 'AddressProof1',
          'agImageType': 'image/jpeg',
          'agImage': thirdHolderAddressDetails['corrDocument1Image'],
        });
      }

      if ((thirdHolderAddressDetails['identityProofImage']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.thirdHolder,
          'agDocType': null,
          'agDocName': 'IdentityProof',
          'agImageType': 'image/jpeg',
          'agImage': thirdHolderAddressDetails['identityProofImage'],
        });
      }

      if ((thirdHolderAddressDetails['identityProof1Image']?.toString() ?? '')
          .isNotEmpty) {
        documentDetails.add({
          'agHolder': AppStrings.thirdHolder,
          'agDocType': null,
          'agDocName': 'IdentityProof1',
          'agImageType': 'image/jpeg',
          'agImage': thirdHolderAddressDetails['identityProof1Image'],
        });
      }
      final Map<String, dynamic> payloadForCKYC = {
        'ocrPanNo': panDetails['panNumber'],
        'ocrAccountType': currentRegistration['accountType'],
        'ocrFirstName': panDetails['firstName'],
        'ocrMiddleName': panDetails['middleName'],
        'ocrLastName': panDetails['lastName'],
        'ocrFullName': panDetails['fullName'],
        'ocrSecHolFirstName': secondHolderPanDetails['firstName'] ?? '',
        'ocrSecHolMiddleName': secondHolderPanDetails['middleName'] ?? '',
        'ocrSecHolLastName': secondHolderPanDetails['lastName'] ?? '',
        'ocrThiHolFirstName': thirdHolderPanDetails['firstName'] ?? '',
        'ocrThiHolMiddleName': thirdHolderPanDetails['middleName'] ?? '',
        'ocrThiHolLastName': thirdHolderPanDetails['lastName'] ?? '',
        'DocumentDetails': documentDetails,
        'UserSign': referalData['Signature'],
        'ocrFormNo': formNumber,
      };

      // LogHelper.infoLog('PAYLOAD FOR CKYC ::: $payloadForCKYC');
      final ckycResponse = await generateCKYCDocAPI(
        requestData: payloadForCKYC,
      );

      if (ckycResponse == null) {
        throw Exception('Generate CKYC document failed');
      }

      final rawSelfieBase64 = selfieDetails['rawBase64']?.toString() ?? '';
      if (rawSelfieBase64.isEmpty) {
        throw Exception('Selfie Base64 is empty');
      }

      final resizedSelfieBase64 = await resizeSelfieImageAPI(
        selfieBase64: rawSelfieBase64,
      );
      if (resizedSelfieBase64 == null || resizedSelfieBase64.isEmpty) {
        throw Exception('Unable to resize selfie');
      }

      List<Map<String, dynamic>> documents = [];

      if (isThirdHolderProcessing) {
        documents.add({
          'agHolder': AppStrings.thirdHolder,
          'agDocType': null,
          'agDocName': 'Photo',
          'agImageType': 'image/jpeg',
          'agImage': resizedSelfieBase64,
        });

        final thirdPersonalDetails =
            thirdHolderDetails['personalDetails'] as Map<String, dynamic>? ??
            {};
        final ipvFileString =
            thirdPersonalDetails['IPVFileString']?.toString() ?? '';
        if (ipvFileString.isNotEmpty) {
          documents.add({
            'agHolder': AppStrings.thirdHolder,
            'agDocType': null,
            'agDocName': 'IPV',
            'agImageType': 'image/jpeg',
            'agImage': ipvFileString,
          });
        }
      } else if (isSecondHolderProcessing) {
        documents.add({
          'agHolder': AppStrings.secondHolder,
          'agDocType': null,
          'agDocName': 'Photo',
          'agImageType': 'image/jpeg',
          'agImage': resizedSelfieBase64,
        });

        final secondPersonalDetails =
            secondHolderDetails['personalDetails'] as Map<String, dynamic>? ??
            {};
        final ipvFileString =
            secondPersonalDetails['IPVFileString']?.toString() ?? '';
        if (ipvFileString.isNotEmpty) {
          documents.add({
            'agHolder': AppStrings.secondHolder,
            'agDocType': null,
            'agDocName': 'IPV',
            'agImageType': 'image/jpeg',
            'agImage': ipvFileString,
          });
        }
      } else {
        documents.add({
          'agHolder': AppStrings.firstHolder,
          'agDocType': null,
          'agDocName': 'Photo',
          'agImageType': 'image/jpeg',
          'agImage': resizedSelfieBase64,
        });

        final ipvFileString =
            personalDetails['IPVFileString']?.toString() ?? '';
        if (loginType == '2' && ipvFileString.isNotEmpty) {
          documents.add({
            'agHolder': AppStrings.firstHolder,
            'agDocType': null,
            'agDocName': 'IPV',
            'agImageType': 'image/jpeg',
            'agImage': ipvFileString,
          });
        }
      }

      final ckycReturnValue = ckycResponse['return_Value'];
      final ckycDocDetails = ckycResponse['CKYCDocDetails'];
      if (ckycReturnValue == 0 &&
          ckycDocDetails is List &&
          ckycDocDetails.isNotEmpty) {
        documents.addAll(
          ckycDocDetails.whereType<Map>().map(
            (item) => Map<String, dynamic>.from(item),
          ),
        );
      }

      final Map<String, dynamic> payload = {
        'ocrStageFlag': AppStrings.photo,
        'ocrDigioSelfieLatitude':
            !isSecondHolderProcessing && !isThirdHolderProcessing
            ? selfieDetails['latitude']
            : null,
        'ocrDigioSelfieLongitude':
            !isSecondHolderProcessing && !isThirdHolderProcessing
            ? selfieDetails['longitude']
            : null,
        'ocrSecHolDigioSelfieLatitude': isSecondHolderProcessing
            ? selfieDetails['latitude']
            : null,
        'ocrSecHolDigioSelfieLongitude': isSecondHolderProcessing
            ? selfieDetails['longitude']
            : null,
        'ocrThiHolDigioSelfieLatitude': isThirdHolderProcessing
            ? selfieDetails['latitude']
            : null,
        'ocrThiHolDigioSelfieLongitude': isThirdHolderProcessing
            ? selfieDetails['longitude']
            : null,
        'ocrFormNo': formNumber,
        'ocrPanNo': panDetails['panNumber'],
        'ocrSecHolPanNo': secondHolderPanDetails['panNumber'],
        'ocrThiHolPanNo': thirdHolderPanDetails['panNumber'],
        'ocrHolder': isThirdHolderProcessing
            ? AppStrings.thirdHolder
            : isSecondHolderProcessing
            ? AppStrings.secondHolder
            : AppStrings.firstHolder,
        'documents': documents,
      };

      // LogHelper.infoLog('INSERT SELFIE PAYLOAD ::: $payload');
      final insertResponse = await authRepository.insertDataRepo(
        requestData: payload,
      );
      if (insertResponse?.data == null) {
        throw Exception('Insert selfie response is empty');
      }

      final responseData = Map<String, dynamic>.from(
        insertResponse!.data as Map,
      );
      final isSuccess = responseData['success'] == true;
      final responseBody = responseData['data'] as Map<String, dynamic>?;
      final output = responseBody?['output'] as Map<String, dynamic>?;
      final returnValue = output?['return_Value'];
      final returnMessage = output?['return_Message']?.toString() ?? '';

      if (isSuccess && returnValue == 0) {
        // LogHelper.infoLog('LINE 8041 ::: INSERT DATA SUCCESS ');
        AppHelperWidgets.showSnackBar(
          title: AppStrings.success,
          message: returnMessage,
          messageType: AppStrings.responseTypeSuccess,
        );

        final savedSelfieDetails = <String, dynamic>{
          'DigioSelfieLatitude': selfieDetails['latitude'],
          'DigioSelfieLongitude': selfieDetails['longitude'],
          'selfieFile': rawSelfieBase64,
          'DigioDocId': selfieReferenceId,
        };

        if (isThirdHolderProcessing) {
          final holderPersonalDetails =
              thirdHolderDetails['personalDetails'] as Map<String, dynamic>? ??
              {};

          // globalStateProvider.setState({
          //   'stage': AppStrings.photo,
          //   'isThirdHolderProcessing': false,
          //   'thirdHolderDetails': {
          //     ...thirdHolderDetails,
          //     'personalDetails': {...holderPersonalDetails, 'selfieDetails': savedSelfieDetails},
          //   },
          // });
        } else if (isSecondHolderProcessing) {
          // final holderPersonalDetails =
          //     secondHolderDetails['personalDetails'] as Map<String, dynamic>? ?? {};
          // globalStateProvider.setState({
          //   'stage': AppStrings.photo,
          //   'isSecondHolderProcessing': false,
          //   'secondHolderDetails': {
          //     ...secondHolderDetails,
          //     'personalDetails': {...holderPersonalDetails, 'selfieDetails': savedSelfieDetails},
          //   },
          // });
        } else {
          // LogHelper.infoLog('FIRST HOLDER PROCESSING');
          globalStateProvider.setState({
            'stage': AppStrings.photo,
            'personalDetails': {
              ...personalDetails,
              'selfieDetails': savedSelfieDetails,
            },
          });
        }

        navigateAfterSelfie();
      } else {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: returnMessage.isNotEmpty
              ? returnMessage
              : AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeWarning,
        );
      }
    } catch (e, s) {
      LogHelper.errorLog('SUBMIT SELFIE DETAILS EXCEPTION ::: $e\n$s');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: 'Server error during submission.',
        messageType: AppStrings.responseTypeError,
      );
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: 'Server error during submission.',
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      AppHelperWidgets.hideLoader();
    }
  }

  Future<void> navigateAfterSelfie() async {
    try {
      final registrationDetail =
          globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
          {};

      final panDetails =
          globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};

      final additionalDetails =
          globalStateProvider.get<Map<String, dynamic>>('additionalDetails') ??
          {};

      final rawSelectedSegmentIds =
          globalStateProvider.get<List>('selectedSegmentIds') ?? [];

      final List<int> selectedSegmentIds = rawSelectedSegmentIds
          .map((e) => int.tryParse(e.toString()))
          .whereType<int>()
          .toList();

      final isSecondHolderProcessing =
          globalStateProvider.get<bool>('isSecondHolderProcessing') ?? false;

      final isThirdHolderProcessing =
          globalStateProvider.get<bool>('isThirdHolderProcessing') ?? false;

      final String subCategory =
          registrationDetail['accountSubCategory']?.toString() ?? '';

      final String loginType =
          registrationDetail['loginType']?.toString() ?? '';

      final String accountOption =
          registrationDetail['accountOption']?.toString() ?? '';

      final bool isMinor = AppHelperWidgets.isUserMinor(panDetails['dob']);
      final bool isDirectMinor = subCategory == '5';
      final bool isNriMinor = subCategory == '6' && isMinor;

      final selectedNsdlClientType =
          additionalDetails['selectedNsdlClientType'] as Map<String, dynamic>?;

      final selectedNsdlSubClientType =
          additionalDetails['selectedNsdlSubClientType']
              as Map<String, dynamic>?;

      final bool trustOthers =
          subCategory == '3' &&
          selectedNsdlClientType?['id'] != 1 &&
          selectedNsdlSubClientType?['id']?.toString() != '1';

      final bool shouldSkipMultiHolder =
          isDirectMinor || isNriMinor || trustOthers;

      final bool hasIncomeProofSegment =
          (selectedSegmentIds.contains(19) &&
              selectedSegmentIds.contains(20)) ||
          selectedSegmentIds.contains(64);

      String nextStep = AppRoutes.nomineeDetailScreen;

      if (hasIncomeProofSegment &&
          !isSecondHolderProcessing &&
          !isThirdHolderProcessing) {
        // LogHelper.infoLog('SELFIE NAVIGATION -> Income Proof');
        nextStep = AppRoutes.uploadIncomeProofScreen;
      } else if (loginType == '2') {
        // const List<String> multiHolderCategories = ['3', '4', '7', '5', '6'];

        // if (multiHolderCategories.contains(subCategory)) {
        //   if (shouldSkipMultiHolder) {
        //     nextStep = AppRoutes.additionalDocumentsScreen;
        //   } else if (accountOption == '1') {
        //     nextStep = AppRoutes.additionalDocumentsScreen;
        //   } else {
        //     nextStep = AppRoutes.multiHolderScreen;
        //   }
        // } else if (['1', '2'].contains(subCategory)) {
        //   nextStep = AppRoutes.additionalDocumentsScreen;
        // }
      }
      // ============================================================
      // 3. Default
      // ============================================================
      else {
        nextStep = AppRoutes.nomineeDetailScreen;
      }

      AppNavigator.push(nextStep);
    } catch (e, stackTrace) {
      LogHelper.errorLog(
        'navigateAfterSelfie Exception: '
        '$e\n$stackTrace',
      );
    }
  }

  // To Resize Selfie Image
  Future<String?> resizeSelfieImageAPI({
    required String selfieBase64,
    int maxFileSize = 50,
  }) async {
    if (selfieBase64.trim().isEmpty) {
      LogHelper.errorLog('RESIZE SELFIE ::: Base64 is empty');
      return null;
    }

    try {
      final cleanBase64 = selfieBase64.contains(',')
          ? selfieBase64.split(',').last
          : selfieBase64;
      final resizeImageRequestPayLoad = <String, dynamic>{
        'filename': AppStrings.selfie,
        'fileData': cleanBase64,
        'maxFileSize': maxFileSize,
      };

      // LogHelper.infoLog('RESIZE SELFIE PAYLOAD ::: $resizeImageRequestPayLoad');
      final response = await authRepository.resizeImageRepo(
        requestData: resizeImageRequestPayLoad,
      );

      if (response == null || response.data == null) {
        // LogHelper.errorLog('RESIZE SELFIE ::: Empty API response');
        return null;
      }

      String resizedBase64 = '';
      if (response.data is Map) {
        final responseMap = Map<String, dynamic>.from(response.data as Map);
        resizedBase64 = responseMap['body']?.toString() ?? '';
      } else {
        resizedBase64 = response.data.toString();
      }

      if (resizedBase64.trim().isEmpty) {
        // LogHelper.errorLog('RESIZE SELFIE ::: Resized Base64 is empty');
        return null;
      }

      resizedBase64 = resizedBase64.replaceFirst(
        RegExp(r'^data:image\/\w+;base64,', caseSensitive: false),
        '',
      );

      // LogHelper.infoLog(
      //   'RESIZE SELFIE SUCCESS ::: '
      //   'base64Length=${resizedBase64.length}',
      // );

      return resizedBase64;
    } catch (e, s) {
      LogHelper.errorLog('RESIZE SELFIE API ERROR ::: $e\n$s');
      return null;
    }
  }

  //GenerateCKYCDocAPI
  Future generateCKYCDocAPI({required Map<String, dynamic> requestData}) async {
    try {
      final response = await authRepository.generateCKYCDocRequestRepo(
        requestData: requestData,
      );
      if (response?.data == null) {
        LogHelper.errorLog('GENERATE CKYC DOC ::: Empty response');
        return null;
      }

      final data = Map<String, dynamic>.from(response!.data as Map);
      // LogHelper.infoLog('GENERATE CKYC DOC SUCCESS ::: $data');
      return data;
    } catch (e, s) {
      LogHelper.errorLog('GENERATE CKYC DOC EXCEPTION ::: $e\n$s');
      return null;
    }
  }

  void removeFetchedSelfie() {
    _fetchedSelfieBase64 = null;
    selfieDetails = {'rawBase64': '', 'latitude': '', 'longitude': ''};
    isUploadSelfieNotifier.value = false;
    isPhotoCaptured = false;
    notifyListeners();
  }

  Future<WorkflowResponse?> launchDigioSelfieWorkflow({
    required String documentId,
    required String identifier,
    required String tokenId,
  }) async {
    try {
      LogHelper.infoLog(
        'LAUNCHING DIGIO WORKFLOW ::: '
        'documentId=$documentId, '
        'identifier=$identifier, '
        'tokenAvailable=${tokenId.isNotEmpty}',
      );

      final digioConfig = DigioConfig();
      digioConfig.environment = Environment.SANDBOX;
      digioConfig.serviceMode = ServiceMode.OTP;
      digioConfig.global = false;
      final kycWorkflow = KycWorkflow(digioConfig);
      kycWorkflow.setGatewayEventListener((GatewayEvent? event) {
        // LogHelper.infoLog('DIGIO GATEWAY EVENT ::: $event');
      });

      final HashMap<String, String> additionalData = HashMap<String, String>();
      final response = await kycWorkflow.start(
        documentId,
        identifier,
        tokenId,
        additionalData,
      );
      return response;
    } catch (e, s) {
      LogHelper.errorLog('Launch Digio Workflow Exception ::: $e\n$s');
      return null;
    }
  }

  //fetchSelfieResponse
  Future<void> fetchSelfieResponse({required String documentId}) async {
    try {
      final Map<String, dynamic> fetchSelfieResponsePayload = {
        'digio_doc_id': documentId,
      };
      AppHelperWidgets.showLoader();
      final response = await authRepository.fetchSelfieResponseRepo(
        requestData: fetchSelfieResponsePayload,
      );

      AppHelperWidgets.hideLoader();
      if (response?.data == null) {
        selfieDetails = {'rawBase64': '', 'latitude': '', 'longitude': ''};
        previewImgUrl = null;
        _fetchedSelfieBase64 = null;
        notifyListeners();
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );

        return;
      }

      final data = response!.data as Map<String, dynamic>;
      final isSuccess = data['success'] == true;
      final selfieImg = data['selfieImg']?.toString() ?? '';
      final message = data['message'];

      if (isSuccess && selfieImg.isNotEmpty && message == null) {
        final geoLocationDetails =
            data['geoLocationDetails'] as Map<String, dynamic>?;
        final latitude = geoLocationDetails?['latitude']?.toString() ?? '';
        final longitude = geoLocationDetails?['longitude']?.toString() ?? '';
        selfieDetails = {
          'rawBase64': selfieImg,
          'latitude': latitude,
          'longitude': longitude,
        };

        previewImgUrl = selfieImg;
        _fetchedSelfieBase64 = selfieImg;
        isUploadSelfieNotifier.value = true;
        notifyListeners();
        AppHelperWidgets.showSnackBar(
          title: AppStrings.success,
          message: AppStrings.fetchedSelfieSuccess,
          messageType: AppStrings.responseTypeSuccess,
        );

        return;
      }

      LogHelper.errorLog(
        'FETCH SELFIE FAILED ::: '
        'success=$isSuccess, '
        'imageAvailable=${selfieImg.isNotEmpty}, '
        'message=$message',
      );

      selfieDetails = {'rawBase64': '', 'latitude': '', 'longitude': ''};
      previewImgUrl = null;
      notifyListeners();

      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: message?.toString().trim().isNotEmpty == true
            ? message.toString()
            : AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    } catch (e, s) {
      AppHelperWidgets.hideLoader();
      selfieDetails = {'rawBase64': '', 'latitude': '', 'longitude': ''};
      previewImgUrl = null;
      _fetchedSelfieBase64 = null;
      notifyListeners();
      LogHelper.errorLog('FETCH SELFIE EXCEPTION ::: $e\n$s');
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.somethingWentWrong,
        messageType: AppStrings.responseTypeError,
      );
    }
  }

  void checkResendAvailability() {
    final lastUpdated = globalStateProvider.get<String>('lastStageUpdated');
    if (lastUpdated == null || lastUpdated.isEmpty) {
      return;
    }

    final localDateStr = lastUpdated.replaceAll('Z', '');
    final parsedTime = DateTime.parse(localDateStr);
    final unlockTime = parsedTime.add(const Duration(minutes: 15));
    resendTimer?.cancel();
    resendTimer = null;
    updateResendTimer(unlockTime);
    if (canResendSelfie) {
      return;
    }

    resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateResendTimer(unlockTime);
    });
  }

  void updateResendTimer(DateTime unlockTime) {
    final now = DateTime.now();
    final remaining = (unlockTime.difference(now).inMilliseconds / 1000).ceil();
    remainingSeconds = remaining > 0 ? remaining : 0;
    canResendSelfie = remaining <= 0;
    notifyListeners();

    if (remaining <= 0) {
      resendTimer?.cancel();
      resendTimer = null;
    }
  }

  Future<void> retrySelfieCapture() async {
    if (!canResendSelfie) return;
    canResendSelfie = false;
    remainingSeconds = const Duration(minutes: 15).inSeconds;
    previewImgUrl = null;
    selectedImage = null;
    isPhotoCaptured = false;
    selfieReferenceId = null;
    imageBase64 = null;

    final nowLocal = DateTime.now().toIso8601String();
    globalStateProvider.setState({'lastStageUpdated': nowLocal});
    notifyListeners();
    checkResendAvailability();
    await capturePhotoRequest();
  }

  //RestoreSelfieImageDetails
  Future<void> restoreSelfieImageDetails(
    GlobalStateProvider globalStateProvider,
  ) async {
    try {
      final registrationDetail = globalStateProvider.get<Map<String, dynamic>>(
        'RegistrationDetail',
      );
      isSecondHolderProcessing =
          globalStateProvider.get<bool>('isSecondHolderProcessing') ?? false;
      isThirdHolderProcessing =
          globalStateProvider.get<bool>('isThirdHolderProcessing') ?? false;
      isEntryRejected =
          globalStateProvider.get<bool>('isEntryRejected') ?? false;
      Map<String, dynamic>? storedSelfieDetails;

      if (isThirdHolderProcessing) {
        selfieTitle = 'Live Photo for Third Holder';
        final thirdHolderDetails = globalStateProvider
            .get<Map<String, dynamic>>('thirdHolderDetails');
        final personalDetails =
            thirdHolderDetails?['personalDetails'] as Map<String, dynamic>?;
        storedSelfieDetails =
            personalDetails?['selfieDetails'] as Map<String, dynamic>?;
      } else if (isSecondHolderProcessing) {
        selfieTitle = 'Live Photo for Second Holder';

        final secondHolderDetails = globalStateProvider
            .get<Map<String, dynamic>>('secondHolderDetails');
        final personalDetails =
            secondHolderDetails?['personalDetails'] as Map<String, dynamic>?;
        storedSelfieDetails =
            personalDetails?['selfieDetails'] as Map<String, dynamic>?;
      } else {
        selfieTitle = 'Live Photo';
        final personalDetails = globalStateProvider.get<Map<String, dynamic>>(
          'personalDetails',
        );
        storedSelfieDetails =
            personalDetails?['selfieDetails'] as Map<String, dynamic>?;
      }

      // LogHelper.debugLog(
      //   'restoreSelfieImageDetails -> '
      //   'storedSelfieDetails: $storedSelfieDetails',
      // );

      final stage = globalStateProvider.get<String>('stage');
      if (stage == 'DigioSelfieRequest') {
        selfieReferenceId = storedSelfieDetails?['DigioDocId']?.toString();
        isPhotoCaptured = true;
        checkResendAvailability();
      }

      // LogHelper.debugLog(
      //   'restoreSelfieImageDetails -> '
      //   'selfieReferenceId: $selfieReferenceId',
      // );

      final loginType = registrationDetail?['loginType']?.toString() ?? '';
      accountSubCategory = registrationDetail?['accountSubCategory'] ?? 0;
      // LogHelper.debugLog(
      //   'restoreSelfieImageDetails -> '
      //   'loginType: $loginType, '
      //   'accountSubCategory: $accountSubCategory',
      // );

      final dynamic selfieFile = storedSelfieDetails?['selfieFile'];

      if (selfieFile == null) {
        // LogHelper.debugLog(
        //   'restoreSelfieImageDetails -> '
        //   'No stored selfieFile found',
        // );

        notifyListeners();
        return;
      }

      // LogHelper.debugLog(
      //   'restoreSelfieImageDetails -> '
      //   'selfieFile runtimeType: ${selfieFile.runtimeType}',
      // );

      selfieDetails = {
        ...selfieDetails,
        'latitude':
            storedSelfieDetails?['DigioSelfieLatitude']?.toString() ?? '',
        'longitude':
            storedSelfieDetails?['DigioSelfieLongitude']?.toString() ?? '',
      };

      isPhotoCaptured = true;

      if (selfieFile is Map) {
        final dynamic fileData = selfieFile['data'];
        final String? mimeType = selfieFile['mime']?.toString();
        // LogHelper.debugLog(
        //   'restoreSelfieImageDetails -> '
        //   'fileData runtimeType: ${fileData.runtimeType}',
        // );

        // LogHelper.debugLog(
        //   'restoreSelfieImageDetails -> '
        //   'mimeType: $mimeType',
        // );

        List<int>? byteArray;

        if (fileData is BufferModel) {
          byteArray = fileData.data
              .map<int>((e) => (e as num).toInt())
              .toList();
        } else if (fileData is Map) {
          final dynamic rawByteArray = fileData['data'];

          if (rawByteArray is List) {
            byteArray = rawByteArray
                .map<int>((e) => (e as num).toInt())
                .toList();
          }
        } else if (fileData is List) {
          byteArray = fileData.map<int>((e) => (e as num).toInt()).toList();
        }

        if (byteArray != null && byteArray.isNotEmpty) {
          final Uint8List bytes = Uint8List.fromList(byteArray);

          final String base64String = base64Encode(bytes);
          selfieDetails = {...selfieDetails, 'rawBase64': base64String};
          _fetchedSelfieBase64 = base64String;
          isPhotoCaptured = true;
          isUploadSelfieNotifier.value = true;

          final tempDirectory = await getTemporaryDirectory();
          String extension = 'jpg';
          if (mimeType?.contains('png') == true) {
            extension = 'png';
          } else if (mimeType?.contains('jpeg') == true ||
              mimeType?.contains('jpg') == true) {
            extension = 'jpg';
          }

          final file = File(
            '${tempDirectory.path}/'
            'selfie_${DateTime.now().millisecondsSinceEpoch}'
            '.$extension',
          );

          await file.writeAsBytes(bytes);
          selectedFile = file;

          // LogHelper.debugLog(
          //   'restoreSelfieImageDetails -> '
          //   'hasFetchedSelfie: $hasFetchedSelfie',
          // );

          notifyListeners();
          return;
        } else {
          // LogHelper.debugLog(
          //   'restoreSelfieImageDetails -> '
          //   'Unable to extract byteArray from selfieFile',
          // );
        }
      }

      if (selfieFile is String) {
        String base64String = selfieFile.trim();
        if (base64String.contains(',')) {
          base64String = base64String.split(',').last;
        }

        if (base64String.isEmpty) {
          // LogHelper.debugLog(
          //   'restoreSelfieImageDetails -> '
          //   'Stored Base64 selfie is empty',
          // );

          notifyListeners();
          return;
        }

        selfieDetails = {...selfieDetails, 'rawBase64': base64String};
        _fetchedSelfieBase64 = base64String;
        isPhotoCaptured = true;
        isUploadSelfieNotifier.value = true;
        final Uint8List bytes = base64Decode(base64String);
        final tempDirectory = await getTemporaryDirectory();
        final file = File(
          '${tempDirectory.path}/'
          'selfie_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        await file.writeAsBytes(bytes);
        selectedFile = file;
        notifyListeners();
        return;
      }

      // LogHelper.debugLog(
      //   'restoreSelfieImageDetails -> '
      //   'Unsupported selfieFile format: '
      //   '${selfieFile.runtimeType}',
      // );

      notifyListeners();
    } catch (e, stackTrace) {
      LogHelper.errorLog(
        'restoreSelfieImageDetails Exception: '
        '$e\n$stackTrace',
      );

      notifyListeners();
    }
  }

  // onFetchIncomeProofAPI
  Future<String?> onFetchIncomeProofAPI() async {
    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};

    final personal =
        globalStateProvider.get<Map<String, dynamic>>('personalDetails') ?? {};
    final bankDetails = personal['bankDetails'] as Map<String, dynamic>? ?? {};
    final mobileNumber = registrationDetail['mobile']?.toString() ?? '';
    final newFormNumber = globalStateProvider.get<int>('formNumber');
    final bankIFSCCode = bankDetails['BankIFSCCode'];
    AppHelperWidgets.showLoader();

    try {
      final bank = await loadExactBankDetails(ifsc: bankIFSCCode ?? '');
      // LogHelper.infoLog('Bank Details: $bank');
      final payload = {
        'mobileNo': mobileNumber,
        'ClientCode': newFormNumber.toString(),
        'redirect': '',
        'type': 'FNO',
        'fipId': null,
        // "fipId": bank?.camsFipId,
        'PAN': '',
      };

      final response = await authRepository.importIncomeProofRepo(
        requestData: payload,
      );

      // LogHelper.infoLog('IIMPORT INCOME :: $response');
      if (response == null || response.data == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.unableToStartIncomeProof,
          messageType: AppStrings.responseTypeError,
        );
        return null;
      }

      final data = response.data as Map<String, dynamic>;
      if (data['Success'] != true) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: data['Message'] ?? AppStrings.unableToStartIncomeProof,
          messageType: AppStrings.responseTypeError,
        );
        return null;
      }

      final redirectUrl = data['response']?['redirectionurl']?.toString();
      if (redirectUrl == null || redirectUrl.isEmpty) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.invalidRedirectionURL,
          messageType: AppStrings.responseTypeError,
        );
        return null;
      }

      return redirectUrl;
    } catch (e, s) {
      LogHelper.errorLog(s.toString());
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.incomeProofError,
        messageType: AppStrings.responseTypeError,
      );

      return null;
    } finally {
      AppHelperWidgets.hideLoader();
    }
  }

  //onIncomeProofBackPressed
  Future<bool> onIncomeProofBackPressed() async {
    if (await incomeProofWebViewController!.canGoBack()) {
      await incomeProofWebViewController!.goBack();
      return false;
    }
    return true;
  }

  Future<void> initializeIncomeProofWebView({
    required String url,
    required Future<void> Function() onSuccess,
    required Future<void> Function() onFailure,
  }) async {
    isIncomeProofLoading = true;
    isIncomeProofCompleted = false;
    notifyListeners();

    incomeProofWebViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'IncomeProofChannel',
        onMessageReceived: (JavaScriptMessage message) async {
          await _handleIncomeProofWebMessage(
            message.message,
            onSuccess: onSuccess,
            onFailure: onFailure,
          );
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (pageUrl) {
            if (!isIncomeProofLoading) {
              isIncomeProofLoading = true;
              notifyListeners();
            }
            unawaited(_injectIncomeProofMessageListener());
          },

          onPageFinished: (pageUrl) async {
            if (isIncomeProofLoading) {
              isIncomeProofLoading = false;
              notifyListeners();
            }

            await _injectIncomeProofMessageListener();
          },

          onNavigationRequest: (request) {
            final currentUrl = request.url;

            final uri = Uri.tryParse(currentUrl);
            final status = uri?.queryParameters['status']?.trim().toUpperCase();

            if (status == 'S') {
              _completeIncomeProofSuccess(onSuccess: onSuccess);
              return NavigationDecision.prevent;
            }

            if (status == 'F' || status == 'N') {
              _completeIncomeProofFailure(onFailure: onFailure);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },

          onWebResourceError: (error) {
            LogHelper.errorLog(
              'Income Proof WebView Error: ${error.description}',
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  Future<void> _handleIncomeProofWebMessage(
    String message, {
    required Future<void> Function() onSuccess,
    required Future<void> Function() onFailure,
  }) async {
    if (isIncomeProofCompleted) {
      LogHelper.infoLog('Income Proof already completed. Ignoring message.');
      return;
    }

    LogHelper.infoLog('INCOME PROOF RAW MESSAGE ::: $message');

    String? status;

    try {
      final decoded = jsonDecode(message);

      if (decoded is Map<String, dynamic>) {
        status = decoded['status']?.toString();
      } else if (decoded is String) {
        status = decoded;
      }
    } catch (_) {
      // Message may simply be "S", "F" or "N"
      status = message;
    }

    status = status?.trim().toUpperCase();

    LogHelper.infoLog('INCOME PROOF PARSED STATUS ::: $status');

    if (status == 'S') {
      await _completeIncomeProofSuccess(onSuccess: onSuccess);
      return;
    }

    if (status == 'F' || status == 'N') {
      await _completeIncomeProofFailure(onFailure: onFailure);
    }
  }

  Future<void> _completeIncomeProofFailure({
    required Future<void> Function() onFailure,
  }) async {
    if (isIncomeProofCompleted) {
      LogHelper.infoLog('Income Proof completion already handled.');
      return;
    }

    isIncomeProofCompleted = true;
    isIncomeProofLoading = false;

    notifyListeners();

    LogHelper.infoLog('INCOME PROOF FAILED - CALLING FAILURE CALLBACK');

    await onFailure();
  }

  Future<void> _completeIncomeProofSuccess({
    required Future<void> Function() onSuccess,
  }) async {
    if (isIncomeProofCompleted) {
      LogHelper.infoLog('Income Proof completion already handled.');
      return;
    }

    isIncomeProofCompleted = true;
    isIncomeProofLoading = false;

    notifyListeners();

    LogHelper.infoLog('INCOME PROOF COMPLETED - CALLING SUCCESS CALLBACK');

    await onSuccess();
  }

  Future<void> _injectIncomeProofMessageListener() async {
    if (incomeProofWebViewController == null) {
      return;
    }

    const javascript = '''
(function() {

  // --- window.opener stub -------------------------------------------
  // CAMS calls window.opener.postMessage({status: 'S'|'F'|'N'}, ...)
  // because it expects to be a real window.open() popup. In a
  // WebView, window.opener is null, so that call is silently
  // skipped or throws. We stub it so the message reaches Flutter.
  if (window.__incomeProofOpenerStubbed !== true) {
    window.__incomeProofOpenerStubbed = true;

    try {
      Object.defineProperty(window, 'opener', {
        configurable: true,
        get: function() {
          return {
            postMessage: function(data, targetOrigin) {
              console.log("INCOME PROOF opener.postMessage:", JSON.stringify(data));
              sendToFlutter(data);
            },
            closed: false,
            close: function() {
              console.log("INCOME PROOF opener.close() called");
            }
          };
        }
      });
      console.log("INCOME PROOF window.opener STUB INSTALLED");
    } catch(e) {
      console.log("INCOME PROOF opener stub failed:", e);
    }
  }

  // --- window.close() override (fallback safety net) -----------------
  if (window.__incomeProofCloseOverridden !== true) {
    window.__incomeProofCloseOverridden = true;
    window.close = function() {
      console.log("INCOME PROOF window.close() INTERCEPTED");
      try {
        if (window.IncomeProofChannel && window.IncomeProofChannel.postMessage) {
          window.IncomeProofChannel.postMessage(JSON.stringify({ type: "CLOSE_REQUESTED" }));
        }
      } catch(e) {
        console.log("Income Proof close override error:", e);
      }
    };
    console.log("INCOME PROOF window.close OVERRIDE INSTALLED");
  }

  // --- postMessage listener + sendToFlutter (existing logic) --------
  if (window.__incomeProofListenerInstalled === true) {
    console.log("Income Proof listener already installed");
    return;
  }

  window.__incomeProofListenerInstalled = true;

  console.log("======================================");
  console.log("INCOME PROOF MESSAGE LISTENER INSTALLED");
  console.log("======================================");

  function sendToFlutter(data) {

    try {

      console.log(
        "INCOME PROOF MESSAGE RECEIVED:",
        JSON.stringify(data)
      );

      if (data === null || data === undefined) {
        return;
      }

      var status = null;

      // Object response
      if (typeof data === "object") {
        status = data.status;
      }

      // JSON string response
      if (typeof data === "string") {

        try {
          var parsed = JSON.parse(data);

          if (parsed && typeof parsed === "object") {
            status = parsed.status;
          } else {
            status = data;
          }

        } catch(e) {
          status = data;
        }
      }

      if (status === null || status === undefined) {
        console.log("Income Proof status not found");
        return;
      }

      status = String(status).trim().toUpperCase();

      console.log(
        "INCOME PROOF STATUS:",
        status
      );

      if (
        status === "S" ||
        status === "F" ||
        status === "N"
      ) {

        var result = {
          status: status
        };

        if (
          window.IncomeProofChannel &&
          window.IncomeProofChannel.postMessage
        ) {
          window.IncomeProofChannel.postMessage(
            JSON.stringify(result)
          );

          console.log(
            "INCOME PROOF STATUS SENT TO FLUTTER:",
            status
          );
        }
      }

    } catch(e) {

      console.log(
        "Income Proof listener error:",
        e
      );

    }
  }

  // Standard browser message listener
  window.addEventListener(
    "message",
    function(event) {

      console.log(
        "INCOME PROOF WINDOW MESSAGE:",
        event.data
      );

      sendToFlutter(event.data);

    },
    false
  );

  // Some CAMS implementations may communicate through parent
  window.addEventListener(
    "message",
    function(event) {

      if (event && event.data) {
        sendToFlutter(event.data);
      }

    },
    true
  );

  console.log(
    "INCOME PROOF MESSAGE LISTENER READY"
  );

})();
''';

    try {
      await incomeProofWebViewController!.runJavaScript(javascript);
      LogHelper.infoLog('INCOME PROOF MESSAGE LISTENER INJECTED');
    } catch (e, s) {
      LogHelper.errorLog('Failed to inject Income Proof listener: $e');
      LogHelper.errorLog(s.toString());
    }
  }

  //getIncomeProofAPI
  Future<bool> getIncomeProofAPI({bool retry = false}) async {
    final formNumber = globalStateProvider.get('formNumber');
    try {
      LogHelper.infoLog('In getIncomeProof');
      final requestData = {
        "tradingCode": formNumber.toString(),
        "bankNumber": null,
      };

      final response = await authRepository.getIncomeProofRepo(
        requestData: requestData,
      );

      if (response?.data == null) {
        fetchedPdfRaw64 = null;
        fetchedPdf = null;
        isUploadIncomeProofNotifier.value = false;
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.unableToFetchIncomeProof,
          messageType: AppStrings.responseTypeError,
        );

        return false;
      }

      final data = response!.data as Map<String, dynamic>;
      if (data['Success'] == true) {
        final rawBase64 = data['Data']?['BankStatementPdf'];

        fetchedPdfRaw64 = rawBase64;
        fetchedPdf = rawBase64 != null && rawBase64.isNotEmpty
            ? 'data:application/pdf;base64,$rawBase64'
            : null;
        if (fetchedPdf != null) {
          await prepareIncomeProofPdf();
        }

        isUploadIncomeProofNotifier.value = true;

        LogHelper.infoLog('Income Proof PDF fetched successfully.');
        LogHelper.infoLog('Base64 Length: ${rawBase64?.length ?? 0}');
        notifyListeners();
        return true;
      }

      fetchedPdfRaw64 = null;
      fetchedPdf = null;
      isUploadIncomeProofNotifier.value = false;

      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: data['Message'] ?? AppStrings.failedToFetchIncomeProof,
        messageType: AppStrings.responseTypeError,
      );

      return false;
    } catch (e, s) {
      fetchedPdfRaw64 = null;
      fetchedPdf = null;
      isUploadIncomeProofNotifier.value = false;
      LogHelper.errorLog('getIncomeProof Exception: $e');
      LogHelper.errorLog(s.toString());
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.unableToFetchIncomeProof,
        messageType: AppStrings.responseTypeError,
      );

      return false;
    } finally {
      AppHelperWidgets.hideLoader();
    }
  }

  Future<bool> prepareIncomeProofPdf() async {
    final path = await createIncomeProofPdfFile();
    if (path == null || path.isEmpty) {
      incomeProofPdfFilePath = null;
      notifyListeners();
      return false;
    }
    incomeProofPdfFilePath = path;
    notifyListeners();
    return true;
  }

  Future<String?> createIncomeProofPdfFile() async {
    try {
      if (fetchedPdf == null || fetchedPdf!.isEmpty) {
        return null;
      }

      String base64Data = fetchedPdf!;

      if (base64Data.contains(',')) {
        base64Data = base64Data.split(',').last;
      }

      base64Data = base64Data.replaceAll('\n', '').replaceAll('\r', '').trim();
      final Uint8List pdfBytes = base64Decode(base64Data);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/income_proof.pdf');
      await file.writeAsBytes(pdfBytes, flush: true);
      LogHelper.infoLog('Income Proof PDF File ::: ${file.path}');
      return file.path;
    } catch (e, s) {
      LogHelper.errorLog('createIncomeProofPdfFile Exception: $e');
      LogHelper.errorLog(s.toString());

      return null;
    }
  }

  //retryGetIncomeProof
  Future<void> retryGetIncomeProof() async {
    LogHelper.infoLog('Retrying Income Proof in 5 seconds...');
    AppHelperWidgets.showSnackBar(
      title: AppStrings.retryInProgress,
      message: AppStrings.retryingIncomeProofIn5Seconds,
      messageType: AppStrings.responseTypeWarning,
    );

    await Future.delayed(const Duration(seconds: 5));
    await getIncomeProofAPI(retry: true);
  }

  // triggerFadeIn
  Future<void> triggerFadeIn() async {
    isFadeIn = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 20));
    isFadeIn = true;
    notifyListeners();
  }

  bool isPDF(String? fileData) {
    if (fileData == null || fileData.isEmpty) {
      return false;
    }

    return fileData.startsWith('data:application/pdf');
  }

  bool isImage(String? fileData) {
    if (fileData == null || fileData.isEmpty) {
      return false;
    }
    return fileData.startsWith('data:image/');
  }

  void clearFile() {
    fetchedPdf = null;
    fetchedPdfRaw64 = null;
    isUploadIncomeProofNotifier.value = false;
    notifyListeners();
  }

  // onFileSelected
  Future<void> onFileSelected() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result == null ||
          result.files.isEmpty ||
          result.files.first.path == null) {
        return;
      }

      final file = File(result.files.first.path!);
      await handleIncomeProofFile(file: file);
    } catch (e, s) {
      LogHelper.errorLog('onFileSelected Exception: $e');
      LogHelper.errorLog(s.toString());

      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.unableToSelectFile,
        messageType: AppStrings.responseTypeError,
      );
    }
  }

  Future<void> handleIncomeProofFile({required File file}) async {
    try {
      final extension = file.path.split('.').last.toLowerCase().trim();
      const validExtensions = ['jpg', 'jpeg', 'png', 'pdf'];
      if (!validExtensions.contains(extension)) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.uploadOnlyJPEGorPNGorPDF,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final bytes = await file.readAsBytes();
      final rawBase64 = base64Encode(bytes);
      final String mimeType;

      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;

        case 'png':
          mimeType = 'image/png';
          break;

        case 'pdf':
          mimeType = 'application/pdf';
          break;

        default:
          AppHelperWidgets.showSnackBar(
            title: AppStrings.error,
            message: AppStrings.unSupportedFileFormat,
            messageType: AppStrings.responseTypeError,
          );
          return;
      }

      selectedIncomeProofFile = file;
      fetchedPdf = 'data:$mimeType;base64,$rawBase64';
      fetchedPdfRaw64 = rawBase64;
      // LogHelper.infoLog('Income Proof selected.');
      // LogHelper.infoLog('File Path :: ${file.path}');
      // LogHelper.infoLog('File Extension :: $extension');
      // LogHelper.infoLog('Mime Type :: $mimeType');
      // LogHelper.infoLog('Base64 Length :: ${rawBase64.length}');
      isUploadIncomeProofNotifier.value = true;
      notifyListeners();
      triggerFadeIn();
    } catch (e, s) {
      LogHelper.errorLog('handleIncomeProofFile Exception: $e');
      LogHelper.errorLog(s.toString());
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.unableToReadSelectedFile,
        messageType: AppStrings.responseTypeError,
      );
    }
  }

  // removeIncomeProofFile
  void removeIncomeProofFile() {
    selectedIncomeProofFile = null;
    fetchedPdf = null;
    fetchedPdfRaw64 = null;
    isUploadIncomeProofNotifier.value = false;
    notifyListeners();
  }

  // incomeProofNextBtnTap
  Future<bool> incomeProofNextBtnTap() async {
    if (fetchedPdf == null || fetchedPdf!.isEmpty) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.validationFailed,
        message: AppStrings.pleaseUploadIncomeProofFirst,
        messageType: AppStrings.responseTypeError,
      );
      return false;
    }
    AppHelperWidgets.showLoader();

    try {
      final processedResult = await processIncomeProof();
      if (processedResult == null) {
        return false;
      }

      final mimeType = processedResult['mimeType']?.toString();
      final finalBase64 = processedResult['finalBase64']?.toString();
      if (mimeType == null ||
          mimeType.isEmpty ||
          finalBase64 == null ||
          finalBase64.isEmpty) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: 'Unable to process Income Proof.',
          messageType: AppStrings.responseTypeError,
        );
        return false;
      }

      final isInserted = await insertIncomeProofIntoDB(
        mimeType: mimeType,
        finalBase64: finalBase64,
      );

      if (!isInserted) {
        return false;
      }

      globalStateProvider.setState({
        'incomeProofPdf': {'base64': finalBase64, 'mime': mimeType},
      });

      await handleIncomeProofNavigation();
      return true;
    } catch (e, s) {
      LogHelper.errorLog('incomeProofNextBtnTap Exception :: $e');
      LogHelper.errorLog(s.toString());

      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: 'Unable to process Income Proof.',
        messageType: AppStrings.responseTypeError,
      );

      return false;
    } finally {
      AppHelperWidgets.hideLoader();
    }
  }

  //InsertIncomeProofIntoDB
  Future<bool> insertIncomeProofIntoDB({
    required String mimeType,
    required String finalBase64,
  }) async {
    try {
      final arrDocuments = [
        {
          "agHolder": AppStrings.firstHolder,
          "agDocType": null,
          "agDocName": AppStrings.incomeProof1,
          "agImageType": mimeType,
          "agImage": finalBase64,
        },
      ];
      final panDetails =
          globalStateProvider.get<Map<String, dynamic>>('panDetails') ?? {};
      final formNumber = globalStateProvider.get<dynamic>('formNumber');

      final insertIncomeProofPayload = {
        "ocrStageFlag": AppStrings.income,
        "ocrFormNo": formNumber?.toString(),
        "ocrPanNo": panDetails['panNumber'],
        "documents": arrDocuments,
      };

      // LogHelper.infoLog(
      //   'INSERT INCOME PROOF PAYLOAD :: '
      //   'formNo=${formNumber?.toString()}, '
      //   'mimeType=$mimeType, '
      //   'base64Length=${finalBase64.length}',
      // );

      final response = await authRepository.insertDataRepo(
        requestData: insertIncomeProofPayload,
      );

      if (response == null || response.data == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );

        return false;
      }

      if (response.data is! Map) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );

        return false;
      }

      final data = Map<String, dynamic>.from(response.data as Map);
      final isSuccess =
          data['success'] == true &&
          data['data']?['output']?['return_Value'] == 0;

      if (isSuccess) {
        final returnMessage =
            data['data']?['output']?['return_Message']?.toString() ??
            'Income Proof uploaded successfully.';

        // LogHelper.infoLog('INSERT INCOME PROOF SUCCESS :: $returnMessage');
        AppHelperWidgets.showSnackBar(
          title: AppStrings.success,
          message: returnMessage,
          messageType: AppStrings.responseTypeSuccess,
        );

        return true;
      }

      final returnMessage =
          data['data']?['output']?['return_Message']?.toString() ??
          'Something went wrong.';

      AppHelperWidgets.showSnackBar(
        title: AppStrings.warning,
        message: returnMessage,
        messageType: AppStrings.responseTypeWarning,
      );

      return false;
    } catch (e, s) {
      LogHelper.errorLog('insertIncomeProofIntoDB Exception :: $e');
      LogHelper.errorLog(s.toString());

      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: 'Server error during saving data.',
        messageType: AppStrings.responseTypeError,
      );

      return false;
    }
  }

  //processIncomeProof
  Future<Map<String, dynamic>?> processIncomeProof() async {
    if (fetchedPdf == null || fetchedPdf!.isEmpty) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.validationFailed,
        message: AppStrings.pleaseUploadIncomeProofFirst,
        messageType: AppStrings.responseTypeError,
      );
      return null;
    }

    try {
      String? mimeType;
      if (isPDF(fetchedPdf)) {
        mimeType = 'application/pdf';
      } else if (isImage(fetchedPdf)) {
        final mimeParts = fetchedPdf!.split(',').first.split(':');

        if (mimeParts.length > 1) {
          mimeType = mimeParts[1].split(';').first;
        }
      }

      if (mimeType == null || mimeType.isEmpty) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: 'Unsupported file format',
          messageType: AppStrings.responseTypeError,
        );
        return null;
      }

      String? finalBase64 = fetchedPdfRaw64;
      if (mimeType != 'application/pdf') {
        // LogHelper.infoLog('MIME TYPE IMAGE');
        try {
          final resizeImagePayload = {
            'filename': 'incomeProof',
            'fileData': fetchedPdfRaw64,
            'maxFileSize': 200,
          };

          final resizeResponse = await authRepository.resizeImageRepo(
            requestData: resizeImagePayload,
          );

          if (resizeResponse?.data == null) {
            throw Exception('Unable to resize Income Proof image.');
          }

          final responseData = resizeResponse!.data;

          if (responseData is String) {
            finalBase64 = responseData
                .replaceFirst(RegExp(r'^"data:.*;base64,'), '')
                .replaceAll('"', '')
                .trim();
          } else {
            finalBase64 = responseData
                .toString()
                .replaceFirst(RegExp(r'^"data:.*;base64,'), '')
                .replaceAll('"', '')
                .trim();
          }

          if (finalBase64 == null || finalBase64!.isEmpty) {
            throw Exception('Image resize returned empty Base64.');
          }
        } catch (e, s) {
          LogHelper.errorLog('IMAGE RESIZE FAILED :: $e');
          LogHelper.errorLog(s.toString());
          AppHelperWidgets.showSnackBar(
            title: AppStrings.resizeError,
            message: 'Unable to resize Income Proof image',
            messageType: AppStrings.responseTypeError,
          );

          return null;
        }
      } else {
        LogHelper.infoLog('MIME TYPE PDF');
        try {
          final cleanedBase64 =
              await checkIncomeProofIsEncryptedOrPasswordProtectedAPI();
          if (cleanedBase64 == null || cleanedBase64.isEmpty) {
            return null;
          }
          final resizedBase64 = await pdfResizeAPI(fileData: cleanedBase64);
          if (resizedBase64 == null || resizedBase64.isEmpty) {
            LogHelper.errorLog(
              'PDF PROCESS FAILED ::: PDF resize returned empty data',
            );
            return null;
          }
          finalBase64 = resizedBase64;
        } catch (e, s) {
          LogHelper.errorLog('PDF PROCESS FAILED ::: $e');
          LogHelper.errorLog(s.toString());
          return null;
        }
      }

      if (finalBase64 == null || finalBase64!.isEmpty) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: 'Unable to process Income Proof.',
          messageType: AppStrings.responseTypeError,
        );

        return null;
      }
      return {'mimeType': mimeType, 'finalBase64': finalBase64};
    } catch (e, s) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: 'Unable to process Income Proof.',
        messageType: AppStrings.responseTypeError,
      );

      return null;
    }
  }

  // checkIncomeProofIsEncryptedOrPasswordProtectedAPI
  Future<String?> checkIncomeProofIsEncryptedOrPasswordProtectedAPI() async {
    try {
      final formNumber = globalStateProvider.get<dynamic>('formNumber');
      final rawBase64 = fetchedPdfRaw64
          ?.replaceFirst(RegExp(r'^data:.*;base64,'), '')
          .replaceAll('"', '')
          .trim();

      if (rawBase64 == null || rawBase64.isEmpty) {
        LogHelper.errorLog('CHECK PDF FAILED :: fetchedPdfRaw64 is null/empty');

        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfCheckedFailed,
          message: AppStrings.incomeProofPDFDataIsEmpty,
          messageType: AppStrings.responseTypeError,
        );

        return null;
      }

      final requestData = {
        "formNo": formNumber.toString(),
        "IncomeProofDoc": rawBase64,
      };

      final response = await authRepository
          .checkIncomeProofIsEncryptedOrPasswordProtectedRepo(
            requestData: requestData,
          );

      if (response == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfCheckedFailed,
          message: AppStrings.unableToCheck,
          messageType: AppStrings.responseTypeError,
        );
        return null;
      }

      if (response.data == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfCheckedFailed,
          message: AppStrings.unableToCheck,
          messageType: AppStrings.responseTypeError,
        );

        return null;
      }

      final responseData = response.data;
      if (responseData is! Map) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfCheckedFailed,
          message: AppStrings.invalidResponseFromPDFCheck,
          messageType: AppStrings.responseTypeError,
        );

        return null;
      }

      final data = Map<String, dynamic>.from(responseData);

      if (data['data'] == null) {
        final message =
            data['StatusMessage']?.toString() ??
            data['message']?.toString() ??
            'Unable to check Income Proof PDF.';

        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfCheckedFailed,
          message: message,
          messageType: AppStrings.responseTypeError,
        );

        return null;
      }

      final cleanedBase64 = data['data']
          .toString()
          .replaceFirst(RegExp(r'^data:.*;base64,'), '')
          .replaceAll('"', '')
          .trim();

      if (cleanedBase64.isEmpty) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfCheckedFailed,
          message: AppStrings.pdfCheckReturnedEmptyData,
          messageType: AppStrings.responseTypeError,
        );
        return null;
      }

      return cleanedBase64;
    } catch (e, s) {
      LogHelper.errorLog(
        'checkIncomeProofIsEncryptedOrPasswordProtectedAPI Exception :: $e',
      );
      LogHelper.errorLog(s.toString());
      AppHelperWidgets.showSnackBar(
        title: AppStrings.pdfCheckedFailed,
        message: AppStrings.unableToProcessPDF,
        messageType: AppStrings.responseTypeError,
      );

      return null;
    }
  }

  // pdfResizeAPI
  Future<String?> pdfResizeAPI({required String fileData}) async {
    LogHelper.infoLog('========== PDF RESIZE START ==========');
    LogHelper.infoLog('PDF INPUT BASE64 LENGTH ::: ${fileData.length}');

    try {
      final pdfResizeRequestPayload = {
        'fileData': fileData,
        'maxFileSize': 200,
      };

      // LogHelper.infoLog(
      //   'PDF RESIZE PAYLOAD ::: '
      //   'fileDataLength=${fileData.length}, '
      //   'maxFileSize=200',
      // );

      final response = await authRepository.pdfResizeRepo(
        requestData: pdfResizeRequestPayload,
      );

      // LogHelper.infoLog('PDF RESIZE STATUS CODE ::: ${response?.statusCode}');

      if (response == null || response.data == null) {
        LogHelper.errorLog('PDF RESIZE FAILED ::: response/data is null');

        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfResizeFailed,
          message: 'Unable to resize Income Proof PDF.',
          messageType: AppStrings.responseTypeError,
        );

        return null;
      }

      final responseData = response.data;

      // LogHelper.infoLog(
      //   'PDF RESIZE RESPONSE TYPE ::: '
      //   '${responseData.runtimeType}',
      // );

      if (response.statusCode != 200) {
        String errorMessage = 'Unable to resize Income Proof PDF.';
        if (responseData is Map) {
          final data = Map<String, dynamic>.from(responseData);
          errorMessage =
              data['error']?.toString() ??
              data['message']?.toString() ??
              errorMessage;

          // LogHelper.errorLog('PDF RESIZE API ERROR ::: $errorMessage');
        }

        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfResizeFailed,
          message: errorMessage,
          messageType: AppStrings.responseTypeWarning,
        );

        // LogHelper.infoLog('========== PDF RESIZE END WITH ERROR ==========');

        return null;
      }

      if (responseData is! Map) {
        // LogHelper.errorLog(
        //   'PDF RESIZE INVALID RESPONSE TYPE ::: '
        //   '${responseData.runtimeType}',
        // );

        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfResizeFailed,
          message: AppStrings.invalidResponseFromPDFService,
          messageType: AppStrings.responseTypeError,
        );

        return null;
      }

      final data = Map<String, dynamic>.from(responseData);

      // LogHelper.infoLog(
      //   'PDF RESIZE RESPONSE KEYS ::: '
      //   '${data.keys.toList()}',
      // );

      final resizedBase64 = data['fileData']?.toString();
      if (resizedBase64 == null || resizedBase64.trim().isEmpty) {
        LogHelper.errorLog('PDF RESIZE FAILED ::: response.fileData is empty');

        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfResizeFailed,
          message: 'PDF resize returned empty file data.',
          messageType: AppStrings.responseTypeError,
        );

        return null;
      }

      String finalBase64 = resizedBase64.trim();
      finalBase64 = finalBase64.replaceFirst(RegExp(r'^"data:.*;base64,'), '');
      finalBase64 = finalBase64.replaceFirst(RegExp(r'^data:.*;base64,'), '');
      finalBase64 = finalBase64.replaceFirst(RegExp(r'"$'), '');
      finalBase64 = finalBase64.trim();

      if (finalBase64.isEmpty) {
        LogHelper.errorLog('PDF RESIZE FAILED ::: cleaned Base64 is empty');
        AppHelperWidgets.showSnackBar(
          title: AppStrings.pdfResizeFailed,
          message: 'PDF resize returned empty file data.',
          messageType: AppStrings.responseTypeError,
        );
        return null;
      }
      LogHelper.infoLog(
        'PDF RESIZE SUCCESS ::: '
        'final Base64 length = ${finalBase64.length}',
      );

      LogHelper.infoLog('========== PDF RESIZE END ==========');
      return finalBase64;
    } catch (e, s) {
      LogHelper.errorLog('pdfResizeAPI Exception ::: $e');
      LogHelper.errorLog(s.toString());
      AppHelperWidgets.showSnackBar(
        title: AppStrings.pdfResizeFailed,
        message: 'Unable to resize Income Proof PDF.',
        messageType: AppStrings.responseTypeError,
      );

      return null;
    }
  }

  //handleIncomeProofNavigation
  Future<void> handleIncomeProofNavigation() async {
    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};

    final additionalDetails =
        globalStateProvider.get<Map<String, dynamic>>('additionalDetails') ??
        {};

    final loginType = registrationDetail['loginType']?.toString();
    final accountSubCategory = registrationDetail['accountSubCategory']
        ?.toString();
    final accountOption = registrationDetail['accountOption']?.toString();
    final selectedNsdlClientType =
        (additionalDetails['selectedNsdlClientType']
                as Map<String, dynamic>?)?['id']
            ?.toString();
    final selectedNsdlSubClientType =
        (additionalDetails['selectedNsdlSubClientType']
                as Map<String, dynamic>?)?['id']
            ?.toString();
    final firstNavigationCondition =
        (loginType == '2' && accountSubCategory == '4') ||
        accountSubCategory == '3' ||
        accountSubCategory == '6' ||
        accountSubCategory == '7';

    if (firstNavigationCondition) {
      if (accountOption == '1') {
        LogHelper.infoLog('Income Proof Navigation → Additional Documents');
        // AppNavigator.push(AppRoutes.additionalDocumentsScreen);

        return;
      }

      if (accountSubCategory == '3' &&
          selectedNsdlClientType != '1' &&
          selectedNsdlSubClientType != '1') {
        LogHelper.infoLog('Trust Others → Additional Documents');
        // AppNavigator.push(AppRoutes.additionalDocumentsScreen);
        return;
      }

      LogHelper.infoLog('Income Proof Navigation → Multi Holder');

      // AppNavigator.push(AppRoutes.multiHolderScreen);

      return;
    }

    // ==========================================================
    if (loginType == '2' && ['1', '2', '5'].contains(accountSubCategory)) {
      LogHelper.infoLog('Income Proof Navigation → Additional Documents');

      // AppNavigator.push(AppRoutes.additionalDocumentsScreen);

      return;
    }

    // LogHelper.infoLog('Income Proof Navigation → Nominee Details');
    AppNavigator.push(AppRoutes.nomineeDetailScreen);
  }

  void freezeUI() {
    isUIFrozen = true;
    debugPrint('[APPLog] UI is frozen');
    notifyListeners();
  }

  void unfreezeUI() {
    isUIFrozen = false;
    debugPrint('[APPLog] UI is unfrozen');
    notifyListeners();
  }

  // RestoreIncomeProofState
  Future<void> restoreIncomeProofFromGlobalState(
    GlobalStateProvider globalStateProvider,
  ) async {
    try {
      final stored = globalStateProvider.get('incomeProofPdf');

      if (stored == null || stored is! Map) {
        // LogHelper.errorLog('RESTORE INCOME PROOF :: Invalid incomeProofPdf');
        return;
      }

      final mime = stored['mime']?.toString();
      if (mime == null || mime.isEmpty) {
        // LogHelper.errorLog('RESTORE INCOME PROOF :: MIME is missing');
        return;
      }

      final storedData = stored['data'];

      String? raw64;
      if (storedData != null &&
          storedData.runtimeType.toString().contains('BufferModel')) {
        try {
          final buffer = storedData as dynamic;
          final bufferData = buffer.data;
          if (bufferData is List) {
            final bytes = bufferData
                .map<int>((e) => int.parse(e.toString()))
                .toList();

            raw64 = base64Encode(bytes);
            // LogHelper.infoLog(
            //   'RESTORE INCOME PROOF :: BufferModel CASE SUCCESS',
            // );
          }
        } catch (e, s) {
          // LogHelper.errorLog(
          //   'RESTORE INCOME PROOF :: BufferModel conversion failed :: $e',
          // );
          LogHelper.errorLog(s.toString());
        }
      }

      if (raw64 == null && storedData is Map) {
        final byteArray = storedData['data'];

        if (byteArray is List) {
          final bytes = byteArray
              .map<int>((e) => int.parse(e.toString()))
              .toList();

          raw64 = base64Encode(bytes);

          // LogHelper.infoLog('RESTORE INCOME PROOF :: Map/List CASE SUCCESS');
        }
      }

      if (raw64 == null && storedData is List) {
        final bytes = storedData
            .map<int>((e) => int.parse(e.toString()))
            .toList();

        raw64 = base64Encode(bytes);

        // LogHelper.infoLog('RESTORE INCOME PROOF :: List CASE SUCCESS');
      }

      if (raw64 == null && storedData is String) {
        raw64 = storedData
            .replaceFirst(RegExp(r'^data:.*;base64,'), '')
            .replaceAll('"', '')
            .trim();

        // LogHelper.infoLog('RESTORE INCOME PROOF :: String CASE SUCCESS');
      }

      if (raw64 == null && stored['base64'] != null) {
        raw64 = stored['base64']
            .toString()
            .replaceFirst(RegExp(r'^data:.*;base64,'), '')
            .replaceAll('"', '')
            .trim();

        // LogHelper.infoLog('RESTORE INCOME PROOF :: Base64 CASE SUCCESS');
      }

      if (raw64 == null || raw64.isEmpty) {
        // LogHelper.errorLog('RESTORE INCOME PROOF :: Unable to extract Base64');
        // LogHelper.errorLog('Available Keys :: ${stored.keys.toList()}');
        return;
      }

      fetchedPdfRaw64 = raw64;
      fetchedPdf = 'data:$mime;base64,$raw64';

      isUploadIncomeProofNotifier.value = true;
      notifyListeners();
    } catch (e, s) {
      LogHelper.errorLog('restoreIncomeProofFromGlobalState Exception :: $e');
      LogHelper.errorLog(s.toString());
    }
  }

  String getIncomeProofMimeType() {
    final stored =
        globalStateProvider.get<Map<String, dynamic>>('incomeProofPdf') ?? {};
    return stored['mime']?.toString() ?? '';
  }

  void setNomineeRelationshipError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeRelationshipHasError = hasError;
    _nomineeRelationshipError = errorMessage;
    notifyListeners();
  }

  //Validate Relationship
  void validateNomineeRelationshipOnFocusLoss() {
    final isNotSelected =
        selectedNomineeRelationship == null ||
        selectedNomineeRelationship!.trim().isEmpty;

    if (isNotSelected) {
      setNomineeRelationshipError(
        hasError: true,
        errorMessage: AppStrings.relationRequired,
      );
    } else {
      setNomineeRelationshipError(hasError: false, errorMessage: '');
    }
  }

  //Validate State
  void validateNomineeStateOnFocusLoss() {
    final selectedText = selectedState?.trim() ?? '';
    final isNotSelected =
        selectedText.isEmpty || selectedText == AppStrings.state.trim();
    setNomineeStateError(
      hasError: isNotSelected,
      errorMessage: isNotSelected ? AppStrings.stateRequired : '',
    );
  }

  //Validate City
  void validateNomineeCityOnFocusLoss() {
    final selectedText = selectedCity?.trim() ?? '';
    final isNotSelected =
        selectedText.isEmpty || selectedText == AppStrings.city.trim();
    setNomineeCityError(
      hasError: isNotSelected,
      errorMessage: isNotSelected ? AppStrings.cityRequired : '',
    );
  }

  //Validate Pincode
  void validateNomineePinCodeOnFocusLoss() {
    final selectedText = selectedPincode?.trim() ?? '';
    final isNotSelected =
        selectedText.isEmpty || selectedText == AppStrings.pincode.trim();

    setNomineePinCodeError(
      hasError: isNotSelected,
      errorMessage: isNotSelected ? AppStrings.pincodeIsRequired : '',
    );
  }

  //validateNomineeRelationship
  bool validateNomineeRelationship() {
    final isNotSelected =
        selectedNomineeRelationship == null ||
        selectedNomineeRelationship!.trim().isEmpty;
    if (isNotSelected) {
      setNomineeRelationshipError(
        hasError: true,
        errorMessage: AppStrings.relationRequired,
      );
      return false;
    }

    setNomineeRelationshipError(hasError: false, errorMessage: '');
    return true;
  }

  // updateSelectedNomineeRelationship
  void updateSelectedNomineeRelationship(PurpleRecordset selectedItem) {
    selectedNomineeRelationship = selectedItem.name;
    setNomineeRelationshipError(hasError: false, errorMessage: '');
    updateGuardianRelationOptions(selectedItem.id?.toString());
  }

  //removeNomineeDocument
  Future<void> removeNomineeDocument() async {
    firstNomineeDocumentUploadController.clear();
    nomineeDocumentImage = null;
    notifyListeners();
  }

  //populateNomineeAddressFromAadhaar
  void populateNomineeAddressFromAadhaar() {
    final aadhaarDetails = globalStateProvider.get<Map<String, dynamic>>(
      'aadharDetails',
    );
    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};

    final mobileNumber = registrationDetail['mobile']?.toString() ?? '';
    final email = registrationDetail['email']?.toString() ?? '';
    final currentAddress =
        aadhaarDetails?['currentAddress'] as Map<String, dynamic>?;
    if (currentAddress == null) {
      LogHelper.errorLog('AADHAR CURRENT ADDRESS IS NULL');
      return;
    }

    firstNomineeAddress1Controller.text =
        currentAddress['address1']?.toString().toUpperCase() ?? '';
    firstNomineeAddress2Controller.text =
        currentAddress['address2']?.toString().toUpperCase() ?? '';
    firstNomineeAddress3Controller.text =
        currentAddress['address3']?.toString().toUpperCase() ?? '';
    firstNomineeMobileNumberController.text = mobileNumber;
    firstNomineeEmailController.text = email;
    final countryId = currentAddress['country']?.toString();
    final countryItem = countryList.firstWhere(
      (item) => item.id?.toString() == countryId,
    );

    updateSelectedCountry(countryItem);
    final stateId = currentAddress['state']?.toString();
    final stateItem = stateList.firstWhere(
      (item) => item.id?.toString() == stateId,
    );

    updateSelectedState(stateItem);
    final cityId = currentAddress['city']?.toString();
    final cityItem = cityList.firstWhere(
      (item) => item.id?.toString() == cityId,
    );

    updateSelectedCity(cityItem);
    final pincodeId = currentAddress['pincode']?.toString();
    final pincodeItem = pinCodeList.firstWhere(
      (item) => item.id?.toString() == pincodeId,
    );
    updateSelectedPinCode(pincodeItem);
  }

  //populateGuardianAddressFromAadhaar
  void populateGuardianAddressFromAadhaar() {
    final aadhaarDetails = globalStateProvider.get<Map<String, dynamic>>(
      'aadharDetails',
    );

    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};

    final mobileNumber = registrationDetail['mobile']?.toString() ?? '';
    final email = registrationDetail['email']?.toString() ?? '';
    final currentAddress =
        aadhaarDetails?['currentAddress'] as Map<String, dynamic>?;

    if (currentAddress == null) {
      LogHelper.errorLog('AADHAR CURRENT ADDRESS IS NULL');
      return;
    }

    guardianAddress1Controller.text =
        currentAddress['address1']?.toString().toUpperCase() ?? '';

    guardianAddress2Controller.text =
        currentAddress['address2']?.toString().toUpperCase() ?? '';

    guardianAddress3Controller.text =
        currentAddress['address3']?.toString().toUpperCase() ?? '';

    guardianMobileNumberController.text = mobileNumber;
    guardianEmailController.text = email;
    final countryId = currentAddress['country']?.toString();
    final countryMatches = countryList.where(
      (item) => item.id?.toString() == countryId,
    );

    if (countryMatches.isEmpty) {
      LogHelper.errorLog('GUARDIAN COUNTRY NOT FOUND: $countryId');
      return;
    }

    final countryItem = countryMatches.first;
    updateSelectedGuardianCountry(countryItem);

    final stateId = currentAddress['state']?.toString();

    final stateMatches = guardianStateList.where(
      (item) => item.id?.toString() == stateId,
    );

    if (stateMatches.isEmpty) {
      LogHelper.errorLog('GUARDIAN STATE NOT FOUND: $stateId');
      return;
    }

    final stateItem = stateMatches.first;
    updateSelectedGuardianState(stateItem);

    final cityId = currentAddress['city']?.toString();

    final cityMatches = guardianCityList.where(
      (item) => item.id?.toString() == cityId,
    );

    if (cityMatches.isEmpty) {
      LogHelper.errorLog('GUARDIAN CITY NOT FOUND: $cityId');
      return;
    }

    final cityItem = cityMatches.first;
    updateSelectedGuardianCity(cityItem);

    final pincodeId = currentAddress['pincode']?.toString();

    final pincodeMatches = guardianPinCodeList.where(
      (item) => item.id?.toString() == pincodeId,
    );

    if (pincodeMatches.isEmpty) {
      LogHelper.errorLog('GUARDIAN PINCODE NOT FOUND: $pincodeId');
      return;
    }

    final pincodeItem = pincodeMatches.first;
    updateSelectedGuardianPinCode(pincodeItem);
    notifyListeners();
  }

  //  clearNomineeAddressValidation
  void clearNomineeAddressValidation() {
    setNomineeAddress1Error(hasError: false, errorMessage: '');
    setNomineeAddress2Error(hasError: false, errorMessage: '');
    setNomineeAddress3Error(hasError: false, errorMessage: '');
    setNomineeCountryError(hasError: false, errorMessage: '');
    setNomineeStateError(hasError: false, errorMessage: '');
    setNomineeCityError(hasError: false, errorMessage: '');
    setNomineePinCodeError(hasError: false, errorMessage: '');
  }

  //onAddressSameCorrespondence
  void onNomineeAddressSameCorrespondence() {
    isNomineeAddressSameAsCorrepondence = !isNomineeAddressSameAsCorrepondence;
    if (isNomineeAddressSameAsCorrepondence) {
      populateNomineeAddressFromAadhaar();
      clearNomineeAddressValidation();
    } else {
      clearNomineeAddressDetails();
    }
    notifyListeners();
  }

  //updateSelectedCountry
  void updateSelectedCountry(PurpleRecordset selectedItem) {
    selectedCountryItem = selectedItem;
    selectedStateItem = null;
    selectedCityItem = null;
    stateList = allStateListForFiltering.where((state) {
      return state.countryId?.toString() == selectedItem.id.toString();
    }).toList();

    cityList = [];
    notifyListeners();
  }

  //updateSelectedState
  void updateSelectedState(PurpleRecordset selectedItem) {
    selectedStateItem = selectedItem;
    selectedCityItem = null;
    final countryId = selectedCountryItem?.id.toString();
    final stateId = selectedItem.id.toString();
    cityList = allCityListForFiltering.where((city) {
      return city.countryId?.toString() == countryId &&
          city.stateId?.toString() == stateId;
    }).toList();

    notifyListeners();
  }

  //updateSelectedCity
  void updateSelectedCity(PurpleRecordset selectedItem) {
    selectedCityItem = selectedItem;
    selectedPinCodeItem = null;
    final cityId = selectedItem.id.toString();
    pinCodeList = allPinCodeListForFiltering.where((pinCode) {
      return pinCode.cityId?.toString() == cityId;
    }).toList();

    notifyListeners();
  }

  //updateSelectedPinCode
  void updateSelectedPinCode(PurpleRecordset selectedItem) {
    selectedPinCodeItem = selectedItem;
    notifyListeners();
  }

  // onGuardianAddressSameCorrespondence
  void onGuardianAddressSameCorrespondence() {
    isGuardianAddressSameAsCorrepondence =
        !isGuardianAddressSameAsCorrepondence;
    if (isGuardianAddressSameAsCorrepondence) {
      populateGuardianAddressFromAadhaar();
    } else {
      clearGuardianAddressDetails();
    }
    notifyListeners();
  }

  //resetNomineefDetails
  void resetNomineefDetails() {
    firstNomineeNameController.clear();
    firstNomineePANNumberController.clear();
    firstNomineeDobController.clear();
    firstNomineeAddress1Controller.clear();
    firstNomineeAddress2Controller.clear();
    firstNomineeAddress3Controller.clear();
    firstNomineeMobileNumberController.clear();
    firstNomineeEmailController.clear();
    firstNomineeDocumentUploadController.clear();
    firstNomineeDocumentNumberController.clear();

    selectedNomineeDocumentType = null;
    selectedNomineeRelationship = null;

    selectedCountryItem = null;
    selectedStateItem = null;
    selectedCityItem = null;
    selectedPinCodeItem = null;

    isNomineeMinor = false;
    addNomineeNotifier.value = false;

    // Clear dependent lists
    stateList = [];
    cityList = [];
    pinCodeList = [];

    isNomineeAddressSameAsCorrepondence = false;

    setNomineeCountryError(hasError: false, errorMessage: '');
    setNomineeStateError(hasError: false, errorMessage: '');
    setNomineeCityError(hasError: false, errorMessage: '');
    setNomineePinCodeError(hasError: false, errorMessage: '');
    setNomineeRelationshipError(hasError: false, errorMessage: '');
    _nomineeRelationshipHasError = false;
    _nomineeRelationshipError = '';
    showNomineeValidationError = false;
    notifyListeners();
  }
  // void resetNomineefDetails() {
  //   firstNomineeNameController.clear();
  //   firstNomineePANNumberController.clear();
  //   firstNomineeDobController.clear();
  //   firstNomineeAddress1Controller.clear();
  //   firstNomineeAddress2Controller.clear();
  //   firstNomineeAddress3Controller.clear();
  //   firstNomineeMobileNumberController.clear();
  //   firstNomineeEmailController.clear();
  //   firstNomineeDocumentUploadController.clear();
  //   firstNomineeDocumentNumberController.clear();

  //   selectedNomineeDocumentType = null;
  //   selectedNomineeRelationship = null;
  //   selectedCountryItem = null;
  //   selectedStateItem = null;
  //   selectedCityItem = null;
  //   selectedPinCodeItem = null;
  //   isNomineeMinor = false;
  //   addNomineeNotifier.value = false;

  //   stateList = [];
  //   cityList = [];
  //   pinCodeList = [];
  //   isNomineeAddressSameAsCorrepondence = false;

  //   setNomineeCountryError(hasError: false, errorMessage: '');
  //   setNomineeStateError(hasError: false, errorMessage: '');
  //   setNomineeCityError(hasError: false, errorMessage: '');
  //   setNomineePinCodeError(hasError: false, errorMessage: '');
  //   setNomineeRelationshipError(hasError: false, errorMessage: '');
  //   _nomineeRelationshipHasError = false;
  //   _nomineeRelationshipError = '';
  // }

  //clearNomineeAddressDetails
  void clearNomineeAddressDetails() {
    firstNomineeAddress1Controller.clear();
    firstNomineeAddress2Controller.clear();
    firstNomineeAddress3Controller.clear();
    firstNomineeMobileNumberController.clear();
    firstNomineeEmailController.clear();
    selectedCountryItem = null;
    selectedStateItem = null;
    selectedCityItem = null;
    selectedPinCodeItem = null;
    stateList = [];
    cityList = [];
    pinCodeList = [];
    setNomineeAddress1Error(hasError: false, errorMessage: '');
    setNomineeAddress2Error(hasError: false, errorMessage: '');
    setNomineeAddress3Error(hasError: false, errorMessage: '');
    setNomineeCountryError(hasError: false, errorMessage: '');
    setNomineeStateError(hasError: false, errorMessage: '');
    setNomineeCityError(hasError: false, errorMessage: '');
    setNomineePinCodeError(hasError: false, errorMessage: '');
  }

  //resetGuardianDetails
  void resetGuardianDetails() {
    guardianNameController.clear();
    guardianDobController.clear();
    guardianRelationController.clear();
    guardianAddress1Controller.clear();
    guardianAddress2Controller.clear();
    guardianAddress3Controller.clear();
    guardianCountryController.clear();
    guardianStateController.clear();
    guardianCityController.clear();
    guardianPinCodeController.clear();
    guardianDocumentTypeController.clear();
    guardianDocumentNumberController.clear();
    guardianDocumentUploadController.clear();
    guardianMobileNumberController.clear();
    guardianEmailController.clear();
    // Reset validation flags
    guardianNameHasError = false;
    guardianDobHasError = false;
    // guardianRelationHasError = false;
    guardianAddress1HasError = false;
    guardianAddress2HasError = false;
    guardianAddress3HasError = false;
    guardianCountryHasError = false;
    guardianStateHasError = false;
    guardianCityHasError = false;
    guardianPinCodeHasError = false;
    guardianDocumentTypeHasError = false;
    guardianDocumentNumberHasError = false;
    guardianDocumentImageHasError = false;
    guardianMobileHasError = false;
    guardianEmailHasError = false;
    guardianRelationshipHasError = false;

    // Reset validation messages
    guardianNameError = '';
    guardianDobError = '';
    // guardianRelationError = '';
    guardianAddress1Error = '';
    guardianAddress2Error = '';
    guardianAddress3Error = '';
    guardianCountryError = '';
    guardianStateError = '';
    guardianCityError = '';
    guardianPinCodeError = '';
    guardianDocumentTypeError = '';
    guardianDocumentNumberError = '';
    guardianDocumentImageError = '';
    guardianMobileError = '';
    guardianEmailError = '';
    guardianRelationshipError = '';
    isGuardianAddressSameAsCorrepondence = false;
  }

  //clearGuardianAddressDetails
  void clearGuardianAddressDetails() {
    guardianAddress1Controller.clear();
    guardianAddress2Controller.clear();
    guardianAddress3Controller.clear();
    guardianMobileNumberController.clear();
    guardianEmailController.clear();

    selectedGuardianCountryItem = null;
    selectedGuardianStateItem = null;
    selectedGuardianCityItem = null;
    selectedGuardianPinCodeItem = null;

    guardianStateList = [];
    guardianCityList = [];
    guardianPinCodeList = [];

    notifyListeners();
  }

  //updateSelectedGuardianCountry
  void updateSelectedGuardianCountry(PurpleRecordset selectedItem) {
    selectedGuardianCountryItem = selectedItem;
    selectedGuardianStateItem = null;
    selectedGuardianCityItem = null;
    selectedGuardianPinCodeItem = null;

    guardianStateList = allStateListForFiltering.where((state) {
      return state.countryId?.toString() == selectedItem.id.toString();
    }).toList();

    guardianCityList = [];
    guardianPinCodeList = [];
    notifyListeners();
  }

  //updateSelectedGuardianState
  void updateSelectedGuardianState(PurpleRecordset selectedItem) {
    selectedGuardianStateItem = selectedItem;
    selectedGuardianCityItem = null;
    selectedGuardianPinCodeItem = null;
    final countryId = selectedGuardianCountryItem?.id.toString();
    final stateId = selectedItem.id.toString();
    guardianCityList = allCityListForFiltering.where((city) {
      return city.countryId?.toString() == countryId &&
          city.stateId?.toString() == stateId;
    }).toList();

    guardianPinCodeList = [];
    notifyListeners();
  }

  //updateSelectedGuardianCity
  void updateSelectedGuardianCity(PurpleRecordset selectedItem) {
    selectedGuardianCityItem = selectedItem;
    selectedGuardianPinCodeItem = null;
    final cityId = selectedItem.id.toString();
    guardianPinCodeList = allPinCodeListForFiltering.where((pinCode) {
      return pinCode.cityId?.toString() == cityId;
    }).toList();

    notifyListeners();
  }

  void updateSelectedGuardianPinCode(PurpleRecordset selectedItem) {
    selectedGuardianPinCodeItem = selectedItem;
    notifyListeners();
  }

  DateTime? get firstNomineeDob {
    final value = firstNomineeDobController.text.trim();
    if (value.isEmpty) {
      return null;
    }

    final parts = value.split('-');
    if (parts.length != 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return null;
    }

    return DateTime(year, month, day);
  }

  void onNomineeDobChanged(DateTime? selectedDate) {
    if (selectedDate == null) {
      return;
    }
    final day = selectedDate.day.toString().padLeft(2, '0');
    final month = selectedDate.month.toString().padLeft(2, '0');
    final year = selectedDate.year.toString();
    firstNomineeDobController.text = '$day-$month-$year';
    isNomineeMinor = AppHelperWidgets.isUserMinor(
      firstNomineeDobController.text.trim(),
    );

    if (isNomineeMinor) {
      setGuardianValidators();
    } else {
      clearGuardianValidators(reset: true);
    }

    validateNomineeRelationship();
    notifyListeners();
  }

  //onGuardianDobChanged
  void onGuardianDobChanged(DateTime? selectedDate) {
    if (selectedDate == null) {
      return;
    }

    final day = selectedDate.day.toString().padLeft(2, '0');
    final month = selectedDate.month.toString().padLeft(2, '0');
    final year = selectedDate.year.toString();

    guardianDobController.text = '$day-$month-$year';
    final nomineeDob = firstNomineeDobController.text.trim();
    if (nomineeDob.isNotEmpty) {
      isNomineeMinor = AppHelperWidgets.isUserMinor(nomineeDob);
    }

    if (isNomineeMinor) {
      setGuardianValidators();
    } else {
      clearGuardianValidators(reset: true);
    }

    validateGuardianDob(
      nomineeDob: nomineeDob,
      guardianDob: guardianDobController.text.trim(),
    );

    updateAddNomineeButtonState();
    notifyListeners();
  }

  //setGuardianValidators
  void setGuardianValidators() {
    final isNri =
        globalStateProvider.get<String>(
          'RegistrationDetail.accountSubCategory',
        ) ==
        '6';

    // Guardian Name
    final guardianName = guardianNameController.text.trim();
    guardianNameHasError = guardianName.isEmpty;
    guardianNameError = guardianNameHasError ? AppStrings.required : '';

    // Guardian DOB
    final guardianDob = guardianDobController.text.trim();
    guardianDobHasError = guardianDob.isEmpty;
    guardianDobError = guardianDobHasError ? AppStrings.required : '';

    // Guardian Relation
    final guardianRelation = guardianRelationController.text.trim();
    guardianRelationshipHasError = guardianRelation.isEmpty;
    guardianRelationshipError = guardianRelationshipHasError
        ? AppStrings.required
        : '';

    // Address 1
    final address1 = guardianAddress1Controller.text.trim();
    guardianAddress1HasError = address1.isEmpty;
    guardianAddress1Error = guardianAddress1HasError ? AppStrings.required : '';

    // Address 2
    final address2 = guardianAddress2Controller.text.trim();
    guardianAddress2HasError = address2.isEmpty;
    guardianAddress2Error = guardianAddress2HasError ? AppStrings.required : '';

    // Address 3
    final address3 = guardianAddress3Controller.text.trim();
    guardianAddress3HasError = address3.isEmpty;
    guardianAddress3Error = guardianAddress3HasError ? AppStrings.required : '';

    // Country
    final country = guardianCountryController.text.trim();
    guardianCountryHasError = country.isEmpty;
    guardianCountryError = guardianCountryHasError ? AppStrings.required : '';

    // State
    final state = guardianStateController.text.trim();
    guardianStateHasError = state.isEmpty;
    guardianStateError = guardianStateHasError ? AppStrings.required : '';

    // City
    final city = guardianCityController.text.trim();
    guardianCityHasError = city.isEmpty;
    guardianCityError = guardianCityHasError ? AppStrings.required : '';

    // Pincode
    final pinCode = guardianPinCodeController.text.trim();
    guardianPinCodeHasError = pinCode.isEmpty;
    guardianPinCodeError = guardianPinCodeHasError ? AppStrings.required : '';
    guardianDocumentTypeHasError = selectedGuardianDocumentType == null;
    guardianDocumentTypeError = guardianDocumentTypeHasError
        ? AppStrings.required
        : '';

    final documentNumber = guardianDocumentNumberController.text.trim();
    guardianDocumentNumberHasError = documentNumber.isEmpty;
    guardianDocumentNumberError = guardianDocumentNumberHasError
        ? AppStrings.required
        : '';

    final mobile = guardianMobileNumberController.text.trim();
    if (isNri) {
      guardianMobileHasError = mobile.isEmpty;
      guardianMobileError = guardianMobileHasError ? AppStrings.required : '';
    } else {
      guardianMobileHasError =
          mobile.isEmpty || !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile);
      guardianMobileError = guardianMobileHasError
          ? (mobile.isEmpty ? AppStrings.required : AppStrings.invalid)
          : '';
    }

    // Email
    final email = guardianEmailController.text.trim();
    guardianEmailHasError =
        email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    guardianEmailError = guardianEmailHasError
        ? (email.isEmpty ? AppStrings.required : AppStrings.invalid)
        : '';

    notifyListeners();
  }

  //clearGuardianValidators
  void clearGuardianValidators({bool reset = false}) {
    guardianNameHasError = false;
    guardianDobHasError = false;
    guardianRelationshipHasError = false;
    guardianAddress1HasError = false;
    guardianAddress2HasError = false;
    guardianAddress3HasError = false;
    guardianCountryHasError = false;
    guardianStateHasError = false;
    guardianCityHasError = false;
    guardianPinCodeHasError = false;
    guardianDocumentTypeHasError = false;
    guardianDocumentNumberHasError = false;
    guardianDocumentImageHasError = false;
    guardianMobileHasError = false;
    guardianEmailHasError = false;

    guardianNameError = '';
    guardianDobError = '';
    guardianRelationshipError = '';
    guardianAddress1Error = '';
    guardianAddress2Error = '';
    guardianAddress3Error = '';
    guardianCountryError = '';
    guardianStateError = '';
    guardianCityError = '';
    guardianPinCodeError = '';
    guardianDocumentTypeError = '';
    guardianDocumentNumberError = '';
    guardianDocumentImageError = '';
    guardianMobileError = '';
    guardianEmailError = '';

    if (reset) {
      guardianNameController.clear();
      guardianDobController.clear();
      guardianRelationController.clear();
      guardianAddress1Controller.clear();
      guardianAddress2Controller.clear();
      guardianAddress3Controller.clear();
      guardianCountryController.clear();
      guardianStateController.clear();
      guardianCityController.clear();
      guardianPinCodeController.clear();
      guardianDocumentTypeController.clear();
      guardianDocumentNumberController.clear();
      guardianDocumentUploadController.clear();
      guardianMobileNumberController.clear();
      guardianEmailController.clear();
    }

    notifyListeners();
  }

  //onGuardianDocumentUploaded
  Future<void> onGuardianDocumentUploaded() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.single;
    if (file.path == null || file.path!.isEmpty) {
      LogHelper.errorLog('Guardian document file path is null');
      return;
    }

    guardianDocumentImage = File(file.path!);
    guardianDocumentUploadController.text = file.name;
    LogHelper.infoLog('SELECTED GUARDIAN DOCUMENT :: ${file.name}');
    notifyListeners();
  }

  //removeNomineeDocument
  Future<void> removeGuardianDocument() async {
    guardianDocumentUploadController.clear();
    guardianDocumentImage = null;
    notifyListeners();
  }

  void setNomineeNameError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeNameHasError = hasError;
    _nomineeNameError = errorMessage;
    notifyListeners();
  }

  void setNomineeDobError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeDobHasError = hasError;
    _nomineeDobError = errorMessage;
    notifyListeners();
  }

  void setNomineeAddress1Error({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeAddress1HasError = hasError;
    _nomineeAddress1Error = errorMessage;
    notifyListeners();
  }

  void setNomineeAddress2Error({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeAddress2HasError = hasError;
    _nomineeAddress2Error = errorMessage;
    notifyListeners();
  }

  void setNomineeAddress3Error({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeAddress3HasError = hasError;
    _nomineeAddress3Error = errorMessage;
    notifyListeners();
  }

  void setNomineeCountryError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeCountryHasError = hasError;
    _nomineeCountryError = errorMessage;
    notifyListeners();
  }

  void setNomineeStateError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeStateHasError = hasError;
    _nomineeStateError = errorMessage;
    notifyListeners();
  }

  void setNomineeCityError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeCityHasError = hasError;
    _nomineeCityError = errorMessage;
    notifyListeners();
  }

  void setNomineePinCodeError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineePinCodeHasError = hasError;
    _nomineePinCodeError = errorMessage;
    notifyListeners();
  }

  void setNomineeDocumentTypeError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeDocumentTypeHasError = hasError;
    _nomineeDocumentTypeError = errorMessage;
    notifyListeners();
  }

  void setNomineeDocumentNumberError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeDocumentNumberHasError = hasError;
    _nomineeDocumentNumberError = errorMessage;
    notifyListeners();
  }

  void setNomineeDocumentImageError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeDocumentImageHasError = hasError;
    _nomineeDocumentImageError = errorMessage;
    notifyListeners();
  }

  void setNomineeMobileError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeMobileHasError = hasError;
    _nomineeMobileError = errorMessage;
    notifyListeners();
  }

  void setNomineeEmailError({
    required bool hasError,
    required String errorMessage,
  }) {
    _nomineeEmailHasError = hasError;
    _nomineeEmailError = errorMessage;
    notifyListeners();
  }

  void setGuardianNameError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianNameHasError = hasError;
    guardianNameError = errorMessage;
    notifyListeners();
  }

  void setGuardianDobError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianDobHasError = hasError;
    guardianDobError = errorMessage;
    notifyListeners();
  }

  void setGuardianAddress1Error({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianAddress1HasError = hasError;
    guardianAddress1Error = errorMessage;
    notifyListeners();
  }

  void setGuardianAddress2Error({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianAddress2HasError = hasError;
    guardianAddress2Error = errorMessage;
    notifyListeners();
  }

  void setGuardianAddress3Error({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianAddress3HasError = hasError;
    guardianAddress3Error = errorMessage;
    notifyListeners();
  }

  void setGuardianCountryError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianCountryHasError = hasError;
    guardianCountryError = errorMessage;
    notifyListeners();
  }

  void setGuardianStateError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianStateHasError = hasError;
    guardianStateError = errorMessage;
    notifyListeners();
  }

  void setGuardianCityError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianCityHasError = hasError;
    guardianCityError = errorMessage;
    notifyListeners();
  }

  void setGuardianPinCodeError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianPinCodeHasError = hasError;
    guardianPinCodeError = errorMessage;
    notifyListeners();
  }

  void setGuardianDocumentTypeError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianDocumentTypeHasError = hasError;
    guardianDocumentTypeError = errorMessage;
    notifyListeners();
  }

  void setGuardianDocumentNumberError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianDocumentNumberHasError = hasError;
    guardianDocumentNumberError = errorMessage;
    notifyListeners();
  }

  void setGuardianDocumentImageError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianDocumentImageHasError = hasError;
    guardianDocumentImageError = errorMessage;
    notifyListeners();
  }

  void setGuardianMobileError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianMobileHasError = hasError;
    guardianMobileError = errorMessage;
    notifyListeners();
  }

  void setGuardianEmailError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianEmailHasError = hasError;
    guardianEmailError = errorMessage;
    notifyListeners();
  }

  //validateNomineeDocumentNumber
  bool validateNomineeDocumentNumber() {
    final value = firstNomineeDocumentNumberController.text.trim();
    if (selectedNomineeDocumentType == null) {
      setNomineeDocumentNumberError(
        hasError: true,
        errorMessage: AppStrings.documentTypeRequired,
      );
      return false;
    }

    if (value.isEmpty) {
      setNomineeDocumentNumberError(
        hasError: true,
        errorMessage: AppStrings.enterDocumentNumber,
      );
      return false;
    }

    final documentType = int.tryParse(
      selectedNomineeDocumentType!.id.toString(),
    );

    if (documentType == 1) {
      if (!RegExp(r'^\d{4}$').hasMatch(value)) {
        setNomineeDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.last4DigitAadhar,
        );
        return false;
      }
    }
    // Passport
    else if (documentType == 4) {
      if (value.length > 25) {
        setNomineeDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.passPortNumberCannot,
        );
        return false;
      }
    }
    // Driving Licence
    else if (documentType == 5) {
      if (value.length > 25) {
        setNomineeDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.drivingLicenceNumberCannot,
        );
        return false;
      }
    }
    // PAN
    else if (documentType == 0) {
      if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
        setNomineeDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.enterValidPANNumber,
        );
        return false;
      }

      if (value.length > 10) {
        setNomineeDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.panNumberCannotExceed,
        );
        return false;
      }
    } else {
      if (value.length > 25) {
        setNomineeDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.docNumberCannotExceed,
        );
        return false;
      }
    }

    setNomineeDocumentNumberError(hasError: false, errorMessage: '');
    return true;
  }

  //applyNomineeDocumentTypeRules
  void applyNomineeDocumentTypeRules(dynamic docType) {
    final int documentType = int.tryParse(docType?.toString() ?? '') ?? -1;
    switch (documentType) {
      case 1:
        // Aadhaar
        nomineeProofPlaceholder = AppStrings.last4DigitAadhar;
        nomineeProofMaxSize = 4;
        break;

      case 4:
        // Passport
        nomineeProofPlaceholder = AppStrings.passportNumber;
        nomineeProofMaxSize = 25;
        break;

      case 5:
        // Driving Licence
        nomineeProofPlaceholder = AppStrings.drivingLicenceNumber;
        nomineeProofMaxSize = 25;
        break;

      case 0:
        // PAN
        nomineeProofPlaceholder = AppStrings.panNumber;
        nomineeProofMaxSize = 10;
        break;

      default:
        nomineeProofPlaceholder = AppStrings.documentProofNo;
        nomineeProofMaxSize = 25;
        break;
    }

    validateNomineeDocumentNumber();
    notifyListeners();
  }

  void setGuardianRelationshipError({
    required bool hasError,
    required String errorMessage,
  }) {
    guardianRelationshipHasError = hasError;
    guardianRelationshipError = errorMessage;
    notifyListeners();
  }

  //updateGuardianRelationOptions
  void updateGuardianRelationOptions(String? nomineeRelationId) {
    selectedGuardianRelationship = null;
    guardianRelationshipHasError = false;
    guardianRelationshipError = '';

    if (nomineeRelationId == null || nomineeRelationId.trim().isEmpty) {
      filteredGuardianRelationsList = [...nomineeRelationShipList];
      notifyListeners();
      return;
    }

    final validRelationIds =
        AppConstants.guardianRelationMap[nomineeRelationId] ?? [];

    filteredGuardianRelationsList = nomineeRelationShipList.where((relation) {
      return validRelationIds.contains(relation.id?.toString());
    }).toList();
    notifyListeners();
  }

  //updateSelectedGuardianRelationship
  void updateSelectedGuardianRelationship(PurpleRecordset selectedItem) {
    selectedGuardianRelationship = selectedItem.name?.trim();
    guardianRelationshipHasError = false;
    guardianRelationshipError = '';
    updateAddNomineeButtonState();
    notifyListeners();
  }

  bool validateGuardianDob({String? nomineeDob, String? guardianDob}) {
    guardianDobHasError = false;
    guardianDobError = '';
    if (nomineeDob == null ||
        nomineeDob.trim().isEmpty ||
        guardianDob == null ||
        guardianDob.trim().isEmpty) {
      notifyListeners();
      return true;
    }

    final nomineeDate = _parseDob(nomineeDob);
    final guardianDate = _parseDob(guardianDob);

    if (nomineeDate == null || guardianDate == null) {
      guardianDobHasError = true;
      guardianDobError = AppStrings.invalidDateOfBirth;
      notifyListeners();
      return false;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (nomineeDate.isAfter(today)) {
      guardianDobHasError = true;
      guardianDobError = AppStrings.nomineeFutureDob;
      notifyListeners();
      return false;
    }

    if (guardianDate.isAfter(today)) {
      guardianDobHasError = true;
      guardianDobError = AppStrings.guardianFutureDob;
      notifyListeners();
      return false;
    }

    if (guardianDate.isAfter(nomineeDate)) {
      guardianDobHasError = true;
      guardianDobError = AppStrings.guardianMustBeOlder;
      notifyListeners();
      return false;
    }

    int guardianAge = today.year - guardianDate.year;
    if (today.month < guardianDate.month ||
        (today.month == guardianDate.month && today.day < guardianDate.day)) {
      guardianAge--;
    }

    if (guardianAge < 18) {
      guardianDobHasError = true;
      guardianDobError = AppStrings.guardianMustBe18OrOlder;
      notifyListeners();
      return false;
    }

    guardianDobHasError = false;
    guardianDobError = '';
    notifyListeners();
    return true;
  }

  DateTime? _parseDob(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final parts = value.trim().split('-');
    if (parts.length != 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      return null;
    }

    try {
      final date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return null;
      }

      return date;
    } catch (_) {
      return null;
    }
  }

  // Validate Guardian Details Errors
  void validateGuardianDetailsErrors() {
    final guardianName = guardianNameController.text.trim();
    setGuardianNameError(
      hasError: guardianName.isEmpty,
      errorMessage: guardianName.isEmpty ? AppStrings.enterGuardianName : '',
    );

    final guardianDob = guardianDobController.text.trim();
    setGuardianDobError(
      hasError: guardianDob.isEmpty || guardianDobHasError,
      errorMessage: guardianDob.isEmpty
          ? AppStrings.guardianDobRequired
          : guardianDobHasError
          ? guardianDobError
          : '',
    );

    final isGuardianRelationshipEmpty =
        selectedGuardianRelationship == null ||
        selectedGuardianRelationship!.trim().isEmpty;
    setGuardianRelationshipError(
      hasError: isGuardianRelationshipEmpty,
      errorMessage: isGuardianRelationshipEmpty
          ? AppStrings.relationRequired
          : '',
    );

    final address1 = guardianAddress1Controller.text.trim();
    setGuardianAddress1Error(
      hasError: address1.length < 3,
      errorMessage: address1.isEmpty
          ? AppStrings.address1Required
          : AppStrings.minimumOf3Char,
    );

    final address2 = guardianAddress2Controller.text.trim();
    setGuardianAddress2Error(
      hasError: address2.isNotEmpty && address2.length < 3,
      errorMessage: address2.isNotEmpty && address2.length < 3
          ? AppStrings.minimumOf3Char
          : '',
    );

    final address3 = guardianAddress3Controller.text.trim();
    setGuardianAddress3Error(
      hasError: address3.isNotEmpty && address3.length < 3,
      errorMessage: address3.isNotEmpty && address3.length < 3
          ? AppStrings.minimumOf3Char
          : '',
    );

    final isCountryEmpty = selectedGuardianCountry == null;
    setGuardianCountryError(
      hasError: isCountryEmpty,
      errorMessage: isCountryEmpty ? AppStrings.countryRequired : '',
    );

    final isStateEmpty = selectedGuardianState == null;
    setGuardianStateError(
      hasError: isStateEmpty,
      errorMessage: isStateEmpty ? AppStrings.stateRequired : '',
    );

    final isCityEmpty = selectedGuardianCity == null;
    setGuardianCityError(
      hasError: isCityEmpty,
      errorMessage: isCityEmpty ? AppStrings.cityRequired : '',
    );

    final isPinCodeEmpty = selectedGuardianPincode == null;
    setGuardianPinCodeError(
      hasError: isPinCodeEmpty,
      errorMessage: isPinCodeEmpty ? AppStrings.pinCodeRequired : '',
    );

    final isDocumentTypeEmpty = selectedGuardianDocumentType == null;
    setGuardianDocumentTypeError(
      hasError: isDocumentTypeEmpty,
      errorMessage: isDocumentTypeEmpty ? AppStrings.documentTypeRequired : '',
    );

    final documentNumber = guardianDocumentNumberController.text.trim();
    if (documentNumber.isEmpty) {
      setGuardianDocumentNumberError(
        hasError: true,
        errorMessage: AppStrings.documentNumberRequired,
      );
    } else {
      validateGuardianDocumentNumber();
    }

    final documentImage = guardianDocumentUploadController.text.trim();
    setGuardianDocumentImageError(
      hasError: documentImage.isEmpty,
      errorMessage: documentImage.isEmpty
          ? AppStrings.documentImageRequired
          : '',
    );

    final mobile = guardianMobileNumberController.text.trim();
    final isMobileInvalid =
        mobile.isEmpty || !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile);
    setGuardianMobileError(
      hasError: isMobileInvalid,
      errorMessage: isMobileInvalid ? AppStrings.enterValidMobile : '',
    );

    final email = guardianEmailController.text.trim();
    final isEmailInvalid =
        email.isEmpty || !RegExp(AppConstants.emailRegex).hasMatch(email);
    setGuardianEmailError(
      hasError: isEmailInvalid,
      errorMessage: email.isEmpty
          ? AppStrings.enterEmail
          : AppStrings.enterValidEmail,
    );
  }

  // Validate Guardian Details
  bool validateGuardianDetails({bool showErrors = true}) {
    if (showErrors) {
      validateGuardianDetailsErrors();
      showGuardianValidationError = true;
    }

    bool isValid = true;

    final guardianName = guardianNameController.text.trim();
    if (guardianName.length < 2) {
      isValid = false;
    }

    final guardianDob = guardianDobController.text.trim();
    if (guardianDob.isEmpty || guardianDobHasError) {
      isValid = false;
    }

    if (selectedGuardianRelationship == null ||
        selectedGuardianRelationship!.trim().isEmpty) {
      isValid = false;
    }

    // LogHelper.infoLog(
    //   'GUARDIAN VALIDATION START\n'
    //   'Name: $guardianName\n'
    //   'DOB: $guardianDob\n'
    //   'Relationship: $selectedGuardianRelationship\n'
    //   'Country: ${selectedGuardianCountryItem?.id}\n'
    //   'State: ${selectedGuardianStateItem?.id}\n'
    //   'City: ${selectedGuardianCityItem?.id}\n'
    //   'Pincode: ${selectedGuardianPinCodeItem?.id}\n'
    //   'Mobile: ${guardianMobileNumberController.text.trim()}\n'
    //   'Email: ${guardianEmailController.text.trim()}\n'
    //   'DocumentType: ${selectedGuardianDocumentType?.id}\n'
    //   'DocumentNumber: ${guardianDocumentNumberController.text.trim()}\n'
    //   'DocumentImage: ${guardianDocumentUploadController.text.trim()}',
    // );

    final address1 = guardianAddress1Controller.text.trim();
    if (address1.length < 3) {
      isValid = false;
    }

    final address2 = guardianAddress2Controller.text.trim();
    if (address2.isNotEmpty && address2.length < 3) {
      isValid = false;
    }

    final address3 = guardianAddress3Controller.text.trim();
    if (address3.isNotEmpty && address3.length < 3) {
      isValid = false;
    }

    if (selectedGuardianCountryItem == null) {
      isValid = false;
    }

    if (selectedGuardianStateItem == null) {
      isValid = false;
    }

    if (selectedGuardianCityItem == null) {
      isValid = false;
    }

    if (selectedGuardianPinCodeItem == null ||
        selectedGuardianPinCodeItem!.name == null ||
        selectedGuardianPinCodeItem!.name!.trim().isEmpty) {
      isValid = false;
    }

    final mobile = guardianMobileNumberController.text.trim();
    if (mobile.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      isValid = false;
    }

    final email = guardianEmailController.text.trim();
    if (email.isEmpty || !RegExp(AppConstants.emailRegex).hasMatch(email)) {
      isValid = false;
    }

    if (selectedGuardianDocumentType == null) {
      isValid = false;
    }

    if (!validateGuardianDocumentNumber()) {
      isValid = false;
    }

    if (guardianDocumentUploadController.text.trim().isEmpty) {
      isValid = false;
    }

    if (showErrors) {
      notifyListeners();
    }

    return isValid;
  }

  void validateNomineeDetailsErrors() {
    final nomineeName = firstNomineeNameController.text.trim();
    setNomineeNameError(
      hasError: nomineeName.isEmpty,
      errorMessage: nomineeName.isEmpty ? AppStrings.enterNomineeName : '',
    );

    final nomineeDob = firstNomineeDobController.text.trim();

    setNomineeDobError(
      hasError: nomineeDob.isEmpty,
      errorMessage: nomineeDob.isEmpty ? AppStrings.nomineeDobRequired : '',
    );

    final isNomineeRelationshipEmpty =
        selectedNomineeRelationship == null ||
        selectedNomineeRelationship!.trim().isEmpty;

    setNomineeRelationshipError(
      hasError: isNomineeRelationshipEmpty,
      errorMessage: isNomineeRelationshipEmpty
          ? AppStrings.relationRequired
          : '',
    );

    final address1 = firstNomineeAddress1Controller.text.trim();

    setNomineeAddress1Error(
      hasError: address1.length < 3,
      errorMessage: address1.isEmpty
          ? AppStrings.address1Required
          : AppStrings.minimumOf3Char,
    );

    final address2 = firstNomineeAddress2Controller.text.trim();

    setNomineeAddress2Error(
      hasError: address2.isNotEmpty && address2.length < 3,
      errorMessage: address2.isNotEmpty && address2.length < 3
          ? AppStrings.minimumOf3Char
          : '',
    );

    final address3 = firstNomineeAddress3Controller.text.trim();

    setNomineeAddress3Error(
      hasError: address3.isNotEmpty && address3.length < 3,
      errorMessage: address3.isNotEmpty && address3.length < 3
          ? AppStrings.minimumOf3Char
          : '',
    );

    final isCountryEmpty = selectedCountry == null;

    setNomineeCountryError(
      hasError: isCountryEmpty,
      errorMessage: isCountryEmpty ? AppStrings.countryRequired : '',
    );

    final isStateEmpty = selectedState == null;

    setNomineeStateError(
      hasError: isStateEmpty,
      errorMessage: isStateEmpty ? AppStrings.stateRequired : '',
    );

    final isCityEmpty = selectedCity == null;

    setNomineeCityError(
      hasError: isCityEmpty,
      errorMessage: isCityEmpty ? AppStrings.cityRequired : '',
    );

    final isPinCodeEmpty = selectedPincode == null;
    setNomineePinCodeError(
      hasError: isPinCodeEmpty,
      errorMessage: isPinCodeEmpty ? AppStrings.pinCodeRequired : '',
    );

    final isDocumentTypeEmpty = selectedNomineeDocumentType == null;

    setNomineeDocumentTypeError(
      hasError: isDocumentTypeEmpty,
      errorMessage: isDocumentTypeEmpty ? AppStrings.documentTypeRequired : '',
    );

    final documentNumber = firstNomineeDocumentNumberController.text.trim();

    if (documentNumber.isEmpty) {
      setNomineeDocumentNumberError(
        hasError: true,
        errorMessage: AppStrings.documentNumberRequired,
      );
    } else {
      setNomineeDocumentNumberError(hasError: false, errorMessage: '');
    }

    final documentImage = firstNomineeDocumentUploadController.text.trim();

    setNomineeDocumentImageError(
      hasError: documentImage.isEmpty,
      errorMessage: documentImage.isEmpty
          ? AppStrings.documentImageRequired
          : '',
    );

    final mobile = firstNomineeMobileNumberController.text.trim();
    final isMobileInvalid =
        mobile.isEmpty || !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile);

    setNomineeMobileError(
      hasError: isMobileInvalid,
      errorMessage: mobile.isEmpty
          ? AppStrings.enterValidMobile
          : AppStrings.enterValidMobile,
    );

    final email = firstNomineeEmailController.text.trim();
    final isEmailInvalid =
        email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    setNomineeEmailError(
      hasError: isEmailInvalid,
      errorMessage: email.isEmpty
          ? AppStrings.enterEmail
          : AppStrings.enterValidEmail,
    );
  }

  //validateNomineeDetails
  bool validateNomineeDetails({bool showErrors = true}) {
    // Validate and populate nominee field errors
    validateNomineeDetailsErrors();
    if (showErrors) {
      showNomineeValidationError = true;
    }

    bool isValid = true;
    final nomineeName = firstNomineeNameController.text.trim();
    if (nomineeName.length < 2) {
      isValid = false;
    }

    final pan = firstNomineePANNumberController.text.trim();
    if (pan.isNotEmpty) {
      if (!AppConstants.individualPANRegex.hasMatch(pan)) {
        isValid = false;
      }
    }

    final nomineeDob = firstNomineeDobController.text.trim();
    if (nomineeDob.isEmpty || nomineeDobHasError) {
      isValid = false;
    }

    if (selectedNomineeRelationship == null ||
        selectedNomineeRelationship!.trim().isEmpty) {
      isValid = false;
    }

    final address1 = firstNomineeAddress1Controller.text.trim();
    if (address1.length < 2) {
      isValid = false;
    }

    final address2 = firstNomineeAddress2Controller.text.trim();
    if (address2.length < 2) {
      isValid = false;
    }

    final address3 = firstNomineeAddress3Controller.text.trim();
    if (address3.isNotEmpty && address3.length < 2) {
      isValid = false;
    }

    if (selectedCountryItem == null) {
      isValid = false;
    }

    if (selectedStateItem == null) {
      isValid = false;
    }

    if (selectedCityItem == null) {
      isValid = false;
    }

    if (selectedPinCodeItem == null ||
        selectedPinCodeItem!.name == null ||
        selectedPinCodeItem!.name!.trim().isEmpty) {
      isValid = false;
    }

    final mobile = firstNomineeMobileNumberController.text.trim();
    if (mobile.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      isValid = false;
    }

    final email = firstNomineeEmailController.text.trim();
    if (email.isEmpty || !RegExp(AppConstants.emailRegex).hasMatch(email)) {
      isValid = false;
    }

    if (selectedNomineeDocumentType == null) {
      isValid = false;
    }

    if (!validateNomineeDocumentNumber()) {
      isValid = false;
    }

    if (firstNomineeDocumentUploadController.text.trim().isEmpty) {
      isValid = false;
    }

    if (isNomineeMinor) {
      final isGuardianValid = validateGuardianDetails(showErrors: showErrors);
      if (!isGuardianValid) {
        isValid = false;
      }
    }

    // if (addNomineeNotifier.value != isValid) {
    //   addNomineeNotifier.value = isValid;
    // }

    if (showErrors) {
      notifyListeners();
    }

    return isValid;
  }

  //updateAddNomineeButtonState
  void updateAddNomineeButtonState() {
    final isNomineeValid = validateNomineeDetails(showErrors: false);
    if (addNomineeNotifier.value != isNomineeValid) {
      addNomineeNotifier.value = isNomineeValid;
    }
  }

  //onNomineeDocumentSelected
  Future<void> onNomineeDocumentSelected() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.single;
    final fileName = file.name.trim();
    final extension = fileName.split('.').last.toLowerCase();
    const allowedExtensions = {'jpg', 'jpeg', 'png'};

    if (!allowedExtensions.contains(extension)) {
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: AppStrings.onlyImageFileAllowed,
        messageType: AppStrings.responseTypeError,
      );
      firstNomineeDocumentUploadController.clear();
      notifyListeners();
      return;
    }

    nomineeDocumentImage = File(file.path!);
    firstNomineeDocumentUploadController.text = fileName;
    updateAddNomineeButtonState();
    notifyListeners();
  }

  // Add or Update Nominee
  Future<bool> addNomineeBtnTap() async {
    if (!validateNomineeDetails(showErrors: true)) {
      LogHelper.errorLog('Nominee validation failed');
      return false;
    }
    AppHelperWidgets.showLoader();

    try {
      final existingNominees =
          globalStateProvider.get<List<dynamic>>('nominees') ?? [];
      final List<Map<String, dynamic>> nominees = existingNominees
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final Map<String, dynamic> nomineeData = {
        'name': firstNomineeNameController.text.trim(),
        'pan': firstNomineePANNumberController.text.trim(),
        'dob': firstNomineeDobController.text.trim(),
        'relation': selectedNomineeRelationship,
        'address1': firstNomineeAddress1Controller.text.trim(),
        'address2': firstNomineeAddress2Controller.text.trim(),
        'address3': firstNomineeAddress3Controller.text.trim(),
        'country': selectedCountryItem?.id,
        'state': selectedStateItem?.id,
        'city': selectedCityItem?.id,
        'pincode': selectedPinCodeItem?.id,
        'mobile': firstNomineeMobileNumberController.text.trim(),
        'email': firstNomineeEmailController.text.trim(),
        'documentType': selectedNomineeDocumentType?.id?.toString(),
        'documentNumber': firstNomineeDocumentNumberController.text.trim(),
        'ageChecked': isNomineeMinor,
        'minorFlag': isNomineeMinor,
      };

      String? resizedResponse;

      try {
        nomineeDocumentImage;
        if (nomineeDocumentImage == null) {
          LogHelper.errorLog('Nominee document image is missing');
          return false;
        }

        LogHelper.infoLog('NOMINEE DOC IMAGE::: $nomineeDocumentImage');

        resizedResponse = await resizeImageAPI(
          imageFile: nomineeDocumentImage,
          maxFileSize: nomineeImageMaxSize,
        );

        if (resizedResponse == null || resizedResponse.trim().isEmpty) {
          return false;
        }
      } catch (error, stackTrace) {
        LogHelper.errorLog('Nominee ImageResize failed: $error');
        LogHelper.errorLog(stackTrace.toString());
        return false;
      }

      String? resizedGuardianImage;

      try {
        final guardianDocumentImage = guardianDocumentFile;
        if (guardianDocumentImage != null) {
          LogHelper.infoLog('Calling Guardian ImageResize API');
          resizedGuardianImage = await resizeImageAPI(
            imageFile: guardianDocumentImage,
            maxFileSize: guardianImageMaxSize,
          );

          LogHelper.infoLog(
            'Guardian ImageResize Response: '
            '$resizedGuardianImage',
          );

          if (resizedGuardianImage == null ||
              resizedGuardianImage.trim().isEmpty) {
            LogHelper.errorLog('Guardian ImageResize API failed');
            return false;
          }
        }
      } catch (error, stackTrace) {
        LogHelper.errorLog('Guardian ImageResize failed: $error');
        LogHelper.errorLog(stackTrace.toString());
        return false;
      }

      final guardianName = guardianNameController.text.trim();
      final guardianDob = guardianDobController.text.trim();
      final guardianRelation = selectedGuardianRelationship;

      LogHelper.infoLog('GUARDIAN DOC NAME ::: $selectedFileNameGU');

      if (guardianName.isNotEmpty ||
          guardianDob.isNotEmpty ||
          (guardianRelation?.isNotEmpty ?? false)) {
        nomineeData['guardian'] = {
          'name': guardianName,
          'dob': guardianDob,
          'relation': guardianRelation,
          'address1': guardianAddress1Controller.text.trim(),
          'address2': guardianAddress2Controller.text.trim(),
          'address3': guardianAddress3Controller.text.trim(),
          'country': selectedGuardianCountryItem?.id,
          'state': selectedGuardianStateItem?.id,
          'city': selectedGuardianCityItem?.id,
          'pincode': selectedGuardianPinCodeItem?.id,
          'documentType': selectedGuardianDocumentType,
          'documentNumber': guardianDocumentNumberController.text.trim(),
          'documentGuardian': {
            'documentImage': resizedGuardianImage,
            'type': selectedGuardianDocumentMimeType ?? '',
            'documentFileName': selectedFileNameGU,
          },

          'mobile': guardianMobileNumberController.text.trim(),
          'email': guardianEmailController.text.trim(),
          'documentFileName': selectedFileNameGU,
        };
      }

      nomineeData['documentNominee'] = {
        'type': selectedNomineeDocumentMimeType ?? '',
        'documentImage': resizedResponse,
        'documentFileName': selectedFileName,
      };

      // nomineeData['documentFileName'] = selectedFileName;
      if (editIndex != null &&
          editIndex! >= 0 &&
          editIndex! < nominees.length) {
        nominees[editIndex!] = nomineeData;
        LogHelper.infoLog('Nominee updated at index: $editIndex');
      } else {
        LogHelper.infoLog('ADDING LIST ::$nomineeData ');
        nominees.add(nomineeData);
        LogHelper.infoLog('New nominee added');
      }

      final updatedNominees = calculateEqualShares(nominees);
      globalStateProvider.setState({
        'nominees': updatedNominees,
        'tcAccepted': false,
      });

      // resetNomineefDetails();
      // resetGuardianDetails();
      editIndex = null;
      notifyListeners();
      AppNavigator.push(AppRoutes.nomineeDetailScreen);
      return true;
    } catch (error, stackTrace) {
      LogHelper.errorLog('Add Nominee failed: $error');
      LogHelper.errorLog(stackTrace.toString());
      return false;
    } finally {
      AppHelperWidgets.hideLoader();
    }
  }

  // Validate Guardian Document Number
  bool validateGuardianDocumentNumber() {
    final value = guardianDocumentNumberController.text.trim();
    if (selectedGuardianDocumentType == null) {
      setGuardianDocumentNumberError(
        hasError: true,
        errorMessage: AppStrings.documentTypeRequired,
      );
      return false;
    }

    if (value.isEmpty) {
      setGuardianDocumentNumberError(
        hasError: true,
        errorMessage: AppStrings.enterDocumentNumber,
      );
      return false;
    }

    final documentType = int.tryParse(
      selectedGuardianDocumentType!.id.toString(),
    );

    // Aadhaar
    if (documentType == 1) {
      if (!RegExp(r'^\d{4}$').hasMatch(value)) {
        setGuardianDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.last4DigitAadhar,
        );
        return false;
      }
    }
    // Passport
    else if (documentType == 4) {
      if (value.length > 25) {
        setGuardianDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.passPortNumberCannot,
        );
        return false;
      }
    } else if (documentType == 5) {
      if (value.length > 25) {
        setGuardianDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.drivingLicenceNumberCannot,
        );
        return false;
      }
    }
    // PAN
    else if (documentType == 0) {
      if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
        setGuardianDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.enterValidPANNumber,
        );
        return false;
      }

      if (value.length > 10) {
        setGuardianDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.panNumberCannotExceed,
        );
        return false;
      }
    }
    // Default document type
    else {
      if (value.length > 25) {
        setGuardianDocumentNumberError(
          hasError: true,
          errorMessage: AppStrings.docNumberCannotExceed,
        );
        return false;
      }
    }

    setGuardianDocumentNumberError(hasError: false, errorMessage: '');
    return true;
  }

  // Apply Guardian Document Type Rules
  void applyGuardianDocumentTypeRules(dynamic docType) {
    final int documentType = int.tryParse(docType?.toString() ?? '') ?? -1;

    switch (documentType) {
      case 1:
        guardianProofPlaceholder = AppStrings.last4DigitAadhar;
        guardianProofMaxSize = 4;
        break;

      case 4:
        guardianProofPlaceholder = AppStrings.passportNumber;
        guardianProofMaxSize = 25;
        break;

      case 5:
        guardianProofPlaceholder = AppStrings.drivingLicenceNumber;
        guardianProofMaxSize = 25;
        break;

      case 0:
        guardianProofPlaceholder = AppStrings.panNumber;
        guardianProofMaxSize = 10;
        break;

      default:
        guardianProofPlaceholder = AppStrings.documentProofNo;
        guardianProofMaxSize = 25;
        break;
    }

    validateGuardianDocumentNumber();
    notifyListeners();
  }

  //initializeTCDetails
  void initializeTCDetails() {
    tcAccepted = globalStateProvider.get<bool>('tcAccepted') ?? false;
    isEntryRejected = globalStateProvider.get<bool>('isEntryRejected') ?? false;
    notifyListeners();
  }

  // To get a NomineesList
  List<dynamic> get nomineesList {
    return globalStateProvider.get<List<dynamic>>('nominees') ?? [];
  }

  //updateNomineeDetailNotifier
  void updateNomineeDetailNotifier() {
    nomineeDetailNotifier.value =
        nomineesList.isNotEmpty || isAddNomineeChecked;
  }

  // onAddNomineeChecked
  void onAddNomineeChecked() {
    isAddNomineeChecked = !isAddNomineeChecked;
    updateNomineeDetailNotifier();
    notifyListeners();
  }

  // Get Nominee Relationship Name
  String getRelationName(String id) {
    final staticData =
        globalStateProvider.get<Map<String, dynamic>>('staticData') ?? {};

    final nomineeRelationShips = staticData['nomineeRelationShips'];

    if (nomineeRelationShips is! List) {
      return id;
    }

    for (final relation in nomineeRelationShips) {
      if (relation is FluffyRecordset) {
        if (relation.id?.toString() == id.toString()) {
          return relation.name?.toString() ?? id;
        }
      } else if (relation is Map) {
        if (relation['id']?.toString() == id.toString()) {
          return relation['name']?.toString() ?? id;
        }
      }
    }

    return id;
  }

  //calculateEqualShares
  List<Map<String, dynamic>> calculateEqualShares(
    List<Map<String, dynamic>> nominees,
  ) {
    if (nominees.isEmpty) {
      return nominees;
    }

    final rawShare = 100 / nominees.length;
    double total = 0;
    for (int index = 0; index < nominees.length; index++) {
      double shareValue;
      if (index < nominees.length - 1) {
        shareValue = double.parse((rawShare).toStringAsFixed(2));
        total += shareValue;
      } else {
        shareValue = double.parse((100 - total).toStringAsFixed(2));
      }

      nominees[index]['share'] = shareValue.toStringAsFixed(2);
    }
    return nominees;
  }

  // Determine if Next button should be disabled
  bool get isNextDisabled {
    final nominees = globalStateProvider.get<List<dynamic>>('nominees') ?? [];
    final tcAccepted = globalStateProvider.get<bool>('tcAccepted') ?? false;
    return nominees.isEmpty && !tcAccepted;
  }

  //redistributeShares
  void redistributeShares(List<Map<String, dynamic>> nominees) {
    if (nominees.isEmpty) {
      return;
    }
    final rawShare = 100 / nominees.length;
    double total = 0;
    for (int i = 0; i < nominees.length; i++) {
      double shareValue;
      if (i < nominees.length - 1) {
        shareValue = (rawShare * 100).round() / 100;
        total += shareValue;
      } else {
        shareValue = ((100 - total) * 100).round() / 100;
      }
      nominees[i]['share'] = shareValue.toStringAsFixed(2);
    }
  }

  //To EditNominee

  void editNominee(int index) {
    final nominees = globalStateProvider.get<List<dynamic>>('nominees') ?? [];
    if (index < 0 || index >= nominees.length) {
      LogHelper.errorLog('Invalid nominee index: $index');
      return;
    }

    final nominee = Map<String, dynamic>.from(nominees[index] as Map);

    // LogHelper.infoLog('EDIT NOMINEE INDEX ::: $index');
    // LogHelper.infoLog('EDIT NOMINEE DATA ::: $nominee');

    globalStateProvider.setState({
      'editingNominee': nominee,
      'editingNomineeIndex': index,
    });

    // Navigate to Add/Edit Nominee screen
    AppNavigator.push(AppRoutes.addNomineeDetailScreen);
  }

  //Remove Nominee
  Future<bool> removeNominee(int index) async {
    final existingNominees =
        globalStateProvider.get<List<dynamic>>('nominees') ?? [];
    final nominees = existingNominees
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    if (index < 0 || index >= nominees.length) {
      LogHelper.errorLog('Invalid nominee index: $index');
      return false;
    }

    try {
      final updatedNominees = nominees
          .asMap()
          .entries
          .where((entry) => entry.key != index)
          .map((entry) => entry.value)
          .toList();

      if (updatedNominees.isNotEmpty) {
        redistributeShares(updatedNominees);
      }

      globalStateProvider.setState({
        'nominees': updatedNominees,
        'tcAccepted': false,
      });

      tcAccepted = false;
      updateNomineeDetailNotifier();
      notifyListeners();
      return true;
    } catch (error, stackTrace) {
      LogHelper.errorLog('Remove Nominee failed: $error');
      LogHelper.errorLog(stackTrace.toString());
      return false;
    }
  }

  //Insert Nominee Data
  Future<void> insertNomineeData() async {
    if (isEntryRejected) {
      globalStateProvider.setState({'isReturnFromNominee': true});
      LogHelper.infoLog('PUSH TO REJECTION DETAILS');
      // AppNavigator.push(AppRoutes.rejectionDetails);
      return;
    }

    final nomineesList =
        globalStateProvider.get<List<dynamic>>('nominees') ?? [];
    final panDetails = globalStateProvider.get<Map<String, dynamic>>(
      'panDetails',
    );
    final String panNumber = panDetails!['panNumber']
        .toString()
        .trim()
        .toUpperCase();

    final newFormNumber = globalStateProvider.get<int>('formNumber');

    // LogHelper.infoLog('NOMINEE LIST::: $nomineesList');

    try {
      AppHelperWidgets.showLoader();
      final Map<String, dynamic> nominee1 = nomineesList.isNotEmpty
          ? mapNomineeToSql(
              'ocrNom',
              Map<String, dynamic>.from(nomineesList[0] as Map),
            )
          : {};

      final Map<String, dynamic> nominee2 = nomineesList.length > 1
          ? mapNomineeToSql(
              'ocrSecNom',
              Map<String, dynamic>.from(nomineesList[1] as Map),
            )
          : {};

      final Map<String, dynamic> nominee3 = nomineesList.length > 2
          ? mapNomineeToSql(
              'ocrThiNom',
              Map<String, dynamic>.from(nomineesList[2] as Map),
            )
          : {};

      // Build final SQL payload
      final Map<String, dynamic> payload = {
        ...nominee1,
        ...nominee2,
        ...nominee3,

        'ocrNomEqualDistributionFlag': nomineesList.isNotEmpty ? 1 : null,
        'ocrNomOptOutFlag': nomineesList.isEmpty ? 1 : 0,
        'ocrStageFlag': AppStrings.nomineeStag,
        'ocrPanNo': panNumber,
        'ocrFormNo': newFormNumber.toString(),
      };

      LogHelper.infoLog('INSERT NOMINEE PAYLOAD ::: $payload');
      final response = await authRepository.insertDataRepo(
        requestData: payload,
      );
      if (response?.data == null) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.error,
          message: AppStrings.somethingWentWrong,
          messageType: AppStrings.responseTypeError,
        );
        return;
      }

      final responseData = response!.data as Map<String, dynamic>;
      final success = responseData['success'] == true;
      final output = responseData['data']?['output'];
      final returnValue =
          int.tryParse(output?['return_Value']?.toString() ?? '') ?? -1;

      final returnMessage =
          output?['return_Message']?.toString() ??
          AppStrings.somethingWentWrong;

      if (success && returnValue == 0) {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.success,
          message: returnMessage,
          messageType: AppStrings.responseTypeSuccess,
        );
        // LogHelper.infoLog('NOMINEE ADD SUCCESS:: NOW REDIRECTED ');
        AppNavigator.push(AppRoutes.disAccountInfoPreviewScreen);
      } else {
        AppHelperWidgets.showSnackBar(
          title: AppStrings.warning,
          message: returnMessage,
          messageType: AppStrings.responseTypeWarning,
        );
      }
    } catch (error, stackTrace) {
      LogHelper.errorLog('insertIntoDB1 error ---> $error');
      LogHelper.errorLog(stackTrace.toString());
      AppHelperWidgets.showSnackBar(
        title: AppStrings.error,
        message: error.toString(),
        messageType: AppStrings.responseTypeError,
      );
    } finally {
      AppHelperWidgets.hideLoader();
    }
  }

  //mapNomineeToSql

  Map<String, dynamic> mapNomineeToSql(
    String prefix,
    Map<String, dynamic>? nominee,
  ) {
    if (nominee == null) {
      final emptyData = {'${prefix}Flag': 0, '${prefix}Percentage': null};

      LogHelper.infoLog('MAP NOMINEE TO SQL [$prefix] ::: $emptyData');

      return emptyData;
    }

    final guardian = nominee['guardian'];
    final dob = nominee['dob']?.toString();

    final bool isMinor = dob != null && dob.isNotEmpty
        ? AppHelperWidgets.isUserMinor(dob)
        : false;

    final ageChecked = nominee['ageChecked'];

    final int minorFlag;

    if (ageChecked == true || ageChecked == null) {
      minorFlag = isMinor ? 1 : 0;
    } else {
      minorFlag = int.tryParse(nominee['minorFlag']?.toString() ?? '') ?? 0;
    }

    final Map<String, dynamic> mappedNominee = {
      // Flags
      '${prefix}Flag': 1,
      '${prefix}MinorFlag': minorFlag,
      '${prefix}Percentage': nominee['share'],

      // Nominee core fields
      '${prefix}Name': nominee['name'],
      '${prefix}Pan': nominee['panNumber'],
      '${prefix}DateOfBirth': AppHelperWidgets.formatToYYYYMMDD(
        nominee['dob']?.toString(),
      ),
      '${prefix}Relation': nominee['relation'],

      // Contact
      '${prefix}Phone': nominee['phone'] ?? null,
      '${prefix}Mobile': nominee['mobile'],
      '${prefix}Email': nominee['email'],

      // Address
      '${prefix}Address1': nominee['address1'],
      '${prefix}Address2': nominee['address2'],
      '${prefix}Address3': nominee['address3'],
      '${prefix}Address4': null,
      '${prefix}Country': nominee['country'],
      '${prefix}State': nominee['state'],
      '${prefix}City': nominee['city'],
      '${prefix}PinCode': nominee['pincode'],

      // Nominee Proof
      '${prefix}Proof': nominee['documentType'],
      '${prefix}ProofNo': nominee['documentNumber'],
      '${prefix}ProofImageType': nominee['documentNominee']?['type'] ?? null,
      '${prefix}ProofImage':
          nominee['documentNominee']?['documentImage'] ?? null,

      // Guardian
      '${prefix}GuaName': guardian?['name'] ?? null,
      '${prefix}GuaDateOfBirth': AppHelperWidgets.formatToYYYYMMDD(
        guardian?['dob']?.toString(),
      ),
      '${prefix}WithGuaRelation': guardian?['relation'] ?? null,
      '${prefix}GuaAddress1': guardian?['address1'] ?? null,
      '${prefix}GuaAddress2': guardian?['address2'] ?? null,
      '${prefix}GuaAddress3': guardian?['address3'] ?? null,
      '${prefix}GuaAddress4': null,
      '${prefix}GuaCountry': guardian?['country'] ?? null,
      '${prefix}GuaState': guardian?['state'] ?? null,
      '${prefix}GuaCity': guardian?['city'] ?? null,
      '${prefix}GuaPinCode': guardian?['pincode'] ?? null,
      '${prefix}GuaPhone': guardian?['phone'] ?? null,
      '${prefix}GuaMobile': guardian?['mobile'] ?? null,
      '${prefix}GuaEmail': guardian?['email'] ?? null,

      // Guardian Proof
      '${prefix}GuaProof': guardian?['documentType'] ?? null,
      '${prefix}GuaProofNo': guardian?['documentNumber'] ?? null,
      '${prefix}GuaProofImageType':
          guardian?['documentGuardian']?['type'] ?? null,
      '${prefix}GuaProofImage':
          guardian?['documentGuardian']?['documentImage'] ?? null,
    };

    LogHelper.infoLog('========== MAP NOMINEE TO SQL [$prefix] ==========');
    LogHelper.infoLog('NOMINEE INPUT [$prefix] ::: $nominee');
    LogHelper.infoLog('GUARDIAN INPUT [$prefix] ::: $guardian');
    LogHelper.infoLog('MINOR FLAG [$prefix] ::: $minorFlag');
    LogHelper.infoLog('FINAL SQL DATA [$prefix] ::: $mappedNominee');
    LogHelper.infoLog('==================================================');
    LogHelper.infoLog('========== NOMINEE SQL [$prefix] ==========');
    LogHelper.infoLog('Name       ::: ${mappedNominee['${prefix}Name']}');
    LogHelper.infoLog('PAN        ::: ${mappedNominee['${prefix}Pan']}');
    LogHelper.infoLog('DOB  ::: ${mappedNominee['${prefix}DateOfBirth']}');

    LogHelper.infoLog('Relation   ::: ${mappedNominee['${prefix}Relation']}');
    LogHelper.infoLog('MinorFlag  ::: ${mappedNominee['${prefix}MinorFlag']}');
    LogHelper.infoLog('Percentage ::: ${mappedNominee['${prefix}Percentage']}');
    LogHelper.infoLog('Country    ::: ${mappedNominee['${prefix}Country']}');
    LogHelper.infoLog('State      ::: ${mappedNominee['${prefix}State']}');
    LogHelper.infoLog('City       ::: ${mappedNominee['${prefix}City']}');
    LogHelper.infoLog('PinCode    ::: ${mappedNominee['${prefix}PinCode']}');
    LogHelper.infoLog('Proof      ::: ${mappedNominee['${prefix}Proof']}');
    LogHelper.infoLog('ProofNo    ::: ${mappedNominee['${prefix}ProofNo']}');

    // Guardian
    LogHelper.infoLog(
      'Guardian Name     ::: ${mappedNominee['${prefix}GuaName']}',
    );
    LogHelper.infoLog(
      'Guardian DOB      ::: ${mappedNominee['${prefix}GuaDateOfBirth']}',
    );
    LogHelper.infoLog(
      'Guardian Relation ::: ${mappedNominee['${prefix}WithGuaRelation']}',
    );
    LogHelper.infoLog(
      'Guardian Country  ::: ${mappedNominee['${prefix}GuaCountry']}',
    );
    LogHelper.infoLog(
      'Guardian State    ::: ${mappedNominee['${prefix}GuaState']}',
    );
    LogHelper.infoLog(
      'Guardian City     ::: ${mappedNominee['${prefix}GuaCity']}',
    );

    LogHelper.infoLog(
      'Guardian PinCode  ::: ${mappedNominee['${prefix}GuaPinCode']}',
    );
    LogHelper.infoLog(
      'Guardian Proof    ::: ${mappedNominee['${prefix}GuaProof']}',
    );
    LogHelper.infoLog(
      'Guardian ProofNo  ::: ${mappedNominee['${prefix}GuaProofNo']}',
    );

    LogHelper.infoLog('===========================================');
    return mappedNominee;
  }

  bool get isAddNomineeDisabled {
    final registration = globalStateProvider.get<Map<String, dynamic>>(
      'RegistrationDetail',
    );
    final accountType =
        int.tryParse(registration?['accountType']?.toString() ?? '') ?? 0;
    final loginType =
        int.tryParse(registration?['loginType']?.toString() ?? '') ?? 0;
    final subCat =
        int.tryParse(registration?['accountSubCategory']?.toString() ?? '') ??
        0;

    final isMinor = accountType == 2 || (loginType == 2 && subCat == 5);
    return isMinor || nomineesList.length >= 3;
  }

  //setPageTitle
  void setPageTitle() {
    final nominees = globalStateProvider.get<List<dynamic>>('nominees') ?? [];
    final int? editIndex = globalStateProvider.get<int>('editingNomineeIndex');
    LogHelper.infoLog('editingNomineeIndex: $editIndex');
    const ordinalWords = ['First', 'Second', 'Third'];

    if (editIndex != null) {
      if (editIndex < 0 || editIndex >= 3) {
        LogHelper.errorLog('Invalid nominee index: $editIndex');
        return;
      }

      final label = ordinalWords[editIndex];
      pageTitle = 'Edit $label Nominee';
      notifyListeners();
      return;
    }

    // ADD MODE
    if (nominees.length >= 3) {
      LogHelper.errorLog('Maximum of 3 nominees allowed');
      return;
    }

    final label = ordinalWords[nominees.length];
    pageTitle = 'Add $label Nominee';
    notifyListeners();
  }

  //validateNomineePanMatch
  bool validateNomineePanMatch() {
    final panNumber = firstNomineePANNumberController.text.trim().toUpperCase();
    final docNumber = firstNomineeDocumentNumberController.text
        .trim()
        .toUpperCase();

    final documentTypeId = selectedNomineeDocumentType?.id?.toString();

    if (nomineeDocumentNumberHasError &&
        nomineeDocumentNumberError == AppStrings.panMismatch) {
      setNomineeDocumentNumberError(hasError: false, errorMessage: '');
    }

    if (documentTypeId != '0') {
      return true;
    }

    if (panNumber.isEmpty || docNumber.isEmpty) {
      return true;
    }

    if (!AppConstants.individualPANRegex.hasMatch(panNumber)) {
      return true;
    }

    if (!validateNomineeDocumentNumber()) {
      return true;
    }

    if (panNumber != docNumber) {
      setNomineeDocumentNumberError(
        hasError: true,
        errorMessage: AppStrings.panMismatch,
      );

      return false;
    }

    return true;
  }

  Future<void> restoreAddedNomineeDetails() async {
    try {
      final stateNominees =
          globalStateProvider.get<List<dynamic>>('nominees') ?? [];
      final editingNominee = globalStateProvider.get<Map<String, dynamic>>(
        'editingNominee',
      );
      final editingNomineeIndex = globalStateProvider.get<int>(
        'editingNomineeIndex',
      );

      nomineeRelationShipList = nomineeRelationShipList
          .where((item) => item.id?.toString() != '99')
          .toList();

      if (editingNominee != null && editingNomineeIndex != null) {
        editIndex = editingNomineeIndex;
        final nominee = normalizeNomineeForForm(editingNominee);

        firstNomineeNameController.text = nominee['name']?.toString() ?? '';
        // firstNomineePANNumberController.text =
        //     nominee['panNumber']?.toString() ?? '';
        firstNomineePANNumberController.text = nominee['pan']?.toString() ?? '';
        firstNomineeDobController.text = AppHelperWidgets.formatToDDMMYYYY(
          nominee['dob']?.toString(),
        );
        firstNomineeAddress1Controller.text =
            nominee['address1']?.toString() ?? '';
        firstNomineeAddress2Controller.text =
            nominee['address2']?.toString() ?? '';
        firstNomineeAddress3Controller.text =
            nominee['address3']?.toString() ?? '';
        firstNomineeDocumentNumberController.text =
            nominee['documentNumber']?.toString() ?? '';
        firstNomineeMobileNumberController.text =
            nominee['mobile']?.toString() ?? '';

        firstNomineeEmailController.text = nominee['email']?.toString() ?? '';

        final nomineeRelationValue =
            nominee['relation']?.toString().trim() ?? '';

        if (nomineeRelationValue.isNotEmpty) {
          PurpleRecordset? nomineeRelation;

          nomineeRelation = nomineeRelationShipList
              .where((item) => item.id?.toString() == nomineeRelationValue)
              .firstOrNull;

          nomineeRelation ??= nomineeRelationShipList
              .where(
                (item) =>
                    item.name?.toString().trim().toLowerCase() ==
                    nomineeRelationValue.toLowerCase(),
              )
              .firstOrNull;

          if (nomineeRelation != null) {
            selectedNomineeRelationship = nomineeRelation.name?.trim() ?? '';
            updateGuardianRelationOptions(nomineeRelation.id?.toString() ?? '');
          } else {
            selectedNomineeRelationship = null;
          }
        } else {
          selectedNomineeRelationship = null;
        }

        final documentTypeId = nominee['documentType']?.toString();
        if (documentTypeId != null && documentTypeId.isNotEmpty) {
          final matchingDocumentType = nomineeDocumentTypeList
              .where((item) => item.id?.toString() == documentTypeId)
              .firstOrNull;

          selectedNomineeDocumentType = matchingDocumentType;
        } else {
          selectedNomineeDocumentType = null;
        }
        final countryId = nominee['country'];
        final stateId = nominee['state'];
        final cityId = nominee['city'];
        final pincodeId = nominee['pincode']?.toString();

        selectedCountryItem = findRecordById(countryList, countryId);
        selectedStateItem = findRecordById(stateList, stateId);
        selectedCityItem = findRecordById(cityList, cityId);
        selectedPinCodeItem = findRecordById(pinCodeList, nominee['pincode']);

        if (countryId != null && countryId.isNotEmpty) {
          stateList = allStateListForFiltering.where((state) {
            return state.countryId?.toString() == countryId;
          }).toList();

          final matchingState = stateList.where((state) {
            return state.id?.toString() == stateId;
          }).toList();

          if (matchingState.isNotEmpty) {
            selectedStateItem = matchingState.first;
          }
        }

        if (stateId != null && stateId.isNotEmpty) {
          cityList = allCityListForFiltering.where((city) {
            return city.countryId?.toString() == countryId &&
                city.stateId?.toString() == stateId;
          }).toList();

          final matchingCity = cityList.where((city) {
            return city.id?.toString() == cityId;
          }).toList();

          if (matchingCity.isNotEmpty) {
            selectedCityItem = matchingCity.first;
          }
        }

        if (cityId != null && cityId.isNotEmpty) {
          pinCodeList = allPinCodeListForFiltering.where((pincode) {
            return pincode.cityId?.toString() == cityId;
          }).toList();

          final matchingPincode = pinCodeList.where((pincode) {
            return pincode.id?.toString() == pincodeId;
          }).toList();

          if (matchingPincode.isNotEmpty) {
            selectedPinCodeItem = matchingPincode.first;
          }
        }

        final rawNomineeDocument = editingNominee['documentNominee'];
        final normalizedNomineeDocument = nominee['documentNominee'];

        final nomineeDocument = rawNomineeDocument is Map
            ? rawNomineeDocument
            : normalizedNomineeDocument is Map
            ? normalizedNomineeDocument
            : null;

        if (nomineeDocument != null) {
          nomineeDocumentImageBase64 =
              nomineeDocument['documentImage']?.toString() ?? '';

          selectedNomineeDocumentMimeType = nomineeDocument['type']
              ?.toString()
              .trim();

          if (selectedNomineeDocumentMimeType == null ||
              selectedNomineeDocumentMimeType!.isEmpty) {
            selectedNomineeDocumentMimeType = 'image/jpeg';
          }

          selectedFileName =
              nomineeDocument['documentFileName']?.toString().trim() ?? '';

          if (selectedFileName.isEmpty) {
            selectedFileName = generateStoredImageName(
              selectedNomineeDocumentMimeType!,
              prefix: 'nominee',
            );
          }

          firstNomineeDocumentUploadController.text = selectedFileName;
        }

        final minorFlag = editingNominee['minorFlag'];

        if (minorFlag is bool) {
          isNomineeMinor = minorFlag;
        } else if (minorFlag is num) {
          isNomineeMinor = minorFlag == 1;
        } else {
          isNomineeMinor =
              minorFlag?.toString().toLowerCase() == 'true' ||
              minorFlag?.toString() == '1';
        }

        // LogHelper.infoLog('RESTORED isNomineeMinor ::: $isNomineeMinor');

        // LogHelper.infoLog('NOMINEE  ::: $nominee');
        // LogHelper.infoLog('NOMINEE GUARDIAN ::: ${nominee['guardian']}');

        final guardian = nominee['guardian'];
        if (guardian != null) {
          guardianNameController.text = guardian['name']?.toString() ?? '';
          guardianDobController.text = guardian['dob']?.toString() ?? '';
          guardianAddress1Controller.text =
              guardian['address1']?.toString() ?? '';
          guardianAddress2Controller.text =
              guardian['address2']?.toString() ?? '';
          guardianAddress3Controller.text =
              guardian['address3']?.toString() ?? '';
          guardianDocumentNumberController.text =
              guardian['documentNumber']?.toString() ?? '';
          guardianMobileNumberController.text =
              guardian['mobile']?.toString() ?? '';
          guardianEmailController.text = guardian['email']?.toString() ?? '';
          selectedGuardianRelationship = guardian['relation']?.toString();

          final guardianDocumentTypeId = guardian['documentType']?.toString();
          if (guardianDocumentTypeId != null &&
              guardianDocumentTypeId.isNotEmpty) {
            try {
              selectedGuardianDocumentType = nomineeDocumentTypeList.firstWhere(
                (item) => item.id?.toString() == guardianDocumentTypeId,
              );
            } catch (_) {
              selectedGuardianDocumentType = null;
            }
          }

          final guardianCountryId = guardian['country'];
          final guardianStateId = guardian['state'];
          final guardianCityId = guardian['city'];
          selectedGuardianCountryItem = findRecordById(
            countryList,
            guardianCountryId,
          );

          selectedGuardianStateItem = findRecordById(
            stateList,
            guardianStateId,
          );

          selectedGuardianCityItem = findRecordById(cityList, guardianCityId);
          selectedGuardianPinCodeItem = findRecordById(
            pinCodeList,
            guardian['pincode'],
          );

          guardianStateList = allStateListForFiltering.where((state) {
            return state.countryId?.toString() == guardianCountryId?.toString();
          }).toList();

          guardianCityList = allCityListForFiltering.where((city) {
            return city.countryId?.toString() ==
                    guardianCountryId?.toString() &&
                city.stateId?.toString() == guardianStateId?.toString();
          }).toList();

          guardianPinCodeList = allPinCodeListForFiltering.where((pinCode) {
            return pinCode.cityId?.toString() == guardianCityId?.toString();
          }).toList();

          final guardianDocument = guardian['documentGuardian'];
          if (guardianDocument != null &&
              guardianDocument['documentImage'] != null &&
              guardianDocument['documentImage'].toString().isNotEmpty) {
            guardianDocumentImageBase64 = guardianDocument['documentImage']
                .toString();

            selectedGuardianDocumentMimeType =
                guardianDocument['type']?.toString() ?? '';

            selectedFileNameGU =
                guardian['documentFileName'] ??
                generateStoredImageName(
                  selectedGuardianDocumentMimeType ?? 'image/jpeg',
                  prefix: 'guardian',
                );
          }
        }

        if (selectedNomineeDocumentType != null) {
          applyNomineeDocumentTypeRules(selectedNomineeDocumentType);
        }
        if (selectedGuardianDocumentType != null) {
          applyGuardianDocumentTypeRules(selectedGuardianDocumentType!);
        }

        if (firstNomineeDobController.text.trim().isNotEmpty &&
            guardianDobController.text.trim().isNotEmpty) {
          validateGuardianDob(
            nomineeDob: firstNomineeDobController.text.trim(),
            guardianDob: guardianDobController.text.trim(),
          );
        }

        if (firstNomineeDobController.text.trim().isNotEmpty) {
          final isMinor = AppHelperWidgets.isUserMinor(
            firstNomineeDobController.text.trim(),
          );

          // LogHelper.infoLog('RESTORE TIME :::: $isMinor');

          if (isMinor) {
            setGuardianValidators();
          } else {
            clearGuardianValidators(reset: true);
          }
        }
        updateAddNomineeButtonState();
        notifyListeners();
        globalStateProvider.setState({
          'editingNominee': null,
          'editingNomineeIndex': null,
        });

        return;
      }

      editIndex = null;
      // nomineeShareController.text = stateNominees.isEmpty ? '100.00' : '0.00';
      selectedCountryItem = null;
      selectedStateItem = null;
      selectedCityItem = null;
      selectedPinCodeItem = null;
      selectedNomineeRelationship = null;
      selectedNomineeDocumentType = null;

      nomineeDocumentImage = null;
      selectedFileName = '';
      selectedNomineeDocumentMimeType = null;

      // Clear guardian data
      selectedGuardianCountryItem = null;
      selectedGuardianStateItem = null;
      selectedGuardianCityItem = null;
      selectedGuardianPinCodeItem = null;

      selectedGuardianRelationship = null;
      selectedGuardianDocumentType = null;

      guardianDocumentImage = null;
      selectedFileNameGU = '';
      selectedGuardianDocumentMimeType = null;

      stateList = [];
      cityList = [];
      pinCodeList = [];

      guardianStateList = [];
      guardianCityList = [];
      guardianPinCodeList = [];
      filteredGuardianRelationsList = [];
      clearGuardianValidators(reset: true);
      updateAddNomineeButtonState();
      notifyListeners();
    } catch (error, stackTrace) {
      LogHelper.errorLog('restoreAddNomineeDetails Exception: $error');
      LogHelper.errorLog(stackTrace.toString());
    }
  }

  PurpleRecordset? findRecordById(List<PurpleRecordset> list, dynamic id) {
    if (id == null) {
      return null;
    }
    return list.cast<PurpleRecordset?>().firstWhere(
      (item) => item?.id?.toString() == id.toString(),
      orElse: () => null,
    );
  }

  //generateStoredImageName
  String generateStoredImageName(
    String? mimeType, {
    String prefix = 'document',
  }) {
    final ext = mimeType?.contains('png') == true ? 'png' : 'jpg';
    return '$prefix.$ext';
  }

  //normalizeNomineeForForm
  Map<String, dynamic> normalizeNomineeForForm(Map<String, dynamic> nominee) {
    return {
      ...nominee,

      'relation': nominee['relation'] != null
          ? nominee['relation'].toString()
          : '',
      'documentType': nominee['documentType'] != null
          ? nominee['documentType'].toString()
          : '',
      'country': nominee['country'] != null
          ? nominee['country'].toString()
          : '',
      'state': nominee['state'] != null ? nominee['state'].toString() : '',
      'city': nominee['city'] != null ? nominee['city'].toString() : '',
      'pincode': nominee['pincode'] != null
          ? nominee['pincode'].toString()
          : '',

      'guardian': nominee['guardian'] != null
          ? {
              ...Map<String, dynamic>.from(nominee['guardian'] as Map),
              'relation': nominee['guardian']['relation'] != null
                  ? nominee['guardian']['relation'].toString()
                  : '',
              'documentType': nominee['guardian']['documentType'] != null
                  ? nominee['guardian']['documentType'].toString()
                  : '',
              'country': nominee['guardian']['country'] != null
                  ? nominee['guardian']['country'].toString()
                  : '',

              'state': nominee['guardian']['state'] != null
                  ? nominee['guardian']['state'].toString()
                  : '',
              'city': nominee['guardian']['city'] != null
                  ? nominee['guardian']['city'].toString()
                  : '',
              'pincode': nominee['guardian']['pincode'] != null
                  ? nominee['guardian']['pincode'].toString()
                  : '',
            }
          : null,
    };
  }
}
