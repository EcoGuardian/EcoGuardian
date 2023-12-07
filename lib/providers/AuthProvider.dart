import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  Future<void> register({
    required String email,
    required String ime,
    required String prezime,
    required String sifra,
    required String sifraPot,
  }) async {
    print(email);
    print(ime);
    print(prezime);
    print(sifra);
    print(sifraPot);
  }
}
