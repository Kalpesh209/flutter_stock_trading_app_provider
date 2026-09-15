import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/core/helper/log_helper.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/dashed_border_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/show_pdf_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/gradient_text_button_widget.dart';

/*
Title: FileUploadWidget
Purpose: FileUploadWidget
Created On:
Edited On:
Author:
*/

class MultiFileUploadWidget extends StatelessWidget {
  final VoidCallback? onPrimaryBtnTap;
  final String primaryBtnText;
  final String? primaryPrefixImage;
  final VoidCallback? onRemoveTap;
  final VoidCallback? onSecondaryBtnTap;
  final String secondaryBtnText;
  final String? secondaryBtnPrefixImage;
  final bool isBrowseEnabled;
  final bool isSecondButtonEnabled;
  final File? selectedIncomeProofFile;
  final String? previewImgUrl;
  final Uint8List? imageBytes;
  final String? previewMimeType;
  final String? pdfFilePath;

  const MultiFileUploadWidget({
    super.key,
    required this.onPrimaryBtnTap,
    required this.primaryBtnText,
    this.primaryPrefixImage,
    this.onRemoveTap,
    this.onSecondaryBtnTap,
    required this.secondaryBtnText,
    this.secondaryBtnPrefixImage,
    this.isBrowseEnabled = true,
    this.isSecondButtonEnabled = true,
    this.selectedIncomeProofFile,
    this.previewImgUrl,
    this.imageBytes,
    this.previewMimeType,
    this.pdfFilePath,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasFile =
        selectedIncomeProofFile != null ||
        (imageBytes != null && imageBytes!.isNotEmpty) ||
        (previewImgUrl?.isNotEmpty ?? false) ||
        (pdfFilePath?.isNotEmpty ?? false);

    if (hasFile) {
      return _buildFilePreview();
    }
    return _buildFileUploadContainer();
  }

  Widget _buildFilePreview() {
    final borderRadius = BorderRadius.circular(12.r);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 180.h,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.kWhiteColor,
            border: Border.all(color: AppColors.kGreyColor),
            borderRadius: borderRadius,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: _buildPreviewContent(),
          ),
        ),

