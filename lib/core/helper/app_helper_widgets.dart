import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/gradient_text_button_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/square_text_button_widget.dart';
import 'package:intl/intl.dart';
// import 'package:shahinvestor/core/appUtils/app_colors.dart';
// import 'package:shahinvestor/core/appUtils/app_dimens.dart';
// import 'package:shahinvestor/core/appUtils/app_font_size.dart';
// import 'package:shahinvestor/core/appUtils/app_font_weight.dart';
// import 'package:shahinvestor/core/appUtils/app_images.dart';
// import 'package:shahinvestor/core/appUtils/app_navigator.dart';
// import 'package:shahinvestor/core/appUtils/app_strings.dart';
// import 'package:shahinvestor/core/appUtils/app_text_style.dart';
// import 'package:shahinvestor/core/helper/log_helper.dart';
// import 'package:shahinvestor/features/common_widgets/gradient_text_button_widget.dart';
import 'package:go_router/go_router.dart';
// import 'package:shahinvestor/features/common_widgets/square_text_button_widget.dart';
import 'package:path/path.dart' as path;

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

class AppHelperWidgets {
  static BuildContext? get context => AppNavigator.navigatorKey.currentContext;
  static bool isLoaderVisible = false;
  static bool isIncomeProofLoaderVisible = false;
  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Future<void> precacheAssets(BuildContext context) async {
    await precacheImage(const AssetImage(AppImages.loaderDataImg), context);
  }

