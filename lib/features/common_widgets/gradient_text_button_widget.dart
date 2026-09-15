import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';

/*
Title:GradientTextButtonWidget
Purpose:To Display a Gradient Text Button
Created On:
Edited On:
Author: 
*/

class GradientTextButtonWidget extends StatelessWidget {
  final VoidCallback? onButtonTap;
  final String btnTxt;
  final double? width;
  final bool isEnabled;
  final String? prefixImage;

  const GradientTextButtonWidget({
    super.key,
    required this.onButtonTap,
    required this.btnTxt,
    this.width,
    this.isEnabled = true,
    this.prefixImage,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          gradient: LinearGradient(
            colors: const [
              AppColors.kPrimaryBlueColor,
              AppColors.kPrimaryGreenColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TextButton(
          onPressed: isEnabled ? onButtonTap : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixImage != null) ...[
                Image.asset(
                  prefixImage!,
                  width: 18.w,
                  height: 18.h,
                  fit: BoxFit.contain,
                  color: AppColors.kWhiteColor,
                ),
                SizedBox(width: 6.w),
              ],

              Flexible(
                child: Text(
                  btnTxt,
                  style: AppTextStyles.poppinsMedium.copyWith(
                    fontSize: AppFontSize.fontSize15,
                    fontWeight: AppFontWeight.fontWeight600,
                    color: AppColors.kWhiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
