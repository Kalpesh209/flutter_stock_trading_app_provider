import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/global_state_provider.dart';

/*
Title:SelectPEPScreen
Purpose:SelectPEPScreen
Created On:
Edited On:
Author: 
*/

class SelectPEPScreen extends StatefulWidget {
  const SelectPEPScreen({super.key});

  @override
  State<SelectPEPScreen> createState() => _SelectPEPScreenState();
}

class _SelectPEPScreenState extends State<SelectPEPScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreAdditionalDetails(globalStateProvider);
      showSelectPEPPopup();
    });
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

  Future<void> showSelectPEPPopup() async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.selectPEP,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: selectPEPBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isPEPSelectedNotifier,
      onPrimaryButtonTap: () async {
        try {
          authProvider.updateAdditionalDetailsState();
          AppNavigator.push(AppRoutes.selectMarketSegmentScreen);
        } catch (e, s) {
          LogHelper.errorLog('ERROR: $e');
          LogHelper.errorLog(s.toString());
        }
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.popAndPush(AppRoutes.selectMaritalStatusScreen);
      },
    );
  }

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }

  Widget selectPEPBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customCheckBoxWidget(
                    context,
                    AppStrings.yes,
                    '1',
                    isPep: true,
                  ),
                  SizedBox(width: 35.w),
                  customCheckBoxWidget(
                    context,
                    AppStrings.no,
                    '0',
                    isPep: true,
                  ),
                ],
              ),

              SizedBox(height: AppDimens.paddingMedium),

              Text(
                AppStrings.selectSettlementCycle,
                textAlign: TextAlign.center,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize18,
                  fontWeight: AppFontWeight.fontWeight700,
                  color: AppColors.kPrimaryBlueColor,
                ),
              ),
              SizedBox(height: AppDimens.paddingMedium),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: authProvider.settlementCycleList.map((settlement) {
                  return customCheckBoxWidget(
                    context,
                    settlement.name ?? '',
                    settlement.id.toString(),
                    isPep: false,
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget customCheckBoxWidget(
    BuildContext context,
    String label,
    String value, {
    required bool isPep,
  }) {
    final authProvider = context.read<AuthProvider>();
    return GestureDetector(
      onTap: () {
        if (isPep) {
          authProvider.selectPEP(value);
        } else {
          authProvider.selectSettlementCycle(value);
        }
      },
      child: Consumer<AuthProvider>(
        builder: (_, authProvider, __) {
          final isSelected = isPep
              ? authProvider.selectedPEPNotifier.value == value
              : authProvider.selectedSettlementCycleNotifier.value == value;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 27.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: AppColors.kWhiteColor,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: AppColors.kBlueColor, width: 2),
                  ),

                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 13.w,
                            height: 13.h,
                            decoration: BoxDecoration(
                              color: AppColors.kBlueColor,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                        )
                      : null,
                ),

                SizedBox(width: 10.w),

                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.poppinsMedium.copyWith(
                    color: AppColors.kBlackColor,
                    fontSize: 16.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
