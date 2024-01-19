// ignore_for_file: unused_import

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ManageCustomer {
  final String loginStatusConsumerKey = 'loginStatus';
  final String userinfo = 'userinformation';

  Future<String> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginStatus = prefs.getString(loginStatusConsumerKey);
    if (loginStatus == 'loggedin') {
      return 'loggedin';
    } else {
      return 'notloggedin';
    }
  }

  Future<void> setLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = isLoggedIn ? 'loggedin' : 'notloggedin';
    await prefs.setString(loginStatusConsumerKey, status);
  }

  Future<void> saveUserInfo(Map<String, String> userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userInfoString = json.encode(userInfo);
    print(userInfoString);
    await prefs.setString(userinfo, userInfoString);
  }

  Future<List<dynamic>> getUserInfoAsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoString = prefs.getString(userinfo);
    if (userInfoString != null && userInfoString.isNotEmpty) {
      Map<String, dynamic> userInfo = json.decode(userInfoString);
      List<dynamic> userInfoList = userInfo.values.toList();
      return userInfoList;
    } else {
      return [];
    }
  }
}
