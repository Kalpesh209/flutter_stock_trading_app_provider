/*
Title: AppStrings through App
Purpose:AppStrings Used through App
Created On: 
Edited On:
Author: 
*/

class AppStrings {
  static const String sihlMoneyMaker = 'SIHL MoneyMaker';
  static const String shahInvestor = 'Shah Investor';
  static const String registration = 'Registration';
  static const String login = 'login';
  static const String individual = 'Individual';
  static const String others = 'Others';

  static const String mobile = 'Mobile';
  static const String emailID = 'Email ID';
  static const String referralCode = 'Referral Code';

  static const String enterReferral =
      'Enter referral code if opening account via partner';

  static const String iAgree = 'I agree to the';
  static const String termCondition = ' Term & Conditions';
  static const String close = 'Close';
  static const String getOTP = 'Get OTP';

  static const String chargeStructure = 'Charge Structure';
  static const String dpCharges = 'DP Charges';
  static const String brokerageCharges = 'Brokerage Charges';
  static const String taxesRegulatoryCharges = 'Taxes & Regulatory Charges';
  static const String enterValidMobile = 'Enter a valid mobile number';
  static const String enterValidEmail = 'Enter a valid Email';
  static const String confirm = 'confirm';
  static const String noReferralAdded = 'No Referral Added';
  static const String sinceNoReferral =
      'Since no referral details were provided, your account will be registered as a direct client.';
  static const String noCancel = 'No,Cancel';
  static const String okContinue = 'Ok,Continue';
  static const String okUpdate = 'Ok,Update';
  static const String isRequired = ' is required';
  static const String required = 'required';
  static const String youMustAccept =
      'You must accept Terms & Conditions to continue';
  static const String next = 'Next';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
  static const String confirmReferralDetails = 'Confirm Referral Details';
  // static const String enterCorrectMobile = 'Enter the correct mobile number';

  static const String partnerName = 'Partner Name';
  static const String branchName = 'Branch Name';
  static const String employee = 'Employee ';
  static const String selectRelationship = 'Select Relationship & Confirm OTP';
  static const String yourNextMessage = 'Your next message';
  static const String drop = 'DROP';
  static const String emailBelongsTo = 'Email Belongs To';
  static const String mobileBelongsTo = 'Mobile Belongs To';
  static const String emailOTP = 'Email OTP';
  static const String mobileOTP = 'Mobile OTP';
  static const String resendOTPIn = 'Resend OTP in ';
  static const String resend = 'Resend';
  static const String otpSentSuccess = 'OTP Sent Success';
  static const String failedToSendMobileOtp = 'Failed to send Mobile OTP';
  static const String failedToSendEmailOtp = 'Failed to send Email OTP';
  static const String mobileOTPSendingFailed = 'Mobile OTP sending failed';

  static const String otpTypeMobile = 'mobile';
  static const String otpTypeBank = 'bank';

  static const String otpTypeEmail = 'email';
  static const String otpSent = 'OTP Sent ';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String selectMobileBelongsTo = 'Select Mobile belongs to';
  static const String selectEmailBelongsTo = 'Select Email belongs to';

  static const String verifyEmailOtp = 'Verify Email OTP';
  static const String verifyMobileOtp = 'Verify Mobile OTP';

  static const String emailOtpVerifiedSuccess = 'Email OTP Verified ';
  static const String mobileOtpVerifiedSuccess = 'Mobile OTP Verified ';
  static const String otpVerificationFailed = 'Invalid OTP';
  static const String digio = 'DIGIO';
  static const String server = 'SERVER';

  static const String fetchUserData = 'Fetching user data...';
  static const String encryptingInformation = 'Encrypting information...';
  static const String transferringDataSecurely = 'Transferring securely...';
  static const String dumpingDataFromDigio = 'Dumping data from DIGIO...';
  static const String doneHeadingNextStep = 'Done, Heading to the next step';
  static const String failedToSendOTP = 'Failed to send OTP. Please try again.';
  static const String failedToFetchData =
      'Failed to fetch data. Please try again.';

