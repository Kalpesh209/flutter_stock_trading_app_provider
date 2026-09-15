import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/income_proof_webview_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/multi_file_upload_widget.dart';
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
Title:UploadIncomeProofScreen
Purpose:To Upload Income Proof
Created On:
Edited On:
Author: 
*/

class UploadIncomeProofScreen extends StatefulWidget {
  const UploadIncomeProofScreen({super.key});

  @override
  State<UploadIncomeProofScreen> createState() =>
      _UploadIncomeProofScreenState();
}

class _UploadIncomeProofScreenState extends State<UploadIncomeProofScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final globalStateProvider = context.read<GlobalStateProvider>();
      await authProvider.restoreIncomeProofFromGlobalState(globalStateProvider);
      showUploadIncomeProofPopup();
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

  //showUploadIncomeProofPopup
  Future<void> showUploadIncomeProofPopup() async {
    final authProvider = context.read<AuthProvider>();
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: AppStrings.incomeProof,
      secondaryTitle: AppStrings.uploadOrFetchIncomeProof.toUpperCase(),
      headerImage: AppImages.sihlLogoImg,
      bodyWidget: showUploadIncomeProofBodyWidget(),
      primaryButtonText: AppStrings.next,
      primaryButtonEnabledNotifier: authProvider.isUploadIncomeProofNotifier,
      onPrimaryButtonTap: () async {
        final success = await authProvider.incomeProofNextBtnTap();
        if (!context.mounted) {
          return;
        }

        if (success) {
          AppNavigator.pop();
        }
      },
      isSecondaryButtonGradient: true,
      secondaryButtonText: AppStrings.back,
      onSecondaryButtonTap: () {
        AppNavigator.popAndPush(AppRoutes.uploadSelfieScreen);
      },
    );
  }

  //showUploadIncomeProofBodyWidget
  Widget showUploadIncomeProofBodyWidget() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.paddingMedium),
              MultiFileUploadWidget(
                primaryBtnText: AppStrings.fetch,
                primaryPrefixImage: AppImages.cloudDownloadImg,
                onPrimaryBtnTap: () async {
                  await fetchIncomeProofFlow(authProvider);
                },
                secondaryBtnText: AppStrings.upload,
                secondaryBtnPrefixImage: AppImages.uploadImg,
                onSecondaryBtnTap: () async {
                  await authProvider.onFileSelected();
                },
                selectedIncomeProofFile: authProvider.selectedIncomeProofFile,
                previewImgUrl: authProvider.fetchedPdf,
                previewMimeType: authProvider.getIncomeProofMimeType(),
                pdfFilePath: authProvider.incomeProofPdfFilePath,
                onRemoveTap: () {
                  authProvider.removeIncomeProofFile();
                },
              ),
              // MultiFileUploadWidget(
              //   primaryBtnText: AppStrings.fetch,
              //   primaryPrefixImage: AppImages.cloudDownloadImg,
              //   onPrimaryBtnTap: () async {
              //     await fetchIncomeProofFlow(authProvider);
              //   },
              //   secondaryBtnText: AppStrings.upload,
              //   secondaryBtnPrefixImage: AppImages.uploadImg,
              //   onSecondaryBtnTap: () async {
              //     await authProvider.onFileSelected();
              //   },

              //   selectedIncomeProofFile: authProvider.selectedIncomeProofFile,
              //   previewImgUrl: authProvider.fetchedPdf,
              //   previewMimeType: authProvider.getIncomeProofMimeType(),
              //   onRemoveTap: () {
              //     authProvider.removeIncomeProofFile();
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  //fetchIncomeProofFlow
  Future<void> fetchIncomeProofFlow(AuthProvider authProvider) async {
    final redirectUrl = await authProvider.onFetchIncomeProofAPI();
    if (redirectUrl == null || redirectUrl.isEmpty) {
      await openRetryDialog(
        context: context,
        authProvider: authProvider,
        title: AppStrings.wantToRetry,
        messages: const [AppStrings.unableToStartIncomeProof],
        onRetry: () async {
          await fetchIncomeProofFlow(authProvider);
        },
      );

      return;
    }

    if (!context.mounted) {
      return;
    }

    LogHelper.infoLog('Income Proof Redirect URL ::: $redirectUrl');
    final result = await AppNavigator.pushRoute<bool>(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: authProvider,
          child: IncomeProofWebViewScreen(url: redirectUrl),
        ),
      ),
    );
    LogHelper.infoLog('Income Proof WebView Result ::: $result');

    if (result == true) {
      AppHelperWidgets.showIncomeProofLoader();
      try {
        await Future.delayed(const Duration(seconds: 15));
        final success = await authProvider.getIncomeProofAPI();
        if (success) {
          return;
        }

        await openRetryDialog(
          context: context,
          authProvider: authProvider,
          title: AppStrings.wantToRetry,
          messages: const [AppStrings.unableToFetchIncomeProof],
          onRetry: () async {
            await fetchIncomeProofFlow(authProvider);
          },
        );
      } finally {
        AppHelperWidgets.hideIncomeProofLoader();
      }

      return;
    }
    LogHelper.infoLog('Income Proof consent failed or cancelled.');
    if (!context.mounted) {
      return;
    }

    AppHelperWidgets.showSnackBar(
      title: AppStrings.warning,
      message: AppStrings.consentNotCompleted,
      messageType: AppStrings.responseTypeWarning,
    );

    await openRetryDialog(
      context: context,
      authProvider: authProvider,
      title: AppStrings.incomeProofConsentFailed,
      messages: const [
        AppStrings.consentFailedOrCancelled,
        AppStrings.doYouwantToRetry,
      ],
      onRetry: () async {
        await fetchIncomeProofFlow(authProvider);
      },
    );
  }

  // openRetryDialog
  Future<void> openRetryDialog({
    required BuildContext context,
    required AuthProvider authProvider,
    required String title,
    required List<String> messages,
    required Future<void> Function() onRetry,
  }) async {
    AlertBoxWithTwoBtnWidget.show(
      context,
      title: title,
      bodyWidget: openRetryDialogWidget(messages),
      primaryButtonText: AppStrings.yes,
      secondaryButtonText: AppStrings.no,
      onPrimaryButtonTap: () async {
        AppNavigator.pop();
        await onRetry();
      },
      onSecondaryButtonTap: () {
        AppNavigator.pop();
      },
    );
  }

  //openRetryDialogWidget
  Widget openRetryDialogWidget(List<String> messages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppDimens.paddingMedium),
          Text(
            messages.toString(),
            textAlign: TextAlign.justify,
            style: AppTextStyles.poppinsMedium.copyWith(
              fontSize: AppFontSize.fontSize16,
              fontWeight: AppFontWeight.fontWeight500,
              color: AppColors.kBlackColor,
            ),
          ),
        ],
      ),
    );
  }
}
