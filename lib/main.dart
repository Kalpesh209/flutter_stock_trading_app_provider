import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/stateProviders/global_state_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/digio/provider/digio_provider.dart';
import 'package:provider/provider.dart';

/*
Title:This is an Entry poiny of App
Purpose:This is an Entry poiny of App
Created On:
Edited On:
Author: 
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalStateProvider()),
        ChangeNotifierProxyProvider<GlobalStateProvider, AuthProvider>(
          create: (_) => AuthProvider(),
          update: (context, globalState, authProvider) {
            final provider = authProvider ?? AuthProvider();
            provider.globalStateProvider = globalState;
            return provider;
          },
        ),

        ChangeNotifierProxyProvider<AuthProvider, DigioProvider>(
          create: (_) => DigioProvider(),
          update: (context, authProvider, previous) {
            previous ??= DigioProvider();
            previous.update(authProvider);
            authProvider.updateDigioProvider(previous);
            return previous;
          },
        ),
      ],

      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: AppNavigator.messengerKey,
          routerConfig: appRouter,
          title: AppStrings.shahInvestor,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
        ),
      ),
    );
  }
}