  static const String panCardVerification = 'PAN Card Verificatiion';
  static const String panCardNum = 'PAN Card Number';
  static const String fNameAsPan = 'First Name as per PAN Card';
  static const String mNameAsPan = 'Middle Name as per PAN Card';
  static const String lNameAsPan = 'Last Name as per PAN Card';
  static const String dob = 'Date of Birth ';
  static const String panVerifiedSuccess = 'PAN Verified Success';
  static const String minorUserDeleted = 'Minor user delected success';

  static const String nameDoesNotMatchPan =
      " Name Doesn't match With PAN Card, Kindly update as per PAN Details";
  static const String dobDoesNotMatchPan =
      "Date of birth doesn't match with PAN Card. Kindly update as per Pan Details";
  static const String validationError = 'Validation Error!';

  // PAN Status Messages
  static const Map<String, String> panStatusMessages = {
    'F': 'Fake PAN Number. Please enter a valid PAN No.',
    'N': 'Invalid PAN Number. Please enter a valid PAN No.',
    'X': 'PAN Number marked as Deactivated. Please enter a valid PAN No.',
    'D': 'PAN Number marked as Deleted. Please enter a valid PAN No.',
    'EA': 'Valid but marked "Amalgamation" in ITD database.',
    'EC': 'Valid but marked "Acquisition" in ITD database.',
    'ED': 'Valid but marked "Death" in ITD database.',
    'EI': 'Valid but marked "Dissolution" in ITD database.',
    'EL': 'Valid but marked "Liquidated" in ITD database.',
    'EM': 'Valid but marked "Merger" in ITD database.',
    'EP': 'Valid but marked "Partition" in ITD database.',
    'ES': 'Valid but marked "Split" in ITD database.',
    'EU': 'Valid but marked "Under Liquidation" in ITD database.',
  };

  static const Map<String, String> panTypeValidationMessages = {
    '1': 'HUF (4th character should be H)',
    '2': 'Corporate (4th character should be F or C)',
    '3': 'Trust (4th character should be T)',
    '5': 'Minor (4th character should be P)',
    '6': 'NRI (4th character should be P)',
    '7': 'MultiHolder(Individual) (4th character should be P)',
    '8': 'Individual (4th character should be P)',
  };

  static const Map<String, List<String>> panTypeValidationChars = {
    '1': ['P'],
    '2': ['F', 'C'],
    '3': ['T'],
    '5': ['P'],
    '6': ['P'],
    '7': ['P'],
    '8': ['P'],
  };

  static const String verifying = 'Verifying, please wait...';
  static const String invalidPANType = 'Invalid PAN type';

  static const String minorPANEntered =
      'A Minor PAN has been entered under the Individual category. Please reprocess your request by selecting Others and proceed accordingly on the registration page.';
  static const String wrongMinorEntry = 'Wrong Minor Entry';

  static const String onlyDemat = 'Only Demat';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String yesCorrect = 'Yes,Correct';

  static const String pendingForUniqueID = 'Pending for Unique ID';
  static const String panDetailsAlreadyExists = 'PAN Details Already Exists';
  static const String aTradingAccount =
      'A trading account is already registered with this PAN. '
      'Please proceed by selecting the Others option on the '
      'registration page and choose Only Demat Account to continue.';

  static const String confirmation = 'Confirmation';
  static const String anotherMobile = 'Use another mobile and try again';
  static const String continueButton = 'Continue';
  static const String kraModification =
      'KRA Modification is Not Validated., Want to continue';

  static const String resumeApp = 'Resume Application';

  static const String weHaveNoticed =
      'We have noticed that your application is pending. Kindly resume your application to complete the process and activate your account.';

  static const String ifYouWish =
      'If you wish to open a different account in the meantime, kindly submit a fresh request using another mobile number.';

  static const String confirmMobileOTP = 'Confirm Mobile OTP';

  static const String mobileAlreadyRegistered =
      'Mobile number already registered';
  static const String verifyOTPFirst = 'Verify OTP First';

