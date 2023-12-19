import 'package:ecoguardian/Screens/Preduzece/DodajKantuScreen.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:ecoguardian/models/Kanta.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/KanteProvider.dart';
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
  List<Kanta> kante = [];
  bool isLoading = false;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
    });
    await Provider.of<Kante>(context, listen: false).readKante().then((value) {
      setState(() {
        kante = Provider.of<Kante>(context, listen: false).getKante;
      });
    });
    await Provider.of<Auth>(context, listen: false).readCurrentUser(Provider.of<Auth>(context, listen: false).getToken).then((value) {
      setState(() {
        currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
        isLoading = false;
      });
    });

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position devicePosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    currentPosition = LatLng(devicePosition.latitude, devicePosition.longitude);

    setState(() {
      isCurrentPosition = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Container(
        child: Column(
          children: [
            CustomAppBar(
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
                  ? const SizedBox(
                      height: 33,
                      child: CircularProgressIndicator(),
                    )
                  : currentUser?.role == 'Employee' || currentUser?.role == 'SuperAdmin'
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
                  ? () {
                      Provider.of<Kante>(context, listen: false).readTypes();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DodajKantuScreen()));
                    }
                  : null,
            ),
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
                        markers: {},
                      ),
                    ),
                  )
                : Container(
                    height: 400,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Container(
              color: Colors.white,
              height: (medijakveri.size.height - medijakveri.padding.top) * 0.263,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: kante.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              TablerIcons.trash,
                              size: 33,
                            ),
                            Text(
                              kante[index].typeName,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
