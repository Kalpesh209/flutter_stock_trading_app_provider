import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_enums.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/global_state_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

/*
Title:PersonalInfoScreen
Purpose:PersonalInfoScreen
Created On:
Edited On:
Author: 
*/

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PresentAddressInfoScreenState();
}

class _PresentAddressInfoScreenState extends State<PersonalInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restorePersonalDetails(globalStateProvider);
      showPersonalInfoPopup();
    });
  }

  Future<void> showPersonalInfoPopup() async {
    final authProvider = context.read<AuthProvider>();
    final bool isDataAvailable = authProvider
        .populateAddressDetailsFromDigiLocker();
    if (!isDataAvailable) {
      LogHelper.errorLog('Digio PAN data not available');
    }

    if (!mounted) return;
    AlertBoxWithSingleCenterBtnWidget.show(
      context,
      title: AppStrings.personalInformation,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: personalInfoBodyWidget(),
      primaryButtonText: AppStrings.next.toUpperCase(),
      onPrimaryButtonTap: () async {
        await authProvider.savePersonalInfoLocally();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [backGroundImgWidget(), overlapWidget()],
      ),
    );
  }

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }

  Widget personalInfoBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isFather =
            authProvider.selectedRelationType == RelationType.father.value;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                relationCheckBoxWidget(
                  context,
                  RelationType.father.label,
                  RelationType.father.value,
                ),
                const SizedBox(width: AppDimens.paddingLarge),
                relationCheckBoxWidget(
                  context,
                  RelationType.spouse.label,
                  RelationType.spouse.value,
                ),
              ],
            ),

            const SizedBox(height: AppDimens.paddingLarge),

            TextFormFieldWidget(
              controller: authProvider.fatherOrSpouceFirstNameController,
              inputAction: TextInputAction.next,
              textInputType: TextInputType.text,
              onFieldSubmittedVal: (String value) {},
              isPhoneField: false,
              prefixImg: AppImages.personImg,
              prefixImgColor: AppColors.klightBlueText,
              isOnlyAlphabetAllowed: true,
              isUpperCase: true,
              onChanged: (value) {},
              hint: isFather
                  ? AppStrings.fatherFirstName
                  : AppStrings.spouseFirstName,
              borderWidth: 2.5,
              validator: (String? value) {
                if (value!.trim().length < 2) {
                  return AppStrings.minimumCharacter;
                }
                return null;
              },
            ),

            const SizedBox(height: AppDimens.paddingMedium),

            TextFormFieldWidget(
              controller: authProvider.fatherOrSpouceMiddleController,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.personImg,
              prefixImgColor: AppColors.klightBlueText,
              isOnlyAlphabetAllowed: true,
              isUpperCase: true,
              onChanged: (value) {},
              hint: isFather
                  ? AppStrings.fatherMiddleName
                  : AppStrings.spouseMiddleName,
              borderWidth: 2.5,
              validator: (String? value) {},
              isValidationOptional: true,
            ),

            const SizedBox(height: AppDimens.paddingMedium),

            TextFormFieldWidget(
              controller: authProvider.fatherOrSpouceLastNameController,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.personImg,
              prefixImgColor: AppColors.klightBlueText,
              isOnlyAlphabetAllowed: true,
              isUpperCase: true,
              onChanged: (value) {},
              hint: isFather
                  ? AppStrings.fatherLastName
                  : AppStrings.spouseLastName,
              borderWidth: 2.5,
              validator: (String? value) {
                if (value!.trim().length < 2) {
                  return AppStrings.minimumCharacter;
                }
                return null;
              },
            ),

            const SizedBox(height: AppDimens.paddingMedium),

            Text(
              AppStrings.motherDetails,
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize15,
                color: AppColors.kBlackColor,
                fontWeight: AppFontWeight.fontWeight500,
              ),
            ),

            const SizedBox(height: AppDimens.paddingMedium),

            TextFormFieldWidget(
              controller: authProvider.motherFirstNameController,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.personImg,
              prefixImgColor: AppColors.klightBlueText,
              isOnlyAlphabetAllowed: true,
              isUpperCase: true,
              onChanged: (value) {},
              hint: AppStrings.motherFirstName,
              borderWidth: 2.5,
              validator: (String? value) {
                if (value!.trim().length < 2) {
                  return AppStrings.minimumCharacter;
                }
                return null;
              },
              isEditable: true,
            ),

            const SizedBox(height: AppDimens.paddingMedium),

            TextFormFieldWidget(
              controller: authProvider.motherMiddleNameController,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.personImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.motherMiddleName,
              isOnlyAlphabetAllowed: true,
              isUpperCase: true,
              borderWidth: 2.5,
              validator: (String? value) {},
              isValidationOptional: true,
              isEditable: true,
            ),

            const SizedBox(height: AppDimens.paddingMedium),

            TextFormFieldWidget(
              controller: authProvider.motherLastNameController,
              inputAction: TextInputAction.next,
              onFieldSubmittedVal: (String value) {},
              prefixImg: AppImages.personImg,
              prefixImgColor: AppColors.klightBlueText,
              onChanged: (value) {},
              hint: AppStrings.motherLastName,
              isOnlyAlphabetAllowed: true,
              isUpperCase: true,
              borderWidth: 2.5,
              validator: (String? value) {
                if (value!.trim().length < 2) {
                  return AppStrings.minimumCharacter;
                }
                return null;
              },
              isEditable: true,
            ),
            const SizedBox(height: AppDimens.paddingMedium),
          ],
        );
      },
    );
  }

  Widget relationCheckBoxWidget(
    BuildContext context,
    String label,
    String value,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<AuthProvider>().updateRelationType(value);
      },
      child: Consumer<AuthProvider>(
        builder: (_, authProvider, __) {
          final isSelected = authProvider.selectedRelationType == value;
          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 28.w,
                height: 23.h,
                decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  border: Border.all(color: AppColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 14.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: AppColors.kBlueColor,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppDimens.paddingSmallToMedium),
              Text(
                label,
                style: AppTextStyles.poppinsMedium.copyWith(
                  color: AppColors.kBlackColor,
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
