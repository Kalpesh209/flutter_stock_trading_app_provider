import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/models/static_data_model.dart';
import 'package:provider/provider.dart';

class CustomRelationshipDropDownWidget extends StatelessWidget {
  final int selectedId;
  final FluffyRecordset? selectedValue;
  final String hintText;
  final bool hasError;
  final String? errorMessage;

  final Function(int selectedId, FluffyRecordset? selectedValue) onChanged;

  const CustomRelationshipDropDownWidget({
    super.key,
    required this.selectedId,
    required this.selectedValue,
    required this.hintText,
    required this.hasError,
    required this.onChanged,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final list = authProvider.emailMobileRelationshipsList.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            authProvider.isStaticDataLoading
                ? Center(
                    child: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.kPrimaryBlueColor,
                      ),
                    ),
                  )
                : DropdownButtonFormField<int>(
                    value: selectedId == -1 ? null : selectedId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: hintText,
                      filled: true,
                      fillColor: AppColors.kWhiteColor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: AppColors.kBlackColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: hasError
                              ? AppColors.kRedColor
                              : AppColors.kBlackColor,
                          width: hasError ? 2.w : 1.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColors.kPrimaryBlueColor,
                          width: 1.5.w,
                        ),
                      ),
                      errorText: hasError ? errorMessage : null,
                    ),
                    onChanged: (int? newId) {
                      if (newId == null) {
                        return;
                      }

                      final selectedItem = list.firstWhere(
                        (item) =>
                            authProvider.getRelationshipId(item.id) == newId,
                      );

                      onChanged(newId, selectedItem);
                    },
                    items: list.map((FluffyRecordset relationship) {
                      return DropdownMenuItem<int>(
                        value: authProvider.getRelationshipId(relationship.id),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            relationship.name ?? '',
                            style: AppTextStyles.poppinsRegular.copyWith(
                              fontSize: AppFontSize.fontSize14,
                              fontWeight: AppFontWeight.fontWeight400,
                              color: AppColors.kBlackColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        );
      },
    );
  }
}
