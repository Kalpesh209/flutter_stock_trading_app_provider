import 'package:flutter/material.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';

class AppTextStyles {
  // Poppins Font Family
  static TextStyle poppinsRegular = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: AppFontWeight.fontWeight400,
  );

  static TextStyle poppinsMedium = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: AppFontWeight.fontWeight500,
  );

  static TextStyle poppinsSemiBold = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: AppFontWeight.fontWeight600,
  );

  static TextStyle poppinsBold = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: AppFontWeight.fontWeight700,
  );

  static TextStyle poppinsExtraBold = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: AppFontWeight.fontWeight800,
  );
  static TextStyle poppinsDoubleExtraBold = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: AppFontWeight.fontWeight900,
  );
}
