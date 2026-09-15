import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/otp_provider.dart';
import 'package:provider/provider.dart';

/*
Title:CustomOtpTextFormFieldWidget
Purpose: To verify OTP throguh App
Created On:
Edited On:
Author: 
*/

class CustomOtpTextFormFieldWidget extends StatefulWidget {
  final Function(String?)? onOTPEntered;
  final Function()? onResendTxtTap;
  final Future<bool> Function(String otp)? onVerifyOtp;
  final String otpType;

  const CustomOtpTextFormFieldWidget({
    super.key,
    required this.onOTPEntered,
    required this.onResendTxtTap,
    required this.otpType,
    this.onVerifyOtp,
  });

  @override
  State<CustomOtpTextFormFieldWidget> createState() =>
      _CustomOtpTextFormFieldWidgetState();
}

class _CustomOtpTextFormFieldWidgetState
    extends State<CustomOtpTextFormFieldWidget> {
  late OtpProvider provider;

  String get successMessage => widget.otpType == AppStrings.otpTypeEmail
      ? AppStrings.emailOtpVerifiedSuccess
      : AppStrings.mobileOtpVerifiedSuccess;

  @override
  void initState() {
    super.initState();
    provider = OtpProvider();
    provider.startTimer();
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<OtpProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  KeyboardListener(
                    focusNode: provider.keyboardFocusNode,
                    onKeyEvent: (event) {
                      _onKey(context, event, provider);
                    },

                    child: Row(
                      children: List.generate(provider.otpLength, (index) {
                        if (index == 2) {
                          return Row(
                            children: [
                              buildOtpBox(provider, index),
                              const SizedBox(
                                width: AppDimens.paddingSmallToMedium,
                              ),
                            ],
                          );
                        }

                        return buildOtpBox(provider, index);
                      }),
                    ),
                  ),

                  if (provider.isLoading)
                    Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.kPrimaryBlueColor,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 6.h),

              if (provider.isSuccess)
                _buildStatusMessage(
                  message: successMessage,
                  color: Colors.green.shade700,
                  icon: Icons.check_box,
                ),

              if (provider.isFailure)
                _buildStatusMessage(
                  message: AppStrings.otpVerificationFailed,
                  color: AppColors.kRedColor,
                  icon: Icons.close,
                ),

              SizedBox(height: 4.h),
              provider.isSuccess
                  ? const SizedBox.shrink()
                  : provider.canResend
                  ? GestureDetector(
                      onTap: () {
                        provider.startTimer();
                        provider.resetFields(context);
                        widget.onResendTxtTap?.call();
                      },

                      child: Text(
                        AppStrings.resend,
                        style: AppTextStyles.poppinsRegular.copyWith(
                          fontSize: AppFontSize.fontSize12,
                          fontWeight: AppFontWeight.fontWeight400,
                          color: AppColors.kPrimaryBlueColor,
                        ),
                      ),
                    )
                  : Text(
                      '${AppStrings.resendOTPIn} 00:${provider.secondsRemaining.toString().padLeft(2, '0')}',

                      style: AppTextStyles.poppinsRegular.copyWith(
                        fontSize: AppFontSize.fontSize12,
                        fontWeight: AppFontWeight.fontWeight400,
                        color: AppColors.kBlackColor,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget buildOtpBox(OtpProvider provider, int index) {
    final fillColor = provider.isSuccess
        ? Colors.green.shade50
        : AppColors.kWhiteColor;

    final enabledBorderColor = provider.isSuccess
        ? Colors.green
        : provider.isFailure
        ? AppColors.kRedColor
        : AppColors.kBlackColor;

    final textColor = provider.isSuccess
        ? Colors.green.shade700
        : AppColors.kBlackColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Container(
        height: 50.h,
        width: 45.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: fillColor,
        ),
        child: TextFormField(
          cursorHeight: AppDimens.paddingLarge,
          controller: provider.controllersList[index],
          focusNode: provider.focusNodesList[index],
          maxLength: 1,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          enabled: !provider.isSuccess && !provider.isLoading,
          style: AppTextStyles.poppinsMedium.copyWith(
            fontSize: AppFontSize.fontSize20,
            fontWeight: AppFontWeight.fontWeight600,
            color: textColor,
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            counter: const Offstage(),
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: enabledBorderColor, width: 2.w),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: provider.isFailure
                    ? AppColors.kRedColor
                    : AppColors.kPrimaryBlueColor,
                width: 2.w,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.kRedColor, width: 2.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.kRedColor, width: 2.w),
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: provider.isSuccess
                    ? AppColors.kPrimaryGreenColor
                    : AppColors.kGreyColor,
                width: 2.w,
              ),
            ),
          ),

          onChanged: (value) {
            _onTextChanged(value, index);
          },
        ),
      ),
    );
  }

  Future<void> _onTextChanged(String value, int index) async {
    if (value.isNotEmpty && index < provider.otpLength - 1) {
      FocusScope.of(context).requestFocus(provider.focusNodesList[index + 1]);
    }
    widget.onOTPEntered?.call(provider.currentOtp);
    provider.clearStatus();
    if (provider.currentOtp.length == provider.otpLength) {
      FocusScope.of(context).unfocus();
      await provider.verifyOtp(onVerifyOtp: widget.onVerifyOtp);
    }
  }

  void _onKey(BuildContext context, KeyEvent event, OtpProvider provider) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      for (int i = 1; i < provider.otpLength; i++) {
        if (provider.controllersList[i].text.isEmpty &&
            provider.focusNodesList[i].hasFocus) {
          FocusScope.of(context).requestFocus(provider.focusNodesList[i - 1]);
          return;
        }
      }
    }
  }

  Widget _buildStatusMessage({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        const SizedBox(width: AppDimens.paddingSmall),

        Text(
          message,
          style: AppTextStyles.poppinsRegular.copyWith(
            fontSize: AppFontSize.fontSize14,
            fontWeight: AppFontWeight.fontWeight500,
            color: color,
          ),
        ),
        Icon(icon, color: color, size: 20.sp),
      ],
    );
  }
}