  static const String presentAddressInfo = 'Present Address Information';
  static const String addressLine1 = 'Address Line 1';
  static const String addressLine2 = 'Address Line 2';
  static const String addressLine3 = 'Address Line 3';

  static const String city = 'City';
  static const String state = 'State';
  static const String pincode = 'Pincode';
  static const String country = 'Country';
  static const String confirmCap = 'Confirm';

  static const String pleaseProvideValidReferralCode =
      'Please provide valid referral code';
  static const String pleaseTryAnotherCode = 'Please try another code';
  static const String verifyingPan = 'Verifying, please wait ...';
  static const String kraAndPassDontMatch = 'KRA Name and PAN Name dont match';
  static const String errorInKRAAgency = 'Error found in KRA Agency Response';
  static const String digilockerSentSuccess =
      'Digilocker request sent successfully';

  static const String kycCompleteSuccess = 'KYC completed successfully';
  static const String kycProcessCancelled = 'KYC Process cancelled ';

  static const String digiLockerResponseFetchSuccess =
      'DigiLocker response Fetch Success';

  static const String personalInformation = 'Personal Information';
  static const String father = 'Father';
  static const String spouse = 'Spouse';

  static const String selectYourOccupation = 'Select Your Occupation';
  static const String selectAnnualIncome = 'Select Your Annual Income';

  static const String fatherFirstName = 'Father First Name';
  static const String fatherMiddleName = 'Father Middle Name';
  static const String fatherLastName = 'Father Last Name';

  static const String motherFirstName = 'Mother First Name';
  static const String motherMiddleName = 'Mother Middle Name';
  static const String motherLastName = 'Mother Last Name';

  static const String spouseFirstName = 'Spouse First Name';
  static const String spouseMiddleName = 'Spouse Middle Name';
  static const String spouseLastName = 'Spouse Last Name';

  static const String motherDetails = 'Mother Details';

  static const String firstNameRequired = 'FirstName is required';
  static const String lastNameRequired = 'LastName is required';

  static const String back = 'Back';
  static const String minimumCharacter = 'Minimum 2 characters required';
  static const String iHaveGSTNumber = 'I have a GST number';
  static const String selectCityOfBirth = 'Select Your City of Birth';
  static const String searchCity = 'Search City';

  static const String selectMarketSegment = 'Select Market Segment';
  static const String selectGenderIdentity = 'Select Your Gender Identity';

  static const String selectMaritalStatus = 'Select Your Marital Status';
  static const String enterAtleast3Characters = 'Enter at least 3 characters';

  static const String nsdl = 'NSDL';
  static const String equity = 'Equity';
  static const String clickToViewYour = 'Click to view your ';

  static const String gstNo = 'GST No';
  static const String pleaseEnterGSTNumber = 'Please enter GST Number';
  static const String enterValidGSTNumber = ' Enter Valid GST Number';
  static const String gstNoMust = 'GST Number must be of 15 characters';

  static const String enterGSTNumber = 'Enter GST number';

  static const String clicktoView = 'Click to view your ';
  static const String brokerage = 'Brokerage';

  static const String brokerageLevied =
      'The brokerage levied on your trading account shall at all times remain '
      'within the maximum limits prescribed under the rules, regulations and '
      'bye-laws of the relevant Stock Exchange(s) and the applicable regulations '
      'and circulars issued by SEBI from time to time.';

  static const String selectedSegmentBrokerage = 'Selected Segment Brokerage';
  static const String bankAccountInfo = 'Bank Account Information';
  static const String noSegmentsSelected = 'No segments selected';
  static const String selectPEP = 'Select PEP (Politically Exposed Person)';
  static const String selectSettlementCycle = 'Select Settlement Cycle';
  static const String accountMustMin = 'Enter atleast 10 digits';
  static const String accountMustMax = 'Must not exceed 20 digits';
  static const String bankNotFound =
      'Bank not found in our system. Please enter your bank details manually.';

