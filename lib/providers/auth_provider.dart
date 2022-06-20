import 'dart:convert';

import 'package:autoly_service/ui/marketPlace/model/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:autoly_service/ui/marketPlace/model/user.dart' as user;

import 'package:http/http.dart' as http;

class AuthProvider extends BaseViewModel {
  AuthProvider() {}

  bool _isLoading = false;

  bool setLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  bool get loading => _isLoading;

  // api
  user.User _currentUser;

  void setCurrentUser(user.User currentUser) {
    _currentUser = currentUser;
    notifyListeners();
  }

  user.User get currentUser => _currentUser;

  Future<user.User> login({
    String email,
    String password,
  }) async {
    try {
      var response = await http
          .post(Uri.parse('https://autoly.io/shop/wp-json/jwt-auth/v1/token'),
              // headers: {
              //   'Accept': 'application/json'
              // },
              body: {
            "username": email,
            "password": password,
          });

      if (response.statusCode == 200) {
        print("status code is 200");
        print(response.body);
        setCurrentUser(user.User.fromJson(json.decode(response.body)));
        // setCurrentUser(User.fromJson(response.body.));
        // SharedPreferencesHelper.save("user", _currentUser);
        // SharedPreferencesHelper.save("user_id", _currentUser.userId);
        // SharedPreferencesHelper.save("storeCode", _currentUser.storecode);

      } else {
        //   Commons.showError(
        //       context: context, message: results['response']["message"]);
        //
        Error error = Error.fromJson(json.decode(response.body));
        print("error $error");
        Fluttertoast.showToast(
          msg: error.message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error:${e.toString()}');
    }
    return _currentUser;
  }
}
