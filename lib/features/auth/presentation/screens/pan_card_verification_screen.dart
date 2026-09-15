import 'package:flutter/material.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

/*
Title:PanCardVerificationScreen
Purpose:PanCardVerificationScreen
Created On:
Edited On:
Author: 
*/

class PanCardVerificationScreen extends StatefulWidget {
  const PanCardVerificationScreen({super.key});

  @override
  State<PanCardVerificationScreen> createState() =>
      _PanCardVerificationScreenState();
}

class _PanCardVerificationScreenState extends State<PanCardVerificationScreen> {
  // void listenToKRAEvents() {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 10), () {
        if (mounted) {
          showPanVerificationPopup(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [backGroundImgWidget(), overlapWidget()],
        ),
      ),
    );
  }

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Future<void> showPanVerificationPopup(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final bool isDataAvailable = authProvider
        .populatePanDetailsFromDigiLocker();

    if (!isDataAvailable) {
      LogHelper.errorLog('Digio PAN data not available');
      return;
    }

    AlertBoxWithSingleCenterBtnWidget.show(
      context,
      title: AppStrings.panCardVerification,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: panBodyWidget(),
      primaryButtonText: AppStrings.confirmCap,
      onPrimaryButtonTap: () async {
        AppNavigator.pop();
        await authProvider.checkBanPanCardAPI();
      },
    );
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }

  Widget confirmationBodyWidget(String? message) {
    return Text(
      message ?? '',
      style: AppTextStyles.poppinsMedium.copyWith(
        fontSize: AppFontSize.fontSize14,
        fontWeight: AppFontWeight.fontWeight600,
        color: AppColors.kBlackColor,
      ),
    );
  }

  Widget panBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormFieldWidget(
              controller: authProvider.panNoController,
              inputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              onFieldSubmittedVal: (String value) {},
              isPhoneField: false,
              prefixImg: AppImages.contactMailImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.panCardNum,
              borderWidth: 2.5,
              validator: (value) {},
              isEditable: false,
            ),
            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.fNameAsPanController,
              inputAction: TextInputAction.done,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.personImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.fNameAsPan,
              borderWidth: 2.5,
              validator: (String? value) {},
              isEditable: authProvider.isNameEditable,
            ),
            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.mNameAsPanController,
              inputAction: TextInputAction.done,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.personImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.mNameAsPan,
              borderWidth: 2.5,
              validator: (String? value) {},
              isEditable: authProvider.isNameEditable,
            ),
            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.lNameAsPanController,
              inputAction: TextInputAction.done,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.personImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.lNameAsPan,
              borderWidth: 2.5,
              validator: (String? p1) {},
              isEditable: authProvider.isNameEditable,
            ),
            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.panDobController,
              inputAction: TextInputAction.done,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.calenderImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.dob,
              borderWidth: 2.5,
              validator: (String? p1) {},
              isEditable: authProvider.isDobEditable,
            ),
            const SizedBox(height: AppDimens.paddingMedium),
            Visibility(
              visible: authProvider.isPanVerificationInProgress,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  AppStrings.verifyingPan,
                  style: AppTextStyles.poppinsMedium.copyWith(
                    fontSize: AppFontSize.fontSize14,
                    fontWeight: AppFontWeight.fontWeight500,
                    color: AppColors.kPrimaryBlueColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimens.paddingMedium),
            const SizedBox(height: AppDimens.paddingMedium),
          ],
        );
      },
    );
  }
}