  static const String branchAddressLine1 = 'Branch Address Line 1';
  static const String branchAddressLine2 = 'Branch Address Line 2';
  static const String branchAddressLine3 = 'Branch Address Line 3';
  static const String branchAddressLine4 = 'Branch Address Line 4';
  static const String micrMustof9Digits = 'MICR Code must be exactly 9 digits';

  static const String monthly = 'Monthly';
  static const String quaterly = 'Quaterly';

  static const String verify = 'Verify';

  static const String panCanNotbeSame =
      'PAN cannot be same as Second or Third Holder PAN';
  static const String secondHolderPanCanNotbeSameAsOthers =
      'Second Holder PAN cannot be same as First or Third Holder PAN, To update the holder details, please refresh the page and restart the process using the same mobile number.';

  static const String thirdHolderPanCanNotbeSameAsOthers =
      'Third Holder PAN cannot be same as First or Second Holder PAN, To update the holder details, please refresh the page and restart the process using the same mobile number.';

  static const String duplicatePANdetected = 'Duplicate PAN detected';
  static const String incorrectPAN = 'Incorrect PAN';

  // DONT EVER CHANGE IT
  static const String warning = 'warning';
  static const String responseTypeSuccess = 'success';
  static const String responseTypeWarning = 'warning';
  static const String responseTypeError = 'error';
  static const String firstHolder = 'FirstHolder';
  static const String secondHolder = 'SecondHolder';
  static const String thirdHolder = 'ThirdHolder';
  static const String newTxt = 'New';
  static const String insert = 'Insert';
  static const String modifyTxt = 'Modify';
  static const String digiLocker = 'DigiLocker';
  static const String personal = 'Personal';
  static const String onlineClientRegistration = 'OnlineClientRegistration';
  static const String onlyTradingDetails = 'OnlyTradingDetails';
  static const String nriDetails = 'NRIDetails';
  static const String guardian = 'Guardian';
  static const String other = 'Other';
  static const String bank = 'Bank';
  static const String signature = 'Signature';
  static const String digioSelfieRequest = 'DigioSelfieRequest';
  static const String photo = 'Photo';
  static const String income = 'Income';
  static const String additionalDocuments = 'AdditionalDocuments';
  static const String nominee = 'Nominee';
  static const String preview = 'Preview';
  static const String plans = 'Plans';
  static const String digitalSignKYC = 'DigitalSignKYC';
  static const String ddpiRequest = 'DDPIRequest';
  static const String ddpiResponse = 'DDPIResponse';
  static const String upi = 'UPI';
  static const String pennyDrop = 'PENNYDROP';
  static const String manual = 'MANUAL';
  static const String accessToken = 'AccessToken';
  static const String cheque = 'Cheque';
  static const String update = 'Update';
  static const String selfie = 'selfie';
  static const String incomeProof1 = 'IncomeProof';
  static const String nomineeStag = 'Nominee';

  //MultiHolderInsert
  static const String multiHolderInsert = 'MultiHolderInsert';

  // Bank Info
  static const String enterAccountNumber = 'Enter account number';
  static const String enterBankName = 'Enter bank name';
  static const String enterifsc = 'Enter IFSC code';
  static const String enterMICRCode = 'Enter MICR Code';
  static const String accountType = 'Account Type';
  static const String accountNumber = 'Account Number';
  static const String ifscCode = 'IFSC Code';
  static const String bankName = 'Bank Name';
  static const String invalidIFSC = 'Invalid IFSC';

  static const String minimumOf3Char = 'Minimum of 3 characters';
  static const String maximum50Characters = 'Maximum of 50 characters';
  static const String maximum36Characters = 'Maximum of 36 characters';

  static const String micrCode = 'MICR Code';
  static const String enableAuto = 'Enable auto debit for this bank account';
  static const String accountTypeRequired = 'Account Type is required';

  static const String bankVerifiedSuccess =
      'Bank verified successfully. Moving to next step';
  static const String invalidBankDetails =
      'Invalid bank details, please check and try again';
  static const String technicalIssuesPennyDrop =
      'Technical issues with PennyDrop Gateway. Please do not initiate another transaction until further communication';

