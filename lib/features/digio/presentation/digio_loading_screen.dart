import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/features/digio/provider/digio_provider.dart';
import 'package:provider/provider.dart';

/*
Title:DigioLoaderWidget
Purpose:DigioLoaderWidget
Created On:
Edited On:
Author: 
*/

class DigioLoadingScreen extends StatefulWidget {
  const DigioLoadingScreen({super.key});

  @override
  State<DigioLoadingScreen> createState() => _DigioLoadingScreenState();
}

class _DigioLoadingScreenState extends State<DigioLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(children: [backGroundImgWidget(), overlapWidget()]),
      ),
    );
  }

  Widget backGroundImgWidget() {
    return Positioned.fill(
      child: Image.asset(
        AppImages.loginBgImg,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget overlapWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Consumer<DigioProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildBoxWidget(title: AppStrings.digio),
                      const SizedBox(width: AppDimens.paddingMedium),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Row(
                            children: List.generate(4, (index) {
                              final animationValue =
                                  (_controller.value - (index * 0.15)).clamp(
                                    0.0,
                                    1.0,
                                  );

                              final opacity = animationValue > 0
                                  ? animationValue
                                  : 0.2;
                              final scale = 0.7 + (animationValue * 0.5);
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 8,
                                height: 8,
                                transform: Matrix4.identity()..scale(scale),
                                decoration: BoxDecoration(
                                  color: AppColors.digioLoaderColor.withValues(
                                    alpha: opacity,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.digioLoaderColor
                                          .withValues(alpha: opacity),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),

                      const SizedBox(width: AppDimens.paddingMedium),
                      buildBoxWidget(title: AppStrings.server),
                    ],
                  ),

                  const SizedBox(height: AppDimens.paddingBitExtraLarge),
                  Container(
                    width: 230.w,
                    height: 40.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.kBlackColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kBlackColor.withValues(alpha: .25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },

                      child: Text(
                        provider.loadingMessages[provider.currentMessageIndex],
                        key: ValueKey(
                          provider.loadingMessages[provider
                              .currentMessageIndex],
                        ),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.poppinsMedium.copyWith(
                          fontSize: AppFontSize.fontSize12,
                          fontWeight: AppFontWeight.fontWeight600,
                          color: AppColors.digioLoaderColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildBoxWidget({required String title}) {
    return Container(
      width: 80.w,
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.digioLoaderColor, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.digioLoaderColor.withValues(alpha: .5),
            blurRadius: 10,
          ),
        ],
      ),

      child: Text(
        title,
        style: AppTextStyles.poppinsMedium.copyWith(
          fontSize: AppFontSize.fontSize14,
          fontWeight: AppFontWeight.fontWeight600,
          color: AppColors.digioLoaderColor,
        ),
      ),
    );
  }
}
