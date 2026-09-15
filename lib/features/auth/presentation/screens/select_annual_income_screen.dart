import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_constants.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/select_occupation_list_item_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/global_state_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

import 'package:go_router/go_router.dart';

/*
Title:SelectAnnualIncomeScreen
Purpose:SelectAnnualIncomeScreen
Created On:
Edited On:
Author: 
*/

class SelectAnnualIncomeScreen extends StatefulWidget {
  const SelectAnnualIncomeScreen({super.key});

  @override
  State<SelectAnnualIncomeScreen> createState() =>
      _SelectOccupationScreenState();
}

class _SelectOccupationScreenState extends State<SelectAnnualIncomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreAdditionalDetails(globalStateProvider);
      showSelectAnnualIncomePopup();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> showSelectAnnualIncomePopup() async {
    final authProvider = context.read<AuthProvider>();
    final globalStateProvider = context.read<GlobalStateProvider>();

    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.selectAnnualIncome,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: selectAnnualIncomeBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isAnnualRangeSelectedNotifier,
      onPrimaryButtonTap: () async {
        AppNavigator.pop();
        String? gstNumber;

        if (authProvider.isGstRegistered) {
          gstNumber = authProvider.gstNumberController.text.trim();
          if (gstNumber.isEmpty) {
            AppHelperWidgets.showSnackBar(
              title: AppStrings.error,
              message: AppStrings.enterGSTNumber,
              messageType: AppStrings.responseTypeError,
            );
            return;
          }
          LogHelper.infoLog('GST Number: $gstNumber');
        }
        authProvider.updateAdditionalDetailsState();
        AppNavigator.push(AppRoutes.selectBirthCityScreen);
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.popAndPush(AppRoutes.selectOccupationScreen);
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

  Widget selectAnnualIncomeBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: authProvider.incomeRangeList.length,
              itemBuilder: (context, index) {
                final incomeRange = authProvider.incomeRangeList[index];
                return Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 8.h),
                  child: SelectOccupationListItemWidget(
                    occupation: incomeRange.name ?? '',
                    isSelected:
                        authProvider.selectedIncomeRange?.id == incomeRange.id,
                    onTap: () {
                      authProvider.selectIncomeRange(incomeRange);
                    },
                  ),
                );
              },
            ),

            const SizedBox(width: AppDimens.paddingMedium),

            Padding(
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
                top: AppDimens.paddingMedium,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: authProvider.updateGSTStatus,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      width: 20.h,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: authProvider.isGstRegistered
                            ? AppColors.kBlueColor
                            : AppColors.kTransparentColor,
                        border: Border.all(
                          color: AppColors.kBlueColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: authProvider.isGstRegistered
                          ? const Icon(
                              Icons.check,
                              color: AppColors.kWhiteColor,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: AppDimens.paddingNormal),
                  Text(
                    AppStrings.iHaveGSTNumber,
                    style: AppTextStyles.poppinsRegular.copyWith(
                      fontSize: AppFontSize.fontSize14,
                      color: AppColors.kBlackColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppDimens.paddingNormal),
            if (authProvider.isGstRegistered)
              Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: TextFormFieldWidget(
                  controller: authProvider.gstNumberController,
                  inputAction: TextInputAction.next,
                  onFieldSubmittedVal: (String value) {},
                  prefixImg: AppImages.billImg,
                  prefixImgColor: AppColors.klightBlueText,
                  onChanged: (value) {},
                  hint: AppStrings.gstNo,
                  borderWidth: 2.5,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.pleaseEnterGSTNumber;
                    }
                    final gst = value.trim().toUpperCase();
                    if (gst.length != 15) {
                      return AppStrings.gstNoMust;
                    }
                    if (!AppConstants.gstRegex.hasMatch(gst)) {
                      return AppStrings.enterValidGSTNumber;
                    }
                    return null;
                  },
                  isEditable: true,
                ),
              ),
          ],
        );
      },
    );
  }
}
