import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_images.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_navigator.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/app_helper_widgets.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/providers/auth_provider.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/gradient_text_button_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ChargesStructureAlertboxWidget extends StatelessWidget {
  final String option1;
  final String option2;
  final String option3;

  final String pdfPath1;
  final String pdfPath2;
  final String pdfPath3;

  final Color primaryColor;
  final double borderRadius;
  final VoidCallback? onClose;

  const ChargesStructureAlertboxWidget({
    super.key,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.pdfPath1,
    required this.pdfPath2,
    required this.pdfPath3,
    this.primaryColor = const Color(0xFF1A3A6B),
    this.borderRadius = 16,
    this.onClose,
  });

  static void show(
    BuildContext context, {
    required String option1,
    required String option2,
    required String option3,
    required String pdfPath1,
    required String pdfPath2,
    required String pdfPath3,
    Color primaryColor = const Color(0xFF1A3A6B),
    double borderRadius = 16,
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: ChargesStructureAlertboxWidget(
            option1: option1,
            option2: option2,
            option3: option3,
            pdfPath1: pdfPath1,
            pdfPath2: pdfPath2,
            pdfPath3: pdfPath3,
            primaryColor: primaryColor,
            borderRadius: borderRadius,
            onClose: onClose,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    final currentPdf = authProvider.selectedIndex == 0
        ? pdfPath1
        : authProvider.selectedIndex == 1
        ? pdfPath2
        : pdfPath3;

    return Dialog(
      backgroundColor: AppColors.kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),

      child: SizedBox(
        height: MediaQuery.of(context).size.height * .80,

        child: Column(
          children: [
            const SizedBox(height: AppDimens.paddingMedium),

            Text(
              AppStrings.chargeStructure,
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize18,
                fontWeight: AppFontWeight.fontWeight700,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: AppDimens.paddingNormal),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingLarge,
              ),

              child: Column(
                children: [
                  OptionTabWidget(
                    label: option1,
                    isSelected: authProvider.selectedIndex == 0,
                    primaryColor: primaryColor,
                    onTap: () {
                      authProvider.selectOption(0);
                    },
                  ),

                  SizedBox(height: AppDimens.paddingSmall),
                  OptionTabWidget(
                    label: option2,
                    isSelected: authProvider.selectedIndex == 1,
                    primaryColor: primaryColor,
                    onTap: () {
                      authProvider.selectOption(1);
                    },
                  ),

                  SizedBox(height: AppDimens.paddingSmall),
                  OptionTabWidget(
                    label: option3,
                    isSelected: authProvider.selectedIndex == 2,
                    primaryColor: primaryColor,
                    onTap: () {
                      authProvider.selectOption(2);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.paddingMedium),

            HorizontalDividerWidget(height: 1.h, color: AppColors.kGreyColor),

            const SizedBox(height: AppDimens.paddingNormal),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingLarge,
              ),
              child: Consumer<AuthProvider>(
                builder: (_, provider, __) {
                  return Row(
                    children: [
                      ZoomButtonWidget(
                        onTap: provider.zoomOut,
                        imagePath: AppImages.minusImg,
                        isDisabled: provider.zoomValue <= AuthProvider.minZoom,
                      ),

                      const SizedBox(width: AppDimens.paddingNormal),

                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            trackShape: const GradientSliderTrackShape(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.kPrimaryGreenColor,
                                  AppColors.kPrimaryBlueColor,
                                ],
                              ),
                            ),

                            thumbColor: AppColors.kPrimaryGreenColor,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayColor: AppColors.kPrimaryGreenColor
                                .withValues(alpha: 0.2),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                          ),

                          child: Slider(
                            value: provider.zoomValue.toDouble(),
                            min: AuthProvider.minZoom.toDouble(),
                            max: AuthProvider.maxZoom.toDouble(),
                            onChanged: (value) {
                              provider.setZoom(value.toInt());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimens.paddingNormal),

                      ZoomButtonWidget(
                        onTap: provider.zoomIn,
                        imagePath: AppImages.plusImg,
                        isDisabled: provider.zoomValue >= AuthProvider.maxZoom,
                      ),

                      SizedBox(width: 8.w),

                      Text(
                        "${provider.zoomValue}%",
                        style: AppTextStyles.poppinsMedium.copyWith(
                          fontSize: AppFontSize.fontSize14,
                        ),
                      ),

                      SizedBox(width: 8.w),
                      ZoomButtonWidget(
                        onTap: provider.resetZoom,
                        imagePath: AppImages.refreshImg,
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: AppDimens.paddingNormal),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: KeyedSubtree(
                  key: ValueKey(authProvider.selectedIndex),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: PdfViewerWidget(
                      pdfPath: currentPdf,
                      zoomScale: authProvider.zoomScale,
                    ),
                  ),
                ),
              ),
            ),

            GradientTextButtonWidget(
              onButtonTap: () {
                AppNavigator.pop();
                onClose?.call();
              },

              btnTxt: AppStrings.close,
              width: 120.w,
            ),
            const SizedBox(height: AppDimens.paddingNormal),
          ],
        ),
      ),
    );
  }
}

class GradientSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const GradientSliderTrackShape({required this.gradient});

  final LinearGradient gradient;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Get track rectangles (active + inactive)
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    // Full track rect (active + inactive combined for gradient)
    final RRect fullTrack = RRect.fromRectAndRadius(trackRect, trackRadius);

    // Gradient paint over entire track
    final Paint gradientPaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..style = PaintingStyle.fill;

    // Inactive (right side of thumb) dimmed paint
    final Paint inactivePaint = Paint()
      ..color =
          (sliderTheme.inactiveTrackColor ?? Colors.grey.withValues(alpha: .3))
      ..style = PaintingStyle.fill;

    // Draw inactive track (right of thumb) first
    final RRect inactiveTrack = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        thumbCenter.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
      ),
      trackRadius,
    );
    context.canvas.drawRRect(inactiveTrack, inactivePaint);

    // Draw full gradient track clipped to active region (left of thumb)
    final Rect activeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.save();
    context.canvas.clipRRect(fullTrack);
    context.canvas.drawRect(activeRect, gradientPaint);
    context.canvas.restore();
  }
}

