import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
Title:AppDimens used through App
Purpose:AppDimens used through App
Created On:
Edited On:
Author: 
*/

class AppDimens {
  static const paddingVerySmall = 2.0;
  static const paddingSmall = 5.0;
  static const paddingSixSmall = 6.0;
  static const paddingSevenSmall = 7.0;
  static const paddingSmallToMedium = 8.0;
  static const paddingNormal = 10.0;
  static const paddingNormalToMedium = 12.0;
  static const paddingMedium = 15.0;
  static const paddingLarge = 20.0;
  static const paddingExtraLarge = 25.0;
  static const paddingBitExtraLarge = 28.0;
  static const paddingXXLarge = 30.0;
  static const paddingXXXLarge = 35.0;
}

class EdgeInsetsDimens extends EdgeInsets {
  const EdgeInsetsDimens.horizontal(double value) : super.symmetric(horizontal: value);

  const EdgeInsetsDimens.vertical(double value) : super.symmetric(vertical: value);

  const EdgeInsetsDimens.login() : super.symmetric(horizontal: AppDimens.paddingLarge * 1.5);

  const EdgeInsetsDimens.screen() : super.all(AppDimens.paddingLarge);
  const EdgeInsetsDimens.screenHorizontal() : super.symmetric(horizontal: AppDimens.paddingLarge);
  const EdgeInsetsDimens.screenVertical() : super.symmetric(vertical: AppDimens.paddingLarge);
  const EdgeInsetsDimens.screenBottom() : super.only(bottom: AppDimens.paddingLarge);
  const EdgeInsetsDimens.screenTop() : super.only(top: AppDimens.paddingLarge);
  const EdgeInsetsDimens.screenLeft() : super.only(left: AppDimens.paddingLarge);
  const EdgeInsetsDimens.screenRight() : super.only(right: AppDimens.paddingLarge);

  const EdgeInsetsDimens.card() : super.all(AppDimens.paddingMedium);

  const EdgeInsetsDimens.surfaceLarge() : super.all(AppDimens.paddingLarge);
  const EdgeInsetsDimens.surfaceNormal() : super.all(AppDimens.paddingNormal);
  const EdgeInsetsDimens.surfaceSmall() : super.all(AppDimens.paddingSmall);
  static EdgeInsetsGeometry surfaceAttachmentDelete() =>
      EdgeInsetsDimens.surfaceNormal().add(EdgeInsets.only(right: -1 * AppDimens.paddingNormal));

  static EdgeInsetsGeometry comment() {
    return EdgeInsets.all(
      AppDimens.paddingMedium,
    ).add(Platform.isIOS ? EdgeInsets.only(bottom: AppDimens.paddingMedium) : EdgeInsets.zero);
  }
}
