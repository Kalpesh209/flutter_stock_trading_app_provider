import 'package:flutter/material.dart';

class DropdownFieldProvider extends ChangeNotifier {
  bool _isTouched = false;
  bool get isTouched => _isTouched;

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  void setTouched(bool value) {
    _isTouched = value;
    notifyListeners();
  }

  void setDropdownState(bool value) {
    _isOpen = value;
    notifyListeners();
  }

  void clear() {
    _isTouched = false;
    _isOpen = false;
    notifyListeners();
  }
}
