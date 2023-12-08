import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _ime;

  bool get isAuth {
    // print(_token);
    if (_token != null) {
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
          _token = responseData['data']['token'];
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              'token': _token,
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

        _token = responseData['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
          },
        );
        prefs.setString('userData', userData);
        notifyListeners();
      });
    } catch (e) {
      print('GRESKA PROVIDER $e');
      throw e;
    }
  }

  Future<bool> autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _token = extractedUserData['token'];
    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}