  static const String bankAccountVerificationSuccess =
      'Bank Account Verification Success';
  static const String othersUI = 'Others UI';

  static const String digioVerificationCancelled =
      'Digio verification was cancelled. Please login and try again.';

  static const String confirmNameAsPerBank = 'Confirm the Name as per Bank';

  static const String bankAccountVerifiedSuccess =
      'Bank Account Verified Successfully.';
  static const String nameAsPerBank = 'Name as per Bank : ';
  static const String doesYourNameMatch =
      'Does your name match with the bank account name?';

  static const String verifiedBankDetails = 'Verified Bank Details';
  static const String uploadOriginalChequeImage =
      'Upload Original Cheque Image';
  static const String chooseAFile = 'Choose a File or Drag & Drop it here';
  static const String browseFile = 'Browse  File';
  static String jpegPNG(dynamic size) =>
      'JPEG, PNG and JPG formats, upto $size KB';

  static String jpegPNGPDF(dynamic size) =>
      'JPEG, PNG and PDF formats, upto $size KB';

  static const String verifyBankDetails = 'Verify Bank Details';

  static const String pleaseContactAdmin = 'Please Contact Admin';
  static const String panNotSeededWithAadhar = 'Pan Not Seeded With Aadhar.';
  static const String entryDeletedSuccessfully = 'Entry Deleted successfully';
  static const String allowedFormat = 'please select only image file';
  static const String invalidFormat = 'Invalid Format';
  static const String onlyImageFile =
      'Only image files (JPG, JPEG, PNG) are allowed.';
  static const String invalidFileSize = 'Invalid File Size';
  static const String fileSizeExceeded =
      'Image size cannot be greater than 300 KB. Please resize manually.';
  static const String enterBranchName = 'Enter BranchName';
  static const String enterBranchAddress1 = 'Enter BranchAddress1';
  static const String minorBankChequePhoto = 'Minor Bank Cheque Photo';
  static const String uploadSignaturePhoto = 'Upload Signature';
  static const String uploadSignatureFile =
      'Upload your signature by selecting a saved signature file from your device';
  static const String uploadCheque = 'Please upload cheque';
  static const String validationFailed = 'Validation Failed';
  static const String uploadSignatureForThirdHolder =
      'Upload Signature for Third Holder';
  static const String uploadSignatureForSecondHolder =
      'Upload Signature for Second Holder';
  static const String uploadKartaSignaturewithHUF =
      'Upload Karta signature with HUF stamp';
  static const String pleaseUploadSignatureFile =
      'Please upload your signature file';
  static const String failedToProcessSignatureImage =
      'Failed to process signature image.';
  static const String failedToProcessImage = 'Failed to process the image.';

  static const String livePhoto = 'Live Photo';

  static const String pleaseCapture =
      'PLEASE CAPTURE A CLEAR, WELL-LIT LIVE PHOTO WITH YOUR FACE FULLY VISIBLE FOR VERIFICATION';

  static const String maximumImageSize = '(MAXIMUM IMAGE SIZE: 50 KB)';

  static const String capturePhoto = 'Capture Photo';
  static const String fetchSelfie = 'Fetch Selfie';
  static const String fetchedSelfieSuccess = 'Selfie Fetched Successfully';
  static const String yourSelfieVerificationSent =
      'Your selfie verification request has been sent.';

  static const String selfieVerificationLinkMessage =
      'Follow the link received on your registered mobile number to complete the process. '
      'Request sent around';

  // Income Proof
  static const String fetch = 'Fetch';
  static const String upload = 'Upload';
  static const String fetchSelfieBeforeSubmit =
      'Please fetch your selfie before proceeding';
  static const String incomeProof = 'Income Proof';
  static const String uploadOrFetchIncomeProof =
      'Upload or fetch your income proof ';

  //Nominee Details
  static const String nomineeDetails = 'Nominee Details';
  static const String addNominee = 'Add Nominee';
  static const String appointmentOfNominee =
      'Appointment of a nominee is required as per regulatory guidelines.';

