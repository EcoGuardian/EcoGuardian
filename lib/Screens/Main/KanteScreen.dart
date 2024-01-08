import 'dart:math';

import 'package:ecoguardian/Screens/Preduzece/DodajKantuScreen.dart';
import 'package:ecoguardian/Screens/Preduzece/UrediKantuScreen.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/models/Kanta.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class KanteScreen extends StatefulWidget {
  static const String routeName = '/KanteScreen';
  const KanteScreen({super.key});

  @override
  State<KanteScreen> createState() => _KanteScreenState();
}

class _KanteScreenState extends State<KanteScreen> {
  bool isCurrentPosition = false;
  LatLng currentPosition = LatLng(0, 0);

  User? currentUser;

  Set<Marker> markeri = {};
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

    try {
      setState(() {
        isLoading = true;
      });

      currentPosition = Provider.of<Auth>(context, listen: false).getCurrentPosition;
      if (currentPosition == LatLng(0, 0)) {
        await Provider.of<Auth>(context, listen: false).setCurrentPosition().then((value) async {
          currentPosition = Provider.of<Auth>(context, listen: false).getCurrentPosition;
        });
      }
      if (markeri.isEmpty) {
        await Provider.of<GeneralProvider>(context).procitajKante().then((value) {
          if (value.isNotEmpty) {
            for (var i = 0; i < value.length; i++) {
              final duzina = sqrt((double.parse(value[i].lat).abs() - currentPosition.latitude.abs()).abs() + (double.parse(value[i].long).abs() - currentPosition.longitude.abs()).abs());

              if (duzina < 0.37) {
                markeri.add(
                  Marker(
                    markerId: MarkerId(value[i].id),
                    position: LatLng(
                      double.parse(value[i].lat),
                      double.parse(value[i].long),
                    ),
                    icon: Metode.mapKanteColor(value[i].typeColor),
                    infoWindow: InfoWindow(title: value[i].typeName),
                  ),
                );
              }
            }
          }
        });
      }

      if (currentUser == null) {
        currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
        if (currentUser == null) {
          await Provider.of<Auth>(context, listen: false).readCurrentUser(Provider.of<Auth>(context, listen: false).getToken).then((value) {
            currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
          });
        }
      }
      setState(() {
        isLoading = false;
        isCurrentPosition = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isCurrentPosition = false;
      });
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
            'Pregled Kanti',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          isCenter: false,
          horizontalMargin: 0.06,
          drugaIkonica: isLoading
              ? CircularProgressIndicator()
              : currentUser!.role == 'Employee' || currentUser!.role == 'SuperAdmin'
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Icon(
                        TablerIcons.circle_plus,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.transparent,
                          )),
                      child: const Icon(
                        TablerIcons.circle_check,
                        color: Colors.transparent,
                      ),
                    ),
          drugaIkonicaFunkcija: currentUser?.role == 'Employee' || currentUser?.role == 'SuperAdmin'
              ? () async {
                  await Provider.of<GeneralProvider>(context, listen: false).procitajTipove().then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DodajKantuScreen()));
                  });
                }
              : null,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            isCurrentPosition
                ? Container(
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.5,
                    margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: currentPosition,
                          zoom: 15,
                        ),
                        onMapCreated: (GoogleMapController c) {
                          yourMapController = c;
                          changeMapMode(yourMapController!);
                        },
                        trafficEnabled: false,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        markers: markeri,
                      ),
                    ),
                  )
                : Container(
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.5,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            FutureBuilder(
              future: Provider.of<GeneralProvider>(context).procitajKante(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.262,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                List<Kanta> sveKante = snapshot.data!;
                List<Kanta> kante = [];
                for (var i = 0; i < sveKante.length; i++) {
                  final duzina = sqrt((double.parse(sveKante[i].lat) - currentPosition.latitude).abs() + (double.parse(sveKante[i].long) - currentPosition.longitude).abs());
                  if (duzina < 0.37) {
                    kante.add(
                      Kanta(
                        id: sveKante[i].id,
                        lat: sveKante[i].lat,
                        long: sveKante[i].long,
                        typeId: sveKante[i].typeId,
                        typeName: sveKante[i].typeName,
                        typeColor: sveKante[i].typeColor,
                        createdAt: sveKante[i].createdAt,
                      ),
                    );
                  }
                }
                kante.sort((a, b) {
                  if (sqrt((double.parse(a.lat) - currentPosition.latitude).abs() + (double.parse(a.long) - currentPosition.longitude).abs()) < sqrt((double.parse(b.lat) - currentPosition.latitude).abs() + (double.parse(b.long) - currentPosition.longitude).abs())) {
                    return 0;
                  } else {
                    return 1;
                  }
                });

                if (kante.isEmpty) {
                  return Container(
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.262,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Nema podataka',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  );
                }

                return Container(
                  height: (medijakveri.size.height - medijakveri.padding.top) * 0.262,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: kante.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          yourMapController!.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  double.parse(kante[index].lat),
                                  double.parse(kante[index].long),
                                ),
                                zoom: 15,
                              ),
                            ),
                          );
                        },
                        onLongPress: isLoading
                            ? () {}
                            : currentUser!.role == 'Employee' || currentUser!.role == 'SuperAdmin'
                                ? () {
                                    Metode.showErrorDialog(
                                      isJednoPoredDrugog: false,
                                      context: context,
                                      naslov: 'Koju akciju želite da izvršite?',
                                      button1Text: 'Uredite kantu',
                                      button1Fun: () async {
                                        Navigator.pop(context);
                                        await Provider.of<GeneralProvider>(context, listen: false).procitajTipove().then((value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UrediKantuScreen(
                                                id: kante[index].id,
                                                lat: kante[index].lat,
                                                long: kante[index].long,
                                                typeId: kante[index].typeId,
                                                typeName: kante[index].typeName,
                                                typeColor: kante[index].typeColor,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      isButton1Icon: true,
                                      button1Icon: Icon(
                                        TablerIcons.pencil,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      isButton2: true,
                                      button2Text: 'Obrišite kantu',
                                      button2Fun: () async {
                                        await Provider.of<GeneralProvider>(context, listen: false).obrisiKantu(kante[index].id).then((value) {
                                          setState(() {
                                            markeri.removeWhere((element) => element.markerId.value == kante[index].id);
                                          });

                                          Navigator.pop(context);
                                        });
                                      },
                                      isButton2Icon: true,
                                      button2Icon: Icon(
                                        TablerIcons.trash,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    );
                                  }
                                : () {},
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    TablerIcons.trash,
                                    size: 33,
                                  ),
                                  Text(
                                    Metode.kanteName(kante[index].typeName),
                                    style: Theme.of(context).textTheme.headline4,
                                  ),
                                ],
                              ),
                              Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  color: Metode.listaKanteColor(kante[index].typeColor),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