  static void showLoader() {
    if (isLoaderVisible) return;
    final context = AppNavigator.navigatorKey.currentContext;
    if (context == null) return;
    isLoaderVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.kTransparentColor,
      useSafeArea: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: AppColors.kTransparentColor,
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            child: Center(
              child: Image.asset(
                AppImages.loaderDataImg,
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    ).then((_) {
      isLoaderVisible = false;
    });
  }

  static void hideLoader() {
    if (!isLoaderVisible) return;
    final context = AppNavigator.navigatorKey.currentContext;
    if (context == null) return;
    Navigator.of(context, rootNavigator: true).pop();
    isLoaderVisible = false;
  }

  //showIncomeProofLoader
  static void showIncomeProofLoader() {
    if (isIncomeProofLoaderVisible) return;
    final context = AppNavigator.navigatorKey.currentContext;
    if (context == null) return;
    isIncomeProofLoaderVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.kTransparentColor,
      useSafeArea: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: AppColors.kTransparentColor,
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            child: Center(
              child: Image.asset(
                AppImages.processIncomeProofgif,
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    ).then((_) {
      isIncomeProofLoaderVisible = false;
    });
  }

  //hideIncomeProofLoader
  static void hideIncomeProofLoader() {
    if (!isIncomeProofLoaderVisible) return;
    final context = AppNavigator.navigatorKey.currentContext;
    if (context == null) return;
    Navigator.of(context, rootNavigator: true).pop();
    isIncomeProofLoaderVisible = false;
  }

  static void showSnackBar({
    required String title,
    required String message,
    String messageType = 'success',
    Duration duration = const Duration(seconds: 2),
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = AppNavigator.navigatorKey.currentState?.overlay;
      if (overlay == null) return;
      late OverlayEntry entry;
      entry = OverlayEntry(
        builder: (context) {
          return Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 12,
            right: 12,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: messageType == 'success'
                      ? AppColors.kPrimaryGreenColor
                      : messageType == 'warning'
                      ? AppColors.warningColor
                      : AppColors.kRedColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.poppinsMedium.copyWith(
                        fontSize: AppFontSize.fontSize14,
                        color: messageType == 'warning'
                            ? AppColors.kBlackColor
                            : AppColors.kWhiteColor,
                      ),
                    ),
                    Text(
                      message,
                      style: AppTextStyles.poppinsMedium.copyWith(
                        fontSize: AppFontSize.fontSize14,
                        color: messageType == 'warning'
                            ? AppColors.kBlackColor
                            : AppColors.kWhiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
      overlay.insert(entry);
      Future.delayed(duration, () {
        entry.remove();
      });
    });
  }

  // To create a preview URL
  String createPreviewUrl({required File file, required String base64}) {
    final extension = path.extension(file.path).toLowerCase();
    final mimeType = extension == '.png' ? 'image/png' : 'image/jpeg';
    return 'data:$mimeType;base64,$base64';
  }

  // Format Date to yyyy-MM-dd
  static String formatToYYYYMMDD(String? date) {
    if (date == null || date.trim().isEmpty) {
      return '';
    }

    final value = date.trim();
    final formats = ['yyyy-MM-dd', 'dd/MM/yyyy', 'dd-MM-yyyy'];
    for (final format in formats) {
      try {
        final parsedDate = DateFormat(format).parseStrict(value);
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (_) {
        // Try next format
      }
    }

    LogHelper.errorLog('formatToYYYYMMDD: Unsupported date format: $date');
    return date;
  }

  // Format to formatToDD-MM-YYYY
  static String formatToDDMMYYYY(String? date) {
    if (date == null || date.trim().isEmpty) {
      return '';
    }

    final value = date.trim();
    // Already DD-MM-YYYY
    if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(value)) {
      try {
        final parsedDate = DateFormat('dd-MM-yyyy', 'en_US').parseStrict(value);
        return DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        LogHelper.errorLog('Invalid DD-MM-YYYY date: $value | $e');
        return value;
      }
    }

    // DD/MM/YYYY
    if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
      try {
        final parsedDate = DateFormat('dd/MM/yyyy', 'en_US').parseStrict(value);
        return DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        LogHelper.errorLog('Invalid DD/MM/YYYY date: $value | $e');
        return value;
      }
    }

    // YYYY-MM-DD
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      try {
        final parsedDate = DateFormat('yyyy-MM-dd', 'en_US').parseStrict(value);
        return DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        LogHelper.errorLog('Invalid YYYY-MM-DD date: $value | $e');
        return value;
      }
    }

    LogHelper.errorLog('formatToDDMMYYYY: Unsupported date format: $value');
    return value;
  }

  static bool isUserMinor(String? dob) {
    if (dob == null || dob.isEmpty) {
      return false;
    }

    try {
      final parts = dob.split('-');
      if (parts.length != 3) {
        return false;
      }
      final birthDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
      final today = DateTime.now();
      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age < 18;
    } catch (e) {
      LogHelper.errorLog('isMinor Exception: $e');

      return false;
    }
  }

  // Format to DD/MM/YYYY
  static String formatToDDSlashMMSlashYYYY(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    try {
      return date.replaceAll('-', '/');
    } catch (e) {
      LogHelper.errorLog('formatToDDSlashMMSlashYYYY Exception: $e');

      return date;
    }
  }
}

class CustomDatePickerWidget extends StatefulWidget {
  final String hintText;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? prefixImg;
  final Color? prefixImgColor;
  final double? width;
  final double height;
  final bool enabled;
  final Color borderColor;
  final Color backgroundColor;
  final bool hasError;
  final String? errorMessage;
  final bool isRequired;
  final bool isTouched;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateFormat;

  const CustomDatePickerWidget({
    super.key,
    required this.hintText,
    required this.value,
    required this.onChanged,
    this.prefixImg,
    this.prefixImgColor,
    this.width,
    this.height = 45,
    this.enabled = true,
    this.borderColor = AppColors.klightBlueText,
    this.backgroundColor = AppColors.kWhiteColor,
    this.hasError = false,
    this.errorMessage,
    this.isRequired = true,
    this.isTouched = false,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'dd/MM/yyyy',
  });

  static Future<DateTime?> showCustomDatePicker({
    required BuildContext context,
    required String hintText,
    DateTime? value,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final now = DateTime.now();
    final resolvedFirstDate = firstDate ?? DateTime(1900, 1, 1);
    final resolvedLastDate = lastDate ?? DateTime(now.year, now.month, now.day);
    DateTime initialDate = value ?? resolvedLastDate;
    if (initialDate.isBefore(resolvedFirstDate)) {
      initialDate = resolvedFirstDate;
    }

    if (initialDate.isAfter(resolvedLastDate)) {
      initialDate = resolvedLastDate;
    }

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: resolvedFirstDate,
      lastDate: resolvedLastDate,
      helpText: hintText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    switch (widget.dateFormat) {
      case 'dd/MM/yyyy':
        return '$day/$month/$year';

      case 'dd-MM-yyyy':
        return '$day-$month-$year';

      case 'yyyy-MM-dd':
        return '$year-$month-$day';

      case 'dd MMM yyyy':
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];

        return '$day ${months[date.month - 1]} $year';

      default:
        return '$day/$month/$year';
    }
  }

  Future<void> openDatePicker() async {
    if (!widget.enabled) {
      return;
    }

    final selectedDate = await CustomDatePickerWidget.showCustomDatePicker(
      context: context,
      hintText: widget.hintText,
      value: widget.value,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (selectedDate != null) {
      widget.onChanged(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValidationError =
        widget.hasError &&
        widget.errorMessage != null &&
        widget.errorMessage!.trim().isNotEmpty;

    final hasValue = widget.value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: widget.enabled ? openDatePicker : null,
              child: Container(
                width: widget.width,
                height: widget.height.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: hasValidationError
                        ? AppColors.kRedColor
                        : widget.borderColor,
                    width: 1.2.w,
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.prefixImg != null) ...[
                      Image.asset(
                        widget.prefixImg!,
                        height: 18.h,
                        width: 18.h,
                        color: widget.prefixImgColor,
                      ),
                      SizedBox(width: 8.w),
                      CustomVerticalDivider(
                        height: 12.h,
                        color: AppColors.kBlueColor,
                      ),
                      SizedBox(width: 8.w),
                    ],

                    Expanded(
                      child: Text(
                        hasValue ? _formatDate(widget.value!) : widget.hintText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.poppinsMedium.copyWith(
                          fontSize: AppFontSize.fontSize14,
                          fontWeight: AppFontWeight.fontWeight600,
                          color: hasValue
                              ? AppColors.kBlackColor
                              : AppColors.kGreyColor,
                        ),
                      ),
                    ),

                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18.sp,
                      color: widget.enabled
                          ? AppColors.kBlackColor
                          : AppColors.kGreyColor,
                    ),
                  ],
                ),
              ),
            ),

            // Floating label
            if (hasValue)
              Positioned(
                top: -15.h,
                left: 50.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.kWhiteColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    widget.hintText,
                    style: AppTextStyles.poppinsMedium.copyWith(
                      fontSize: AppFontSize.fontSize11,
                      color: hasValidationError
                          ? AppColors.kRedColor
                          : AppColors.kPrimaryBlueColor,
                    ),
                  ),
                ),
              ),
          ],
        ),

        if (hasValidationError)
          Padding(
            padding: EdgeInsets.only(top: 3.h, left: 4.w),
            child: Text(
              widget.errorMessage!,
              style: AppTextStyles.poppinsRegular.copyWith(
                fontSize: AppFontSize.fontSize11,
                color: AppColors.kRedColor,
                height: 1,
              ),
            ),
          ),
      ],
    );
  }
}