  static const String yourSIHLNominee =
      'Your SIHL nominee will be applicable to all your ';
  static const String stocksMutualFunds = 'Stock and mutual funds';
  static const String youMayAdd =
      'You may add a maximum of three nominees to your account.';
  static const String iDontWantToAddNominee = 'I don\'t want to add a nominee';
  static const String nomineeDeclaration =
      'I / We hereby confirm that I / We do not wish to appoint any nominee(s) '
      'in my / our trading / demat account and understand the issues involved '
      'in non-appointment of nominee(s) and further are aware that in case of '
      'death of all the account holder(s), my / our legal heirs would need to '
      'submit all the requisite documents / information for claiming of assets '
      'held in my / our trading / demat account, which may also include '
      'documents issued by Court or other such competent authority, based on '
      'the value of assets held in the trading / demat account.';

  static const String unableToStartIncomeProof =
      'Unable to start Income Proof.';

  static const String invalidRedirectionURL = 'Invalid redirection URL.';
  static const String consentNotCompleted =
      'Consent not completed. Please retry.';
  static const String incomeProofError = 'Income Proof Error';
  static const String unableToFetchIncomeProof =
      'Unable to fetch Income Proof. Please try again.';

  static const String failedToFetchIncomeProof =
      'Failed to fetch Income Proof. Try again.';

  static const String retryInProgress = 'Retry in Progress';
  static const String retryingIncomeProofIn5Seconds =
      'Retrying Income Proof in 5 seconds…';

  static const String unableToSelectFile = 'Unable to select file.';
  static const String unSupportedFileFormat = 'Unsupported file format.';
  static const String incomeProofConsentFailed = 'Income Proof Consent Failed';
  static const String consentFailedOrCancelled = 'Consent failed or cancelled.';
  static const String doYouwantToRetry = 'Do you want to retry?';
  static const String uploadOnlyJPEGorPNGorPDF =
      'Please upload only JPEG, PNG, or PDF files.';

  static const String unableToReadSelectedFile =
      'Unable to read selected file.';
  static const String incomeProofPDF = 'Income Proof PDF';
  static const String pleaseUploadIncomeProofFirst =
      'Please upload your income proof first';

  static const String pdfIsTooLarge =
      'PDF is too large. Please upload a smaller file.';

  static const String fileSizeIssue = 'File Size Issue';
  static const String unableToProcessPDF = 'Unable to process Income Proof PDF';
  static const String pdfError = 'PDF Error';
  static const String resizeError = 'Resize Error';
  static const String wantToRetry = 'Want to Retry';
  static const String popUpBlocked =
      'Popup blocked. Retry income proof process?';

  // Add Nominee
  static const String relation = 'Relation';
  static const String addFirstNominee = 'Add First Nominee';
  static const String addSecondNominee = 'Add Second Nominee';
  static const String addThirdNominee = 'Add Third Nominee';

  static const String nomineeName = 'Nominee Name';
  static const String nomineePanNumber = 'PAN Number';
  static const String nomineeDob = 'Date of Birth';
  static const String nomineeRelation = 'Relation';
  static const String addressSameAsCorrespondenceAddress =
      'Address same as correspondence address ';

  static const String documentType = 'Document Type';
  static const String documentNumber = 'Document number';
  static const String uploadNomineeDocument = 'Upload Document of nominee';
  static const String guardianDetails = 'Guardian Details';

  static const String mobileNumber = 'Mobile Number';
  static const String email = 'Email';
  static const String onlyImageFileAllowed =
      'Only image files (JPG, JPEG, PNG) are allowed';

  static const String invalid = 'Invalid';
  static const String enterGuardianName = 'Enter Guardian Name';
  static const String guardianName = 'Guardian Name';
  static const String guardianDOB = 'Guardian Date of Birth';

