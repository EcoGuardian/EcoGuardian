import 'package:ecoguardian/Screens/Preduzece/DodajKantuScreen.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/models/Kanta.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<GeneralProvider>(context).readKante().then((value) {
        if (value.isNotEmpty) {
          for (var i = 0; i < value.length; i++) {
            markeri.add(
              Marker(
                markerId: MarkerId(value[i].createdAt),
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
      });
      currentPosition = Provider.of<Auth>(context, listen: false).getCurrentPosition;
      if (currentPosition == LatLng(0, 0)) {
        await Provider.of<Auth>(context, listen: false).setCurrentPosition().then((value) async {
          currentPosition = Provider.of<Auth>(context, listen: false).getCurrentPosition;
        });
      }
      currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
      if (currentUser == null) {
        await Provider.of<Auth>(context, listen: false).readCurrentUser(Provider.of<Auth>(context, listen: false).getToken).then((value) {
          currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
          setState(() {
            isLoading = false;
          });
        });
      }
      setState(() {
        isCurrentPosition = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
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
          drugaIkonica: currentUser?.role == 'Employee' || currentUser?.role == 'SuperAdmin'
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
                  await Provider.of<GeneralProvider>(context, listen: false).readTypes().then((value) {
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
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        mapType: MapType.normal,
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
              future: Provider.of<GeneralProvider>(context).readKante(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Kanta> kante = snapshot.data!;

                if (kante.isEmpty) {
                  return Container(
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.263,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Nismo našli podatke',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  );
                }

                return Container(
                  height: (medijakveri.size.height - medijakveri.padding.top) * 0.263,
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
                      return Container(
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
