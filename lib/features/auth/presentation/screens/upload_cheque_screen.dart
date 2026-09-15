import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/file_upload_widget.dart';
import 'package:image_picker/image_picker.dart';
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
Title:UploadChequeScreen
Purpose:UploadChequeScreen
Created On:
Edited On:
Author: 
*/

class UploadChequeScreen extends StatefulWidget {
  const UploadChequeScreen({super.key});

  @override
  State<UploadChequeScreen> createState() => _UploadChequeScreenState();
}

class _UploadChequeScreenState extends State<UploadChequeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreChequeImageState(globalStateProvider);
      showOriginalChequeImgPopup();
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

  Future<void> showOriginalChequeImgPopup() async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.uploadOriginalChequeImage,
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: showOriginalChequeImgBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isUploadChequeNotifier,
      onPrimaryButtonTap: () async {
        authProvider.updateUploadChequeDetails();
        AppNavigator.push(AppRoutes.uploadSignatureScreen);
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        AppNavigator.popAndPush(AppRoutes.bankInfoScreen);
      },
    );
  }

  Widget showOriginalChequeImgBodyWidget() {
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
                    buttonNotifier: authProvider.isUploadChequeNotifier,
                  );
                },
                onRemoveTap: () {
                  authProvider.removeSelectedImage(
                    buttonNotifier: authProvider.isUploadChequeNotifier,
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
