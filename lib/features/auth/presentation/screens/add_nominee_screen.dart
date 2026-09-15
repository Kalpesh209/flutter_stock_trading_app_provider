import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_constants.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/custom_drop_down_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

/*
Title:AddNomineeDetailScreen
Purpose:To Add Nominee Details
Created On:
Edited On:
Author: 
*/

class AddNomineeDetailScreen extends StatefulWidget {
  final int nomineeIndex;
  const AddNomineeDetailScreen({super.key, required this.nomineeIndex});

  @override
  State<AddNomineeDetailScreen> createState() => _AddNomineeScreenState();
}

class _AddNomineeScreenState extends State<AddNomineeDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      await authProvider.restoreAddedNomineeDetails();
      if (!mounted) {
        return;
      }
      authProvider.updateAddNomineeButtonState();
      await showAddNomineeDetailPopup();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [backGroundImgWidget(), overlapWidget()],
      ),
    );
  }

  //showAddNomineeDetailPopup
  Future<void> showAddNomineeDetailPopup() async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.addFirstNominee,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: showAddNomineeDetailBodyWidget(),
      primaryButtonText: AppStrings.add.toUpperCase(),
      primaryButtonEnabledNotifier: authProvider.addNomineeNotifier,
      onPrimaryButtonTap: () async {
        await authProvider.addNomineeBtnTap();
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back.toUpperCase(),
      onSecondaryButtonTap: () {
        authProvider.resetNomineefDetails();
        authProvider.resetGuardianDetails();
        AppNavigator.popAndPush(AppRoutes.nomineeDetailScreen);
      },
    );
  }

  //showAddNomineeDetailBodyWidget
  Widget showAddNomineeDetailBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isDocumentUploaded = authProvider
            .firstNomineeDocumentUploadController
            .text
            .trim()
            .isNotEmpty;
        return Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.paddingMedium),
              TextFormFieldWidget(
                controller: authProvider.firstNomineeNameController,
                inputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                onFieldSubmittedVal: (String value) {},
                isPhoneField: false,
                prefixImg: AppImages.personImg,
                prefixImgColor: AppColors.klightBlueText,
                isOnlyAlphabetAllowed: false,
                isUpperCase: true,
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                },
                hint: AppStrings.nomineeName,
                borderWidth: 2,
                validator: (String? value) {
                  if (value!.trim().length < 2) {
                    return AppStrings.minimumCharacter;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimens.paddingNormal),

              //PanNumber
              TextFormFieldWidget(
                controller: authProvider.firstNomineePANNumberController,
                inputAction: TextInputAction.next,
                onFieldSubmittedVal: (String value) {},
                prefixImg: AppImages.badgeImg,
                prefixImgColor: AppColors.klightBlueText,
                isOnlyAlphabetAllowed: false,
                isUpperCase: true,
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                },
                hint: AppStrings.nomineePanNumber,
                borderWidth: 2,
                isPhoneField: false,
                validator: (String? value) {
                  final pan = value?.trim().toUpperCase() ?? '';
                  if (pan.isEmpty) {
                    return null;
                  }
                  if (pan.length != 10) {
                    return AppStrings.enterValidPANNumber;
                  }

                  if (!AppConstants.individualPANRegex.hasMatch(pan)) {
                    return AppStrings.enterValidPANNumber;
                  }

                  return null;
                },

                isValidationOptional: true,
              ),
              const SizedBox(height: AppDimens.paddingNormal),
              TextFormFieldWidget(
                controller: authProvider.firstNomineeDobController,
                inputAction: TextInputAction.next,
                onFieldSubmittedVal: (String value) {},
                prefixImg: AppImages.calenderTodayImg,
                prefixImgColor: AppColors.klightBlueText,
                isOnlyAlphabetAllowed: false,
                isUpperCase: false,
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                },
                hint: AppStrings.nomineeDob,
                borderWidth: 2,
                validator: (String? value) {
                  if (value!.trim().length < 2) {
                    return AppStrings.minimumCharacter;
                  }
                  return null;
                },
                onTextFieldTap: () async {
                  final now = DateTime.now();
                  final selectedDate =
                      await CustomDatePickerWidget.showCustomDatePicker(
                        context: context,
                        hintText: AppStrings.nomineeDob,
                        value: authProvider.firstNomineeDob,
                        firstDate: DateTime(1900, 1, 1),
                        lastDate: DateTime(now.year, now.month, now.day),
                      );

                  if (selectedDate == null) {
                    return;
                  }
                  authProvider.onNomineeDobChanged(selectedDate);
                },

                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    authProvider.validateNomineeRelationshipOnFocusLoss();
                  }
                },
              ),
              const SizedBox(height: AppDimens.paddingNormalToMedium),

              //Relation
              CustomDropDownWidget<String>(
                prefixImg: AppImages.relationshipImg,
                prefixImgColor: AppColors.klightBlueText,
                hintText: AppStrings.relation,
                value: authProvider.selectedNomineeRelationship,
                // hasError: authProvider.nomineeRelationshipHasError,
                // errorMessage: authProvider.nomineeRelationshipError,
                items: authProvider.nomineeRelationShipList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.name,
                    child: Text(e.name ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  final selectedItem = authProvider.nomineeRelationShipList
                      .firstWhere((e) => e.name == value);
                  authProvider.updateSelectedNomineeRelationship(selectedItem);
                  authProvider.updateAddNomineeButtonState();
                  authProvider.notifyListeners();
                },
                onDropdownClosed: () {
                  final selectedText =
                      authProvider.selectedNomineeRelationship?.trim() ?? '';
                  final hintText = AppStrings.relation.trim();
                  final isNotSelected =
                      selectedText.isEmpty || selectedText == hintText;
                  // authProvider.setNomineeRelationshipError(
                  //   hasError: isNotSelected,
                  //   errorMessage: isNotSelected
                  //       ? AppStrings.relationRequired
                  //       : '',
                  // );
                  authProvider.setNomineeRelationshipError(
                    hasError: isNotSelected,
                    errorMessage: isNotSelected
                        ? AppStrings.relationshipIsRequired
                        : '',
                  );
                },
                onEnableTap: () {},
              ),

              const SizedBox(height: AppDimens.paddingMedium),
              Row(
                children: [
                  GestureDetector(
                    onTap: authProvider.onNomineeAddressSameCorrespondence,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 5),
                      width: 15.h,
                      height: 15.h,
                      decoration: BoxDecoration(
                        color: authProvider.isNomineeAddressSameAsCorrepondence
                            ? AppColors.kBlueColor
                            : AppColors.kTransparentColor,
                        border: Border.all(
                          color: AppColors.kBlueColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: authProvider.isNomineeAddressSameAsCorrepondence
                          ? const Icon(
                              Icons.check,
                              color: AppColors.kWhiteColor,
                              size: 15,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(width: AppDimens.paddingSmall),

                  Expanded(
                    child: Text(
                      AppStrings.addressSameAsCorrespondenceAddress,
                      style: AppTextStyles.poppinsMedium.copyWith(
                        fontSize: AppFontSize.fontSize11,
                        color: AppColors.kBlackColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.paddingNormal),
                ],
              ),
              const SizedBox(height: AppDimens.paddingNormal),
              TextFormFieldWidget(
                controller: authProvider.firstNomineeAddress1Controller,
                inputAction: TextInputAction.next,
                onFieldSubmittedVal: (String value) {},
                prefixImg: AppImages.homeImg,
                prefixImgColor: AppColors.klightBlueText,
                isOnlyAlphabetAllowed: true,
                isUpperCase: true,
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                },
                hint: AppStrings.addressLine1,
                borderWidth: 2,
                validator: (String? value) {
                  if (value!.trim().length < 2) {
                    return AppStrings.minimumCharacter;
                  }
                  return null;
                },
                isEditable: authProvider.isNomineeAddressSameAsCorrepondence
                    ? false
                    : true,
              ),
              const SizedBox(height: AppDimens.paddingNormal),
              TextFormFieldWidget(
                controller: authProvider.firstNomineeAddress2Controller,
                inputAction: TextInputAction.next,
                onFieldSubmittedVal: (String value) {},
                prefixImg: AppImages.homeImg,
                prefixImgColor: AppColors.klightBlueText,
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                },
                hint: AppStrings.addressLine2,
                isOnlyAlphabetAllowed: true,
                isUpperCase: true,
                borderWidth: 2,
                validator: (String? value) {
                  if (value!.trim().length < 2) {
                    return AppStrings.minimumCharacter;
                  }
                  return null;
                },

                isEditable: authProvider.isNomineeAddressSameAsCorrepondence
                    ? false
                    : true,
              ),
              const SizedBox(height: AppDimens.paddingMedium),
              TextFormFieldWidget(
                controller: authProvider.firstNomineeAddress3Controller,
                inputAction: TextInputAction.next,
                onFieldSubmittedVal: (String value) {},
                prefixImg: AppImages.homeImg,
                prefixImgColor: AppColors.klightBlueText,
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                },
                hint: AppStrings.addressLine3,
                isOnlyAlphabetAllowed: true,
                isUpperCase: true,
                borderWidth: 2,
                validator: (String? value) {
                  if (value!.trim().length < 2) {
                    return AppStrings.minimumCharacter;
                  }
                  return null;
                },
                isValidationOptional: true,
                isEditable: authProvider.isNomineeAddressSameAsCorrepondence
                    ? false
                    : true,
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    final selectedText =
                        authProvider.selectedCountry?.trim() ?? '';
                    final isNotSelected =
                        selectedText.isEmpty ||
                        selectedText == AppStrings.country.trim();
                    authProvider.setNomineeCountryError(
                      hasError: isNotSelected,
                      errorMessage: isNotSelected
                          ? AppStrings.countryRequired
                          : '',
                    );
                  }
                },
              ),
              const SizedBox(height: AppDimens.paddingMedium),
              // Country
              CustomDropDownWidget<String>(
                prefixImg: AppImages.countryImg,
                prefixImgColor: AppColors.klightBlueText,
                hintText: AppStrings.country,
                value: authProvider.selectedCountry,
                // hasError: authProvider.nomineeCountryHasError,
                // errorMessage: authProvider.nomineeCountryError,
                items: authProvider.countryList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.name,
                    child: Text(e.name ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  final selectedItem = authProvider.countryList.firstWhere(
                    (e) => e.name == value,
                  );
                  authProvider.updateSelectedCountry(selectedItem);
                  authProvider.updateAddNomineeButtonState();
                  authProvider.notifyListeners();
                },
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    final selectedStateText =
                        authProvider.selectedState?.trim() ?? '';

                    final isNotSelected =
                        selectedStateText.isEmpty ||
                        selectedStateText == AppStrings.state.trim();
                    authProvider.setNomineeStateError(
                      hasError: isNotSelected,
                      errorMessage: isNotSelected
                          ? AppStrings.stateRequired
                          : '',
                    );
                  }
                },
                enabled: !authProvider.isNomineeAddressSameAsCorrepondence,
                onEnableTap: () {},
              ),

              const SizedBox(height: AppDimens.paddingMedium),
              // State
              CustomDropDownWidget<String>(
                prefixImg: AppImages.mapImg,
                prefixImgColor: AppColors.klightBlueText,
                hintText: AppStrings.state,
                value: authProvider.selectedState,
                enabled: !authProvider.isNomineeAddressSameAsCorrepondence,
                // hasError: authProvider.nomineeStateHasError,
                // errorMessage: authProvider.nomineeStateError,
                items: authProvider.stateList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.name,
                    child: Text(e.name ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final selectedItem = authProvider.stateList.firstWhere(
                    (e) => e.name == value,
                  );
                  authProvider.updateSelectedState(selectedItem);
                  authProvider.updateAddNomineeButtonState();
                  authProvider.notifyListeners();
                },

                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    final selectedCityText =
                        authProvider.selectedCity?.trim() ?? '';

                    final isNotSelected =
                        selectedCityText.isEmpty ||
                        selectedCityText == AppStrings.city.trim();

                    authProvider.setNomineeCityError(
                      hasError: isNotSelected,
                      errorMessage: isNotSelected
                          ? AppStrings.cityRequired
                          : '',
                    );
                  }
                },
                onEnableTap: () {},
              ),
              const SizedBox(height: AppDimens.paddingMedium),
              // City
              CustomDropDownWidget<String>(
                prefixImg: AppImages.cityImg,
                prefixImgColor: AppColors.klightBlueText,
                hintText: AppStrings.city,
                value: authProvider.selectedCity,
                enabled: !authProvider.isNomineeAddressSameAsCorrepondence,
                // enabled: authProvider.selectedState != null,
                // hasError: authProvider.nomineeCityHasError,
                // errorMessage: authProvider.nomineeCityError,
                items: authProvider.cityList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.name,
                    child: Text(e.name ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final selectedItem = authProvider.cityList.firstWhere(
                    (e) => e.name == value,
                  );
                  authProvider.updateSelectedCity(selectedItem);
                  authProvider.updateAddNomineeButtonState();
                  authProvider.notifyListeners();
                },

                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    final selectedPinCodeText =
                        authProvider.selectedPincode?.trim() ?? '';

                    final isNotSelected =
                        selectedPinCodeText.isEmpty ||
                        selectedPinCodeText == AppStrings.pincode.trim();

                    authProvider.setNomineePinCodeError(
                      hasError: isNotSelected,
                      errorMessage: isNotSelected
                          ? AppStrings.pincodeIsRequired
                          : '',
                    );
                  }
                },

                onEnableTap: () {},
              ),
              const SizedBox(height: AppDimens.paddingMedium),

              // Pincode
              CustomDropDownWidget<String>(
                prefixImg: AppImages.pinDropImg,
                prefixImgColor: AppColors.klightBlueText,
                hintText: AppStrings.pincode,
                value: authProvider.selectedPincode,
                // hasError: authProvider.nomineePinCodeHasError,
                // errorMessage: authProvider.nomineePinCodeError,
                items: authProvider.pinCodeList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.name,
                    child: Text(e.name ?? ''),
                  );
                }).toList(),

                enabled: !authProvider.isNomineeAddressSameAsCorrepondence,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  final selectedItem = authProvider.pinCodeList.firstWhere(
                    (e) => e.name == value,
                  );
                  authProvider.updateSelectedPinCode(selectedItem);
                  authProvider.updateAddNomineeButtonState();
                  authProvider.notifyListeners();
                },

                onEnableTap: () {},
              ),
              const SizedBox(height: AppDimens.paddingMedium),
              TextFormFieldWidget(
                controller: authProvider.firstNomineeMobileNumberController,
                inputAction: TextInputAction.next,
                textInputType: TextInputType.phone,
                maxLength: 10,
                onFieldSubmittedVal: (String value) async {},
                isPhoneField: true,
                validator: (value) {
                  if (value!.length < 10) {
                    return AppStrings.enterValidMobile;
                  }
                  return null;
                },
                prefixImg: AppImages.callImg,
                prefixImgColor: AppColors.klightBlueText,
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                  authProvider.notifyListeners();
                  // authProvider.setMobileError(
                  //   hasError: false,
                  //   errorMessage: '',
                  // );
                },
                hint: AppStrings.mobileNumber,
                // externalHasError: authProvider.mobileHasError,
                // externalErrorMessage: authProvider.mobileError,
              ),

              const SizedBox(height: AppDimens.paddingMedium),
              TextFormFieldWidget(
                controller: authProvider.firstNomineeEmailController,
                inputAction: TextInputAction.next,
                onFieldSubmittedVal: (String value) {},
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  if (!RegExp(AppConstants.emailRegex).hasMatch(value.trim())) {
                    return AppStrings.enterValidEmail;
                  }
                  return null;
                },
                prefixImg: AppImages.mailImg,
                prefixImgColor: AppColors.klightBlueText,
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                  authProvider.notifyListeners();
                },
                hint: AppStrings.email,
                // externalHasError: authProvider.emailHasError,
                // externalErrorMessage: authProvider.emailError,
              ),

              const SizedBox(height: AppDimens.paddingMedium),

              //Document Type
              CustomDropDownWidget<String>(
                prefixImg: AppImages.descriptionImg,
                prefixImgColor: AppColors.klightBlueText,
                hintText: AppStrings.documentType,
                value: authProvider.selectedNomineeDocumentType?.name,
                hasError: authProvider.nomineeDocumentTypeHasError,
                errorMessage: authProvider.nomineeDocumentTypeError,
                items: authProvider.nomineeDocumentTypeList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.name,
                    child: Text(e.name ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  final selectedItem = authProvider.nomineeDocumentTypeList
                      .firstWhere((e) => e.name == value);

                  authProvider.firstNomineeDocumentNumberController.clear();
                  authProvider.setNomineeDocumentNumberError(
                    hasError: false,
                    errorMessage: '',
                  );
                  authProvider.selectedNomineeDocumentType = selectedItem;
                  authProvider.applyNomineeDocumentTypeRules(selectedItem.id);
                  authProvider.updateAddNomineeButtonState();
                  authProvider.notifyListeners();
                },
                onEnableTap: () {},
              ),
              const SizedBox(height: AppDimens.paddingMedium),
              TextFormFieldWidget(
                controller: authProvider.firstNomineeDocumentNumberController,
                inputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                onFieldSubmittedVal: (String value) async {
                  authProvider.validateNomineeDocumentNumber();
                },
                isPhoneField: false,
                isUpperCase: true,
                maxLength: authProvider.nomineeProofMaxSize,
                validator: (value) {
                  return null;
                },
                prefixImg: AppImages.micrImg,
                prefixImgColor: AppColors.klightBlueText,
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                  authProvider.notifyListeners();
                },
                hint: authProvider.nomineeProofPlaceholder!,
                externalHasError: authProvider.nomineeDocumentNumberHasError,
                externalErrorMessage: authProvider.nomineeDocumentNumberError,
              ),

              const SizedBox(height: AppDimens.paddingNormal),

              //Upload Nominee Doc Image
              TextFormFieldWidget(
                controller: authProvider.firstNomineeDocumentUploadController,
                inputAction: TextInputAction.next,
                onFieldSubmittedVal: (String value) {},
                prefixImg: AppImages.uploadFileImg,
                prefixImgColor: AppColors.klightBlueText,
                suffixImg: isDocumentUploaded
                    ? AppImages.closeImg
                    : AppImages.cloudUploadImg,
                suffixImgColor: AppColors.klightBlueText,
                onSuffixImgTap: () async {
                  if (isDocumentUploaded) {
                    await authProvider.removeNomineeDocument();
                  } else {
                    // Open file picker
                    await authProvider.onNomineeDocumentSelected();
                  }
                },
                onChanged: (value) {
                  authProvider.updateAddNomineeButtonState();
                },
                hint: AppStrings.uploadNomineeDocument,
                isOnlyAlphabetAllowed: true,
                isUpperCase: true,
                borderWidth: 2,
                validator: (String? value) {
                  if (value!.trim().length < 2) {
                    return AppStrings.minimumCharacter;
                  }
                  return null;
                },
                isEditable: false,
                onTextFieldTap: () async {
                  await authProvider.onNomineeDocumentSelected();
                },
              ),

              if (authProvider.isNomineeMinor) ...[
                SizedBox(height: AppDimens.paddingMedium),
                showGuardianDetailsWidget(authProvider),
              ],
            ],
          ),
        );
      },
    );
  }

  // showGuardianDetailsWidget
  Widget showGuardianDetailsWidget(AuthProvider authProvider) {
    return Column(
      children: [
        Text(
          AppStrings.guardianDetails,
          style: AppTextStyles.poppinsMedium.copyWith(
            fontSize: AppFontSize.fontSize24,
            color: AppColors.k198754,
            fontWeight: AppFontWeight.fontWeight700,
          ),
        ),
        const SizedBox(height: AppDimens.paddingMedium),
        TextFormFieldWidget(
          controller: authProvider.guardianNameController,
          inputAction: TextInputAction.next,
          onFieldSubmittedVal: (String value) {},
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.enterGuardianName;
            }
            return null;
          },
          prefixImg: AppImages.personImg,
          prefixImgColor: AppColors.klightBlueText,
          onChanged: (value) {
            authProvider.updateAddNomineeButtonState();
          },
          hint: AppStrings.guardianName,
          isUpperCase: true,
        ),
        const SizedBox(height: AppDimens.paddingMedium),
        TextFormFieldWidget(
          controller: authProvider.guardianDobController,
          inputAction: TextInputAction.next,
          onFieldSubmittedVal: (String value) {},
          prefixImg: AppImages.calenderTodayImg,
          prefixImgColor: AppColors.klightBlueText,
          isOnlyAlphabetAllowed: false,
          isUpperCase: false,
          externalHasError: authProvider.guardianDobHasError,
          externalErrorMessage: authProvider.guardianDobError,
          onChanged: (value) {
            authProvider.validateGuardianDob(
              nomineeDob: authProvider.firstNomineeDobController.text.trim(),
              guardianDob: value.trim(),
            );
            authProvider.updateAddNomineeButtonState();
          },

          hint: AppStrings.guardianDOB,
          borderWidth: 2,
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.guardianDobRequired;
            }

            return null;
          },

          onTextFieldTap: () async {
            final now = DateTime.now();
            final selectedDate =
                await CustomDatePickerWidget.showCustomDatePicker(
                  context: context,
                  hintText: AppStrings.guardianDOB,
                  value: _parseGuardianDobForPicker(
                    authProvider.guardianDobController.text.trim(),
                  ),
                  firstDate: DateTime(1900, 1, 1),
                  lastDate: DateTime(now.year, now.month, now.day),
                );

            if (selectedDate == null) {
              return;
            }

            authProvider.onGuardianDobChanged(selectedDate);
            authProvider.validateGuardianDob(
              nomineeDob: authProvider.firstNomineeDobController.text.trim(),
              guardianDob: authProvider.guardianDobController.text.trim(),
            );
          },
        ),

        const SizedBox(height: AppDimens.paddingNormalToMedium),

        // Guardian Relation
        CustomDropDownWidget<String>(
          prefixImg: AppImages.relationshipImg,
          prefixImgColor: AppColors.klightBlueText,
          hintText: AppStrings.relation,
          value: authProvider.selectedGuardianRelationship,
          hasError: authProvider.guardianRelationshipHasError,
          errorMessage: authProvider.guardianRelationshipError,
          items: authProvider.filteredGuardianRelationsList.map((e) {
            return DropdownMenuItem<String>(
              value: e.name,
              child: Text(e.name ?? ''),
            );
          }).toList(),

          onChanged: (value) {
            if (value == null) {
              return;
            }

            final selectedItem = authProvider.filteredGuardianRelationsList
                .firstWhere((e) => e.name == value);
            authProvider.updateSelectedGuardianRelationship(selectedItem);
          },

          onDropdownClosed: () {
            final selectedText =
                authProvider.selectedGuardianRelationship?.trim() ?? '';
            final hintText = AppStrings.relation.trim();
            final isNotSelected =
                selectedText.isEmpty || selectedText == hintText;
            authProvider.setGuardianRelationshipError(
              hasError: isNotSelected,
              errorMessage: isNotSelected
                  ? AppStrings.relationshipIsRequired
                  : '',
            );
          },
          onEnableTap: () {},
        ),

        const SizedBox(height: AppDimens.paddingNormalToMedium),

        Row(
          children: [
            GestureDetector(
              onTap: authProvider.onGuardianAddressSameCorrespondence,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 5),
                width: 15.h,
                height: 15.h,
                decoration: BoxDecoration(
                  color: authProvider.isGuardianAddressSameAsCorrepondence
                      ? AppColors.kBlueColor
                      : AppColors.kTransparentColor,
                  border: Border.all(color: AppColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),

                child: authProvider.isGuardianAddressSameAsCorrepondence
                    ? const Icon(
                        Icons.check,
                        color: AppColors.kWhiteColor,
                        size: 15,
                      )
                    : null,
              ),
            ),

            const SizedBox(width: AppDimens.paddingSmall),

            Expanded(
              child: Text(
                AppStrings.addressSameAsCorrespondenceAddress,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize11,
                  color: AppColors.kBlackColor,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.paddingNormal),
          ],
        ),
        const SizedBox(height: AppDimens.paddingNormal),
        TextFormFieldWidget(
          controller: authProvider.guardianAddress1Controller,
          inputAction: TextInputAction.next,
          onFieldSubmittedVal: (String value) {},
          prefixImg: AppImages.homeImg,
          prefixImgColor: AppColors.klightBlueText,
          isOnlyAlphabetAllowed: true,
          isUpperCase: true,
          onChanged: (value) {
            authProvider.updateAddNomineeButtonState();
          },
          hint: AppStrings.addressLine1,
          borderWidth: 2,
          validator: (String? value) {
            if (value!.trim().length < 2) {
              return AppStrings.minimumCharacter;
            }
            return null;
          },
          isEditable: authProvider.isGuardianAddressSameAsCorrepondence
              ? false
              : true,
        ),
        const SizedBox(height: AppDimens.paddingNormal),
        TextFormFieldWidget(
          controller: authProvider.guardianAddress2Controller,
          inputAction: TextInputAction.next,
          onFieldSubmittedVal: (String value) {},
          prefixImg: AppImages.homeImg,
          prefixImgColor: AppColors.klightBlueText,
          onChanged: (value) {
            authProvider.updateAddNomineeButtonState();
          },
          hint: AppStrings.addressLine2,
          isOnlyAlphabetAllowed: true,
          isUpperCase: true,
          borderWidth: 2,
          validator: (String? value) {},
          isValidationOptional: true,
          isEditable: authProvider.isGuardianAddressSameAsCorrepondence
              ? false
              : true,
        ),
        const SizedBox(height: AppDimens.paddingMedium),
        TextFormFieldWidget(
          controller: authProvider.guardianAddress3Controller,
          inputAction: TextInputAction.next,
          onFieldSubmittedVal: (String value) {},
          prefixImg: AppImages.homeImg,
          prefixImgColor: AppColors.klightBlueText,
          onChanged: (value) {
            authProvider.updateAddNomineeButtonState();
          },
          hint: AppStrings.addressLine3,
          isOnlyAlphabetAllowed: true,
          isUpperCase: true,
          borderWidth: 2,
          validator: (String? value) {
            if (value!.trim().length < 2) {
              return AppStrings.minimumCharacter;
            }
            return null;
          },
          isEditable: authProvider.isGuardianAddressSameAsCorrepondence
              ? false
              : true,
        ),
        const SizedBox(height: AppDimens.paddingMedium),
        // Country
        CustomDropDownWidget<String>(
          prefixImg: AppImages.countryImg,
          prefixImgColor: AppColors.klightBlueText,
          hintText: AppStrings.guardianCountry,
          value: authProvider.selectedGuardianCountry,
          items: authProvider.countryList.map((e) {
            return DropdownMenuItem<String>(
              value: e.name,
              child: Text(e.name ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }

            final selectedItem = authProvider.countryList.firstWhere(
              (e) => e.name == value,
            );
            authProvider.updateSelectedGuardianCountry(selectedItem);
            authProvider.updateAddNomineeButtonState();
          },

          enabled: !authProvider.isGuardianAddressSameAsCorrepondence,
          onEnableTap: () {},
        ),
        const SizedBox(height: AppDimens.paddingMedium),

        // State
        CustomDropDownWidget<String>(
          prefixImg: AppImages.mapImg,
          prefixImgColor: AppColors.klightBlueText,
          hintText: AppStrings.guardianState,
          value: authProvider.selectedGuardianState,
          items: authProvider.guardianStateList.map((e) {
            return DropdownMenuItem<String>(
              value: e.name,
              child: Text(e.name ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }

            final selectedItem = authProvider.guardianStateList.firstWhere(
              (e) => e.name == value,
            );
            authProvider.updateSelectedGuardianState(selectedItem);
            authProvider.updateAddNomineeButtonState();
          },
          enabled: !authProvider.isGuardianAddressSameAsCorrepondence,
          onEnableTap: () {},
        ),
        const SizedBox(height: AppDimens.paddingMedium),

        // City
        CustomDropDownWidget<String>(
          prefixImg: AppImages.cityImg,
          prefixImgColor: AppColors.klightBlueText,
          hintText: AppStrings.guardianCity,
          value: authProvider.selectedGuardianCity,
          items: authProvider.guardianCityList.map((e) {
            return DropdownMenuItem<String>(
              value: e.name,
              child: Text(e.name ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            final selectedItem = authProvider.guardianCityList.firstWhere(
              (e) => e.name == value,
            );
            authProvider.updateSelectedGuardianCity(selectedItem);
            authProvider.updateAddNomineeButtonState();
          },
          enabled: !authProvider.isGuardianAddressSameAsCorrepondence,
          onEnableTap: () {},
        ),

        const SizedBox(height: AppDimens.paddingMedium),
        // Pincode
        CustomDropDownWidget<String>(
          prefixImg: AppImages.pinDropImg,
          prefixImgColor: AppColors.klightBlueText,
          hintText: AppStrings.guardianPincode,
          value: authProvider.selectedGuardianPincode,
          items: authProvider.guardianPinCodeList.map((e) {
            return DropdownMenuItem<String>(
              value: e.name,
              child: Text(e.name ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }

            final selectedItem = authProvider.guardianPinCodeList.firstWhere(
              (e) => e.name == value,
            );
            authProvider.updateSelectedGuardianPinCode(selectedItem);
            authProvider.updateAddNomineeButtonState();
          },

          enabled: !authProvider.isGuardianAddressSameAsCorrepondence,
          onEnableTap: () {},
        ),

        const SizedBox(height: AppDimens.paddingMedium),

        // Guardian MobileNumber
        TextFormFieldWidget(
          controller: authProvider.guardianMobileNumberController,
          inputAction: TextInputAction.next,
          textInputType: TextInputType.phone,
          maxLength: 10,
          onFieldSubmittedVal: (String value) async {
            // if (value.trim().length != 10) {
            //   return;
            // }
            // final isUserExist = await authProvider
            //     .validateExistingMobile();
            // if (!context.mounted) {
            //   return;
            // }

            // if (!isUserExist) {
            //   return;
            // }
          },
          isPhoneField: true,
          validator: (value) {
            if (value!.length < 10) {
              return AppStrings.enterValidMobile;
            }
            return null;
          },
          prefixImg: AppImages.callImg,
          prefixImgColor: AppColors.klightBlueText,
          onChanged: (value) {
            authProvider.updateAddNomineeButtonState();
          },
          hint: AppStrings.mobileNumber,
          // externalHasError: authProvider.mobileHasError,
          // externalErrorMessage: authProvider.mobileError,
        ),

        const SizedBox(height: AppDimens.paddingMedium),
        TextFormFieldWidget(
          controller: authProvider.guardianEmailController,
          inputAction: TextInputAction.next,
          onFieldSubmittedVal: (String value) {},
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return null;
            }
            if (!RegExp(AppConstants.emailRegex).hasMatch(value.trim())) {
              return AppStrings.enterValidEmail;
            }
            return null;
          },
          prefixImg: AppImages.mailImg,
          prefixImgColor: AppColors.klightBlueText,
          onChanged: (value) {
            authProvider.updateAddNomineeButtonState();
          },
          hint: AppStrings.email,
          // externalHasError: authProvider.emailHasError,
          // externalErrorMessage: authProvider.emailError,
        ),

        const SizedBox(height: AppDimens.paddingMedium),

        // Guardian Document Type
        CustomDropDownWidget<String>(
          prefixImg: AppImages.descriptionImg,
          prefixImgColor: AppColors.klightBlueText,
          hintText: AppStrings.documentType,
          value: authProvider.selectedGuardianDocumentType?.name,
          hasError: authProvider.guardianDocumentTypeHasError,
          errorMessage: authProvider.guardianDocumentTypeError,
          items: authProvider.nomineeDocumentTypeList.map((e) {
            return DropdownMenuItem<String>(
              value: e.name,
              child: Text(e.name ?? ''),
            );
          }).toList(),

          onChanged: (value) {
            if (value == null) {
              return;
            }

            final selectedItem = authProvider.nomineeDocumentTypeList
                .firstWhere((e) => e.name == value);

            authProvider.guardianDocumentNumberController.clear();
            authProvider.setGuardianDocumentNumberError(
              hasError: false,
              errorMessage: '',
            );

            authProvider.selectedGuardianDocumentType = selectedItem;
            authProvider.applyGuardianDocumentTypeRules(selectedItem.id);
            authProvider.updateAddNomineeButtonState();
            authProvider.notifyListeners();
          },

          onEnableTap: () {},
        ),

        const SizedBox(height: AppDimens.paddingMedium),

        // CustomDropDownWidget<String>(
        //   prefixImg: AppImages.descriptionImg,
        //   prefixImgColor: AppColors.klightBlueText,
        //   hintText: AppStrings.documentType,
        //   value: authProvider.selectedGuardianDocumentType?.name,
        //   hasError: authProvider.guardianDocumentTypeHasError,
        //   errorMessage: authProvider.guardianDocumentTypeError,
        //   items: authProvider.nomineeDocumentTypeList.map((e) {
        //     return DropdownMenuItem<String>(
        //       value: e.name,
        //       child: Text(e.name ?? ''),
        //     );
        //   }).toList(),

        //   onChanged: (value) {
        //     if (value == null) {
        //       return;
        //     }

        //     final selectedItem = authProvider.nomineeDocumentTypeList
        //         .firstWhere((e) => e.name == value);
        //     authProvider.selectedGuardianDocumentType = selectedItem;
        //     authProvider.applyGuardianDocumentTypeRules(selectedItem.id);
        //     authProvider.updateAddNomineeButtonState();
        //   },

        //   onEnableTap: () {},
        // ),
        // const SizedBox(height: AppDimens.paddingMedium),
        TextFormFieldWidget(
          controller: authProvider.guardianDocumentNumberController,

          inputAction: TextInputAction.next,
          textInputType: TextInputType.text,

          onFieldSubmittedVal: (String value) async {
            authProvider.validateGuardianDocumentNumber();
          },

          isPhoneField: false,
          isUpperCase: true,

          maxLength: authProvider.guardianProofMaxSize,

          validator: (value) {
            return null;
          },

          prefixImg: AppImages.micrImg,
          prefixImgColor: AppColors.klightBlueText,
          onChanged: (value) {
            authProvider.updateAddNomineeButtonState();
            authProvider.notifyListeners();
          },

          hint: authProvider.guardianProofPlaceholder!,
          externalHasError: authProvider.guardianDocumentNumberHasError,
          externalErrorMessage: authProvider.guardianDocumentNumberError,
        ),

        // TextFormFieldWidget(
        //   controller: authProvider.guardianDocumentNumberController,
        //   inputAction: TextInputAction.next,
        //   textInputType: TextInputType.text,
        //   isPhoneField: false,
        //   isUpperCase: true,
        //   maxLength: authProvider.guardianProofMaxSize,
        //   onFieldSubmittedVal: (String value) async {
        //     authProvider.validateGuardianDocumentNumber();
        //   },

        //   prefixImg: AppImages.micrImg,
        //   prefixImgColor: AppColors.klightBlueText,
        //   hint: authProvider.guardianProofPlaceholder!,
        //   externalHasError: authProvider.guardianDocumentNumberHasError,
        //   externalErrorMessage: authProvider.guardianDocumentNumberError,
        //   onChanged: (value) {
        //     authProvider.validateGuardianDocumentNumber();
        //     authProvider.updateAddNomineeButtonState();
        //   },

        //   validator: (value) {
        //     if (value == null || value.trim().isEmpty) {
        //       return AppStrings.enterDocumentNumber;
        //     }

        //     if (authProvider.guardianDocumentNumberHasError) {
        //       return authProvider.guardianDocumentNumberError;
        //     }

        //     return null;
        //   },
        // ),
        const SizedBox(height: AppDimens.paddingNormal),
        TextFormFieldWidget(
          controller: authProvider.guardianDocumentUploadController,
          inputAction: TextInputAction.next,
          onFieldSubmittedVal: (String value) {},
          prefixImg: AppImages.uploadFileImg,
          prefixImgColor: AppColors.klightBlueText,
          suffixImg: authProvider.isGuardianDocumentUploaded
              ? AppImages.closeImg
              : AppImages.cloudUploadImg,
          suffixImgColor: AppColors.klightBlueText,
          onSuffixImgTap: () async {
            if (authProvider.isGuardianDocumentUploaded) {
              await authProvider.removeGuardianDocument();
            } else {
              await authProvider.onGuardianDocumentUploaded();
            }
          },
          onChanged: (value) {
            authProvider.updateAddNomineeButtonState();
          },
          hint: AppStrings.uploadNomineeDocument,
          isOnlyAlphabetAllowed: true,
          isUpperCase: true,
          borderWidth: 2,
          validator: (String? value) {
            if (value!.trim().length < 2) {
              return AppStrings.minimumCharacter;
            }
            return null;
          },
          isEditable: false,
          onTextFieldTap: () async {
            await authProvider.onGuardianDocumentUploaded();
          },
        ),
      ],
    );
  }

  DateTime? _parseGuardianDobForPicker(String value) {
    if (value.trim().isEmpty) {
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

    final date = DateTime(year, month, day);
    if (date.day != day || date.month != month || date.year != year) {
      return null;
    }
    return date;
  }

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }
}
