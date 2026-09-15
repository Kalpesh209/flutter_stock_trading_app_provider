import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/market_segment_list_item_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/global_state_provider.dart';

/*
Title:SelectMarketSegmentScreen
Purpose:SelectMarketSegmentScreen
Created On:
Edited On:
Author:
*/

class SelectMarketSegmentScreen extends StatefulWidget {
  const SelectMarketSegmentScreen({super.key});

  @override
  State<SelectMarketSegmentScreen> createState() =>
      _SelectMarketSegmentScreenState();
}

class _SelectMarketSegmentScreenState extends State<SelectMarketSegmentScreen> {
  final GlobalKey _brokerageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final authProvider = context.read<AuthProvider>();
        await authProvider.loadSegmentTypes();
        showSelectMarketSegmentPopup();
      } catch (e, s) {
        LogHelper.errorLog('ERROR: $e');
        LogHelper.errorLog(s.toString());
      }
    });
  }

  Future<void> showSelectMarketSegmentPopup() async {
    final authProvider = context.read<AuthProvider>();
    final globalStateProvider = context.read<GlobalStateProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.selectMarketSegment,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: selectMarketSegmentBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isSelectMarketSegmentNotifier,
      onPrimaryButtonTap: () async {
        final isSuccess = await authProvider.insertMarketSegmentData();
        if (isSuccess) {
          globalStateProvider.setState({
            'selectedSegmentIds': authProvider.selectedSegmentIds
                .map((e) => e.toString())
                .toList(),
            'brkConfirmed': authProvider.isBrokerageChecked,
          });

          final personalDetails =
              globalStateProvider.get<Map<String, dynamic>>(
                'personalDetails',
              ) ??
              {};
          final bankDetails =
              personalDetails['bankDetails'] as Map<String, dynamic>? ?? {};
          final isBankVerified = bankDetails['isOTPVerified'] == true;
          authProvider.isBankDetailsVerified = isBankVerified;
          AppNavigator.push(AppRoutes.bankInfoScreen);
        }
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        // authProvider.updateAdditionalDetailsState();
        AppNavigator.popAndPush(AppRoutes.selectPepInfoScreen);
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

  Widget selectMarketSegmentBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final segments = authProvider.displaySegments;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: segments.length,
          itemBuilder: (context, index) {
            final segmentDataModel = segments[index];
            if (segmentDataModel.header == 'SLBM') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: authProvider.toggleBrokerageChecked,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 50),
                          width: 22.h,
                          height: 22.h,
                          decoration: BoxDecoration(
                            color: authProvider.isBrokerageChecked
                                ? AppColors.kBlueColor
                                : AppColors.kTransparentColor,
                            border: Border.all(
                              color: AppColors.kBlueColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: authProvider.isBrokerageChecked
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.kWhiteColor,
                                  size: 18,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: AppDimens.paddingSmall),
                      Padding(
                        key: _brokerageKey,
                        padding: const EdgeInsets.only(
                          left: AppDimens.paddingNormal,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showSelectedSegmentBrokeragePopup(
                              context,
                              _brokerageKey,
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: AppStrings.clicktoView,
                                  style: AppTextStyles.poppinsMedium.copyWith(
                                    fontSize: AppFontSize.fontSize14,
                                    color: AppColors.kBlackColor,
                                  ),
                                ),

                                TextSpan(
                                  text: AppStrings.brokerage,
                                  style: AppTextStyles.poppinsMedium.copyWith(
                                    fontSize: AppFontSize.fontSize14,
                                    color: AppColors.kPrimaryBlueColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (authProvider.isBrokerageChecked)
                    Padding(
                      padding: EdgeInsets.only(left: 34.w, top: 8.h),
                      child: Text(
                        AppStrings.brokerageLevied,
                        textAlign: TextAlign.justify,
                        style: AppTextStyles.poppinsMedium.copyWith(
                          fontSize: AppFontSize.fontSize13,
                          color: AppColors.kGreyColor,
                          height: 1.4,
                        ),
                      ),
                    ),

                  SizedBox(height: AppDimens.paddingMedium),
                  MarketSegmentListItemWidget(
                    segmentDataModel: segmentDataModel,
                    description: authProvider.getDisplayDescription(
                      segmentDataModel,
                    ),
                    onChanged: (_) {},
                  ),
                ],
              );
            }

            // =========================
            // NORMAL ITEMS
            // =========================
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: MarketSegmentListItemWidget(
                segmentDataModel: segmentDataModel,
                description: '',
                onChanged: (value) {
                  authProvider.toggleSegmentSelection(segmentDataModel);
                },
              ),
            );
          },
        );
      },
    );
  }

  void showSelectedSegmentBrokeragePopup(BuildContext context, GlobalKey key) {
    final authProvider = context.read<AuthProvider>();
    final scrollController = ScrollController();
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;
    final popupWidth = screenWidth > 600 ? 520.0 : screenWidth * 0.88;
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // AppNavigator.pop();
                  Navigator.pop(dialogContext);
                },
                child: Container(color: Colors.transparent),
              ),
            ),

            /// Popup
            Positioned(
              left: position.dx,
              top: position.dy - 25,
              // top: position.dy + renderBox.size.height - 12,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: popupWidth,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kWhiteColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: authProvider.selectedBrokerageInfo.isEmpty
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  AppStrings.noSegmentsSelected,
                                  style: AppTextStyles.poppinsRegular.copyWith(
                                    fontSize: AppFontSize.fontSize13,
                                    color: AppColors.kGreyColor,
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: AppColors.kBlackColor,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Header
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      AppStrings.selectedSegmentBrokerage,
                                      style: AppTextStyles.poppinsMedium
                                          .copyWith(
                                            fontSize: AppFontSize.fontSize14,
                                            color: AppColors.kPrimaryBlueColor,
                                            fontWeight:
                                                AppFontWeight.fontWeight600,
                                          ),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: AppColors.kBlackColor,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              /// Scrollable Content
                              Flexible(
                                child: Scrollbar(
                                  controller: scrollController,
                                  thumbVisibility: true,
                                  radius: const Radius.circular(10),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...authProvider.selectedBrokerageInfo.map(
                                          (item) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 14,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.header,
                                                  style: AppTextStyles
                                                      .poppinsSemiBold
                                                      .copyWith(
                                                        fontSize: AppFontSize
                                                            .fontSize13,
                                                        color: AppColors
                                                            .kBlackColor,
                                                      ),
                                                ),

                                                const SizedBox(height: 6),

                                                ...item.lines.map(
                                                  (line) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 4,
                                                        ),
                                                    child: Text(
                                                      line,
                                                      style: AppTextStyles
                                                          .poppinsRegular
                                                          .copyWith(
                                                            fontSize:
                                                                AppFontSize
                                                                    .fontSize13,
                                                            color: AppColors
                                                                .kBlackColor,
                                                            height: 1.5,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: AppDimens.paddingXXLarge),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
