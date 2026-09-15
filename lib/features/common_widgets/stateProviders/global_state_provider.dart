import 'package:flutter/foundation.dart';

class GlobalStateProvider extends ChangeNotifier {
  final Map<String, dynamic> _state = {};

  String? currentHolder;
  String? currentStage;
  String? currentMode;
  DateTime? lastStageUpdated;

  Map<String, dynamic> get state => _state;

  void setState(Map<String, dynamic> data) {
    _state.addAll(data);
    notifyListeners();
  }

  Map<String, dynamic> getState() {
    return Map.unmodifiable(_state);
  }

  T? get<T>(String key) {
    return _state[key] as T?;
  }

  void set<T>(String key, T value) {
    _state[key] = value;
    notifyListeners();
  }

  bool contains(String key) {
    return _state.containsKey(key);
  }

  void remove(String key) {
    _state.remove(key);
    notifyListeners();
  }

  void clear() {
    _state.clear();
    currentHolder = null;
    currentStage = null;
    currentMode = null;
    lastStageUpdated = null;
    notifyListeners();
  }

  // To get Holder Details
  Map<String, dynamic>? getHolderDetails({
    required String section,
    required bool isSecondHolderProcessing,
    required bool isThirdHolderProcessing,
  }) {
    if (isThirdHolderProcessing) {
      final thirdHolderDetails = get<Map<String, dynamic>>('thirdHolderDetails');
      return thirdHolderDetails?[section] as Map<String, dynamic>?;
    }

    if (isSecondHolderProcessing) {
      final secondHolderDetails = get<Map<String, dynamic>>('secondHolderDetails');
      return secondHolderDetails?[section] as Map<String, dynamic>?;
    }

    return get<Map<String, dynamic>>(section);
  }
}
