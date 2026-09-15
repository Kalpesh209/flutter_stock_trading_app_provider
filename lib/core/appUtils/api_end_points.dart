/*
Title: ApiEndPoints Used through App
Purpose:ApiEndPoints Used through App
Created On: 
Edited On:
Author: 
*/

class ApiEndPoints {
  // Registration Base URL
  static const String registrationBaseURL = 'registration/';
  static const String checkMobileExistURL =
      '${registrationBaseURL}checkMobileExists/';
  static const String fetchExistingClientDetailsURL =
      '${registrationBaseURL}fetchExistingClientDetails/';
  static const String referralCodeURL = '${registrationBaseURL}getReferalCode/';
  static const String getStaticDataURL = '${registrationBaseURL}getStaticData/';
  static const String sendOTPURL = '${registrationBaseURL}sendOTP';
  static const String verifyOTPURL = '${registrationBaseURL}verifyOTP';
  static const String insertDataIntoDBURL =
      '${registrationBaseURL}insertDataIntoDB';
  static const String getNSDLSubTypeURL =
      '${registrationBaseURL}getNSDLSubType/';

  // Bank
  static const String bankBaseURL = 'Bank/';
  static const String getBankDetailsURL = '${bankBaseURL}getBankDetails/';
  static const String newCashfreeBankAccountVerificationAPIURL =
      '${bankBaseURL}NewCashfreeBankAccountVerificationAPI';

  static const String saveBankAccountVerificationLogURL =
      '${bankBaseURL}saveBankAccountVerificationLog';

  // PDF Generation
  static const String generatePDFURL = 'generatePDF/';
  static const String generateCKYCDOCURL = '${generatePDFURL}generateCKYCDoc';

  //Selfie
  static const String selfieBaseURL = 'selfie/';
  static const String selfieResizeURL = '${selfieBaseURL}ImageResize';
  static const String sendSelfieRequestURL =
      '${selfieBaseURL}SendSelfieRequest';
  static const String fetchSelfieRequestURL =
      '${selfieBaseURL}fetchSelfieResponse';

  static const String checkIncomeProofIsEncryptedOrPasswordProtectedURL =
      '${selfieBaseURL}CheckIncomeProofIsEncryptedOrPasswordProtected';

  static const String pdfResizeURL = '${selfieBaseURL}pdfResize';

  // Digio Base URL
  static const String digioBaseURL = 'Digio/';
  static const String sendDigiLockerRequestURL =
      '${digioBaseURL}SendDigiLockerRequest';
  static const String fetchDigiLockerResponseURL =
      '${digioBaseURL}FetchDigiLockerResponse';

  // KRA Details Base URL
  static const String kraDetailsBaseURL = 'KRADetails/';
  static const String checkBanPanCardURL =
      '${kraDetailsBaseURL}CheckBanPanCard/';
  static const String newPanVerificationURL =
      '${kraDetailsBaseURL}NewPanVerification/';

  static const String deleteFormDetailsForMinorAndOnlyDematCasesURL =
      '${kraDetailsBaseURL}DeleteFormDetailsForMinorAndOnlyDematCases';

  static const String fetchKRAAgencyDetailsURL =
      '${kraDetailsBaseURL}FetchKRAAgencyDetails';
  static const String fetchKRADetailsURL =
      '${kraDetailsBaseURL}FetchKRADetails';

  static const String importIncomeProofURL = 'import';
  static const String getIncomeProofURL = 'fetchCAMSData/FNO';
}
