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
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/custom_drop_down_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/custom_otp_textform_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/gradient_text_button_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/global_state_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;

/*
Title:BankAccountInfoScreen
Purpose:BankAccountInfoScreen
Created On:
Edited On:
Author: 
*/

class BankAccountInfoScreen extends StatefulWidget {
  const BankAccountInfoScreen({super.key});

  @override
  State<BankAccountInfoScreen> createState() => _BankAccountInfoScreenState();
}

class _BankAccountInfoScreenState extends State<BankAccountInfoScreen> {
  final ScrollController bankIFSCScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      authProvider.initBankValidation();
      await authProvider.restoreBankDetailsState(globalStateProvider);
      showBankAccountInfoPopup();
    });
  }

  Future<void> showBankAccountInfoPopup() async {
    final authProvider = context.read<AuthProvider>();
    // LogHelper.infoLog('ISBANK DETAILS::: ${!authProvider.isBankDetailsVerified}');

    final personalDetails =
        authProvider.globalStateProvider.get<Map<String, dynamic>>(
          'personalDetails',
        ) ??
        {};
    final bankDetails =
        personalDetails['bankDetails'] as Map<String, dynamic>? ?? {};

    final isVerified = bankDetails['isOTPVerified'] == true;
    authProvider.isVerifiedBankNotifier.value = isVerified;
    authProvider.isBankDetailsVerified = isVerified;
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.bankAccountInfo,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          return provider.isBankDetailsVerified
              ? verifiedBankDetailsBodyWidget(context)
              : bankAccountInfoBodyWidget(context);
        },
      ),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isVerifiedBankNotifier,
      onPrimaryButtonTap: () async {
        final personalDetails =
            authProvider.globalStateProvider.get<Map<String, dynamic>>(
              'personalDetails',
            ) ??
            {};
        final bankDetails =
            personalDetails['bankDetails'] as Map<String, dynamic>? ?? {};
        final isBankAccountVerified = bankDetails['isOTPVerified'] == true;

        if (!isBankAccountVerified) {
          AppHelperWidgets.showSnackBar(
            title: AppStrings.warning,
            message: AppStrings.verifyBankDetails,
            messageType: AppStrings.responseTypeWarning,
          );
          return;
        }

        AppNavigator.pop();
        appRouter.push(AppRoutes.uploadChequeScreen);
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        authProvider.resetBankDetails();
        AppNavigator.popAndPush(AppRoutes.selectMarketSegmentScreen);
      },
    );
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

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }

  Widget buildBankDetailRow(String title, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title :',
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize14,
                fontWeight: AppFontWeight.fontWeight600,
                color: AppColors.kBlackColor.withValues(alpha: 0.5),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight600,
                  color: AppColors.kBlackColor.withValues(alpha: 0.5),
                  // color: AppColors.kBlackColor,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: AppDimens.paddingNormal),
        HorizontalDividerWidget(height: 1.0, color: AppColors.kGreyColor),
        SizedBox(height: AppDimens.paddingNormal),
      ],
    );
  }

  Widget verifiedBankDetailsBodyWidget(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final personalDetails =
        authProvider.globalStateProvider.get<Map<String, dynamic>>(
          'personalDetails',
        ) ??
        {};
    final bankDetails =
        personalDetails['bankDetails'] as Map<String, dynamic>? ?? {};
    final bankAccountType = authProvider.bankAccountTypeList
        .where((e) => e.id == bankDetails['BankType'])
        .firstOrNull;

    return Column(
      children: [
        SizedBox(height: AppDimens.paddingNormal),
        Container(
          decoration: BoxDecoration(
            color: AppColors.kGreyColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.paddingNormal,
              right: AppDimens.paddingNormal,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimens.paddingNormal),
                Center(
                  child: Text(
                    AppStrings.verifiedBankDetails,
                    style: AppTextStyles.poppinsMedium.copyWith(
                      fontSize: AppFontSize.fontSize18,
                      fontWeight: AppFontWeight.fontWeight600,
                      color: AppColors.kBlackColor,
                    ),
                  ),
                ),

                SizedBox(height: AppDimens.paddingMedium),

                buildBankDetailRow(
                  AppStrings.accountNumber,
                  bankDetails['BankAccountNo']?.toString() ?? '-',
                ),

                buildBankDetailRow(
                  AppStrings.bankName,
                  bankDetails['BankName']?.toString() ?? '-',
                ),

                buildBankDetailRow(
                  AppStrings.ifscCode,
                  bankDetails['BankIFSCCode']?.toString() ?? '-',
                ),

                buildBankDetailRow(
                  AppStrings.accountType,
                  bankAccountType?.name ?? '-',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppDimens.paddingMedium),
        Row(
          children: [
            GestureDetector(
              onTap: authProvider.isAutoDebitChecked,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                width: 22.h,
                height: 22.h,
                decoration: BoxDecoration(
                  color: authProvider.isAutoDebitEnable
                      ? AppColors.kBlueColor
                      : AppColors.kTransparentColor,
                  border: Border.all(color: AppColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),

                child: authProvider.isAutoDebitEnable
                    ? const Icon(
                        Icons.check,
                        color: AppColors.kWhiteColor,
                        size: 20,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: AppDimens.paddingNormal),
            Expanded(
              child: Text(
                AppStrings.enableAuto,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize13,
                  color: AppColors.kBlackColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget bankAccountInfoBodyWidget(BuildContext context) {
    final globalStateProvider = context.read<GlobalStateProvider>();
    final registrationDetail =
        globalStateProvider.get<Map<String, dynamic>>('RegistrationDetail') ??
        {};

    final mobileNumber = registrationDetail['mobile']?.toString() ?? '';
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final int itemCount = authProvider.searchIFSCCodeList.length;
        final int visibleItems = itemCount > 4 ? 4 : itemCount;
        final double listHeight = visibleItems * 62.h;
        return Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.paddingMedium),
              CustomDropDownWidget<String>(
                prefixImg: AppImages.accountTypeImg,
                prefixImgColor: AppColors.klightBlueText,
                hintText: AppStrings.accountType,
                value: authProvider.selectedBankAccountType,
                hasError: authProvider.accountTypeHasError,
                errorMessage: authProvider.accountTypeError,
                items: authProvider.bankAccountTypeList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.name,
                    child: Text(e.name ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  final selectedItem = authProvider.bankAccountTypeList
                      .firstWhere((e) => e.name == value);
                  authProvider.updateSelectedBankAccountType(selectedItem);
                },
                onDropdownClosed: () {
                  if (authProvider.selectedBankAccountType == null ||
                      authProvider.selectedBankAccountType!.trim().isEmpty) {
                    authProvider.setAccountTypeError(
                      hasError: true,
                      errorMessage: AppStrings.accountTypeRequired,
                    );
                  } else {
                    authProvider.setAccountTypeError(
                      hasError: false,
                      errorMessage: '',
                    );
                  }
                },
                onEnableTap: () {},
              ),
              SizedBox(height: AppDimens.paddingNormal),
              TextFormFieldWidget(
                controller: authProvider.bankAccountNumberController,
                inputAction: TextInputAction.next,
                textInputType: TextInputType.phone,
                focusNode: authProvider.bankAccountNumberFocusNode,
                maxLength: 20,
                onFieldSubmittedVal: (String value) async {},
                isPhoneField: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.enterAccountNumber;
                  }

                  if (value.length < 10) {
                    return AppStrings.accountMustMin;
                  }

                  if (value.length > 20) {
                    return AppStrings.accountMustMax;
                  }

                  return null;
                },
                prefixImg: AppImages.accountNoImg,
                prefixImgColor: AppColors.klightBlueText,
                onChanged: (value) {
                  authProvider.validateBankAccountNumber();
                },
                hint: AppStrings.accountNumber,
                externalHasError: authProvider.bankAccountNumberHasError,
                externalErrorMessage: authProvider.bankAccountNumberError,
              ),
              SizedBox(height: AppDimens.paddingNormal),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormFieldWidget(
                    controller: authProvider.bankIFSCController,
                    inputAction: TextInputAction.next,
                    textInputType: TextInputType.text,
                    isUpperCase: true,
                    maxLength: 11,
                    isPhoneField: false,
                    onFieldSubmittedVal: (String value) async {},
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.enterifsc;
                      }
                      if (!AppConstants.ifscRegex.hasMatch(
                        value.trim().toUpperCase(),
                      )) {
                        return AppStrings.invalidIFSC;
                      }
                      return null;
                    },
                    prefixImg: AppImages.ifscImg,
                    focusNode: authProvider.bankIFSCFocusNode,
                    prefixImgColor: AppColors.klightBlueText,
                    onChanged: (value) async {
                      authProvider.validateIFSCCode();
                      if (value.trim().length > 2) {
                        await authProvider.getBankDetailsByIFSC(
                          searchedIFSC: value,
                        );
                      } else {
                        authProvider.searchIFSCCodeList = [];
                        authProvider.isBankDetailsNotFound = false;
                        authProvider.notifyListeners();
                      }
                    },
                    hint: AppStrings.ifscCode,
                    externalHasError: authProvider.ifscCodeHasError,
                    externalErrorMessage: authProvider.ifscCodeError,
                  ),
                  SizedBox(height: AppDimens.paddingNormal),
                  if (authProvider.isLoadingSearchIFSCCode)
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: SizedBox(
                        height: 18.h,
                        width: 18.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  if (authProvider.searchIFSCCodeList.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      height: listHeight,
                      decoration: BoxDecoration(
                        color: AppColors.kWhiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.kGreyColor.withValues(alpha: .15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              controller: bankIFSCScrollController,
                              padding: EdgeInsets.zero,
                              itemCount: authProvider.searchIFSCCodeList.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1.h,
                                color: AppColors.kGreyColor.withValues(
                                  alpha: .12,
                                ),
                              ),
                              itemBuilder: (context, index) {
                                final bank =
                                    authProvider.searchIFSCCodeList[index];
                                return InkWell(
                                  onTap: () =>
                                      authProvider.selectSearchIFSCCode(bank),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 10.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 3.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: index % 2 == 0
                                                ? AppColors.kRedColor
                                                : AppColors.kBlueColor,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '${bank.IFSCCode} '
                                                '- '
                                                '${bank.MICRCode} '
                                                '- '
                                                '${bank.bankName}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles
                                                    .poppinsSemiBold
                                                    .copyWith(
                                                      fontSize: AppFontSize
                                                          .fontSize12,
                                                      color: AppColors
                                                          .kPrimaryBlueColor,
                                                    ),
                                              ),
                                              SizedBox(height: 3.h),
                                              Text(
                                                '${bank.bankBranchName}, '
                                                '${bank.branchAdd4}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles
                                                    .poppinsMedium
                                                    .copyWith(
                                                      fontSize: AppFontSize
                                                          .fontSize10,
                                                      color:
                                                          AppColors.kGreyColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          Container(
                            width: 26.w,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: AppColors.kGreyColor.withValues(
                                    alpha: .15,
                                  ),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    bankIFSCScrollController.animateTo(
                                      (bankIFSCScrollController.offset - 50)
                                          .clamp(
                                            0.0,
                                            bankIFSCScrollController
                                                .position
                                                .maxScrollExtent,
                                          ),
                                      duration: const Duration(
                                        milliseconds: 150,
                                      ),
                                      curve: Curves.easeOut,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.arrow_drop_up,
                                    size: 28,
                                  ),
                                ),

                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),

                                          AnimatedBuilder(
                                            animation: bankIFSCScrollController,
                                            builder: (_, __) {
                                              if (!bankIFSCScrollController
                                                  .hasClients) {
                                                return const SizedBox.shrink();
                                              }

                                              final position =
                                                  bankIFSCScrollController
                                                      .position;
                                              if (!position
                                                  .hasContentDimensions) {
                                                return const SizedBox.shrink();
                                              }
                                              if (!position.haveDimensions) {
                                                return const SizedBox.shrink();
                                              }
                                              if (constraints.maxHeight <= 40) {
                                                return const SizedBox.shrink();
                                              }
                                              if (position.maxScrollExtent <=
                                                  0) {
                                                return const SizedBox.shrink();
                                              }
                                              const thumbHeight = 40.0;
                                              final maxScroll =
                                                  position.maxScrollExtent;
                                              final availableHeight = math.max(
                                                0.0,
                                                constraints.maxHeight -
                                                    thumbHeight,
                                              );
                                              if (availableHeight <= 0 ||
                                                  maxScroll <= 0) {
                                                return const SizedBox.shrink();
                                              }
                                              final top =
                                                  (position.pixels /
                                                          maxScroll *
                                                          availableHeight)
                                                      .clamp(
                                                        0.0,
                                                        availableHeight,
                                                      );

                                              return Positioned(
                                                top: top,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child: GestureDetector(
                                                    onVerticalDragUpdate: (details) {
                                                      final newTop =
                                                          (top +
                                                                  details
                                                                      .delta
                                                                      .dy)
                                                              .clamp(
                                                                0.0,
                                                                availableHeight,
                                                              );

                                                      final offset =
                                                          (newTop /
                                                              availableHeight) *
                                                          maxScroll;
                                                      if (bankIFSCScrollController
                                                          .hasClients) {
                                                        bankIFSCScrollController.jumpTo(
                                                          offset.clamp(
                                                            0.0,
                                                            bankIFSCScrollController
                                                                .position
                                                                .maxScrollExtent,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 8,
                                                      height: thumbHeight,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                                InkWell(
                                  onTap: () {
                                    bankIFSCScrollController.animateTo(
                                      (bankIFSCScrollController.offset + 50)
                                          .clamp(
                                            0.0,
                                            bankIFSCScrollController
                                                .position
                                                .maxScrollExtent,
                                          ),
                                      duration: const Duration(
                                        milliseconds: 50,
                                      ),
                                      curve: Curves.easeOut,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.arrow_drop_down,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (authProvider.isBankDetailsNotFound)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4D6),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFFFD67A)),
                      ),

                      child: Text(
                        AppStrings.bankNotFound,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.poppinsMedium.copyWith(
                          fontSize: AppFontSize.fontSize12,
                          color: const Color(0xFF9A6B00),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: AppDimens.paddingMedium),
              TextFormFieldWidget(
                controller: authProvider.bankNameController,
                inputAction: TextInputAction.next,
                textInputType: TextInputType.text,
                isUpperCase: true,
                focusNode: authProvider.bankNameFocusNode,
                onFieldSubmittedVal: (String value) async {},
                isEditable: authProvider.isBankDetailsNotFound == true
                    ? true
                    : false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.enterBankName;
                  }

                  if (value.trim().length < 3) {
                    return AppStrings.minimumOf3Char;
                  }

                  if (value.trim().length > 50) {
                    return AppStrings.maximum50Characters;
                  }
                  return null;
                },
                prefixImg: AppImages.bankNameImg,
                prefixImgColor: AppColors.klightBlueText,
                onChanged: (value) {},
                hint: AppStrings.bankName,
                externalHasError: authProvider.bankNameHasError,
                externalErrorMessage: authProvider.bankNameError,
              ),
              SizedBox(height: AppDimens.paddingNormal),
              TextFormFieldWidget(
                controller: authProvider.bankMICRCodeController,
                inputAction: TextInputAction.next,
                textInputType: TextInputType.phone,
                onFieldSubmittedVal: (String value) async {},
                isEditable: authProvider.isBankDetailsNotFound == true
                    ? true
                    : false,
                isPhoneField: true,
                maxLength: 9,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (authProvider.isShowManualBankEntry && text.isEmpty) {
                    return AppStrings.enterMICRCode;
                  }
                  if (text.isEmpty) {
                    return null;
                  }
                  if (!AppConstants.micrRegex.hasMatch(text)) {
                    return AppStrings.micrMustof9Digits;
                  }

                  return null;
                },
                prefixImg: AppImages.micrImg,
                prefixImgColor: AppColors.klightBlueText,
                onChanged: (value) {},
                hint: AppStrings.micrCode,
                externalHasError: authProvider.micrCodeHasError,
                externalErrorMessage: authProvider.micrCodeError,
                // isValidationOptional: true,
              ),

              SizedBox(height: AppDimens.paddingMedium),

              if (authProvider.isBankDetailsNotFound)
                Column(
                  children: [
                    TextFormFieldWidget(
                      controller: authProvider.branchNameController,
                      inputAction: TextInputAction.next,
                      textInputType: TextInputType.text,
                      isUpperCase: true,
                      onFieldSubmittedVal: (String value) async {},
                      isEditable: authProvider.isBankDetailsNotFound == true
                          ? true
                          : false,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (authProvider.isShowManualBankEntry &&
                            text.isEmpty) {
                          return '';
                        }
                        if (text.isEmpty) {
                          return null;
                        }
                        if (text.length < 3) {
                          return AppStrings.minimumOf3Char;
                        }
                        if (text.length > 50) {
                          return AppStrings.maximum50Characters;
                        }
                        return null;
                      },
                      prefixImg: AppImages.bankNameImg,
                      prefixImgColor: AppColors.klightBlueText,
                      onChanged: (value) {},
                      hint: AppStrings.branchName,
                      externalHasError: authProvider.branchNameHasError,
                      externalErrorMessage: authProvider.branchNameError,
                    ),
                    SizedBox(height: AppDimens.paddingMedium),
                    TextFormFieldWidget(
                      controller: authProvider.branchAddress1Controller,
                      inputAction: TextInputAction.next,
                      textInputType: TextInputType.text,
                      isUpperCase: true,
                      onFieldSubmittedVal: (String value) async {},
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (authProvider.isShowManualBankEntry &&
                            text.isEmpty) {
                          return '';
                        }
                        if (text.isEmpty) {
                          return null;
                        }
                        if (text.length < 3) {
                          return AppStrings.minimumOf3Char;
                        }
                        if (text.length > 36) {
                          return AppStrings.maximum36Characters;
                        }

                        return null;
                      },
                      prefixImg: AppImages.homeImg,
                      prefixImgColor: AppColors.klightBlueText,
                      onChanged: (value) {},
                      hint: AppStrings.branchAddressLine1,
                      externalHasError: authProvider.branchAddress1HasError,
                      externalErrorMessage: authProvider.branchAddress1Error,
                    ),
                    SizedBox(height: AppDimens.paddingNormal),

                    TextFormFieldWidget(
                      controller: authProvider.branchAddress2Controller,
                      inputAction: TextInputAction.next,
                      textInputType: TextInputType.text,
                      isUpperCase: true,
                      onFieldSubmittedVal: (String value) async {},
                      isValidationOptional: true,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) {
                          return null;
                        }
                        if (text.length < 3) {
                          return AppStrings.minimumOf3Char;
                        }
                        if (text.length > 36) {
                          return AppStrings.maximum36Characters;
                        }

                        return null;
                      },

                      prefixImg: AppImages.homeImg,
                      prefixImgColor: AppColors.klightBlueText,
                      onChanged: (value) {},
                      hint: AppStrings.branchAddressLine2,
                      externalHasError: authProvider.branchAddress2HasError,
                      externalErrorMessage: authProvider.branchAddress2Error,
                    ),

                    SizedBox(height: AppDimens.paddingNormal),
                    TextFormFieldWidget(
                      controller: authProvider.branchAddress3Controller,
                      inputAction: TextInputAction.next,
                      isUpperCase: true,
                      textInputType: TextInputType.text,
                      onFieldSubmittedVal: (String value) async {},
                      isValidationOptional: true,
                      validator: (value) {
                        final text = value?.trim() ?? '';

                        if (text.isEmpty) {
                          return null;
                        }
                        if (text.length < 3) {
                          return AppStrings.minimumOf3Char;
                        }

                        if (text.length > 36) {
                          return AppStrings.maximum36Characters;
                        }

                        return null;
                      },

                      prefixImg: AppImages.homeImg,
                      prefixImgColor: AppColors.klightBlueText,
                      onChanged: (value) {},
                      hint: AppStrings.branchAddressLine3,
                      externalHasError: authProvider.branchAddress3HasError,
                      externalErrorMessage: authProvider.branchAddress3Error,
                    ),

                    SizedBox(height: AppDimens.paddingNormal),
                    TextFormFieldWidget(
                      controller: authProvider.branchAddress4Controller,
                      inputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      isUpperCase: true,
                      onFieldSubmittedVal: (String value) async {},
                      isValidationOptional: true,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) {
                          return null;
                        }
                        if (text.length < 3) {
                          return AppStrings.minimumOf3Char;
                        }
                        if (text.length > 36) {
                          return AppStrings.maximum36Characters;
                        }

                        return null;
                      },

                      prefixImg: AppImages.homeImg,
                      prefixImgColor: AppColors.klightBlueText,
                      onChanged: (value) {},
                      hint: AppStrings.branchAddressLine4,
                      externalHasError: authProvider.branchAddress4HasError,
                      externalErrorMessage: authProvider.branchAddress4Error,
                    ),
                  ],
                ),

              SizedBox(height: AppDimens.paddingMedium),
              authProvider.isVerifyBtnVisible == false
                  ? Center(child: bankOTPTextFormFieldWidget())
                  : SizedBox(),
              SizedBox(height: AppDimens.paddingNormal),
              if (authProvider.isVerifyBtnVisible)
                Center(
                  child: GradientTextButtonWidget(
                    onButtonTap: () async {
                      final isValid = authProvider.validateBankDetails();
                      if (!isValid) {
                        return;
                      }
                      authProvider.updateVerifyButtonVisibility(false);
                      await authProvider.sendOTP(
                        type: AppStrings.otpTypeMobile,
                        isResume: false,
                        isResent: false,
                        mobile: mobileNumber,
                        email: '',
                        loginType: authProvider.defaultLoginType.value,
                        messageType: AppStrings.otpTypeBank,
                      );
                    },
                    btnTxt: AppStrings.verify,
                    width: 120.w,
                  ),
                ),
              SizedBox(height: AppDimens.paddingMedium),

              Row(
                children: [
                  GestureDetector(
                    onTap: authProvider.isAutoDebitChecked,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      width: 22.h,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: authProvider.isAutoDebitEnable
                            ? AppColors.kBlueColor
                            : AppColors.kTransparentColor,
                        border: Border.all(
                          color: AppColors.kBlueColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: authProvider.isAutoDebitEnable
                          ? const Icon(
                              Icons.check,
                              color: AppColors.kWhiteColor,
                              size: 20,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(width: AppDimens.paddingNormal),

                  Expanded(
                    child: Text(
                      AppStrings.enableAuto,
                      style: AppTextStyles.poppinsMedium.copyWith(
                        fontSize: AppFontSize.fontSize13,
                        color: AppColors.kBlackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget bankOTPTextFormFieldWidget() {
    final authProvider = context.read<AuthProvider>();
    return CustomOtpTextFormFieldWidget(
      otpType: AppStrings.otpTypeMobile,
      onOTPEntered: (otp) {},
      onResendTxtTap: () async {
        await authProvider.resendMobileOtp();
      },
      onVerifyOtp: (otp) async {
        final bool isBankOTPVerifiedSuccess = await authProvider
            .verifyBankMobileOtp(otp);
        if (!isBankOTPVerifiedSuccess) {
          return false;
        }

        final bool isBankVerificationSuccess = await authProvider
            .newCashfreeBankAccountVerificationAPI();
        if (isBankVerificationSuccess) {
          await confirmNameAsPerBankAlertDialog();
        }
        return isBankOTPVerifiedSuccess;
      },
    );
  }

  // Confirm Name as per Bank
  Future<void> confirmNameAsPerBankAlertDialog() async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.confirmNameAsPerBank,
      bodyWidget: nameAsperBankBodyWidget(),
      primaryButtonText: AppStrings.yesCorrect,
      primaryButtonEnabledNotifier: authProvider.isConfirmNameAsperBankNotifier,
      onPrimaryButtonTap: () async {
        AppNavigator.pop();
        await authProvider.saveBankVerificationDataLogAPI(
          authProvider.pendingBankVerificationData,
          authProvider.pendingBankVerificationStatusCode,
        );
        authProvider.pendingBankVerificationData = null;
        authProvider.pendingBankVerificationStatusCode = null;
      },
      isSecondaryButtonGradient: false,
      secondaryButtonText: AppStrings.no,
      onSecondaryButtonTap: () async {
        AppNavigator.pop();
        authProvider.updateVerifyButtonVisibility(true);
        authProvider.bankNameController.clear();
        authProvider.bankMICRCodeController.clear();
        final ifsc = authProvider.bankIFSCController.text.trim();
        if (ifsc.length > 2) {
          await authProvider.getBankDetailsByIFSC(searchedIFSC: ifsc);
        }
        authProvider.notifyListeners();
      },
    );
  }

  Widget nameAsperBankBodyWidget() {
    final authProvider = context.read<AuthProvider>();
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.paddingNormal,
        right: AppDimens.paddingNormal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppDimens.paddingMedium),
          Text(
            AppStrings.bankAccountVerifiedSuccess,
            style: AppTextStyles.poppinsMedium.copyWith(
              fontSize: AppFontSize.fontSize14,
              fontWeight: AppFontWeight.fontWeight400,
              color: AppColors.kBlackColor,
            ),
          ),

          SizedBox(height: AppDimens.paddingSmall),
          Row(
            children: [
              Text(
                AppStrings.nameAsPerBank,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight400,
                  color: AppColors.kBlackColor,
                ),
              ),
              SizedBox(width: AppDimens.paddingSmall),
              Text(
                authProvider.finalNameAtBank ?? '',
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight400,
                  color: AppColors.kBlackColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.paddingSmall),
          Text(
            AppStrings.doesYourNameMatch,
            style: AppTextStyles.poppinsMedium.copyWith(
              fontSize: AppFontSize.fontSize14,
              fontWeight: AppFontWeight.fontWeight400,
              color: AppColors.kBlackColor,
            ),
          ),
        ],
      ),
    );
  }
}
