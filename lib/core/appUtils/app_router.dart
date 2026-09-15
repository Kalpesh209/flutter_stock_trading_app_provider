import 'package:flutter/material.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/add_nominee_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/bank_account_info_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/dis_account_preview_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/nominee_detail_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/pan_card_verification_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/personal_info_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/present_address_info_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/select_annual_income_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/select_birth_city_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/select_gender_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/select_marital_status_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/select_market_segment_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/select_occupation_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/select_pep_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/upload_cheque_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/upload_income_proof_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/upload_selfie_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/screens/upload_signature_screen.dart';
import 'package:flutter_stock_trading_app_provider/features/digio/presentation/digio_loading_screen.dart';
import 'package:go_router/go_router.dart';

/*
Title:List of All Routes Used through App
Purpose:List of All Routes Used through App
Created On:
Edited On:
Author: 
*/

class AppRoutes {
  AppRoutes._();
  static const loginScreen = '/login';
  static const digioLoadingScreen = '/digioLoading';
  static const panCardVerificationScreen = '/panCardVerification';
  static const presentAddressInfoScreen = '/presentAddressInfo';
  static const personalInfoScreen = '/personalInfo';
  static const selectOccupationScreen = '/selectOccupation';
  static const selectAnnualIncomeScreen = '/selectAnnualIncome';
  static const selectBirthCityScreen = '/selectBirthCity';
  static const selectGenderScreen = '/selectGender';
  static const selectMaritalStatusScreen = '/selectMaritalStatus';
  static const selectPepInfoScreen = '/selectPepInfo';
  static const selectMarketSegmentScreen = '/selectMarketSegment';
  static const bankInfoScreen = '/bankInfo';
  static const uploadChequeScreen = '/uploadCheque';
  static const uploadSignatureScreen = '/uploadSignature';
  static const uploadSelfieScreen = '/uploadSelfie';
  static const uploadIncomeProofScreen = '/uploadIncomeProof';
  static const incomeProofWebviewScreen = '/incomeProofWebview';
  static const nomineeDetailScreen = '/nomineeDetail';
  static const addNomineeDetailScreen = '/addNominee';
  static const disAccountInfoPreviewScreen = '/disAccountInfoPreview';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.loginScreen,
  routes: [
    GoRoute(
      path: AppRoutes.loginScreen,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.digioLoadingScreen,
      builder: (context, state) => const DigioLoadingScreen(),
    ),
    GoRoute(
      path: AppRoutes.panCardVerificationScreen,
      builder: (context, state) => PanCardVerificationScreen(),
    ),

    GoRoute(
      path: AppRoutes.presentAddressInfoScreen,
      builder: (context, state) => PresentAddressInfoScreen(),
    ),

    GoRoute(
      path: AppRoutes.personalInfoScreen,
      builder: (context, state) => PersonalInfoScreen(),
    ),
    GoRoute(
      path: AppRoutes.selectOccupationScreen,
      builder: (context, state) => SelectOccupationScreen(),
    ),

    GoRoute(
      path: AppRoutes.selectAnnualIncomeScreen,
      builder: (context, state) => SelectAnnualIncomeScreen(),
    ),

    GoRoute(
      path: AppRoutes.selectBirthCityScreen,
      builder: (context, state) => SelectBirthCityScreen(),
    ),
    GoRoute(
      path: AppRoutes.selectGenderScreen,
      builder: (context, state) => SelectGenderScreen(),
    ),
    GoRoute(
      path: AppRoutes.selectMaritalStatusScreen,
      builder: (context, state) => SelectMaritalStatusScreen(),
    ),

    GoRoute(
      path: AppRoutes.selectPepInfoScreen,
      builder: (context, state) => SelectPEPScreen(),
    ),
    GoRoute(
      path: AppRoutes.selectMarketSegmentScreen,
      builder: (context, state) => SelectMarketSegmentScreen(),
    ),
    GoRoute(
      path: AppRoutes.bankInfoScreen,
      builder: (context, state) => BankAccountInfoScreen(),
    ),
    GoRoute(
      path: AppRoutes.uploadChequeScreen,
      builder: (context, state) => UploadChequeScreen(),
    ),
    GoRoute(
      path: AppRoutes.uploadSignatureScreen,
      builder: (context, state) => UploadSignatureScreen(),
    ),
    GoRoute(
      path: AppRoutes.uploadSelfieScreen,
      builder: (context, state) => UploadSelfieScreen(),
    ),

    GoRoute(
      path: AppRoutes.uploadIncomeProofScreen,
      builder: (context, state) => const UploadIncomeProofScreen(),
    ),

    GoRoute(
      path: AppRoutes.nomineeDetailScreen,
      builder: (context, state) => const NomineeDetailScreen(),
    ),

    GoRoute(
      path: AppRoutes.addNomineeDetailScreen,
      builder: (context, state) {
        final nomineeIndex = state.extra as int? ?? 1;
        return AddNomineeDetailScreen(nomineeIndex: nomineeIndex);
      },
    ),
    GoRoute(
      path: AppRoutes.disAccountInfoPreviewScreen,
      builder: (context, state) => const DISAccountPreviewScreen(),
    ),
  ],
);
