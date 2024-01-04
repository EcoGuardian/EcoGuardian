import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:ecoguardian/components/InputFieldDisabled.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class DodajAktivnostScreen extends StatefulWidget {
  static const String routeName = '/DodajAktivnostScreen';

  const DodajAktivnostScreen({super.key});

  @override
  State<DodajAktivnostScreen> createState() => _DodajAktivnostScreenState();
}

class _DodajAktivnostScreenState extends State<DodajAktivnostScreen> {
  final formKey = GlobalKey<FormState>();

  GoogleMapController? yourMapController;

  //this is the function to load custom map style json
  void changeMapMode(GoogleMapController mapController) {
    getJsonFile("assets/map_style.json").then((value) => setMapStyle(value, mapController));
  }

  //helper function
  void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
  }

  //helper function
  Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  }

  bool isLoading = false;
  bool isCurrentPosition = false;
  LatLng currentPosition = LatLng(0, 0);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    currentPosition = Provider.of<Auth>(context, listen: false).getCurrentPosition;
    setState(() {
      isCurrentPosition = true;
    });
  }

  String lokacijaError = '';
  String datumError = '';
  String vrijemeError = '';

  Map<String, dynamic> aktivnostData = {
    'naziv': '',
    'opis': '',
    'datum': '',
    'vrijeme': '',
    'lat': '',
    'long': '',
  };

  void submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    setState(() {
      lokacijaError = '';
    });
    setState(() {
      datumError = '';
    });
    setState(() {
      vrijemeError = '';
    });

    if (aktivnostData['datum'] == '') {
      setState(() {
        datumError = 'Molimo Vas izaberite datum';
      });
      return;
    }
    if (aktivnostData['vrijeme'] == '') {
      setState(() {
        vrijemeError = 'Molimo Vas izaberite vrijeme';
      });
      return;
    }
    if (aktivnostData['lat'] == '' || aktivnostData['long'] == '') {
      setState(() {
        lokacijaError = 'Molimo Vas izaberite lokaciju';
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<GeneralProvider>(context, listen: false)
          .addAktivnost(
        naziv: aktivnostData['naziv'],
        opis: aktivnostData['opis'],
        lat: aktivnostData['lat'],
        long: aktivnostData['long'],
        datum: aktivnostData['datum'].toString(),
        vrijeme: aktivnostData['vrijeme'].toString(),
      )
          .then((value) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              content: Text(
                'Uspješno ste dodali aktivnost',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Metode.showErrorDialog(
        isJednoPoredDrugog: false,
        context: context,
        naslov: e.toString(),
        button1Text: 'Zatvori',
        button1Fun: () {
          Navigator.pop(context);
        },
        isButton2: false,
      );
    }
  }

  Set<Marker> markers = {};

  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime.now().add(Duration(days: 365));
  void datePicker() {
    showDatePicker(
      context: context,
      initialDate: date1,
      firstDate: DateTime.now(),
      lastDate: date2,
    ).then((value) async {
      if (value == null) {
        return;
      }
      if (value.isAfter(date2)) {
        return;
      }

      setState(() {
        date1 = value;
        aktivnostData['datum'] = value;
      });
    });
  }

  TimeOfDay time = TimeOfDay.now();
  void timePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    ).then((value) {
      setState(() {
        time = value!;
        aktivnostData['vrijeme'] = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100, 100),
          child: CustomAppBar(
            pageTitle: Text(
              'Dodajte Aktivnost',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            isCenter: true,
            horizontalMargin: 0.06,
            prvaIkonica: Container(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  )),
              child: Icon(
                TablerIcons.arrow_big_left_lines,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            prvaIkonicaFunkcija: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();

              Navigator.pop(context);
            },
            drugaIkonica: isLoading
                ? const SizedBox(
                    height: 33,
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    child: Icon(
                      TablerIcons.circle_check,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
            drugaIkonicaFunkcija: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              FocusManager.instance.primaryFocus!.unfocus();
              submit();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputField(
                        medijakveri: medijakveri,
                        hintText: 'Naziv',
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.name,
                        obscureText: false,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Molimo Vas unesite naziv';
                          }
                          if (value.trim().length > 200) {
                            return 'Molimo Vas unesite kraći naziv';
                          }
                          if (value.trim().length < 2) {
                            return 'Molimo Vas unesite duži naziv';
                          }
                        },
                        onSaved: (value) {
                          aktivnostData['naziv'] = value!.trim();
                        },
                        isMargin: true,
                        borderRadijus: 10,
                        isLabel: true,
                        visina: 18,
                        kapitulacija: TextCapitalization.sentences,
                        label: Text(
                          'Naziv',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      InputField(
                        medijakveri: medijakveri,
                        hintText: 'Opis',
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.name,
                        obscureText: false,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Molimo Vas unesite opis';
                          }
                          if (value.trim().length > 200) {
                            return 'Molimo Vas unesite kraći opis';
                          }
                          if (value.trim().length < 2) {
                            return 'Molimo Vas unesite duži opis';
                          }
                        },
                        onSaved: (value) {
                          aktivnostData['opis'] = value!.trim();
                        },
                        isMargin: true,
                        borderRadijus: 10,
                        isLabel: true,
                        visina: 18,
                        kapitulacija: TextCapitalization.sentences,
                        label: Text(
                          'Opis',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        brMinLinija: 1,
                        brMaxLinija: 5,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => datePicker(),
                  child: InputFieldDisabled(
                    medijakveri: medijakveri,
                    label: Text(
                      'Datum',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    text: aktivnostData['datum'] == '' ? 'Datum' : DateFormat('dd.MM.yyyy.').format(date1),
                    borderRadijus: 10,
                    visina: 20,
                    errorString: datumError,
                  ),
                ),
                GestureDetector(
                  onTap: () => timePicker(),
                  child: InputFieldDisabled(
                    medijakveri: medijakveri,
                    label: Text(
                      'Vrijeme',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    text: aktivnostData['vrijeme'] == '' ? 'Vrijeme' : time.format(context),
                    borderRadijus: 10,
                    visina: 20,
                    errorString: vrijemeError,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Dodajte lokaciju',
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
                isCurrentPosition
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: currentPosition,
                              zoom: 15,
                            ),
                            onMapCreated: (GoogleMapController c) {
                              yourMapController = c;
                              changeMapMode(yourMapController!);
                            },
                            compassEnabled: false,
                            mapToolbarEnabled: false,
                            mapType: MapType.normal,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            gestureRecognizers: {
                              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                            },
                            onTap: (position) {
                              setState(() {
                                markers.clear();
                                markers.add(
                                  Marker(
                                    markerId: MarkerId(
                                      DateTime.now().toIso8601String(),
                                    ),
                                    position: position,
                                    icon: BitmapDescriptor.defaultMarker,
                                  ),
                                );
                                aktivnostData['lat'] = position.latitude.toString();
                                aktivnostData['long'] = position.longitude.toString();
                                lokacijaError = '';
                              });
                            },
                            markers: markers,
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                if (lokacijaError != '')
                  Row(
                    children: [
                      Text(
                        lokacijaError,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ],
                  ),
                if (lokacijaError != '') SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                Button(
                  buttonText: 'Trenutna lokacija',
                  borderRadius: 10,
                  visina: 18,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  isBorder: false,
                  funkcija: () {
                    setState(() {
                      markers.clear();
                      markers.add(
                        Marker(
                          markerId: MarkerId(
                            DateTime.now().toIso8601String(),
                          ),
                          position: currentPosition,
                          icon: BitmapDescriptor.defaultMarker,
                        ),
                      );
                      aktivnostData['lat'] = currentPosition.latitude.toString();
                      aktivnostData['long'] = currentPosition.longitude.toString();
                      lokacijaError = '';
                    });
                  },
                  icon: const Icon(
                    TablerIcons.map_pin_filled,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.035),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
