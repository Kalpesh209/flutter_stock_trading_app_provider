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

/*
Title:SelectOccupationScreen
Purpose:SelectOccupationScreen
Created On:
Edited On:
Author: 
*/

class SelectOccupationScreen extends StatefulWidget {
  const SelectOccupationScreen({super.key});

  @override
  State<SelectOccupationScreen> createState() => _SelectOccupationScreenState();
}

class _SelectOccupationScreenState extends State<SelectOccupationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreAdditionalDetails(globalStateProvider);
      showSelectOccupationInfoPopup();
    });
  }

  Future<void> showSelectOccupationInfoPopup() async {
    final authProvider = context.read<AuthProvider>();
    final globalStateProvider = context.read<GlobalStateProvider>();

    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.selectYourOccupation,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: selectOccupationBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isOccupationSelectedNotifier,
      onPrimaryButtonTap: () async {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.push(AppRoutes.selectAnnualIncomeScreen);
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.popAndPush(AppRoutes.personalInfoScreen);
      },
      titleBodySpacing: 2.0,
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

  Widget selectOccupationBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: authProvider.occupationList.length,
          itemBuilder: (context, index) {
            final occupation = authProvider.occupationList[index];
            return Padding(
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
                top: index == 0 ? 0 : 8.h,
              ),
              child: SelectOccupationListItemWidget(
                occupation: occupation.name ?? '',
                isSelected:
                    authProvider.selectedOccupation?.id == occupation.id,
                onTap: () {
                  authProvider.selectOccupation(occupation);
                },
              ),
            );
          },
        );
      },
    );
  }
}
