import 'dart:io';

import 'package:ecoguardian/models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? token;
  User? currentUser;

  User get getCurrentUser {
    return currentUser!;
  }

  String get getToken {
    return token!;
  }

  bool get isAuth {
    if (token != null) {
      return true;
    }

    return false;
  }

  Future<void> register({
    required String email,
    required String ime,
    required String prezime,
    required String sifra,
    required String sifraPot,
  }) async {
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/register');
    try {
      await http.post(url, body: {
        'name': '$ime $prezime',
        'email': email,
        'password': sifra,
        'password_confirmation': sifraPot,
      }).then(
        (value) async {
          final responseData = json.decode(value.body);
          if (responseData['success'] == false) {
            throw HttpException(responseData['data']['email'][0]);
          }
          token = responseData['data']['token'];
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              'token': token,
            },
          );
          prefs.setString('userData', userData);
          notifyListeners();
        },
      );
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/login');

    try {
      await http.post(url, body: {
        'email': email,
        'password': password,
      }).then((value) async {
        final responseData = json.decode(value.body);
        if (responseData['success'] == false) {
          throw HttpException(responseData['data']);
        }

        token = responseData['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': token,
          },
        );
        prefs.setString('userData', userData);
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<bool> autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    token = extractedUserData['token'];
    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    currentUser = null;
    prefs.clear();
    notifyListeners();
  }

  Future<void> readCurrentUser(token) async {
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/users/me');
    try {
      await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).then((value) {
        final responseData = json.decode(value.body);
        if (responseData['message'] != 'User fetched successfuly!') {
          throw HttpException(responseData['message']);
        }

        currentUser = User(
          name: responseData['data']['name'],
          email: responseData['data']['email'],
          role: responseData['data']['role'],
        );
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }
}
