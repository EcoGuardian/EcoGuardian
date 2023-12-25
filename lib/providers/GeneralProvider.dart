import 'dart:convert';
import 'dart:io';

import 'package:ecoguardian/components/HttpException.dart';
import 'package:ecoguardian/models/Kanta.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ecoguardian/models/Type.dart';
import 'package:http/http.dart' as http;

class GeneralProvider with ChangeNotifier {
  String? token;

  GeneralProvider(this.token);

  List<Type> types = [];

  List<Kanta> kante = [];

  List<Type> get getTypes {
    return types;
  }

  List<Kanta> get getKante {
    return kante;
  }

  Future<void> addKantu({required lat, required long, required typeId}) async {
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/spots/new');

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
        if (response['success'] != true) {
          throw HttpException('Došlo je do greške');
        }
        notifyListeners();
      },
    );
  }

  Future<List<Kanta>> readKante() async {
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/spots');
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
        if (response['success'] != true) {
          print('RESPONSEEEE $response');
          throw HttpException('Došlo je do greške');
        }

        if (kante.isEmpty && response['data'] != []) {
          for (var i = 0; i < response['data'].length; i++) {
            kante.add(
              Kanta(
                latitude: response['data'][i]['location']['lat'],
                longitude: response['data'][i]['location']['long'],
                typeId: response['data'][i]['type']['id'].toString(),
                typeName: response['data'][i]['type']['name'],
                typeColor: response['data'][i]['type']['color'],
                createdAt: response['data'][i]['created_at'],
              ),
            );
          }
        }
        notifyListeners();
        return kante;
      },
    );
    return kante;
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
          if (response['success'] != true) {
            throw HttpException('Došlo je do greške');
          }
          if (types.isEmpty) {
            for (var i = 0; i < response['data'].length; i++) {
              types.add(
                Type(
                  id: response['data'][i]['id'].toString(),
                  name: response['data'][i]['name'],
                  color: response['data'][i]['color'],
                ),
              );
            }
          }
          notifyListeners();
        },
      );
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> addPrijavu({required lat, required long, required opis, required File image}) async {
    print(image.uri);
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/reports/new');
    await http.post(
      url,
      body: {
        "photo_path": "placeholder",
        "location": "$lat, $long",
        "description": opis,
      },
      headers: {
        'Authorization': 'Bearer $token',
        // 'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).then(
      (value) async {
        final response = json.decode(value.body);
        print('RESPONSE $response');
        if (response['success'] != true) {
          throw HttpException('Došlo je do greške');
        }
        await FirebaseStorage.instance.ref().child('TREZAN.jpg').putFile(image);
      },
    );
  }
}
