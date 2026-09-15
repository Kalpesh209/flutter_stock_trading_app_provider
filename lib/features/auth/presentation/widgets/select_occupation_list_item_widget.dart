import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';

/*
Title:SelectOccupationListItemWidget
Purpose:SelectOccupationListItemWidget
Created On:
Edited On:
Author: 
*/

class SelectOccupationListItemWidget extends StatelessWidget {
  final String occupation;
  final bool isSelected;
  final VoidCallback onTap;
  const SelectOccupationListItemWidget({
    super.key,
    required this.occupation,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryBlueColor
              : AppColors.kWhiteColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.klightBlueText, width: 2.w),
        ),
        child: Text(
          occupation,
          textAlign: TextAlign.center,
          style: AppTextStyles.poppinsMedium.copyWith(
            fontSize: AppFontSize.fontSize16,
            fontWeight: AppFontWeight.fontWeight600,
            color: isSelected
                ? AppColors.kWhiteColor
                : AppColors.kPrimaryBlueColor,
          ),
        ),
      ),
    );
  }
}
