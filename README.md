# flutter_stock_trading_app_provider

A new Flutter project.

// Success
AppHelperWidgets.showSnackBar(
title: AppStrings.success,
message: message,
messageType: AppStrings.responseTypeSuccess,
);

// Error
AppHelperWidgets.showSnackBar(
title: AppStrings.error,
message: message,
messageType: AppStrings.responseTypeError,
);

// Warning
AppHelperWidgets.showSnackBar(
title: AppStrings.warning,
message: AppStrings.pleaseProvideValidReferralCode,
messageType: AppStrings.responseTypeWarning,
);

// To analyze a buildSize
flutter build apk --release --target-platform android-arm64 --analyze-size

// To generate a split abi
flutter build apk --release --split-per-abi

// To Generate new models
dart run build_runner build --delete-conflicting-outputs

// Text Style
style: AppTextStyles.poppinsMedium.copyWith(
            fontSize: AppFontSize.fontSize14,
            fontWeight: AppFontWeight.fontWeight600,
            color:AppColors.kBlackColor,
          ),

// All widget will have name ends with widget
// All screen will have a name ends with screen
// All widgets will be under build()

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