class TermsSection {
  final String? heading;
  final String content;
  final bool isBullet;

  const TermsSection({
    this.heading,
    required this.content,
    this.isBullet = false,
  });
}

// AlertBoxWithSingleCenterBtnWidget
class AlertBoxWithSingleCenterBtnWidget extends StatefulWidget {
  final String title;
  final Widget bodyWidget;
  final String primaryButtonText;
  final String secondaryButtonText;
  final Color primaryColor;
  final double borderRadius;
  final VoidCallback? onPrimaryButtonTap;
  final VoidCallback? onSecondaryButtonTap;
  final String? headerImage;
  final double headerImageSize;

  const AlertBoxWithSingleCenterBtnWidget({
    super.key,
    this.title = 'Terms & Conditions',
    required this.bodyWidget,
    this.primaryButtonText = AppStrings.confirm,
    this.secondaryButtonText = AppStrings.close,
    this.primaryColor = const Color(0xFF1A3A6B),
    this.borderRadius = 28,
    this.onPrimaryButtonTap,
    this.onSecondaryButtonTap,
    this.headerImage,
    this.headerImageSize = 80,
  });

  static void show(
    BuildContext context, {
    String title = 'Terms & Conditions',
    required Widget bodyWidget,
    String primaryButtonText = AppStrings.confirm,
    Color primaryColor = const Color(0xFF1A3A6B),
    double borderRadius = 28,
    VoidCallback? onPrimaryButtonTap,
    VoidCallback? onSecondaryButtonTap,
    String? headerImage,
    double headerImageSize = 80,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: MediaQuery.removeViewInsets(
          context: dialogContext,
          removeBottom: true,
          child: AlertBoxWithSingleCenterBtnWidget(
            title: title,
            bodyWidget: bodyWidget,
            primaryButtonText: primaryButtonText,
            primaryColor: primaryColor,
            borderRadius: borderRadius,
            onPrimaryButtonTap: onPrimaryButtonTap,
            onSecondaryButtonTap: onSecondaryButtonTap,
            headerImage: headerImage,
          ),
        ),
      ),
    );
  }

  @override
  State<AlertBoxWithSingleCenterBtnWidget> createState() =>
      _AlertBoxWithSingleCenterBtnState();
}