        if (onRemoveTap != null)
          Positioned(
            top: -10,
            right: -10,
            child: GestureDetector(
              onTap: onRemoveTap,
              child: Container(
                width: 28.w,
                height: 28.h,
                decoration: const BoxDecoration(
                  color: AppColors.k45D483,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: AppColors.kBlackColor,
                  size: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPreviewContent() {
    if (selectedIncomeProofFile != null) {
      final extension = selectedIncomeProofFile!.path
          .split('.')
          .last
          .toLowerCase();

      // PDF
      if (extension == 'pdf') {
        return _buildPdfFilePreview(selectedIncomeProofFile!.path);
      }

      // Image
      if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
        return Image.file(
          selectedIncomeProofFile!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      }
    }

    if (previewImgUrl != null && previewImgUrl!.isNotEmpty) {
      String mimeType = previewMimeType?.toLowerCase() ?? '';
      if (mimeType.isEmpty && previewImgUrl!.startsWith('data:')) {
        final header = previewImgUrl!.split(',').first;
        if (header.startsWith('data:')) {
          mimeType = header.substring(5).split(';').first.toLowerCase();
        }
      }

      // API PDF
      if (mimeType == 'application/pdf') {
        return _buildApiPdfPreview();
      }

      // API Image
      final base64String = previewImgUrl!.contains(',')
          ? previewImgUrl!.split(',').last
          : previewImgUrl!;

      try {
        return Image.memory(
          base64Decode(base64String.replaceAll('"', '').trim()),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } catch (e) {
        LogHelper.errorLog('INCOME PROOF PREVIEW DECODE FAILED :: $e');
        return const SizedBox.shrink();
      }
    }

    if (imageBytes != null && imageBytes!.isNotEmpty) {
      return Image.memory(
        imageBytes!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    if (pdfFilePath != null && pdfFilePath!.isNotEmpty) {
      return _buildPdfFilePreview(pdfFilePath!);
    }

    return const SizedBox.shrink();
  }

  Widget _buildPdfFilePreview(String filePath) {
    return showPDFWidget(filePath: filePath);
  }

  Widget _buildApiPdfPreview() {
    if (pdfFilePath == null || pdfFilePath!.isEmpty) {
      return _buildPdfPlaceholder(
        title: AppStrings.incomeProofPDF,
        subtitle: 'Preparing PDF...',
      );
    }

    return showPDFWidget(filePath: pdfFilePath!);
  }

  // ---------------------------------------------------------------------------
  // PDF PLACEHOLDER
  // ---------------------------------------------------------------------------

  Widget _buildPdfPlaceholder({
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.kWhiteColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: 55.sp, color: Colors.red),

            SizedBox(height: 10.h),

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize14,
                fontWeight: AppFontWeight.fontWeight600,
                color: AppColors.kBlackColor,
              ),
            ),

            SizedBox(height: 5.h),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize12,
                fontWeight: AppFontWeight.fontWeight400,
                color: AppColors.kGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UPLOAD CONTAINER
  // ---------------------------------------------------------------------------

  Widget _buildFileUploadContainer() {
    return CustomPaint(
      painter: DashedBorderPainter(color: Colors.grey.shade400, radius: 12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.file_upload_outlined,
              color: Color(0xff0A84FF),
              size: 34,
            ),

            SizedBox(height: 10.h),

            Text(
              AppStrings.chooseAFile,
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize14,
                fontWeight: AppFontWeight.fontWeight600,
                color: const Color(0xff0A84FF),
              ),
            ),

            SizedBox(height: AppDimens.paddingNormal),

            Text(
              AppStrings.jpegPNGPDF(200),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSize.fontSize14,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(height: AppDimens.paddingMedium),

            _buildUploadButtons(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUTTONS
  // ---------------------------------------------------------------------------

  Widget _buildUploadButtons() {
    return Row(
      children: [
        Expanded(
          child: GradientTextButtonWidget(
            onButtonTap: onPrimaryBtnTap,
            btnTxt: primaryBtnText,
            prefixImage: primaryPrefixImage,
            isEnabled: isBrowseEnabled,
            width: double.infinity,
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: GradientTextButtonWidget(
            onButtonTap: onSecondaryBtnTap,
            btnTxt: secondaryBtnText,
            prefixImage: secondaryBtnPrefixImage,
            isEnabled: isSecondButtonEnabled,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}

// class MultiFileUploadWidget extends StatelessWidget {
//   final VoidCallback? onPrimaryBtnTap;
//   final String primaryBtnText;
//   final String? primaryPrefixImage;
//   final VoidCallback? onRemoveTap;
//   final VoidCallback? onSecondaryBtnTap;
//   final String secondaryBtnText;
//   final String? secondaryBtnPrefixImage;
//   final bool isBrowseEnabled;
//   final bool isSecondButtonEnabled;
//   final File? selectedIncomeProofFile;
//   final String? previewImgUrl;
//   final Uint8List? imageBytes;
//   final String? previewMimeType;

//   const MultiFileUploadWidget({
//     super.key,
//     required this.onPrimaryBtnTap,
//     required this.primaryBtnText,
//     this.onRemoveTap,
//     this.onSecondaryBtnTap,
//     required this.secondaryBtnText,
//     this.primaryPrefixImage,
//     this.secondaryBtnPrefixImage,
//     this.isBrowseEnabled = true,
//     this.isSecondButtonEnabled = true,
//     this.selectedIncomeProofFile,
//     this.previewImgUrl,
//     this.imageBytes,
//     this.previewMimeType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool hasFile =
//         selectedIncomeProofFile != null ||
//         (imageBytes != null && imageBytes!.isNotEmpty) ||
//         (previewImgUrl?.isNotEmpty ?? false);

//     if (hasFile) {
//       return _buildFilePreview();
//     }
//     return _buildFileUploadContainer();
//   }

//   Widget _buildFilePreview() {
//     final borderRadius = BorderRadius.circular(12.r);
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           width: double.infinity,
//           height: 180.h,
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: AppColors.kWhiteColor,
//             border: Border.all(color: AppColors.kGreyColor),
//             borderRadius: borderRadius,
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(6.r),
//             child: _buildPreviewContent(),
//           ),
//         ),

//         if (onRemoveTap != null)
//           Positioned(
//             top: -10,
//             right: -10,
//             child: GestureDetector(
//               onTap: onRemoveTap,
//               child: Container(
//                 width: 28.w,
//                 height: 28.h,
//                 decoration: const BoxDecoration(
//                   color: AppColors.k45D483,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.close,
//                   color: AppColors.kBlackColor,
//                   size: 14,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildPreviewContent() {
//     // Current upload
//     if (selectedIncomeProofFile != null) {
//       final extension = selectedIncomeProofFile!.path
//           .split('.')
//           .last
//           .toLowerCase();

//       if (extension == 'pdf') {
//         return _buildPdfPreview();
//       }

//       if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
//         return Image.file(
//           selectedIncomeProofFile!,
//           width: double.infinity,
//           height: double.infinity,
//           fit: BoxFit.cover,
//           gaplessPlayback: true,
//         );
//       }
//     }

//     // Restored/API file
//     if (previewImgUrl != null && previewImgUrl!.isNotEmpty) {
//       String mimeType = previewMimeType?.toLowerCase() ?? '';

//       // Fallback: derive MIME directly from data URI.
//       if (mimeType.isEmpty && previewImgUrl!.startsWith('data:')) {
//         final header = previewImgUrl!.split(',').first;

//         if (header.startsWith('data:')) {
//           mimeType = header.substring(5).split(';').first.toLowerCase();
//         }
//       }

//       // Restored PDF
//       if (mimeType == 'application/pdf') {
//         return _buildStoredPdfPreview();
//       }

//       // Restored image
//       final base64String = previewImgUrl!.contains(',')
//           ? previewImgUrl!.split(',').last
//           : previewImgUrl!;

//       try {
//         return Image.memory(
//           base64Decode(base64String.replaceAll('"', '').trim()),
//           width: double.infinity,
//           height: double.infinity,
//           fit: BoxFit.cover,
//           gaplessPlayback: true,
//         );
//       } catch (e) {
//         LogHelper.errorLog('INCOME PROOF PREVIEW DECODE FAILED :: $e');
//         return const SizedBox.shrink();
//       }
//     }

//     if (imageBytes != null && imageBytes!.isNotEmpty) {
//       return Image.memory(
//         imageBytes!,
//         width: double.infinity,
//         height: double.infinity,
//         fit: BoxFit.cover,
//         gaplessPlayback: true,
//       );
//     }

//     return const SizedBox.shrink();
//   }

//   Widget _buildStoredPdfPreview() {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: BoxDecoration(
//         color: AppColors.kWhiteColor,
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.picture_as_pdf, size: 55.sp, color: Colors.red),
//             SizedBox(height: 10.h),
//             Text(
//               AppStrings.incomeProofPDF,
//               textAlign: TextAlign.center,
//               style: AppTextStyles.poppinsMedium.copyWith(
//                 fontSize: AppFontSize.fontSize14,
//                 fontWeight: AppFontWeight.fontWeight600,
//                 color: AppColors.kBlackColor,
//               ),
//             ),
//             SizedBox(height: 5.h),
//             Text(
//               'Uploaded Income Proof',
//               textAlign: TextAlign.center,
//               style: AppTextStyles.poppinsMedium.copyWith(
//                 fontSize: AppFontSize.fontSize12,
//                 fontWeight: AppFontWeight.fontWeight400,
//                 color: AppColors.kGreyColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPdfPreview() {
//     if (authProvider.incomeProofPdfFilePath == null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.picture_as_pdf, size: 55.sp, color: Colors.red),
//             SizedBox(height: 10.h),
//             Text(
//               AppStrings.incomeProofPDF,
//               textAlign: TextAlign.center,
//               style: AppTextStyles.poppinsMedium.copyWith(
//                 fontSize: AppFontSize.fontSize14,
//                 fontWeight: AppFontWeight.fontWeight600,
//                 color: AppColors.kBlackColor,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return showPDFWidget(filePath: authProvider.incomeProofPdfFilePath!);
//   }

//   // Widget _buildPdfPreview() {
//   //   return Center(
//   //     child: Column(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       children: [
//   //         Icon(Icons.picture_as_pdf, size: 55.sp, color: Colors.red),
//   //         SizedBox(height: 10.h),
//   //         Text(
//   //           AppStrings.incomeProofPDF,
//   //           textAlign: TextAlign.center,
//   //           style: AppTextStyles.poppinsMedium.copyWith(
//   //             fontSize: AppFontSize.fontSize14,
//   //             fontWeight: AppFontWeight.fontWeight600,
//   //             color: AppColors.kBlackColor,
//   //           ),
//   //         ),

//   //         if (selectedIncomeProofFile != null)
//   //           Padding(
//   //             padding: EdgeInsets.only(top: 5.h, left: 15.w, right: 15.w),
//   //             child: Text(
//   //               selectedIncomeProofFile!.path.split('/').last,
//   //               maxLines: 1,
//   //               overflow: TextOverflow.ellipsis,
//   //               textAlign: TextAlign.center,
//   //               style: AppTextStyles.poppinsMedium.copyWith(
//   //                 fontSize: AppFontSize.fontSize12,
//   //                 fontWeight: AppFontWeight.fontWeight400,
//   //                 color: AppColors.kGreyColor,
//   //               ),
//   //             ),
//   //           ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _buildFileUploadContainer() {
//     return CustomPaint(
//       painter: DashedBorderPainter(color: Colors.grey.shade400, radius: 12),
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade400, width: 1),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.file_upload_outlined,
//               color: Color(0xff0A84FF),
//               size: 34,
//             ),

//             SizedBox(height: 10.h),

//             Text(
//               AppStrings.chooseAFile,
//               style: AppTextStyles.poppinsMedium.copyWith(
//                 fontSize: AppFontSize.fontSize14,
//                 fontWeight: AppFontWeight.fontWeight600,
//                 color: const Color(0xff0A84FF),
//               ),
//             ),

//             SizedBox(height: AppDimens.paddingNormal),

//             Text(
//               AppStrings.jpegPNGPDF(200),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: AppFontSize.fontSize14,
//                 color: Colors.grey.shade600,
//               ),
//             ),

//             SizedBox(height: AppDimens.paddingMedium),
//             _buildUploadButtons(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUploadButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: GradientTextButtonWidget(
//             onButtonTap: onPrimaryBtnTap,
//             btnTxt: primaryBtnText,
//             prefixImage: primaryPrefixImage,
//             isEnabled: isBrowseEnabled,
//             width: double.infinity,
//           ),
//         ),

//         SizedBox(width: 10.w),

//         Expanded(
//           child: GradientTextButtonWidget(
//             onButtonTap: onSecondaryBtnTap,
//             btnTxt: secondaryBtnText,
//             prefixImage: secondaryBtnPrefixImage,
//             isEnabled: isSecondButtonEnabled,
//             width: double.infinity,
//           ),
//         ),
//       ],
//     );
//   }
// }
