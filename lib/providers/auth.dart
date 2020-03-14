import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  String _email;
  String _password;
  bool _loading = false;
  String _token;
  static const BASE_URL = 'http://172.16.0.20:5000';

  bool get loading => _loading;
  String get token => _token;

  Future<bool> isUserLoggedIn () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.get('token');
    notifyListeners();
    if (_token != null) {
      return true;
    } else {
      return false;
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    print('logged out!');
  }

  void setEmail (String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword (String password) {
    _password = password;
    notifyListeners();
  }

  Future<void> loginUser() async {
    _loading = true;
    notifyListeners();
    final String url = '$BASE_URL/api/users/login';

    Map<String, String> parameters = {
      "email": _email,
      "password": _password
    };

    try {
      Response response = await Dio().post(url, data: parameters);

      final mainDir = await getApplicationDocumentsDirectory();
      File privateKey = File('${mainDir.path}/private_key.pem');
      File publicKey = File('${mainDir.path}/public_key.pem');

      String keyURL = response.data['keyPath'];
      keyURL = BASE_URL+keyURL;
      String publicKeyUrl = '$BASE_URL/api/books/get-public/keys';

      await Dio().download(keyURL, privateKey.path);
      await Dio().download(publicKeyUrl, publicKey.path);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response.data['token']);
      //prefs.setString('keyPath', response.data['keyPath']);
      print('logged in!');
    } on DioError catch (err) {
      print(err.message);
    }
    _loading = false;
    notifyListeners();
  }
}