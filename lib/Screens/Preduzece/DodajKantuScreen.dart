import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ecoguardian/models/Tip.dart';
import 'dart:convert';

class DodajKantuScreen extends StatefulWidget {
  static const String routeName = '/DodajKantuScreen';

  const DodajKantuScreen({super.key});

  @override
  State<DodajKantuScreen> createState() => _DodajKantuScreenState();
}

class _DodajKantuScreenState extends State<DodajKantuScreen> {
  final _form = GlobalKey<FormState>();
  bool isCurrentPosition = false;
  LatLng currentPosition = LatLng(0, 0);
  List<Tip> types = [];
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

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    currentPosition = Provider.of<Auth>(context, listen: false).getCurrentPosition;
    types = Provider.of<GeneralProvider>(context, listen: false).getTypes;

    setState(() {
      isCurrentPosition = true;
    });
  }

  String lokacijaError = '';

  void submit() async {
    setState(() {
      lokacijaError = '';
    });

    if (kantaData['lat'] == '' || kantaData['long'] == '') {
      setState(() {
        lokacijaError = 'Molimo Vas izaberite lokaciju';
      });
      return;
    }

    if (!_form.currentState!.validate()) {
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<GeneralProvider>(context, listen: false).dodajKantu(lat: kantaData['lat'], long: kantaData['long'], typeId: kantaData['typeId']).then(
        (value) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              content: Text(
                'Uspješno ste dodali kantu',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
          // Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        },
      );
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

  Map<String, String> kantaData = {
    'lat': '',
    'long': '',
    'typeId': '',
  };
  String? typeId;

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: CustomAppBar(
          pageTitle: Text(
            'Dodajte Kantu',
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
        child: Column(
          children: [
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Dodajte lokaciju',
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                isCurrentPosition
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: (medijakveri.size.height - medijakveri.padding.top) * 0.5,
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
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
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
                                kantaData['lat'] = position.latitude.toString();
                                kantaData['long'] = position.longitude.toString();
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
                        lokacijaError!,
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
                      kantaData['lat'] = currentPosition.latitude.toString();
                      kantaData['long'] = currentPosition.longitude.toString();
                      lokacijaError = '';
                    });
                  },
                  icon: const Icon(
                    TablerIcons.map_pin_filled,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.01),
              ],
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Izaberite tip kante',
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.015),
                Form(
                  key: _form,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    icon: null,
                    validator: (value) => value == null ? "Molimo Vas da izaberete tip" : null,
                    dropdownColor: Colors.white,
                    hint: Text(
                      'Izaberite tip kante',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    value: typeId,
                    onChanged: (String? newValue) {
                      setState(() {
                        typeId = newValue!;
                        kantaData['typeId'] = newValue;
                      });
                      _form.currentState!.validate();
                    },
                    iconSize: 0,
                    items: types
                        .map(
                          (item) => DropdownMenuItem(
                            child: Text(item.name),
                            value: item.id,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
