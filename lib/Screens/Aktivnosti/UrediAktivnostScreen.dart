import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:ecoguardian/components/InputFieldDisabled.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UrediAktivnostScreen extends StatefulWidget {
  static const String routeName = '/UrediAktivnostScreen';
  final String id;
  final String naziv;
  final String opis;
  final String datum;
  final String vrijeme;
  final String lat;
  final String long;
  const UrediAktivnostScreen({
    super.key,
    required this.id,
    required this.naziv,
    required this.opis,
    required this.datum,
    required this.vrijeme,
    required this.lat,
    required this.long,
  });

  @override
  State<UrediAktivnostScreen> createState() => _UrediAktivnostScreenState();
}

class _UrediAktivnostScreenState extends State<UrediAktivnostScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  GoogleMapController? yourMapController;

  void changeMapMode(GoogleMapController mapController) {
    getJsonFile("assets/map_style.json").then((value) => setMapStyle(value, mapController));
  }

  void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
  }

  Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  }

  bool isCurrentPosition = false;
  LatLng currentPosition = LatLng(0, 0);
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    currentPosition = LatLng(double.parse(widget.lat), double.parse(widget.long));
    if (markeri.isEmpty) {
      markeri.add(
        Marker(
          markerId: MarkerId(DateTime.now().toString()),
          position: LatLng(
            double.parse(widget.lat),
            double.parse(widget.long),
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
    setState(() {
      isCurrentPosition = true;
    });
  }

  @override
  void initState() {
    super.initState();
    aktivnostData['naziv'] = widget.naziv;
    aktivnostData['opis'] = widget.opis;
    aktivnostData['datum'] = widget.naziv;
    aktivnostData['vrijeme'] = widget.vrijeme;
    aktivnostData['lat'] = widget.lat;
    aktivnostData['long'] = widget.long;
    date1 = DateTime.parse(widget.datum);
    time = TimeOfDay(hour: int.parse(widget.vrijeme.substring(10, widget.vrijeme.indexOf(':'))), minute: int.parse(widget.vrijeme.substring(widget.vrijeme.indexOf(':') + 1, widget.vrijeme.length - 1)));
  }

  Map<String, dynamic> aktivnostData = {
    'naziv': '',
    'opis': '',
    'datum': '',
    'vrijeme': '',
    'lat': '',
    'long': '',
  };

  Set<Marker> markeri = {};

  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime.now().add(Duration(days: 365));
  void datePicker() {
    FocusManager.instance.primaryFocus!.unfocus();

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
    FocusManager.instance.primaryFocus!.unfocus();

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

  void submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<GeneralProvider>(context, listen: false)
          .urediAktivnost(
        id: widget.id,
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
        });
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            content: Text(
              'Uspješno ste uredili aktivnost',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      Metode.showErrorDialog(
        isJednoPoredDrugog: false,
        context: context,
        naslov: 'Došlo je do greške',
        button1Text: 'Zatvori',
        button1Fun: () {
          Navigator.pop(context);
        },
        isButton2: false,
      );
    }
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
              'Uredite Aktivnost',
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
                ? SizedBox(
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
              submit();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
            child: Column(
              children: [
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputField(
                        initalValue: widget.naziv,
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
                        initalValue: widget.opis,
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
                    hintTextColor: Colors.black,
                    text: DateFormat('dd.MM.yyyy.').format(date1),
                    borderRadijus: 10,
                    visina: 20,
                    errorString: '',
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
                    hintTextColor: Colors.black,
                    text: time.format(context),
                    borderRadijus: 10,
                    visina: 20,
                    errorString: '',
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Uredite lokaciju',
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
                isCurrentPosition
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: (medijakveri.size.height - medijakveri.padding.top) * 0.4,
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
                                markeri.clear();
                                markeri.add(
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
                              });
                            },
                            markers: markeri,
                          ),
                        ),
                      )
                    : Container(
                        height: (medijakveri.size.height - medijakveri.padding.top) * 0.4,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.035),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
