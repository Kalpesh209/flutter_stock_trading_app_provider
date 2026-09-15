import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/text_form_field_provider.dart';
import 'package:provider/provider.dart';

/*
Title:TextFormFieldWidget used through App
Purpose:TextFormFieldWidget used through App
Created On:
Edited On:
Author: 
*/

class TextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool? isPhoneField;
  final TextInputAction inputAction;
  final ValueChanged<String>? onFieldSubmittedVal;
  final ValueChanged<String>? onEditCompleted;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final Function()? onTextFieldTap;
  final String? suffixImg;
  final Color? suffixImgColor;
  final String? prefixImg;
  final Color? prefixImgColor;
  final bool isEditable;
  final int maxline;
  final bool autoFocus;
  final bool? externalHasError;
  final String? externalErrorMessage;
  final double borderWidth;
  final bool isValidationOptional;
  final bool isOnlyAlphabetAllowed;
  final bool isUpperCase;
  final int? maxLength;
  final VoidCallback? onSuffixImgTap;
  final ValueChanged<bool>? onFocusChange;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.inputAction,
    required this.onFieldSubmittedVal,
    required this.validator,
    this.onChanged,
    this.onEditCompleted,
    this.textInputType = TextInputType.text,
    this.hint = '',
    this.focusNode,
    this.isPhoneField,
    this.enabled = true,
    this.isEditable = true,
    this.suffixImg,
    this.prefixImgColor,
    this.prefixImg,
    this.suffixImgColor,
    this.onTextFieldTap,
    this.maxline = 1,
    this.autoFocus = false,
    this.externalHasError,
    this.externalErrorMessage,
    this.borderWidth = 1.5,
    this.isValidationOptional = false,
    this.isOnlyAlphabetAllowed = false,
    this.isUpperCase = false,
    this.maxLength,
    this.onSuffixImgTap,
    this.onFocusChange,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late FocusNode _focusNode;
  final textFieldProvider = TextFormFieldProvider();
  late VoidCallback _focusListener;
  late VoidCallback _controllerListener;

  @override
  void initState() {
    super.initState();
    _focusListener = () {
      final hasFocus = _focusNode.hasFocus;
      textFieldProvider.setFocus(hasFocus);
      widget.onFocusChange?.call(hasFocus);

      if (!hasFocus) {
        _validate();
        widget.onFieldSubmittedVal?.call(widget.controller.text);
      }
    };

    _controllerListener = () {
      textFieldProvider.setFocus(_focusNode.hasFocus);
    };
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_focusListener);
    widget.controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    widget.controller.removeListener(_controllerListener);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TextFormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hint != widget.hint) {
      textFieldProvider.clearError();
    }
  }

  void _validate() {
    if (!mounted) return;
    if (widget.isValidationOptional && widget.controller.text.trim().isEmpty) {
      textFieldProvider.clearError();
      return;
    }

    String error = '';
    if (widget.controller.text.trim().isEmpty) {
      error = '${widget.hint} is required';
    } else if (widget.validator != null) {
      error = widget.validator!(widget.controller.text) ?? '';
    }

    final hasError = error.isNotEmpty;
    textFieldProvider.setError(hasError: hasError, errorMessage: error);
    final authProvider = context.read<AuthProvider>();
    if (widget.hint == AppStrings.mobile) {
      authProvider.setMobileError(hasError: hasError, errorMessage: error);
    } else if (widget.hint == AppStrings.emailID) {
      authProvider.setEmailError(hasError: hasError, errorMessage: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commonTextStyle = AppTextStyles.poppinsMedium.copyWith(
      fontSize: AppFontSize.fontSize14,
      fontWeight: AppFontWeight.fontWeight500,
      color: AppColors.kBlackColor,
    );

    return ChangeNotifierProvider.value(
      value: textFieldProvider,
      child: Consumer<TextFormFieldProvider>(
        builder: (_, provider, __) {
          final hasError = widget.externalHasError ?? provider.hasError;
          final errorMessage =
              widget.externalErrorMessage ?? provider.errorMessage;
          final borderColor = (hasError && !provider.isFocused)
              ? AppColors.kRedColor
              : AppColors.kBlueColor;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.kTransparentColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      border: Border.all(
                        color: borderColor,
                        width: widget.borderWidth,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        constraints: BoxConstraints(minHeight: 35.h),
                        decoration: BoxDecoration(
                          color: AppColors.kWhiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingNormal,
                          ),

                          child: Row(
                            children: [
                              Image.asset(
                                widget.prefixImg!,
                                height: 18.h,
                                width: 18.h,
                                color: widget.prefixImgColor,
                              ),

                              const SizedBox(width: AppDimens.paddingSmall),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppDimens.paddingSmallToMedium,
                                ),
                                child: CustomVerticalDivider(
                                  height: 10.h,
                                  color: AppColors.kBlueColor,
                                ),
                              ),
                              const SizedBox(width: AppDimens.paddingSmall),
                              Expanded(
                                child: TextFormField(
                                  controller: widget.controller,
                                  focusNode: _focusNode,
                                  style: commonTextStyle,
                                  showCursor: true,
                                  cursorHeight: 18.h,
                                  readOnly: !widget.isEditable,
                                  enableInteractiveSelection: false,
                                  contextMenuBuilder:
                                      (context, editableTextState) {
                                        return const SizedBox.shrink();
                                      },
                                  autofocus: widget.autoFocus,
                                  textCapitalization: widget.isUpperCase
                                      ? TextCapitalization.characters
                                      : TextCapitalization.none,

                                  textAlignVertical: TextAlignVertical.center,
                                  cursorColor: AppColors.kBlueColor,
                                  keyboardType: widget.textInputType,
                                  maxLength: widget.maxLength,
                                  enabled: widget.enabled,
                                  maxLines: widget.maxline,
                                  onChanged: (value) {
                                    if (value.trim().isNotEmpty && hasError) {
                                      textFieldProvider.clearError();
                                    }

                                    widget.onChanged?.call(value);
                                  },
                                  onFieldSubmitted: (String value) {
                                    _validate();

                                    if (!(widget.externalHasError ??
                                        textFieldProvider.hasError)) {
                                      widget.onFieldSubmittedVal?.call(value);
                                    }
                                  },
                                  onTap: widget.onTextFieldTap,
                                  inputFormatters: [
                                    if (widget.isPhoneField == true)
                                      FilteringTextInputFormatter.digitsOnly
                                    else if (widget.isOnlyAlphabetAllowed)
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[A-Za-z ]'),
                                      )
                                    else
                                      FilteringTextInputFormatter
                                          .singleLineFormatter,

                                    if (widget.isUpperCase)
                                      UpperCaseTextFormatter(),
                                  ],

                                  decoration: _buildInputDecoration(),
                                ),
                              ),

                              if (widget.suffixImg != null)
                                GestureDetector(
                                  onTap: widget.onSuffixImgTap,
                                  child: Image.asset(
                                    widget.suffixImg!,
                                    height: 18.h,
                                    width: 18.h,
                                    color: widget.suffixImgColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -15.h,
                    left: 50.w,
                    child: AnimatedOpacity(
                      opacity:
                          (provider.isFocused ||
                              widget.controller.text.isNotEmpty)
                          ? 1
                          : 0,

                      duration: const Duration(milliseconds: 200),
                      child:
                          (provider.isFocused ||
                              widget.controller.text.isNotEmpty)
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
                                widget.hint,
                                style: AppTextStyles.poppinsMedium.copyWith(
                                  fontSize: AppFontSize.fontSize12,
                                  fontWeight: AppFontWeight.fontWeight500,
                                  color: AppColors.kPrimaryBlueColor,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),

              if (hasError && !provider.isFocused)
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.w),
                  child: Text(
                    errorMessage,
                    style: AppTextStyles.poppinsMedium.copyWith(
                      fontSize: AppFontSize.fontSize12,
                      fontWeight: AppFontWeight.fontWeight400,
                      color: AppColors.kRedColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTextStyles.poppinsMedium.copyWith(
        fontSize: AppFontSize.fontSize14,
        fontWeight: AppFontWeight.fontWeight600,
        color: AppColors.kGreyColor,
      ),

      counterText: '',
      contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 10.h),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
