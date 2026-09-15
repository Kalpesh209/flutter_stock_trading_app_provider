import 'package:flutter/material.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

/*
Title:PresentAddressInfoScreen
Purpose:PresentAddressInfoScreen
Created On:
Edited On:
Author: 
*/

class PresentAddressInfoScreen extends StatefulWidget {
  const PresentAddressInfoScreen({super.key});

  @override
  State<PresentAddressInfoScreen> createState() =>
      _PresentAddressInfoScreenState();
}

class _PresentAddressInfoScreenState extends State<PresentAddressInfoScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showPresentAddInfoPopup();
    });
  }

  Future<void> showPresentAddInfoPopup() async {
    final authProvider = context.read<AuthProvider>();
    final bool isDataAvailable = authProvider
        .populateAddressDetailsFromDigiLocker();

    if (!isDataAvailable) {
      LogHelper.errorLog('Digio PAN data not available');
      return;
    }

    AlertBoxWithSingleCenterBtnWidget.show(
      context,
      title: AppStrings.presentAddressInfo,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: presentAddressBodyWidget(),
      primaryButtonText: AppStrings.confirmCap,
      onPrimaryButtonTap: () async {
        await authProvider.insertAddressInfoAPI();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

  Widget presentAddressBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          children: [
            TextFormFieldWidget(
              controller: authProvider.addressLine1Controller,
              inputAction: TextInputAction.next,
              textInputType: TextInputType.text,
              onFieldSubmittedVal: (String value) {},
              isPhoneField: false,
              prefixImg: AppImages.homeImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.addressLine1,
              borderWidth: 2.5,
              validator: (value) {},
              isEditable: authProvider.isAddressEditable,
            ),
            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.addressLine2Controller,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.homePinImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.addressLine2,
              borderWidth: 2.5,
              validator: (String? value) {},
              isEditable: authProvider.isAddressEditable,
            ),
            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.addressLine3Controller,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.homePinImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.addressLine3,
              borderWidth: 2.5,
              validator: (String? value) {},
              isEditable: authProvider.isAddressEditable,
            ),

            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.cityController,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.cityImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.city,
              borderWidth: 2.5,
              validator: (String? p1) {},
              isEditable: authProvider.isCityEditable,
            ),

            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.stateController,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.mapImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.state,
              borderWidth: 2.5,
              validator: (String? p1) {},
              isEditable: authProvider.isStateEditable,
            ),

            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.pinCodeController,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.pinDropImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.pincode,
              borderWidth: 2.5,
              validator: (String? p1) {},
              isEditable: authProvider.isPincodeEditable,
            ),

            const SizedBox(height: AppDimens.paddingMedium),
            TextFormFieldWidget(
              controller: authProvider.countryController,
              inputAction: TextInputAction.done,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.countryImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.country,
              borderWidth: 2.5,
              validator: (String? p1) {},
              isEditable: authProvider.isDobEditable,
            ),

            const SizedBox(height: AppDimens.paddingMedium),
          ],
        );
      },
    );
  }
}
