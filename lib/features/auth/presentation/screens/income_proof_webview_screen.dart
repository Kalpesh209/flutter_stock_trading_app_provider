import 'package:flutter/material.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IncomeProofWebViewScreen extends StatefulWidget {
  final String url;
  const IncomeProofWebViewScreen({super.key, required this.url});

  @override
  State<IncomeProofWebViewScreen> createState() =>
      _IncomeProofWebViewScreenState();
}

class _IncomeProofWebViewScreenState extends State<IncomeProofWebViewScreen> {
  late final AuthProvider authProvider;
  bool isClosing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      authProvider = context.read<AuthProvider>();
      authProvider.initializeIncomeProofWebView(
        url: widget.url,
        onSuccess: onIncomeProofSuccess,
        onFailure: onIncomeProofFailure,
      );
    });
  }

  Future<void> _handleBackPress() async {
    final shouldPop = await context
        .read<AuthProvider>()
        .onIncomeProofBackPressed();
    if (shouldPop && mounted) {
      AppNavigator.pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: AppColors.kWhiteColor,
        appBar: AppBar(
          title: const Text(AppStrings.incomeProof),
          centerTitle: true,
          backgroundColor: AppColors.kWhiteColor,
        ),
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                if (authProvider.incomeProofWebViewController != null)
                  WebViewWidget(
                    controller: authProvider.incomeProofWebViewController!,
                  ),

                if (authProvider.isIncomeProofLoading)
                  const ColoredBox(
                    color: Colors.white,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> onIncomeProofSuccess() async {
    if (!mounted || isClosing) return;
    isClosing = true;
    LogHelper.infoLog(
      'INCOME PROOF SUCCESS - REDIRECTING TO UPLOAD INCOME PROOF',
    );
    AppNavigator.pop(true);
  }

  Future<void> onIncomeProofFailure() async {
    if (!mounted || isClosing) return;
    isClosing = true;
    LogHelper.infoLog('INCOME PROOF FAILED / CANCELLED - REDIRECTING BACK');
    AppNavigator.pop(false);
  }
}
