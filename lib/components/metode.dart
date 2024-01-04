import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Metode {
  static Future<bool> checkConnection({required context}) async {
    try {
      await InternetAddress.lookup('google.com');
      return true;
    } catch (error) {
      return false;
    }
  }

  static void showErrorDialog({
    String? message,
    Widget? sifra,
    required BuildContext context,
    required String naslov,
    required String button1Text,
    required Function button1Fun,
    bool isButton1Icon = false,
    Widget? button1Icon,
    required bool isButton2,
    String? button2Text,
    Function? button2Fun,
    bool isButton2Icon = false,
    Widget? button2Icon,
    required bool isJednoPoredDrugog,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final medijakveri = MediaQuery.of(context);

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            naslov,
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          content: message != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 24),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : sifra != null
                  ? sifra
                  : null,
          actions: [
            isJednoPoredDrugog == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => button1Fun(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                // color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isButton1Icon) button1Icon!,
                                  if (isButton1Icon) const SizedBox(width: 5),
                                  Text(
                                    button1Text,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isButton2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => button2Fun!(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  // color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isButton2Icon) button2Icon!,
                                    if (isButton2Icon) const SizedBox(width: 5),
                                    Text(
                                      button2Text!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        // color: Colors.white,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => button1Fun(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            // color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              if (isButton1Icon) button1Icon!,
                              if (isButton1Icon) const SizedBox(width: 5),
                              Text(
                                button1Text,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            if (!isJednoPoredDrugog)
              if (isButton2) const SizedBox(height: 20),
            if (isButton2)
              if (!isJednoPoredDrugog)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => button2Fun!(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          // color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (isButton2Icon) button2Icon!,
                            if (isButton2Icon) const SizedBox(width: 5),
                            Text(
                              button2Text!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        );
      },
    );
  }

  static String getMessageFromErrorCode(error) {
    switch (error) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Taj E-mail je već u upotrebi.";
      case 'invalid-phone-number':
        return 'Taj broj telefona nije validan';
      case "network-request-failed":
        return "Nema internet konekcije";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Pogrešna šifra";
      case "Invalid email or password!":
        return "Pogrešna šifra ili email";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "Ne možemo naći korisnika sa tim E-mailom.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Molimo Vas unesite validnu E-mail adresu.";
      default:
        return "Došlo je do greške. Molimo Vas pokušajte kasnije.";
    }
  }

  static String kanteName(typeName) {
    if (typeName == 'Papir') {
      return 'Kanta za reciklažu papira';
    }
    if (typeName == 'Plastika') {
      return 'Kanta za reciklažu plastike';
    }
    if (typeName == 'Metal') {
      return 'Kanta za reciklažu metala';
    }
    if (typeName == 'Staklo') {
      return 'Kanta za reciklažu stakla';
    }
    if (typeName == 'Opasne materije') {
      return 'Kanta za reciklažu opasnih materija';
    }
    if (typeName == 'Otpad') {
      return 'Kanta za otpad';
    }
    return 'Kanta';
  }

  static Color listaKanteColor(color) {
    if (color == 'hueBlue') {
      return Colors.blue.shade900;
    }
    if (color == 'hueYellow') {
      return Colors.yellow;
    }
    if (color == 'hueCyan') {
      return Colors.cyan;
    }
    if (color == 'hueGreen') {
      return Colors.green;
    }
    if (color == 'hueRed') {
      return Colors.red.shade700;
    }
    if (color == 'hueMagenta') {
      return Colors.purple.shade400;
    }
    return Colors.black;
  }

  static BitmapDescriptor mapKanteColor(color) {
    if (color == 'hueGreen') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
    if (color == 'hueYellow') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    }
    if (color == 'hueBlue') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
    if (color == 'hueCyan') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    }
    if (color == 'hueRed') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
    if (color == 'hueMagenta') {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
    }
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }

  static Future<void> launchInBrowser(String juarel) async {
    final url = Uri.parse(juarel);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // static String? stavke(int kolicina) {
  //   if (kolicina % 10 == 1 && kolicina != 11) {
  //     return 'stavka';
  //   } else if ((kolicina % 10 <= 4 && (kolicina % 100 != 12 && kolicina % 100 != 13 && kolicina % 100 != 14) && kolicina != 0)) {
  //     return 'stavke';
  //   } else {
  //     return 'stavki';
  //   }
  // }

  // static Future<String?> stavke2(Future<int> kolicina) async {
  //   int kolicinaValue = await kolicina;
  //   if (kolicinaValue % 10 == 1 && kolicinaValue != 11) {
  //     return 'stavka';
  //   } else if (kolicinaValue % 10 <= 4 && (kolicinaValue % 100 != 12 && kolicinaValue % 100 != 13 && kolicinaValue % 100 != 14)) {
  //     return 'stavke';
  //   } else {
  //     return 'stavki';
  //   }
  // }
}