// class GradientSliderTrackShape extends SliderTrackShape {
//   final LinearGradient gradient;

//   const GradientSliderTrackShape({required this.gradient});

//   @override
//   Rect getPreferredRect({
//     required RenderBox parentBox,
//     Offset offset = Offset.zero,
//     required SliderThemeData sliderTheme,
//     bool isEnabled = false,
//     bool isDiscrete = false,
//   }) {
//     final double trackHeight = sliderTheme.trackHeight ?? 4;
//     final double trackLeft = offset.dx;
//     final double trackTop =
//         offset.dy + (parentBox.size.height - trackHeight) / 2;
//     final double trackWidth = parentBox.size.width;
//     return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
//   }

//   @override
//   void paint(
//     PaintingContext context,
//     Offset offset, {
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required Animation<double> enableAnimation,
//     required TextDirection textDirection,
//     required Offset thumbCenter,
//     Offset? secondaryOffset,
//     bool isDiscrete = false,
//     bool isEnabled = false,
//   }) {
//     final Rect trackRect = getPreferredRect(
//       parentBox: parentBox,
//       offset: offset,
//       sliderTheme: sliderTheme,
//       isEnabled: isEnabled,
//       isDiscrete: isDiscrete,
//     );

//     final Paint gradientPaint = Paint()
//       ..shader = gradient.createShader(trackRect)
//       ..strokeCap = StrokeCap.round;

//     final Paint inactivePaint = Paint()
//       ..color = AppColors.kGreyColor.withValues(alpha: 0.3)
//       ..strokeCap = StrokeCap.round;

//     final RRect activeTrack = RRect.fromRectAndRadius(
//       Rect.fromLTRB(
//         trackRect.left,
//         trackRect.top,
//         thumbCenter.dx,
//         trackRect.bottom,
//       ),
//       const Radius.circular(4),
//     );

//     final RRect inactiveTrack = RRect.fromRectAndRadius(
//       Rect.fromLTRB(
//         thumbCenter.dx,
//         trackRect.top,
//         trackRect.right,
//         trackRect.bottom,
//       ),
//       const Radius.circular(4),
//     );

//     context.canvas.drawRRect(inactiveTrack, inactivePaint);
//     context.canvas.drawRRect(activeTrack, gradientPaint);
//   }
// }

class ZoomButtonWidget extends StatefulWidget {
  final VoidCallback onTap;
  final String imagePath;
  final bool isDisabled;

  const ZoomButtonWidget({
    super.key,
    required this.onTap,
    required this.imagePath,
    this.isDisabled = false,
  });

  @override
  State<ZoomButtonWidget> createState() => _ZoomButtonWidgetState();
}

class _ZoomButtonWidgetState extends State<ZoomButtonWidget> {
  final ValueNotifier<bool> isHovered = ValueNotifier(false);

  @override
  void dispose() {
    isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        isHovered.value = true;
      },

      onExit: (_) {
        isHovered.value = false;
      },

