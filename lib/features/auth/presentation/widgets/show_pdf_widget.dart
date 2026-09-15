import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

/*
Title:PdfViewerWidget
Purpose:To show PDF
Created On:
Edited On:
Author: 
*/

class showPDFWidget extends StatelessWidget {
  final String filePath;

  const showPDFWidget({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: filePath,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      fitPolicy: FitPolicy.WIDTH,
      onError: (error) {
        debugPrint('Income Proof PDF Error: $error');
      },
      onPageError: (page, error) {
        debugPrint('Income Proof PDF Page Error - Page: $page, Error: $error');
      },
    );
  }
}
