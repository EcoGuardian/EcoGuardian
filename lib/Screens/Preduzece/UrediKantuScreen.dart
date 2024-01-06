import 'dart:math';

import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ecoguardian/models/Tip.dart';

import 'dart:convert';

import 'package:provider/provider.dart';

class UrediKantuScreen extends StatefulWidget {
  static const String routeName = '/UrediKantuScreen';

  final String id;
  final String lat;
  final String long;
  final String typeId;
  final String typeName;
  final String typeColor;
  const UrediKantuScreen({
    super.key,
    required this.id,
    required this.lat,
    required this.long,
    required this.typeId,
    required this.typeName,
    required this.typeColor,
  });

  @override
  State<UrediKantuScreen> createState() => _UrediKantuScreenState();
}

class _UrediKantuScreenState extends State<UrediKantuScreen> {
  final _form = GlobalKey<FormState>();
  List<Tip> types = [];
  bool isLoading = false;
  Set<Marker> markeri = {};

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
    types = Provider.of<GeneralProvider>(context, listen: false).getTypes;
    if (markeri.isEmpty) {
      markeri.add(
        Marker(
          markerId: MarkerId(widget.id),
          position: LatLng(
            double.parse(widget.lat),
            double.parse(widget.long),
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
  }

  Map<String, String> kantaData = {
    'lat': '',
    'long': '',
    'typeId': '',
  };
  @override
  void initState() {
    super.initState();
    kantaData['lat'] = widget.lat;
    kantaData['long'] = widget.long;
    kantaData['typeId'] = widget.typeId;
  }

  String? typeId;

  void submit() async {
    if (kantaData['lat'] == '' || kantaData['long'] == '') {
      return;
    }

    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<GeneralProvider>(context, listen: false)
          .urediKantu(
        lat: kantaData['lat'],
        long: kantaData['long'],
        typeId: kantaData['typeId'],
        id: widget.id,
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
              'Uspješno ste uredili kantu',
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: CustomAppBar(
          pageTitle: Text(
            'Uredite Kantu',
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
                      'Uredite lokaciju',
                      style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.5,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(double.parse(widget.lat), double.parse(widget.long)),
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
                          kantaData['lat'] = position.latitude.toString();
                          kantaData['long'] = position.longitude.toString();
                        });
                      },
                      markers: markeri,
                    ),
                  ),
                ),
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
                    value: widget.typeId,
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
