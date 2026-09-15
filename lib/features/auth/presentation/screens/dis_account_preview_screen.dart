import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
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
import 'package:provider/provider.dart';

/*
Title:DisAccountPreviewScreen
Purpose:To show Preview of Account info
Created On:
Edited On:
Author: 
*/

class DISAccountPreviewScreen extends StatefulWidget {
  const DISAccountPreviewScreen({super.key});

  @override
  State<DISAccountPreviewScreen> createState() =>
      _DisAccountPreviewScreenState();
}

class _DisAccountPreviewScreenState extends State<DISAccountPreviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      await showDISAccountPreviewPopup();
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

  Future<void> showDISAccountPreviewPopup() async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.disIntimation,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: showDISAccountPreviewBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.disAccountInfoPreviewNotifier,
      onPrimaryButtonTap: () async {},
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        AppNavigator.popAndPush(AppRoutes.nomineeDetailScreen);
      },
    );
  }

  Widget showDISAccountPreviewBodyWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.paddingMedium),
          Row(
            children: [
              GestureDetector(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2),
                  width: 18.h,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: AppColors.kBlueColor,
                    border: Border.all(color: AppColors.kBlueColor, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.kWhiteColor,
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(width: AppDimens.paddingNormal),

              Expanded(
                child: Text(
                  AppStrings.ddpiFlag,
                  style: AppTextStyles.poppinsMedium.copyWith(
                    fontSize: AppFontSize.fontSize12,
                    color: AppColors.kBlackColor,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.paddingNormal),
            ],
          ),
          const SizedBox(height: AppDimens.paddingMedium),
          Text(
            AppStrings.selectDeliveryOptionDIS,
            style: AppTextStyles.poppinsMedium.copyWith(
              fontSize: AppFontSize.fontSize14,
              fontWeight: AppFontWeight.fontWeight600,
              color: AppColors.k198754,
            ),
          ),
        ],
      ),
    );
    // Consumer<AuthProvider>(
    //   builder: (context, authProvider, child) {

    //   },
    // );
  }

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }
}
