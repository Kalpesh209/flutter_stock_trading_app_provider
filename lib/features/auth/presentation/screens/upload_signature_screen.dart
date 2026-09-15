import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/file_upload_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/appUtils/app_navigator.dart';

import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/global_state_provider.dart';

/*
Title:UploadSignatureScreen
Purpose:To Upload a Signature 
Created On:
Edited On:
Author: 
*/

class UploadSignatureScreen extends StatefulWidget {
  const UploadSignatureScreen({super.key});

  @override
  State<UploadSignatureScreen> createState() => _UploadSignatureScreenState();
}

class _UploadSignatureScreenState extends State<UploadSignatureScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreSignatureState(globalStateProvider);
      showOriginalSignatureImgPopup();
    });
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

  Future<void> showOriginalSignatureImgPopup() async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.uploadSignaturePhoto,
      secondaryTitle: AppStrings.uploadSignatureFile,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: showOriginalSignatureImgBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isUploadSignatureNotifier,
      onPrimaryButtonTap: () async {
        await authProvider.insertSignatureData();
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        AppNavigator.popAndPush(AppRoutes.uploadChequeScreen);
      },
    );
  }

  Widget showOriginalSignatureImgBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.paddingNormal),
              FileUploadWidget(
                selectedImage: authProvider.selectedImage,
                previewImgUrl: authProvider.previewImgUrl,
                onBrowseTap: () async {
                  await authProvider.pickImageFromSource(
                    source: ImageSource.gallery,
                    buttonNotifier: authProvider.isUploadSignatureNotifier,
                  );
                },
                onRemoveTap: () {
                  authProvider.removeSelectedImage(
                    buttonNotifier: authProvider.isUploadSignatureNotifier,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget backGroundImgWidget() {
    return Image.asset(AppImages.loginBgImg, fit: BoxFit.cover);
  }

  Widget overlapWidget() {
    return const SizedBox.shrink();
  }
}
