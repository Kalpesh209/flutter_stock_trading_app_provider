import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/file_upload_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/gradient_text_button_widget.dart';
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
Title:UploadSelfieScreen
Purpose:To Upload a Selfie 
Created On:
Edited On:
Author: 
*/

class UploadSelfieScreen extends StatefulWidget {
  const UploadSelfieScreen({super.key});

  @override
  State<UploadSelfieScreen> createState() => _UploadSelfieScreenState();
}

class _UploadSelfieScreenState extends State<UploadSelfieScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreSelfieImageDetails(globalStateProvider);
      if (!mounted) return;
      showUploadSelfieImgPopup();
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

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }

  Future<void> showUploadSelfieImgPopup() async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.livePhoto,
      secondaryTitle: AppStrings.pleaseCapture,
      tertiaryTitle: AppStrings.maximumImageSize,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: showUploadSelfieImgBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isUploadSelfieNotifier,
      onPrimaryButtonTap: () async {
        await authProvider.submitSelfieDetails();
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        AppNavigator.popAndPush(AppRoutes.uploadSignatureScreen);
      },
    );
  }

  Widget showUploadSelfieImgBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.paddingMedium),
              if (authProvider.hasFetchedSelfie)
                FileUploadWidget(
                  selectedImage: null,
                  previewImgUrl: authProvider.fetchedSelfieBase64,
                  onBrowseTap: () async {},
                  onRemoveTap: () {
                    authProvider.removeFetchedSelfie();
                  },
                )
              else ...[
                GradientTextButtonWidget(
                  onButtonTap: () {
                    authProvider.capturePhotoRequest();
                  },
                  btnTxt: AppStrings.capturePhoto,
                  width: double.infinity,
                ),

                SizedBox(height: AppDimens.paddingNormal),

                GradientTextButtonWidget(
                  onButtonTap: () {
                    final documentId = authProvider.selfieReferenceId;
                    if (documentId == null || documentId.isEmpty) {
                      return;
                    }
                    authProvider.fetchSelfieResponse(documentId: documentId);
                  },
                  btnTxt: AppStrings.fetchSelfie,
                  isEnabled: authProvider.isPhotoCaptured,
                  width: double.infinity,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
