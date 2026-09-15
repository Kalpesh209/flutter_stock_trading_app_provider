import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
Title: ApiConstants Used through App
Purpose:ApiConstants Used through App
Created On: 
Edited On:
Author: 
*/

class ApiConstants {
  static String get sihlUATBaseURL => dotenv.env['BASE_URL'] ?? '';
  static String get camsUATBaseURL => dotenv.env['CAMS_BASE_URL'] ?? '';
}
