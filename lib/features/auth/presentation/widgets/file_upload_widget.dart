import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:io';

import 'package:flutter_stock_trading_app_provider/core/appUtils/app_colors.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_dimens.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_size.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_font_weight.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_strings.dart';
import 'package:flutter_stock_trading_app_provider/core/appUtils/app_text_style.dart';
import 'package:flutter_stock_trading_app_provider/features/auth/presentation/widgets/dashed_border_widget.dart';
import 'package:flutter_stock_trading_app_provider/features/common_widgets/gradient_text_button_widget.dart';

/*
Title:FileUploadWidget
Purpose:FileUploadWidget
Created On:
Edited On:
Author: 
*/

class FileUploadWidget extends StatelessWidget {
  final VoidCallback onBrowseTap;
  final VoidCallback? onRemoveTap;
  final File? selectedImage;
  final String? previewImgUrl;
  final Uint8List? imageBytes;

  const FileUploadWidget({
    super.key,
    required this.onBrowseTap,
    this.onRemoveTap,
    this.selectedImage,
    this.previewImgUrl,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        selectedImage != null ||
        imageBytes != null ||
        (previewImgUrl?.isNotEmpty ?? false);

    if (hasImage) {
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
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: AspectRatio(aspectRatio: 16 / 9, child: _buildImage()),
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

    return CustomPaint(
      painter: DashedBorderPainter(color: Colors.grey.shade400, radius: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.file_upload_outlined,
              color: Color(0xff0A84FF),
              size: 34,
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.chooseAFile,
              style: AppTextStyles.poppinsMedium.copyWith(
                fontSize: AppFontSize.fontSize14,
                fontWeight: AppFontWeight.fontWeight600,
                color: const Color(0xff0A84FF),
              ),
            ),
            const SizedBox(height: AppDimens.paddingNormal),
            Text(
              AppStrings.jpegPNG(200),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: AppDimens.paddingMedium),

            GradientTextButtonWidget(
              onButtonTap: onBrowseTap,
              btnTxt: AppStrings.browseFile,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    if (imageBytes != null && imageBytes!.isNotEmpty) {
      return Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    if (previewImgUrl != null && previewImgUrl!.isNotEmpty) {
      final base64String = previewImgUrl!.contains(',')
          ? previewImgUrl!.split(',').last
          : previewImgUrl!;

      return Image.memory(
        base64Decode(base64String),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    return const SizedBox.shrink();
  }
}
