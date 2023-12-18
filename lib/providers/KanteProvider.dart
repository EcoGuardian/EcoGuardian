import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ecoguardian/models/Type.dart';
import 'package:http/http.dart' as http;

class Kante with ChangeNotifier {
  String? token;

  Kante(this.token);

  List<Type> types = [];

  List<Type> get getTypes {
    return types;
  }

  Future<void> addKantu({required lat, required long, required typeId}) async {
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/spots/new');
    try {
      await http.post(
        url,
        body: {
          'name': 'Example',
          'latitude': lat,
          'longitude': long,
          'type_id': typeId,
        },
        headers: {
          'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).then(
        (value) {
          final response = json.decode(value.body);
          print(response);
          notifyListeners();
        },
      );
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> readTypes() async {
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/spots/types');

    try {
      await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).then(
        (value) {
          final response = json.decode(value.body);
          print(response['data'].length);
          for (var i = 0; i < response['data'].length; i++) {
            types.add(
              Type(
                id: response['data'][i]['id'].toString(),
                name: response['data'][i]['name'],
                color: response['data'][i]['color'],
              ),
            );
            print('DODAT');
          }
          notifyListeners();
        },
      );
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
