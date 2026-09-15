import 'package:flutter/material.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_router.dart';
import 'package:go_router/go_router.dart';

/*
Title:To manage navigation in a App
Purpose:To manage navigation in a App
Created On:
Edited On:
Author: 
*/

class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey = rootNavigatorKey;

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // To Push Screen
  static void push(String route) {
    appRouter.push(route);
  }

  // To Go Screen
  static void go(String route) {
    appRouter.go(route);
  }

  // To Replace Screen
  static void replace(String route) {
    appRouter.replace(route);
  }

  // To POP Screen
  static void pop<T extends Object?>([T? result]) {
    final context = rootNavigatorKey.currentContext;
    if (context != null && context.canPop()) {
      context.pop(result);
    }
  }

  // To POP&Push Screen
  static void popAndPush(String route) {
    pop();
    Future.microtask(() {
      push(route);
    });
  }

  static Future<T?> pushRoute<T extends Object?>(Route<T> route) {
    return navigatorKey.currentState!.push(route);
  }

  /// Clears all previous routes and makes [route]
  /// the new root route.
  static void clearAndGo(String route) {
    appRouter.go(route);
  }
}
