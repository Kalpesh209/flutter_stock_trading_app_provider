import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';

class SquareTextButtonWidget extends StatelessWidget {
  final VoidCallback onButtonTap;
  final String btnTxt;
  final Color backgroundColor;
  final Color textColor;
  final double? width;

  const SquareTextButtonWidget({
    super.key,
    required this.onButtonTap,
    required this.btnTxt,
    required this.backgroundColor,
    required this.textColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.kGreyColor),
      ),

      child: TextButton(
        onPressed: onButtonTap,
        child: Text(
          btnTxt,
          style: AppTextStyles.poppinsMedium.copyWith(
            fontSize: AppFontSize.fontSize14,
            fontWeight: AppFontWeight.fontWeight600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