  static const String guardianCountry = 'Guardian Country';
  static const String guardianState = 'Guardian State';
  static const String guardianCity = 'Guardian City';
  static const String guardianPincode = 'Guardian Pincode';
  static const String uploadGuardianDocument = 'Upload Document of guardian';
  static const String relationRequired = 'Relation is required';
  static const String add = 'Add';

  static const String documentNumberRequired = 'Document number is required';
  static const String documentTypeRequired = 'Document type is required';
  static const String documentImageRequired = 'Nominee document  is required';

  static const String pinCodeRequired = 'Pincode is required ';
  static const String cityRequired = 'City is required';

  static const String enterNomineeName = 'NomineeName is required ';
  static const String nomineeDobRequired = 'Nominee Dob is required';
  static const String stateRequired = 'State is required';
  static const String enterNomineeAddress =
      'Please enter nominee address is required';
  static const String enterEmail = 'Please enter email';
  static const String address1Required = 'Address1 is required';
  static const String countryRequired = 'Country is required';
  static const String pdfResizeFailed = 'PDF Resize Failed';
  static const String invalidResponseFromPDFService =
      'Invalid response received from PDF resize service.';
  static const String pdfCheckedFailed = 'PDF Check Failed';
  static const String pdfCheckReturnedEmptyData =
      'PDF check returned empty data';
  static const String unableToCheck = 'Unable to check Income Proof PDF.';
  static const String invalidResponseFromPDFCheck =
      'Invalid response received while checking PDF.';

  static const String incomeProofPDFDataIsEmpty =
      'Income Proof PDF data is empty';

  static const String relationshipIsRequired = 'Relationship is Required';
  static const String pincodeIsRequired = 'Pincode is Required';
  static const String last4DigitAadhar = 'Last 4 Digits of Aadhaar';
  static const String passportNumber = 'Passport Number';
  static const String drivingLicenceNumber = 'Driving Licence number';
  static const String panNumber = 'Pan Number';
  static const String documentProofNo = 'Document Proof No';

  static const String guardianDobRequired = 'Guardian Dob is required';
  static const String invalidDateOfBirth = 'Please enter a valid date of birth';

  static const String nomineeFutureDob =
      'Nominee date of birth cannot be in the future';
  static const String guardianFutureDob =
      'Guardian date of birth cannot be in the future';
  static const String guardianMustBeOlder =
      'Guardian must be older than nominee';
  static const String guardianMustBe18OrOlder =
      'Guardian must be 18 years or older';

  static const String passPortNumberCannot =
      'Passport number cannot exceed 25 characters';
  static const String drivingLicenceNumberCannot =
      'Driving Licence number cannot exceed 25 characters';

  static const String enterValidPANNumber = 'Enter valid PAN number';
  static const String enterDocumentNumber = 'Enter document number';

  static const String panNumberCannotExceed =
      'PAN number cannot exceed 10 characters';

  static const String docNumberCannotExceed =
      'Document number cannot exceed 25 characters';

  static const String confirmDelete = 'Confirm Delete';
  static const String yesDelete = 'Yes, Delete';
  static const String noKeep = 'No, Keep';
  static const String deleteConfirmation =
      'Are you sure you want to delete this nominee?';

  static const String panMismatch = 'PAN Mismatch';
  static const String disIntimation =
      'DIS Intimation & Account Information Preview';

  static const String ddpiFlag =
      'DDPI (Demat Debit and Pledge Instruction) Flag';
  static const String selectDeliveryOptionDIS =
      'Select Delivery Options for DIS (Delivery Instruction Slip) :';
  static const String receivedDISAtOpening =
      'Receive the DIS at the time of account opening.';

  static const String receivedDISLater =
      'Receive the DIS at a later date upon request.';

  static const String generatePDF = 'Generate PDF';
  static const String reviewAccountInformation =
      'Please review your account information carefully.';
  static const String downloadAccountOpeingForm =
      'Download the account opening form. ';

  static const String proceedToNextStepForESign =
      'Proceed to the next step for the e-sign process.';

  static const String docNumberMustMatchPan =
      'Document number must match the entered PAN number';
}