class _AlertBoxWithSingleCenterBtnState
    extends State<AlertBoxWithSingleCenterBtnWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: AppColors.kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 24, 25, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.headerImage != null) ...[
              Image.asset(widget.headerImage!),
              const SizedBox(height: AppDimens.paddingMedium),
            ],

            Text(
              widget.title,
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize18,
                fontWeight: AppFontWeight.fontWeight700,
                color: AppColors.kPrimaryBlueColor,
              ),
            ),

            SizedBox(height: AppDimens.paddingNormal),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight * 0.45),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 4,
                radius: const Radius.circular(8),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 12),
                  child: widget.bodyWidget,
                ),
              ),
            ),

            const SizedBox(height: AppDimens.paddingLarge),
            GradientTextButtonWidget(
              onButtonTap: () {
                widget.onPrimaryButtonTap?.call();
              },
              btnTxt: widget.primaryButtonText,
              width: double.infinity,
            ),
            const SizedBox(height: AppDimens.paddingMedium),
          ],
        ),
      ),
    );
  }
}

// AlertBoxWithTwoBtnWidget
class AlertBoxWithTwoBtnWidget extends StatefulWidget {
  final String title;
  final String? secondaryTitle;
  final String? tertiaryTitle;
  final Widget bodyWidget;
  final String primaryButtonText;
  final String secondaryButtonText;
  final Color primaryColor;
  final double borderRadius;
  final VoidCallback? onPrimaryButtonTap;
  final VoidCallback? onSecondaryButtonTap;
  final String? headerImage;
  final double headerImageSize;
  final bool isSecondaryButtonGradient;
  final ValueListenable<bool>? primaryButtonEnabledNotifier;
  final bool isPrimaryButtonEnabled;
  final double titleBodySpacing;

  const AlertBoxWithTwoBtnWidget({
    super.key,
    this.title = 'Terms & Conditions',
    this.secondaryTitle,
    this.tertiaryTitle,
    required this.bodyWidget,
    this.primaryButtonText = AppStrings.confirm,
    this.secondaryButtonText = AppStrings.close,
    this.primaryColor = const Color(0xFF1A3A6B),
    this.borderRadius = 28,
    this.onPrimaryButtonTap,
    this.onSecondaryButtonTap,
    this.headerImage,
    this.headerImageSize = 80,
    this.isSecondaryButtonGradient = false,
    this.primaryButtonEnabledNotifier,
    this.isPrimaryButtonEnabled = true,
    this.titleBodySpacing = AppDimens.paddingNormal,
  });

