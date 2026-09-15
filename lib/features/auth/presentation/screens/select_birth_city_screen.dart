import 'package:flutter/material.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart'
    show AppColors;
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

import 'package:provider/provider.dart';

/*
Title:SelectBirthCityScreen
Purpose:SelectBirthCityScreen
Created On:
Edited On:
Author: 
*/

class SelectBirthCityScreen extends StatefulWidget {
  const SelectBirthCityScreen({super.key});

  @override
  State<SelectBirthCityScreen> createState() => _SelectBirthCityScreenState();
}

class _SelectBirthCityScreenState extends State<SelectBirthCityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreAdditionalDetails(globalStateProvider);
      showSelectBirthCityPopup();
    });
  }

  Future<void> showSelectBirthCityPopup() async {
    final authProvider = context.read<AuthProvider>();

    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.selectCityOfBirth,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: selectBirthCityBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isBirthCityNotifier,
      onPrimaryButtonTap: () async {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.push(AppRoutes.selectGenderScreen);
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        authProvider.updateAdditionalDetailsState();
        AppNavigator.popAndPush(AppRoutes.selectAnnualIncomeScreen);
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

  Widget selectBirthCityBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final cityList = authProvider.selectedBirthCity != null
            ? [authProvider.selectedBirthCity!]
            : authProvider.filteredSearchCityList;

        return Padding(
          padding: EdgeInsets.only(
            left: AppDimens.paddingMedium,
            right: AppDimens.paddingMedium,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.paddingMedium),
              TextFormFieldWidget(
                controller: authProvider.birthCityController,
                inputAction: TextInputAction.next,
                onFieldSubmittedVal: (String value) {},
                isUpperCase: true,
                prefixImg: AppImages.homePinImg,
                prefixImgColor: AppColors.klightBlueText,
                onChanged: (value) {
                  authProvider.searchCity(value);
                },
                hint: AppStrings.searchCity,
                borderWidth: 2.5,
                validator: (String? value) {
                  final query = value?.trim() ?? '';
                  if (query.isNotEmpty && query.length < 3) {
                    return AppStrings.enterAtleast3Characters;
                  }

                  return null;
                },
                isEditable: true,
              ),
              SizedBox(height: AppDimens.paddingMedium),
              if (cityList.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cityList.length,
                  itemBuilder: (context, index) {
                    final city = cityList[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? 0 : AppDimens.paddingSmallToMedium,
                      ),
                      child: SelectOccupationListItemWidget(
                        occupation: city.name ?? '',
                        isSelected:
                            authProvider.selectedBirthCity?.id == city.id,
                        onTap: () {
                          authProvider.selectBirthCity(city);
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
