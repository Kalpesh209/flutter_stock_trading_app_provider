import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/gradient_text_button_widget.dart';
import 'package:provider/provider.dart';

/*
Title:NomineeDetailScreen
Purpose:To Show Nominee Details
Created On:
Edited On:
Author: 
*/

class NomineeDetailScreen extends StatefulWidget {
  const NomineeDetailScreen({super.key});

  @override
  State<NomineeDetailScreen> createState() => _NomineeDetailScreenState();
}

class _NomineeDetailScreenState extends State<NomineeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      authProvider.updateNomineeDetailNotifier();
      await showNomineeDetailImgPopup();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [backGroundImgWidget(), overlapWidget()],
      ),
    );
  }

  //showNomineeDetailImgPopup
  Future<void> showNomineeDetailImgPopup() async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.nomineeDetails,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: showNomineeDetailBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.nomineeDetailNotifier,
      onPrimaryButtonTap: () async {
        await authProvider.insertNomineeData();
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        authProvider.nomineeDetailNotifier.value = false;
        AppNavigator.popAndPush(AppRoutes.uploadIncomeProofScreen);
      },
    );
  }

  Widget showNomineeDetailBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final addedNomineesList = authProvider.nomineesList;

        return Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.paddingMedium),
              Text(
                AppStrings.appointmentOfNominee,
                style: AppTextStyles.poppinsRegular.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight500,
                  color: AppColors.kBlackColor,
                ),
              ),
              SizedBox(height: AppDimens.paddingMedium),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.poppinsMedium.copyWith(
                    fontSize: AppFontSize.fontSize14,
                    fontWeight: AppFontWeight.fontWeight500,
                    color: AppColors.kBlackColor,
                  ),
                  children: [
                    const TextSpan(text: AppStrings.yourSIHLNominee),
                    TextSpan(
                      text: AppStrings.stocksMutualFunds,
                      style: AppTextStyles.poppinsMedium.copyWith(
                        fontSize: AppFontSize.fontSize14,
                        fontWeight: AppFontWeight.fontWeight700,
                        color: AppColors.kBlackColor,
                      ),
                    ),
                    const TextSpan(text: ' investments.'),
                  ],
                ),
              ),
              SizedBox(height: AppDimens.paddingMedium),
              Text(
                AppStrings.youMayAdd,
                style: AppTextStyles.poppinsRegular.copyWith(
                  fontSize: AppFontSize.fontSize14,
                  fontWeight: AppFontWeight.fontWeight500,
                  color: AppColors.kBlackColor,
                ),
              ),
              SizedBox(height: AppDimens.paddingMedium),

              GradientTextButtonWidget(
                onButtonTap: () {
                  AppNavigator.push(AppRoutes.addNomineeDetailScreen);
                },
                btnTxt: AppStrings.addNominee,
                width: double.infinity,
              ),
              SizedBox(height: AppDimens.paddingMedium),

              // Added Nominee List
              if (addedNomineesList.isNotEmpty) ...[
                SizedBox(height: AppDimens.paddingMedium),

                ...List.generate(addedNomineesList.length, (index) {
                  final nominee = Map<String, dynamic>.from(
                    addedNomineesList[index] as Map,
                  );

                  return buildNomineeListItemWidget(
                    context: context,
                    authProvider: authProvider,
                    nominee: nominee,
                    index: index,
                  );
                }),
              ],

              if (authProvider.nomineesList.isEmpty) ...[
                Row(
                  children: [
                    GestureDetector(
                      onTap: authProvider.onAddNomineeChecked,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 5),
                        width: 22.h,
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: authProvider.isAddNomineeChecked
                              ? AppColors.kBlueColor
                              : AppColors.kTransparentColor,
                          border: Border.all(
                            color: AppColors.kBlueColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: authProvider.isAddNomineeChecked
                            ? const Icon(
                                Icons.check,
                                color: AppColors.kWhiteColor,
                                size: 20,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(width: AppDimens.paddingNormal),

                    Text(
                      AppStrings.iDontWantToAddNominee,
                      style: AppTextStyles.poppinsMedium.copyWith(
                        fontSize: AppFontSize.fontSize14,
                        color: AppColors.kBlackColor,
                      ),
                    ),

                    const SizedBox(width: AppDimens.paddingNormal),
                  ],
                ),

                if (authProvider.isAddNomineeChecked)
                  Padding(
                    padding: EdgeInsets.only(left: 34.w, top: 8.h),
                    child: Text(
                      AppStrings.nomineeDeclaration,
                      textAlign: TextAlign.justify,
                      style: AppTextStyles.poppinsMedium.copyWith(
                        fontSize: AppFontSize.fontSize13,
                        color: AppColors.kGreyColor,
                        height: 1.4,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget buildNomineeListItemWidget({
    required BuildContext context,
    required AuthProvider authProvider,
    required Map<String, dynamic> nominee,
    required int index,
  }) {
    // LogHelper.infoLog('NOMINEE DATA ::: $nominee');
    final nomineeName = nominee['name']?.toString().trim() ?? '';
    final relationId = nominee['relation']?.toString() ?? '';
    final relationName = authProvider.getRelationName(relationId);
    final share = nominee['share']?.toString() ?? '0.00';

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.k0dcaf0, width: 3.w),
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${nomineeName.toUpperCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.poppinsMedium.copyWith(
                      fontSize: AppFontSize.fontSize14,
                      fontWeight: AppFontWeight.fontWeight700,
                      color: AppColors.klightBlueText,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$relationName - $share% Share',
                    style: AppTextStyles.poppinsRegular.copyWith(
                      fontSize: AppFontSize.fontSize13,
                      fontWeight: AppFontWeight.fontWeight500,
                      color: AppColors.kBlackColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: () {
                authProvider.editNominee(index);
              },
              child: Container(
                height: 32.h,
                width: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.k198754,
                  borderRadius: BorderRadius.circular(5.r),
                ),

                padding: EdgeInsets.only(left: 10.w, right: 6.w),
                child: Image.asset(
                  AppImages.editImg,
                  fit: BoxFit.contain,
                  color: AppColors.kWhiteColor,
                ),
              ),
            ),
            SizedBox(width: 7.w),
            GestureDetector(
              onTap: () async {
                await deleteNomineeAlertBoxDialog(context, index);
              },
              child: Container(
                height: 32.h,
                width: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.kRedColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                padding: EdgeInsets.all(8.w),
                child: Image.asset(
                  AppImages.deleteImg,
                  fit: BoxFit.contain,
                  color: AppColors.kWhiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Delete Nominee
  Future<void> deleteNomineeAlertBoxDialog(
    BuildContext context,
    int deleteIndex,
  ) async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.confirmDelete,
      bodyWidget: deleteNomineeBodyWidget(),
      primaryButtonText: AppStrings.yesDelete,
      secondaryButtonText: AppStrings.noKeep,
      onPrimaryButtonTap: () async {
        AppNavigator.pop();
        authProvider.removeNominee(deleteIndex);
      },
      onSecondaryButtonTap: () {
        AppNavigator.pop();
      },
    );
  }

  Widget deleteNomineeBodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimens.paddingMedium),
        Text(
          AppStrings.deleteConfirmation,
          textAlign: TextAlign.center,
          style: AppTextStyles.poppinsMedium.copyWith(
            fontSize: AppFontSize.fontSize14,
            fontWeight: AppFontWeight.fontWeight600,
            color: AppColors.kBlackColor,
          ),
        ),
      ],
    );
  }

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }
}
