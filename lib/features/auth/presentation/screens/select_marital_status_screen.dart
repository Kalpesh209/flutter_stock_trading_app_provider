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
Title:SelectMaritalStatusScreen
Purpose:SelectMaritalStatusScreen
Created On:
Edited On:
Author: 
*/

class SelectMaritalStatusScreen extends StatefulWidget {
  const SelectMaritalStatusScreen({super.key});

  @override
  State<SelectMaritalStatusScreen> createState() =>
      _SelectMaritalStatusScreenState();
}

class _SelectMaritalStatusScreenState extends State<SelectMaritalStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreAdditionalDetails(globalStateProvider);
      showSelectMaritalStatusPopup();
    });
  }

  Future<void> showSelectMaritalStatusPopup() async {
    final authProvider = context.read<AuthProvider>();

    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.selectMaritalStatus,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: selectMaritalStatusBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isSelectMaritalStatusNotifier,
      onPrimaryButtonTap: () async {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.push(AppRoutes.selectPepInfoScreen);
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.popAndPush(AppRoutes.selectGenderScreen);
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

  Widget selectMaritalStatusBodyWidget() {
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
                itemCount: authProvider.maritalStatusList.length,
                itemBuilder: (context, index) {
                  final maritalStatus = authProvider.maritalStatusList[index];

                  return Padding(
                    padding: const EdgeInsets.only(top: AppDimens.paddingSmall),
                    child: SelectOccupationListItemWidget(
                      occupation: maritalStatus.name ?? '',
                      isSelected:
                          authProvider.selectedMaritalStatus?.id ==
                          maritalStatus.id,
                      onTap: () {
                        authProvider.selectMaritalStatus(maritalStatus);
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
