import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/drop_down_provider.dart';
import 'package:provider/provider.dart';

/*
Title:CustomDropDownWidget used through App
Purpose:CustomDropDownWidget used through App
Created On:
Edited On:
Author: 
*/

class CustomDropDownWidget<T> extends StatefulWidget {
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final VoidCallback onEnableTap;
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
  final VoidCallback? onDropdownClosed;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;

  const CustomDropDownWidget({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.onEnableTap,
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
    this.onDropdownClosed,
    this.onFocusChange,
    this.focusNode,
  });

  @override
  State<CustomDropDownWidget<T>> createState() =>
      _CustomDropDownWidgetState<T>();
}

class _CustomDropDownWidgetState<T> extends State<CustomDropDownWidget<T>> {
  OverlayEntry? overlayEntry;

  final dropdownProvider = DropdownFieldProvider();
  final LayerLink _layerLink = LayerLink();
  final ScrollController dropdownScrollController = ScrollController();
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(handleFocusChange);
  }

  void handleFocusChange() {
    final hasFocus = _focusNode.hasFocus;
    widget.onFocusChange?.call(hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(handleFocusChange);
    _internalFocusNode?.dispose();
    overlayEntry?.remove();
    overlayEntry = null;
    dropdownProvider.dispose();
    dropdownScrollController.dispose();
    super.dispose();
  }

  void toggleDropdown(AuthProvider authProvider) {
    if (dropdownProvider.isOpen) {
      removeOverlay(authProvider);
    } else {
      showOverlay(authProvider);
    }
  }

  void showOverlay(AuthProvider authProvider) {
    widget.onEnableTap();
    final renderBox = context.findRenderObject() as RenderBox;
    final dropdownWidth = renderBox.size.width;
    final overlay = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            removeOverlay(authProvider);
          },
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                // link: authProvider.customDropdownLayerLink,
                showWhenUnlinked: false,
                offset: Offset(0, widget.height.h + 6.h),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10.r),

                  child: Container(
                    width: dropdownWidth,
                    constraints: BoxConstraints(maxHeight: 160.h),
                    decoration: BoxDecoration(
                      color: AppColors.kWhiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.klightBlueText),
                    ),
                    child: Scrollbar(
                      controller: dropdownScrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      thickness: 5.w,
                      radius: Radius.circular(10.r),
                      child: ListView(
                        controller: dropdownScrollController,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: widget.items.map((item) {
                          final isSelected = item.value == widget.value;
                          return InkWell(
                            onTap: () {
                              dropdownProvider.setTouched(false);
                              widget.onChanged(item.value);
                              removeOverlay(authProvider, itemSelected: true);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              child: Text(
                                item.child is Text
                                    ? ((item.child as Text).data ?? '')
                                    : '',
                                style: AppTextStyles.poppinsRegular.copyWith(
                                  fontSize: AppFontSize.fontSize13,
                                  fontWeight: isSelected
                                      ? AppFontWeight.fontWeight600
                                      : AppFontWeight.fontWeight400,
                                  color: AppColors.kBlackColor,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    overlay.insert(overlayEntry!);
    dropdownProvider.setDropdownState(true);
  }

  void removeOverlay(AuthProvider authProvider, {bool itemSelected = false}) {
    overlayEntry?.remove();
    overlayEntry = null;
    dropdownProvider.setDropdownState(false);
    _focusNode.unfocus();
    if (!itemSelected) {
      widget.onDropdownClosed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dropdownProvider,
      child: Consumer2<AuthProvider, DropdownFieldProvider>(
        builder: (context, authProvider, provider, child) {
          final selectedItem = widget.items
              .where((e) => e.value == widget.value)
              .firstOrNull;

          final hasValidationError =
              widget.hasError &&
              widget.errorMessage != null &&
              widget.errorMessage!.trim().isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CompositedTransformTarget(
                    link: _layerLink,
                    // link: authProvider.customDropdownLayerLink,
                    child: GestureDetector(
                      onTap: widget.enabled
                          ? () {
                              _focusNode.requestFocus();
                              toggleDropdown(authProvider);
                            }
                          : null,
                      // onTap: widget.enabled
                      //     ? () {
                      //         _focusNode.requestFocus();
                      //         toggleDropdown(authProvider);
                      //       }
                      //     : null,
                      // onTap: widget.enabled
                      //     ? () => toggleDropdown(authProvider)
                      //     : null,
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
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: CustomVerticalDivider(
                                  height: 12.h,
                                  color: AppColors.kBlueColor,
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],

                            Expanded(
                              child: Text(
                                widget.value == null
                                    ? widget.hintText
                                    : selectedItem != null &&
                                          selectedItem.child is Text
                                    ? (selectedItem.child as Text).data ?? ''
                                    : widget.hintText,

                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.poppinsMedium.copyWith(
                                  fontSize: AppFontSize.fontSize14,
                                  fontWeight: AppFontWeight.fontWeight600,
                                  color: AppColors.kGreyColor,
                                ),
                              ),
                            ),

                            Icon(
                              provider.isOpen
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18.sp,
                              color: AppColors.kBlackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -15.h,
                    left: 50.w,
                    child: AnimatedOpacity(
                      opacity: provider.isOpen || widget.value != null ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: provider.isOpen || widget.value != null
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
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
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                child: hasValidationError
                    ? Padding(
                        padding: EdgeInsets.only(top: 3.h, left: 4.w),
                        child: Text(
                          widget.errorMessage!,
                          style: AppTextStyles.poppinsRegular.copyWith(
                            fontSize: AppFontSize.fontSize11,
                            color: AppColors.kRedColor,
                            height: 1,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}