  static void show(
    BuildContext context, {
    String title = 'Terms & Conditions',
    String? secondaryTitle,
    String? tertiaryTitle,
    required Widget bodyWidget,
    String primaryButtonText = AppStrings.confirm,
    String secondaryButtonText = AppStrings.close,
    Color primaryColor = const Color(0xFF1A3A6B),
    double borderRadius = 28,
    VoidCallback? onPrimaryButtonTap,
    VoidCallback? onSecondaryButtonTap,
    String? headerImage,
    double headerImageSize = 80,
    bool isSecondaryButtonGradient = false,
    bool isPrimaryButtonEnabled = true,
    ValueListenable<bool>? primaryButtonEnabledNotifier,
    double titleBodySpacing = AppDimens.paddingNormal,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: MediaQuery.removeViewInsets(
            context: dialogContext,
            removeBottom: true,
            child: AlertBoxWithTwoBtnWidget(
              title: title,
              secondaryTitle: secondaryTitle,
              tertiaryTitle: tertiaryTitle,
              bodyWidget: bodyWidget,
              primaryButtonText: primaryButtonText,
              secondaryButtonText: secondaryButtonText,
              primaryColor: primaryColor,
              borderRadius: borderRadius,
              onPrimaryButtonTap: onPrimaryButtonTap,
              onSecondaryButtonTap: onSecondaryButtonTap,
              headerImage: headerImage,
              headerImageSize: headerImageSize,
              isSecondaryButtonGradient: isSecondaryButtonGradient,
              isPrimaryButtonEnabled: isPrimaryButtonEnabled,
              primaryButtonEnabledNotifier: primaryButtonEnabledNotifier,
              titleBodySpacing: titleBodySpacing,
            ),
          ),
        );
      },
    );
  }

  @override
  State<AlertBoxWithTwoBtnWidget> createState() => _AlertBoxWithTwoBtnState();
}

class _AlertBoxWithTwoBtnState extends State<AlertBoxWithTwoBtnWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: AppColors.kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 24, 10, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.headerImage != null) ...[
              Image.asset(widget.headerImage!),
              const SizedBox(height: AppDimens.paddingMedium),
            ],
            SizedBox(height: AppDimens.paddingMedium),

            Flexible(
              child: Text(
                widget.title,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize18,
                  fontWeight: AppFontWeight.fontWeight700,
                  color: AppColors.kPrimaryBlueColor,
                ),
              ),
            ),
            SizedBox(height: AppDimens.paddingMedium),

            if (widget.secondaryTitle != null &&
                widget.secondaryTitle!.trim().isNotEmpty) ...[
              const SizedBox(height: AppDimens.paddingSmall),
              Text(
                widget.secondaryTitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.poppinsRegular.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight400,
                  color: AppColors.kGreyColor,
                ),
              ),
            ],

            if (widget.tertiaryTitle != null &&
                widget.tertiaryTitle!.trim().isNotEmpty) ...[
              const SizedBox(height: AppDimens.paddingSmall),
              Text(
                widget.tertiaryTitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.poppinsRegular.copyWith(
                  fontSize: AppFontSize.fontSize13,
                  fontWeight: AppFontWeight.fontWeight400,
                  color: AppColors.kGreyColor,
                ),
              ),
            ],

            const SizedBox.shrink(),

            // SizedBox(height: widget.titleBodySpacing),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: screenHeight * 0.6),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  thickness: 4,
                  radius: const Radius.circular(8),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(right: 12),
                    child: widget.bodyWidget,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimens.paddingLarge),

            Padding(
              padding: const EdgeInsets.only(
                left: AppDimens.paddingMedium,
                right: AppDimens.paddingMedium,
              ),
              child: Row(
                children: [
                  widget.isSecondaryButtonGradient
                      ? Expanded(
                          child: GradientTextButtonWidget(
                            onButtonTap: () {
                              widget.onSecondaryButtonTap?.call();
                            },
                            btnTxt: widget.secondaryButtonText,
                            width: double.infinity,
                          ),
                        )
                      : Expanded(
                          child: SquareTextButtonWidget(
                            onButtonTap: () {
                              widget.onSecondaryButtonTap?.call();
                            },
                            btnTxt: widget.secondaryButtonText,
                            backgroundColor: AppColors.kGreyColor,
                            textColor: AppColors.kBlackColor,
                          ),
                        ),

                  SizedBox(width: AppDimens.paddingLarge),

                  Expanded(
                    child: widget.primaryButtonEnabledNotifier != null
                        ? ValueListenableBuilder<bool>(
                            valueListenable:
                                widget.primaryButtonEnabledNotifier!,
                            builder: (_, isEnabled, __) {
                              return buildPrimaryButton(isEnabled);
                            },
                          )
                        : buildPrimaryButton(widget.isPrimaryButtonEnabled),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.paddingMedium),
          ],
        ),
      ),
    );
  }

  Widget buildPrimaryButton(bool isEnabled) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !isEnabled,
        child: GradientTextButtonWidget(
          onButtonTap: () {
            widget.onPrimaryButtonTap?.call();
          },
          btnTxt: widget.primaryButtonText,
          width: double.infinity,
        ),
      ),
    );
  }
}

