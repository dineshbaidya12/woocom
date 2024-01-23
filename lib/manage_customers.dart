// ignore_for_file: unused_import

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ManageCustomer {
  final String loginStatusConsumerKey = 'loginStatus';
  final String userinfo = 'userinformation';
  final String orderInfo = 'address';

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

  Future<void> saveOrderInfo(Map<String, String> orderInformation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userInfoString = json.encode(orderInformation);
    await prefs.setString(orderInfo, userInfoString);
  }

  Future<void> saveOrderInfoShipping(
      Map<String, String> orderInformation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? existingInfoString = prefs.getString(orderInfo);

    Map<String, dynamic> existingInfo = {};
    if (existingInfoString != null && existingInfoString.isNotEmpty) {
      existingInfo = json.decode(existingInfoString);
    }
    existingInfo.addAll(orderInformation);

    String updatedInfoString = json.encode(existingInfo);
    await prefs.setString(orderInfo, updatedInfoString);
  }

  Future<Map<String, String>> getOrderInfoAsMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoString = prefs.getString(orderInfo);
    if (userInfoString != null && userInfoString.isNotEmpty) {
      Map<String, dynamic> orderInfo = json.decode(userInfoString);
      Map<String, String> userInfoMap = orderInfo
          .map((key, value) => MapEntry<String, String>(key, value.toString()));
      return userInfoMap;
    } else {
      return {};
    }
  }
}
