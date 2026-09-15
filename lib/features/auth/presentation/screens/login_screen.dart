import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_constants.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_enums.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/charges_structure_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/custom_otp_textform_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/custom_relationship_drop_down_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/square_text_button_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

/*
Title:Login Screen
Purpose:Login Screen
Created On:
Edited On:
Author: 
*/

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // All variable,function, initialisation will be in initState

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthProvider>().initData();
    });

    super.initState();
  }

  // To Dispose
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.naviBlueColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Stack(
              children: [backGroundImgWidget(), overlapWidget(context)],
            ),
          ),
        ),
      ),
    );
  }

  // All UI Widgets will always goes below build()
  Widget overlapWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.paddingMedium,
        right: AppDimens.paddingMedium,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  const SizedBox(height: AppDimens.paddingLarge),
                  Image.asset(AppImages.zeroAd1Img),
                  const SizedBox(height: AppDimens.paddingMedium),
                  GestureDetector(
                    onTap: () async {
                      final path1 = await getPdfPath(AppImages.dpChargesPDF);
                      final path2 = await getPdfPath(
                        AppImages.brokerageChargesPDF,
                      );
                      final path3 = await getPdfPath(
                        AppImages.taxesRegulatoryChargesPDF,
                      );
                      ChargesStructureAlertboxWidget.show(
                        context,
                        option1: AppStrings.dpCharges,
                        option2: AppStrings.brokerageCharges,
                        option3: AppStrings.taxesRegulatoryCharges,
                        pdfPath1: path1,
                        pdfPath2: path2,
                        pdfPath3: path3,
                      );
                    },
                    child: Image.asset(AppImages.amcYear2627Img),
                  ),
                  const SizedBox(height: AppDimens.paddingMedium),
                  Image.asset(AppImages.helloThereImg),
                  const SizedBox(height: AppDimens.paddingMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customCheckBoxWidget(
                        context,
                        LoginType.individual.label,
                        LoginType.individual.value,
                      ),
                      const SizedBox(width: AppDimens.paddingMedium),
                      customCheckBoxWidget(
                        context,
                        LoginType.others.label,
                        LoginType.others.value,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimens.paddingMedium),
                  Consumer<AuthProvider>(
                    builder: (_, authProvider, __) {
                      if (authProvider.defaultLoginType.value ==
                          LoginType.individual.value) {
                        return individualUI(context);
                      }
                      return othersUI(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget individualUI(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormFieldWidget(
          controller: authProvider.mobileController,
          inputAction: TextInputAction.next,
          textInputType: TextInputType.phone,
          maxLength: 10,
          onFieldSubmittedVal: (String value) async {
            if (value.trim().length != 10) {
              return;
            }
            final isUserExist = await authProvider.validateExistingMobile();
            if (!context.mounted) {
              return;
            }

            if (!isUserExist) {
              return;
            }

            await openExistingUserDialog(
              context,
              authProvider,
              authProvider.existingUserMessages,
              authProvider.existingUserTitle,
            );
          },
          isPhoneField: true,
          validator: (value) {
            if (value!.length < 10) {
              return AppStrings.enterValidMobile;
            }
            return null;
          },
          prefixImg: AppImages.mobileImg,
          prefixImgColor: AppColors.klightBlueText,
          onChanged: (value) {
            authProvider.setMobileError(hasError: false, errorMessage: '');
          },
          hint: AppStrings.mobile,
          externalHasError: authProvider.mobileHasError,
          externalErrorMessage: authProvider.mobileError,
        ),

        const SizedBox(height: AppDimens.paddingMedium),
        TextFormFieldWidget(
          controller: authProvider.emailController,
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
          onChanged: (value) {},
          hint: AppStrings.emailID,
          externalHasError: authProvider.emailHasError,
          externalErrorMessage: authProvider.emailError,
        ),
        const SizedBox(height: AppDimens.paddingMedium),
        TextFormFieldWidget(
          controller: authProvider.referralController,
          inputAction: TextInputAction.done,
          onFieldSubmittedVal: (String value) {},
          validator: (String? p1) {},
          isValidationOptional: true,
          prefixImg: AppImages.referralImg,
          prefixImgColor: AppColors.klightBlueText,
          onChanged: (value) {},
          hint: AppStrings.referralCode,
        ),
        const SizedBox(height: AppDimens.paddingMedium),
        enterReferralTextWidget(),
        const SizedBox(height: AppDimens.paddingMedium),
        agreeTermConditionWidget(context),
        const SizedBox(height: AppDimens.paddingMedium),
        getOTPTextButtonWidget(context),
        const SizedBox(height: AppDimens.paddingMedium),
      ],
    );
  }

  // openExistingUserDialog
  Future<void> openExistingUserDialog(
    BuildContext context,
    AuthProvider authProvider,
    List<String> messages,
    String title,
  ) async {
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: title,
      bodyWidget: userExistBodyWidget(messages),
      primaryButtonText: AppStrings.okUpdate,
      secondaryButtonText: AppStrings.noCancel,
      onPrimaryButtonTap: () async {
        AppNavigator.pop();
        final isSendOTPSuccess = await authProvider.sendOTP(
          type: AppStrings.otpTypeMobile,
          isResume: true,
          isResent: false,
          mobile: authProvider.mobileController.text.trim(),
          email: '',
          loginType: authProvider.defaultLoginType.value,
          messageType: '',
        );

        if (isSendOTPSuccess) {
          await Future.delayed(const Duration(milliseconds: 1));
          if (context.mounted) {
            confirmMobileOTPWidget(context);
          }
        }
      },
      onSecondaryButtonTap: () async {
        AppNavigator.pop();
        await Future.delayed(const Duration(milliseconds: 1));
        AppHelperWidgets.showSnackBar(
          title: AppStrings.warning,
          message: AppStrings.anotherMobile,
          messageType: AppStrings.responseTypeWarning,
        );
      },
    );
  }

  // ConfirmMobile OTP
  void confirmMobileOTPWidget(BuildContext context) {
    return AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.confirmMobileOTP,
      bodyWidget: confirmMobileOTPBodyWidget(),
      primaryButtonText: AppStrings.next,
      onPrimaryButtonTap: () {
        navigateToNextScreen(context);
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.close,
      onSecondaryButtonTap: () {
        AppNavigator.pop();
      },
    );
  }

  Widget confirmMobileOTPBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isMobileOtpVerified &&
            !authProvider.isNavigatingAfterOtp) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              navigateToNextScreen(context);
            }
          });
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: AppDimens.paddingNormal,
            right: AppDimens.paddingNormal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.paddingNormal),
              Text(
                AppStrings.mobileOTP,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight600,
                  color: AppColors.kBlackColor,
                ),
              ),
              const SizedBox(height: AppDimens.paddingNormal),
              otpTextFieldWidget(AppStrings.otpTypeMobile),
              const SizedBox(height: AppDimens.paddingMedium),
            ],
          ),
        );
      },
    );
  }

  void navigateToNextScreen(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isMobileOtpVerified ||
        authProvider.isNavigatingAfterOtp) {
      return;
    }
    authProvider.setOtpNavigationInProgress(true);
    AppNavigator.pop();
    Future.microtask(() {
      // LogHelper.infoLog('Context mounted: ${context.mounted}');
      if (context.mounted) {
        // LogHelper.infoLog('Calling resumeApplication');
        authProvider.resumeApplication();
      }
      authProvider.setOtpNavigationInProgress(false);
    });
  }

  Widget otpTextFieldWidget(String otpType) {
    final authProvider = context.read<AuthProvider>();
    return CustomOtpTextFormFieldWidget(
      otpType: otpType,
      onOTPEntered: (otp) {},
      onResendTxtTap: () {
        authProvider.resendMobileOtp();
      },
      onVerifyOtp: (otp) async {
        return await authProvider.verifyMobileOtp(otp);
      },
    );
  }

  //userExistBodyWidget
  Widget userExistBodyWidget(List<String> messages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppDimens.paddingMedium),
          ...messages.map(
            (message) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
              child: Text(
                message.replaceAll(r'\n', '\n\n'),
                textAlign: TextAlign.justify,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight400,
                  color: AppColors.kBlackColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget enterReferralTextWidget() {
    return Text(
      AppStrings.enterReferral,
      style: AppTextStyles.poppinsMedium.copyWith(
        fontSize: AppFontSize.fontSize16,
        fontWeight: AppFontWeight.fontWeight600,
        color: AppColors.kWhiteColor,
      ),
    );
  }

  Widget agreeTermConditionWidget(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, authProvider, __) {
        return Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: authProvider.toggleTerms,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 50),
                    width: 22.h,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: authProvider.isTermsAccepted
                          ? AppColors.kBlueColor
                          : AppColors.kTransparentColor,
                      border: Border.all(color: AppColors.kBlueColor, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),

                    child: authProvider.isTermsAccepted
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
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.poppinsMedium.copyWith(
                        fontSize: AppFontSize.fontSize14,
                        fontWeight: AppFontWeight.fontWeight400,
                        color: AppColors.kWhiteColor,
                      ),

                      children: [
                        const TextSpan(text: AppStrings.iAgree),

                        TextSpan(
                          text: AppStrings.termCondition,
                          style: AppTextStyles.poppinsMedium.copyWith(
                            fontSize: AppFontSize.fontSize16,
                            fontWeight: AppFontWeight.fontWeight700,
                            color: AppColors.kPrimaryGreenColor,
                          ),

                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AlertBoxWithSingleBtnWidget.show(
                                context,
                                title: AppStrings.termCondition,
                                primaryColor: AppColors.kPrimaryBlueColor,
                                closeButtonText: AppStrings.close,
                                onClose: () {
                                  // LogHelper.infoLog('T&C Dialog Closed');
                                },
                                sections: const [
                                  TermsSection(
                                    content: 'I understand and agree that the nature of information I have provided for the purpose of Online Account Opening with / through Shah Investor’s Home Ltd (SIHL) (hereinafter referred as “the Company”) are true and correct to the best of my knowledge and belief and I undertake to inform you of any changes therein immediately.',
                                  ),
                                  TermsSection(
                                    isBullet: true,
                                    content: 'I confirm that I am a tax resident of India and not a tax resident of any other country. If my tax residency status changes, I undertake to inform SIHL within 30 days and provide updated FATCA/CRS declarations as required by law. I authorize SIHL to disclose my information to the tax authorities, SEBI, or any government body if required for compliance with tax regulations, FATCA, CRS, or PMLA guidelines.',
                                  ),
                                  TermsSection(
                                    isBullet: true,
                                    heading: '',
                                    content: 'I am aware and agree to open Individual Regular Demat and Trading account through online mode. I understand that my PAN will be verified with the Income Tax database, and my Trading and Demat account will be opened accordingly.',
                                  ),
                                  TermsSection(
                                    isBullet: true,
                                    heading: '',
                                    content: 'I confirm that I am a tax resident of India and not a tax resident of any other country. If my tax residency status changes, I undertake to inform SIHL within 30 days and provide updated FATCA/CRS declarations as required by law. I authorize SIHL to disclose my information to the tax authorities, SEBI, or any government body if required for compliance with tax regulations, FATCA, CRS, or PMLA guidelines',
                                  ),
                                  TermsSection(
                                    isBullet: true,
                                    heading: '',
                                    content: ' I am aware and agree to open Individual Regular Demat and Trading account through online mode. I understand that my PAN will be verified with the Income Tax database, and my Trading and Demat account will be opened accordingly.',
                                  ),
                                  TermsSection(
                                    isBullet: true,
                                    heading: '',
                                    content: 'I hereby agree and allow SIHL to download my KYC information available from KRA/CKYC for the purpose of opening trading and demat accounts.',
                                  ),
                                  TermsSection(
                                    isBullet: true,
                                    heading: '',
                                    content: 'I hereby consent to receive information from Central KYC Registry/KRA through SMS/Email on the above-registered number/email address and to download my records from CKYCR by SIHL.',
                                  ),
                                  TermsSection(
                                    isBullet: true,
                                    heading: '',
                                    content: 'I hereby consent the company to provide its communication messages to me through the medium of short messages services and / or telephone calls / or Whats app on my registered phone number(s) with the Company.',
                                  ),
                                ],
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 50),
              child: authProvider.termsHasError
                  ? Padding(
                      key: const ValueKey('terms-error'),
                      padding: EdgeInsets.only(top: 6.h, left: 2.w),
                      child: Text(
                        authProvider.termsError,
                        style: AppTextStyles.poppinsMedium.copyWith(
                          fontSize: AppFontSize.fontSize14,
                          fontWeight: AppFontWeight.fontWeight400,
                          color: AppColors.kRedColor,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('no-terms-error')),
            ),
          ],
        );
      },
    );
  }

  Widget getOTPTextButtonWidget(BuildContext context) {
    return SquareTextButtonWidget(
      onButtonTap: () async {
        AppHelperWidgets.removeFocus();
        final authProvider = context.read<AuthProvider>();
        final status = authProvider.validateLoginFields();
        final isUserExist = await authProvider.checkMobileExist();
        if (isUserExist) {
          authProvider.setMobileError(
            hasError: true,
            errorMessage: AppStrings.mobileAlreadyRegistered,
          );
        }

        switch (status) {
          case LoginValidationStatus.invalid:
            break;

          case LoginValidationStatus.validWithoutReferral:
            await openNoReferralDialog(context, authProvider);
            break;

          case LoginValidationStatus.valid:
            final isSuccess = await authProvider.getReferralCodeAPI();
            if (isSuccess) {
              final referralCode = authProvider.referralController.text.trim();
              final referralData = authProvider.referralData?.data;

              final List<Widget> details = [];
              if (referralCode.startsWith('B') ||
                  referralCode.startsWith('b')) {
                details.addAll([
                  Text(
                    '${AppStrings.branchName} - '
                    '${referralData?.branchName ?? ''}',
                  ),
                  Text(
                    '${AppStrings.employee} - '
                    '${referralData?.employeeName ?? ''}',
                  ),
                ]);
              } else if (referralCode.startsWith('P') ||
                  referralCode.startsWith('p')) {
                // LogHelper.infoLog('STARTING WITH P');
                details.addAll([
                  Text(
                    '${AppStrings.branchName} - '
                    '${referralData?.branchName ?? ''}',
                  ),
                  Text(
                    '${AppStrings.partnerName} - '
                    '${referralData?.easyPartnerName ?? ''}',
                  ),
                  Text(
                    '${AppStrings.employee} - '
                    '${referralData?.employeeName ?? ''}',
                  ),
                ]);
              } else if (referralCode.startsWith('R') ||
                  referralCode.startsWith('r')) {
                // LogHelper.infoLog('STARTING WITH R');
                // Branch + Partner
                details.addAll([
                  Text(
                    '${AppStrings.branchName} - '
                    '${referralData?.branchName ?? ''}',
                  ),
                  Text(
                    '${AppStrings.partnerName} - '
                    '${referralData?.remisarName ?? ''}',
                  ),
                ]);
              }

              await openReferralDetailsDialog(context, authProvider, details);
            } else {
              AppHelperWidgets.showSnackBar(
                title: AppStrings.warning,
                message: AppStrings.pleaseProvideValidReferralCode,
                messageType: AppStrings.responseTypeWarning,
              );
            }
            break;
        }
      },
      btnTxt: AppStrings.getOTP,
      backgroundColor: AppColors.kWhiteColor,
      textColor: AppColors.kPrimaryBlueColor,
      width: double.infinity,
    );
  }

  // NoReferral Code
  Future<void> openNoReferralDialog(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.noReferralAdded,
      bodyWidget: noReferralAddedWidget(),
      primaryButtonText: AppStrings.okContinue,
      secondaryButtonText: AppStrings.noCancel,
      onPrimaryButtonTap: () async {
        AppNavigator.pop();

        try {
          authProvider.saveRegistrationDetail();
          await authProvider.sendOTP(
            type: AppStrings.otpTypeMobile,
            isResume: false,
            isResent: false,
            mobile: authProvider.mobileController.text.trim(),
            email: authProvider.emailController.text.trim(),
            loginType: authProvider.defaultLoginType.value,
            messageType: '',
          );

          await authProvider.sendOTP(
            type: AppStrings.otpTypeEmail,
            isResume: false,
            isResent: false,
            mobile: authProvider.mobileController.text.trim(),
            email: authProvider.emailController.text.trim(),
            loginType: authProvider.defaultLoginType.value,
            messageType: '',
          );

          if (context.mounted) {
            SelectRelationshipPopup.show(context);
          }
        } catch (e) {
          AppHelperWidgets.showSnackBar(
            title: AppStrings.error,
            message: AppStrings.failedToSendOTP,
            messageType: AppStrings.responseTypeError,
          );
        }
      },
      onSecondaryButtonTap: () {
        AppNavigator.pop();
        // context.pop();
      },
    );
  }

  // openReferralDetailsDialog
  Future<void> openReferralDetailsDialog(
    BuildContext context,
    AuthProvider authProvider,
    List<Widget> details,
  ) async {
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.confirmReferralDetails,
      bodyWidget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.paddingNormal),
          ...details,
        ],
      ),
      primaryButtonText: AppStrings.okContinue,
      secondaryButtonText: AppStrings.noCancel,
      onPrimaryButtonTap: () async {
        AppNavigator.pop();

        try {
          authProvider.saveRegistrationDetail();
          await authProvider.sendOTP(
            type: AppStrings.otpTypeMobile,
            isResume: false,
            isResent: false,
            mobile: authProvider.mobileController.text.trim(),
            email: '',
            loginType: authProvider.defaultLoginType.value,
            messageType: '',
          );

          await authProvider.sendOTP(
            type: AppStrings.otpTypeEmail,
            isResume: false,
            isResent: false,
            mobile: '',
            email: authProvider.emailController.text.trim(),
            loginType: authProvider.defaultLoginType.value,
            messageType: '',
          );

          if (context.mounted) {
            SelectRelationshipPopup.show(context);
          }
        } catch (e) {
          AppHelperWidgets.showSnackBar(
            title: AppStrings.error,
            message: AppStrings.failedToSendOTP,
            messageType: AppStrings.responseTypeError,
          );
        }
      },
      onSecondaryButtonTap: () {
        AppNavigator.pop();
      },
    );
  }

  Widget noReferralAddedWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: AppDimens.paddingMedium),
        const Text(AppStrings.sinceNoReferral),
      ],
    );
  }

  Widget othersUI(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppDimens.paddingMedium),
        Text(
          AppStrings.othersUI,
          style: AppTextStyles.poppinsMedium.copyWith(
            fontSize: AppFontSize.fontSize14,
            fontWeight: AppFontWeight.fontWeight600,
            color: AppColors.kWhiteColor,
          ),
        ),
      ],
    );
  }

  Widget backGroundImgWidget() {
    return Positioned.fill(
      child: Image.asset(
        AppImages.loginBgImg,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget customCheckBoxWidget(
    BuildContext context,
    String label,
    String value,
  ) {
    final authProvider = context.read<AuthProvider>();
    return GestureDetector(
      onTap: () {
        authProvider.selectedLoginType(value);
      },

      child: Consumer<AuthProvider>(
        builder: (_, authProvider, __) {
          final isSelected = authProvider.defaultLoginType.value == value;
          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 28.w,
                height: 23.h,
                decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  border: Border.all(color: AppColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),

                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12.h,
                          height: 14.w,
                          decoration: BoxDecoration(
                            color: AppColors.kBlueColor,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppDimens.paddingSmallToMedium),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.kWhiteColor,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SelectRelationshipPopup {
  static void show(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      headerImage: AppImages.sihlLogoImg,
      title: AppStrings.selectRelationship,
      bodyWidget: buildRelationshipBody(),
      primaryButtonText: AppStrings.next,
      secondaryButtonText: AppStrings.close,
      isSecondaryButtonGradient: true,
      onPrimaryButtonTap: () async {
        if (!authProvider.validateRelationships()) {
          return;
        }
        final bool isDataInserted = await authProvider.insertDataAPI();
        if (isDataInserted && context.mounted) {
          AppNavigator.popAndPush(AppRoutes.digioLoadingScreen);
        }
      },
      onSecondaryButtonTap: () {
        AppNavigator.pop();
      },
    );
  }

  static Widget buildRelationshipBody() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(
            left: AppDimens.paddingNormalToMedium,
            right: AppDimens.paddingNormalToMedium,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimens.paddingLarge),
              CustomRelationshipDropDownWidget(
                selectedId: authProvider.selectedEmailRelationshipId,
                selectedValue: authProvider.selectedEmailRelationship,
                hintText: AppStrings.emailBelongsTo,
                hasError: authProvider.emailRelationshipError,
                errorMessage: AppStrings.selectEmailBelongsTo,
                onChanged: (selectedId, selectedValue) {
                  authProvider.updateEmailRelationship(
                    selectedId,
                    selectedValue,
                  );
                },
              ),
              const SizedBox(height: AppDimens.paddingXXLarge),

              CustomRelationshipDropDownWidget(
                selectedId: authProvider.selectedMobileRelationshipId,
                selectedValue: authProvider.selectedMobileRelationship,
                hintText: AppStrings.mobileBelongsTo,
                hasError: authProvider.mobileRelationshipError,
                errorMessage: AppStrings.selectMobileBelongsTo,
                onChanged: (selectedId, selectedValue) {
                  authProvider.updateMobileRelationship(
                    selectedId,
                    selectedValue,
                  );
                },
              ),
              const SizedBox(height: AppDimens.paddingLarge),

              Text(
                AppStrings.emailOTP,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight600,
                  color: AppColors.kBlackColor,
                ),
              ),

              const SizedBox(height: AppDimens.paddingNormal),
              otpTextFieldWidget(context, AppStrings.otpTypeEmail),
              const SizedBox(height: AppDimens.paddingMedium),

              Text(
                AppStrings.mobileOTP,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight600,
                  color: AppColors.kBlackColor,
                ),
              ),

              const SizedBox(height: AppDimens.paddingNormal),
              otpTextFieldWidget(context, AppStrings.otpTypeMobile),
              const SizedBox(height: AppDimens.paddingXXLarge),
            ],
          ),
        );
      },
    );
  }

  static Widget otpTextFieldWidget(BuildContext context, String otpType) {
    final authProvider = context.read<AuthProvider>();
    final bool isEmail = otpType == AppStrings.otpTypeEmail;
    return CustomOtpTextFormFieldWidget(
      otpType: otpType,
      onOTPEntered: (otp) {},
      onResendTxtTap: () {
        if (isEmail) {
          authProvider.resendEmailOtp();
        } else {
          authProvider.resendMobileOtp();
        }
      },
      onVerifyOtp: (otp) async {
        if (isEmail) {
          return await authProvider.verifyEmailOtp(otp);
        } else {
          return await authProvider.verifyMobileOtp(otp);
        }
      },
    );
  }
}
