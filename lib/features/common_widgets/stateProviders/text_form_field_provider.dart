import 'package:flutter/material.dart';

class TextFormFieldProvider extends ChangeNotifier {
  bool _hasError = false;
  String _errorMessage = '';
  bool _isFocused = false;

  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get isFocused => _isFocused;

  void setFocus(bool value) {
    _isFocused = value;
    notifyListeners();
  }

  void setError({required bool hasError, required String errorMessage}) {
    _hasError = hasError;
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void clearError() {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }
}