      child: ValueListenableBuilder(
        valueListenable: isHovered,

        builder: (_, hovered, __) {
          final active = hovered && !widget.isDisabled;

          return GestureDetector(
            onTap: widget.isDisabled ? null : widget.onTap,

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),

              height: 36,
              width: 36,

              decoration: BoxDecoration(
                color: widget.isDisabled
                    ? AppColors.kGreyColor.withValues(alpha: .3)
                    : AppColors.kWhiteColor,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(
                  color: active
                      ? AppColors.kPrimaryGreenColor
                      : AppColors.kGreyColor,

                  width: active ? 2 : 1,
                ),
              ),

              child: Center(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    active
                        ? AppColors.kPrimaryGreenColor
                        : AppColors.kGreyColor,

                    BlendMode.srcIn,
                  ),

                  child: Image.asset(
                    widget.imagePath,
                    width: 18,
                    height: 18,
                    color: active
                        ? AppColors.kPrimaryGreenColor
                        : AppColors.kGreyColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// class ZoomButtonWidget extends StatelessWidget {
//   final VoidCallback onTap;
//   final String imagePath;
//   final bool isDisabled;

//   ZoomButtonWidget({
//     super.key,
//     required this.onTap,
//     required this.imagePath,
//     this.isDisabled = false,
//   });

//   final ValueNotifier<bool> isHovered = ValueNotifier(false);

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: isHovered,
//       builder: (_, hovered, __) {
//         final bool isActive = hovered && !isDisabled;

//         return MouseRegion(
//           onEnter: (_) {
//             isHovered.value = true;
//           },

//           onExit: (_) {
//             isHovered.value = false;
//           },

//           child: GestureDetector(
//             onTap: isDisabled ? null : onTap,

//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 150),

//               height: 36,
//               width: 36,

//               decoration: BoxDecoration(
//                 color: isDisabled
//                     ? AppColors.kGreyColor.withValues(alpha: .3)
//                     : AppColors.kWhiteColor,

//                 borderRadius: BorderRadius.circular(18),

//                 border: Border.all(
//                   color: isActive
//                       ? AppColors.kPrimaryGreenColor
//                       : AppColors.kGreyColor,

//                   width: isActive ? 2 : 1,
//                 ),
//               ),

//               child: Center(
//                 child: Image.asset(
//                   imagePath,

//                   color: isActive
//                       ? AppColors.kPrimaryGreenColor
//                       : AppColors.kGreyColor,

//                   colorBlendMode: BlendMode.srcIn,

//                   width: 18,
//                   height: 18,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class ZoomButtonWidget extends StatefulWidget {
//   final VoidCallback onTap;
//   final String imagePath;
//   final bool isDisabled;

//   const ZoomButtonWidget({
//     super.key,
//     required this.onTap,
//     required this.imagePath,
//     this.isDisabled = false,
//   });

//   @override
//   State<ZoomButtonWidget> createState() => _ZoomButtonWidgetState();
// }

// class _ZoomButtonWidgetState extends State<ZoomButtonWidget> {
//   bool isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) {
//         setState(() {
//           isHovered = true;
//         });
//       },

//       onExit: (_) {
//         setState(() {
//           isHovered = false;
//         });
//       },

//       child: GestureDetector(
//         onTap: widget.isDisabled ? null : widget.onTap,

//         child: Container(
//           height: 36,
//           width: 36,

//           decoration: BoxDecoration(
//             color: widget.isDisabled
//                 ? AppColors.kGreyColor.withValues(alpha: .3)
//                 : AppColors.kWhiteColor,

//             borderRadius: BorderRadius.circular(18),

//             border: Border.all(
//               color: isHovered && !widget.isDisabled
//                   ? AppColors.kPrimaryGreenColor
//                   : AppColors.kGreyColor,

//               width: isHovered ? 2 : 1,
//             ),
//           ),

//           child: Center(
//             child: ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 isHovered ? AppColors.kPrimaryGreenColor : AppColors.kGreyColor,

//                 BlendMode.srcIn,
//               ),

//               child: Image.asset(widget.imagePath),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class PdfViewerWidget extends StatelessWidget {
  final String pdfPath;
  final double zoomScale;

  const PdfViewerWidget({
    super.key,
    required this.pdfPath,
    required this.zoomScale,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    final scrollController = ScrollController();

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (_) => true,

          child: SingleChildScrollView(
            controller: scrollController,

            physics: const ClampingScrollPhysics(),

            child: SizedBox(
              height: MediaQuery.of(context).size.height * .5,

              child: Transform.scale(
                scale: zoomScale,

                alignment: Alignment.topCenter,

                child: PDFView(
                  filePath: pdfPath,

                  enableSwipe: true,

                  swipeHorizontal: false,

                  autoSpacing: true,

                  pageFling: false,

                  fitPolicy: FitPolicy.WIDTH,

                  pageSnap: false,

                  onRender: (_) {
                    provider.setPdfLoading(false);
                  },

                  onError: (error) {
                    provider.setPdfLoading(false);

                    LogHelper.infoLog('PDF Error : $error');
                  },
                ),
              ),
            ),
          ),
        ),

        if (provider.isPdfLoading)
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.kPrimaryGreenColor,
            ),
          ),
      ],
    );
  }
}

class OptionTabWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const OptionTabWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),

        padding: EdgeInsets.symmetric(vertical: 8.h),

        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    AppColors.kPrimaryBlueColor,
                    AppColors.kPrimaryGreenColor,
                  ],
                )
              : null,

          color: isSelected ? null : primaryColor.withValues(alpha: .08),

          borderRadius: BorderRadius.circular(18.r),
        ),

        alignment: Alignment.center,

        child: Text(
          label,
          style: AppTextStyles.poppinsMedium.copyWith(
            color: isSelected ? AppColors.kWhiteColor : primaryColor,
          ),
        ),
      ),
    );
  }
}

Future<String> getPdfPath(String assetPath) async {
  final tempDir = await getTemporaryDirectory();
  final fileName = assetPath.split('/').last;
  final file = File('${tempDir.path}/$fileName');

  if (await file.exists()) return file.path;

  final byteData = await rootBundle.load(assetPath);
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file.path;
}
