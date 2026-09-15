import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/features/models/segment_data_model.dart';

class MarketSegmentListItemWidget extends StatelessWidget {
  final SegmentDataModel segmentDataModel;
  final String description;
  final ValueChanged<bool?> onChanged;

  const MarketSegmentListItemWidget({
    super.key,
    required this.segmentDataModel,
    required this.description,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = segmentDataModel.disabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isLocked ? null : () => onChanged(!segmentDataModel.selected),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                width: 22.h,
                height: 22.h,
                decoration: BoxDecoration(
                  color: segmentDataModel.selected
                      ? AppColors.kBlueColor
                      : AppColors.kTransparentColor,
                  border: Border.all(color: AppColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: segmentDataModel.selected
                    ? const Icon(
                        Icons.check,
                        color: AppColors.kWhiteColor,
                        size: 18,
                      )
                    : null,
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Text(
                  segmentDataModel.header,
                  style: AppTextStyles.poppinsMedium.copyWith(
                    fontSize: AppFontSize.fontSize15,
                    fontWeight: FontWeight.w600,
                    color: isLocked
                        ? AppColors.kGreyColor
                        : AppColors.kBlackColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (description.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 38.w, top: 6.h),
            child: Text(
              description,
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize13,
                color: isLocked ? AppColors.kGreyColor : AppColors.kBlackColor,
              ),
            ),
          ),
      ],
    );
  }
}
