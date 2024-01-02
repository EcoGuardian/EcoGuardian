import 'dart:convert';
import 'dart:io';

import 'package:ecoguardian/components/HttpException.dart';
import 'package:ecoguardian/models/Aktivnost.dart';
import 'package:ecoguardian/models/Kanta.dart';
import 'package:ecoguardian/models/Prijava.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ecoguardian/models/Type.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class GeneralProvider with ChangeNotifier {
  String? token;

  GeneralProvider(this.token);

  List<Type> types = [];

  List<Kanta> kante = [];

  List<Prijava> prijave = [];

  List<Type> get getTypes {
    return types;
  }

  List<Kanta> get getKante {
    return kante;
  }

  List<Prijava> get getPrijave {
    return prijave;
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
    List<Kanta> localKante = [];
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/spots');
    await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).then((value) {
      final response = json.decode(value.body);

      if (response['success'] != true && response['data'] != 'No spots yet!') {
        throw HttpException('Došlo je do greške');
      }
      if (response['data'] == 'No spots yet!') {
        return [];
      }

      for (var i = 0; i < response['data'].length; i++) {
        localKante.add(
          Kanta(
            lat: response['data'][i]['location']['lat'],
            long: response['data'][i]['location']['long'],
            typeId: response['data'][i]['type']['id'].toString(),
            typeName: response['data'][i]['type']['name'],
            typeColor: response['data'][i]['type']['color'],
            createdAt: response['data'][i]['created_at'],
          ),
        );
      }
      return localKante;
    });
    return localKante;
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
    Uri url = Uri.parse('https://ecoguardian.oarman.tech/api/reports/new');
    await http.post(
      url,
      body: {
        'photo_path': 'placeholder',
        'location': '$lat, $long',
        'description': opis,
        'status': 'Neriješena',
      },
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).then(
      (value) async {
        final response = json.decode(value.body);
        print('RESPONSE $response');
        if (response['success'] != true) {
          throw HttpException('Došlo je do greške');
        }

        await FirebaseStorage.instance.ref().child('${response['data']['id']}.jpg').putFile(image).then((value) async {
          final imageUrl = await value.ref.getDownloadURL();
          print('IMAGGGGGG   $imageUrl');
          final updateUrl = Uri.parse('https://ecoguardian.oarman.tech/api/reports/update/${response['data']['id']}');
          await http.patch(
            updateUrl,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
            body: {
              'photo_path': imageUrl,
            },
          ).then((value) {
            final response2 = json.decode(value.body);

            if (response2['success'] != true) {
              throw HttpException('Došlo je do greške');
            }
          });
        });
      },
    );
    notifyListeners();
  }

  Future<List<Prijava>> readPrijave() async {
    final url = Uri.parse('https://ecoguardian.oarman.tech/api/reports');
    List<Prijava> localPrijave = [];
    await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).then((value) {
      final response = json.decode(value.body);
      if (response['success'] != true && response['data'] != 'No reports yet!') {
        throw HttpException('Došlo je do greške');
      }
      if (response['data'] == 'No reports yet!') {
        return [];
      }

      for (var i = 0; i < response['data'].length; i++) {
        int zarez = response['data'][i]['location'].toString().indexOf(',');
        localPrijave.add(
          Prijava(
            id: response['data'][i]['id'].toString(),
            userId: response['data'][i]['user']['id'].toString(),
            imageUrl: response['data'][i]['photo_path'],
            lat: response['data'][i]['location'].toString().substring(0, zarez),
            long: response['data'][i]['location'].toString().substring(zarez + 2, response['data'][i]['location'].toString().length),
            description: response['data'][i]['description'],
            status: response['data'][i]['status'],
            createdAt: DateTime.parse(response['data'][i]['created_at']),
          ),
        );
      }
      return localPrijave;
    });
    return localPrijave;
  }

  Future<void> updatePrijavu({required String lat, required String long, required String description, File? image, required int id}) async {
    final url = Uri.parse('https://ecoguardian.oarman.tech/api/reports/update/${id + 1}');
    try {
      if (image == null) {
        await http.patch(url, headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }, body: {
          'location': '$lat, $long',
          'description': description,
        });
      } else {
        await http.patch(url, headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }, body: {
          'location': '$lat, $long',
          'description': description,
        }).then(
          (value) async {
            final response = json.decode(value.body);

            if (response['success'] != true) {
              throw HttpException('Došlo je do greške');
            }

            await FirebaseStorage.instance.ref().child('${response['data']['id']}.jpg').putFile(image).then((value) async {
              final imageUrl = await value.ref.getDownloadURL();

              final updateUrl = Uri.parse('https://ecoguardian.oarman.tech/api/reports/update/${id + 1}');
              await http.patch(
                updateUrl,
                headers: {
                  'Authorization': 'Bearer $token',
                  'Accept': 'application/json',
                },
                body: {
                  'photo_path': imageUrl,
                },
              ).then((value) {
                final response2 = json.decode(value.body);

                if (response2['success'] != true) {
                  throw HttpException('Došlo je do greške');
                }
              });
            });
          },
        );
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> rrijesiPrijavuBre(id, status) async {
    final url = Uri.parse('https://ecoguardian.oarman.tech/api/reports/update/${int.parse(id) + 1}');
    try {
      if (status == 'Riješena') {
        await await http.patch(url, headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }, body: {
          'status': 'Neriješena',
        }).then((value) {
          print(json.decode(value.body));
        });
      } else {
        await await http.patch(url, headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }, body: {
          'status': 'Riješena',
        }).then((value) {
          print(json.decode(value.body));
        });
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> dodajAktivnost({
    required String naziv,
    required String opis,
    required String lat,
    required String long,
    required String datum,
    required String vrijeme,
  }) async {
    final url = Uri.parse('https://ecoguardian.oarman.tech/api/events/new');
    try {
      await http.post(url, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }, body: {
        'title': naziv,
        'description': opis,
        'latitude': lat,
        'longitude': long,
        'datetime': '$datum|||$vrijeme',
      }).then((value) {
        final response = json.decode(value.body);
        if (response['success'] != true && response['data'] != 'No reports yet!') {
          throw HttpException('Došlo je do greške');
        }
        if (response['success'] != true) {
          throw HttpException('Došlo je do greške');
        }
      });
    } catch (e) {
      throw e;
    }
  }

  Future<List<Aktivnost>> readAktivnosti() async {
    List<Aktivnost> aktivnosti = [];
    final url = Uri.parse('https://ecoguardian.oarman.tech/api/events');
    try {
      await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).then((value) {
        final response = json.decode(value.body);
        if (response['success'] != true) {
          throw HttpException('Došlo je do greške');
        }

        for (var i = 0; i < response['data'].length; i++) {
          int zarez = response['data'][i]['datetime'].indexOf('|||');
          aktivnosti.add(
            Aktivnost(
              naziv: response['data'][i]['title'],
              opis: response['data'][i]['description'],
              lat: response['data'][i]['location']['lat'],
              long: response['data'][i]['location']['long'],
              datum: response['data'][i]['datetime'].substring(0, zarez),
              vrijeme: response['data'][i]['datetime'].substring(zarez + 3, response['data'][i]['datetime'].length),
              likes: response['data'][i]['likes'].toString(),
            ),
          );
        }
        return aktivnosti;
      });

      return aktivnosti;
    } catch (e) {
      throw e;
    }
  }
}
