import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/select_occupation_list_item_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/global_state_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/text_form_field_widget.dart';

/*
Title:SelectGenderScreen
Purpose:SelectGenderScreen
Created On:
Edited On:
Author: 
*/

class SelectGenderScreen extends StatefulWidget {
  const SelectGenderScreen({super.key});

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreAdditionalDetails(globalStateProvider);
      showSelectGenderPopup();
    });
  }

  Future<void> showSelectGenderPopup() async {
    final authProvider = context.read<AuthProvider>();

    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.selectGenderIdentity,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: selectGenderBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isSelectGenderNotifier,
      onPrimaryButtonTap: () async {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.push(AppRoutes.selectMaritalStatusScreen);
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.popAndPush(AppRoutes.selectBirthCityScreen);
      },
    );
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

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }

  Widget selectGenderBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: authProvider.genderList.length,
                itemBuilder: (context, index) {
                  final gender = authProvider.genderList[index];

                  return Padding(
                    padding: const EdgeInsets.only(top: AppDimens.paddingSmall),
                    child: SelectOccupationListItemWidget(
                      occupation: gender.name ?? '',
                      isSelected: authProvider.selectedGender?.id == gender.id,
                      onTap: () {
                        authProvider.selectGender(gender);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
