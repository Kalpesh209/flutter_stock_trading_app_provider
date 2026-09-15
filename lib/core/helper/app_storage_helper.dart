import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/*
Title:AppStorageHelper
Purpose:To Manage Token or data locally through App
Created On:
Edited On:
Author: 
*/

class AppStorageHelper {
  AppStorageHelper._internal();
  static AppStorageHelper? _appStorageHelper;

  factory AppStorageHelper.getInstance() {
    _appStorageHelper ??= AppStorageHelper._internal();
    return _appStorageHelper!;
  }

  static const FlutterSecureStorage flutterSecureStorage =
      FlutterSecureStorage();

  /// Write Data
  Future<void> setData({required String key, required String value}) async {
    final existingValue = await flutterSecureStorage.read(key: key);

    await flutterSecureStorage.write(key: key, value: value);
    final updatedValue = await flutterSecureStorage.read(key: key);
    // LogHelper.infoLog('After Write -> Stored Token: $updatedValue');
  }

  /// Read Data
  Future<String?> getData({required String key}) async {
    return await flutterSecureStorage.read(key: key);
  }

  /// Delete Data
  Future<void> deleteData({required String key}) async {
    await flutterSecureStorage.delete(key: key);
  }

  /// Delete All Data
  Future<void> deleteAllData() async {
    await flutterSecureStorage.deleteAll();
  }

  /// Check Key Existence
  Future<bool> containsKey({required String key}) async {
    return await flutterSecureStorage.containsKey(key: key);
  }

  /// Read All Data
  Future<Map<String, String>> readAllData() async {
    return await flutterSecureStorage.readAll();
  }
}
