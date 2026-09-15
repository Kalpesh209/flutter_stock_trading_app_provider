import 'dart:async';
import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  final int otpLength;
  bool isDisposed = false;

  OtpProvider({this.otpLength = 5}) {
    controllersList = List.generate(otpLength, (_) => TextEditingController());
    focusNodesList = List.generate(otpLength, (_) => FocusNode());
    keyboardFocusNode = FocusNode();
    startTimer();
  }

  late List<TextEditingController> controllersList;
  late List<FocusNode> focusNodesList;
  late FocusNode keyboardFocusNode;

  Timer? timer;

  int secondsRemaining = 60;
  bool canResend = false;

  String status = 'idle';

  bool get isSuccess => status == 'success';
  bool get isFailure => status == 'failure';
  bool get isLoading => status == 'loading';
  String get currentOtp => controllersList.map((e) => e.text).join();

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    }
  }

  void startTimer() {
    secondsRemaining = 60;
    canResend = false;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
        canResend = true;
      } else {
        secondsRemaining--;
      }
      notifyListeners();
    });

    notifyListeners();
  }

  void setStatus(String value) {
    status = value;
    notifyListeners();
  }

  void resetFields(BuildContext context) {
    for (var c in controllersList) {
      c.clear();
    }
    status = 'idle';
    FocusScope.of(context).requestFocus(focusNodesList[0]);
    notifyListeners();
  }

  void clearStatus() {
    if (status != 'idle') {
      status = 'idle';
      notifyListeners();
    }
  }

  Future<void> verifyOtp({required Future<bool> Function(String otp)? onVerifyOtp}) async {
    if (onVerifyOtp == null || isLoading) return;

    status = 'loading';
    notifyListeners();

    try {
      final isVerified = await onVerifyOtp(currentOtp);
      if (isVerified) {
        timer?.cancel();
        canResend = false;
        status = 'success';
      } else {
        status = 'failure';
      }
    } catch (e) {
      status = 'failure';
    }

    notifyListeners();
  }

  

  @override
  void dispose() {
    isDisposed = true;
    for (var controller in controllersList) {
      controller.dispose();
    }
    for (var node in focusNodesList) {
      node.dispose();
    }
    keyboardFocusNode.dispose();
    timer?.cancel();
    super.dispose();
  }
}
