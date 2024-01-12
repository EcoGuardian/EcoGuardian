import 'dart:io';

import 'package:ecoguardian/models/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? token;
  User? currentUser;
  LatLng currentPosition = LatLng(0, 0);

  User get getCurrentUser {
    return currentUser!;
  }

  String? get getToken {
    return token;
  }

  bool get isAuth {
    if (token != null) {
      return true;
    }

    return false;
  }

  LatLng get getCurrentPosition {
    return currentPosition;
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
      throw e;
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
          id: responseData['data']['id'].toString(),
          name: responseData['data']['name'],
          email: responseData['data']['email'],
          profilePicture: responseData['data']['profile_picture'],
          role: responseData['data']['role'],
        );
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<User> readUserById(token, id) async {
    User? user;
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/users/$id');
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
        user = User(
          id: responseData['data']['id'].toString(),
          name: responseData['data']['name'],
          email: responseData['data']['email'],
          profilePicture: responseData['data']['profile_picture'],
          role: responseData['data']['role'],
        );
        return user;
      });
    } catch (e) {
      throw e;
    }
    return user!;
  }

  Future<void> setCurrentPosition() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((devicePosition) {
      currentPosition = LatLng(devicePosition.latitude, devicePosition.longitude);
    });
    notifyListeners();
  }

  Future<void> updateCurrentUser(
    String ime,
    String prezime,
    String email,
    File? image,
    String id,
  ) async {
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/users/me/update');

    try {
      if (image == null) {
        await http.patch(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          body: {
            'name': '$ime $prezime',
            'email': email,
          },
        ).then((value) {
          final response = json.decode(value.body);

          if (response['success'] != true) {
            throw HttpException('Došlo je do greške');
          }
        });
      } else {
        await http.patch(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          body: {
            'name': '$ime $prezime',
            'email': email,
          },
        ).then((value) async {
          final response = json.decode(value.body);

          if (response['success'] != true) {
            throw HttpException('Došlo je do greške');
          }

          await FirebaseStorage.instance.ref().child('userImages').child('$id.jpg').putFile(image).then((value) async {
            final imageUrl = await value.ref.getDownloadURL();
            final updateUrl = Uri.parse('https://ecoguardian.oarman.tech/api/users/me/update');
            await http.patch(
              updateUrl,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
              body: {
                'profile_picture': imageUrl,
              },
            ).then((value) {
              final response2 = json.decode(value.body);

              if (response2['success'] != true) {
                throw HttpException('Došlo je do greške');
              }
            });
          });
        });
      }
    } catch (e) {
      throw e;
    }
  }
}