// SingleBtnWIdget
class AlertBoxWithSingleBtnWidget extends StatefulWidget {
  final String title;
  final List<TermsSection> sections;
  final String closeButtonText;
  final Color primaryColor;
  final double borderRadius;
  final VoidCallback? onClose;

  const AlertBoxWithSingleBtnWidget({
    super.key,
    this.title = 'Terms & Conditions',
    required this.sections,
    this.closeButtonText = 'Close',
    this.primaryColor = const Color(0xFF1A3A6B),
    this.borderRadius = 28,
    this.onClose,
  });

  static void show(
    BuildContext context, {
    String title = 'Terms & Conditions',
    required List<TermsSection> sections,
    String closeButtonText = AppStrings.close,
    Color primaryColor = const Color(0xFF1A3A6B),
    double borderRadius = 28,
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: MediaQuery.removeViewInsets(
          context: context,
          removeBottom: true,
          child: AlertBoxWithSingleBtnWidget(
            title: title,
            sections: sections,
            closeButtonText: closeButtonText,
            primaryColor: primaryColor,
            borderRadius: borderRadius,
            onClose: onClose,
          ),
        ),
      ),
    );
  }

  @override
  State<AlertBoxWithSingleBtnWidget> createState() => AlertBoxWithSingleBtn();
}

class AlertBoxWithSingleBtn extends State<AlertBoxWithSingleBtnWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: AppColors.kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      // insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize16,
                fontWeight: AppFontWeight.fontWeight700,
                color: widget.primaryColor,
              ),
            ),

            SizedBox(height: AppDimens.paddingNormal),

            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: screenHeight * .5),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  thickness: 4,
                  radius: const Radius.circular(8),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.sections.map((section) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TermsSectionTileWidget(
                            section: section,
                            primaryColor: widget.primaryColor,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimens.paddingMedium),

            GradientTextButtonWidget(
              onButtonTap: () {
                context.pop();
                widget.onClose?.call();
              },
              btnTxt: AppStrings.close,
              width: 120.w,
            ),
          ],
        ),
      ),
    );
  }
}

// TermsSectionTileWidget
class TermsSectionTileWidget extends StatelessWidget {
  final TermsSection section;
  final Color primaryColor;

  const TermsSectionTileWidget({
    required this.section,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.heading != null) ...[
          Text(
            section.heading!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
        ],

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.isBullet)
              Text(
                '• ',
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight500,
                  color: AppColors.kBlackColor,
                ),
              ),
            Expanded(
              child: Text(
                section.content,
                textAlign: TextAlign.justify,
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: AppFontSize.fontSize12,
                  fontWeight: AppFontWeight.fontWeight500,
                  color: AppColors.kBlackColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// CustomVerticalDivider
class CustomVerticalDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const CustomVerticalDivider({
    super.key,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(width: height, color: color);
  }
}

// HorizontalDividerWidget
class HorizontalDividerWidget extends StatelessWidget {
  final double height;
  final Color? color;
  final double thickness;

  const HorizontalDividerWidget({
    super.key,
    required this.height,
    required this.color,
    this.thickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, color: color, thickness: thickness);
  }
}
