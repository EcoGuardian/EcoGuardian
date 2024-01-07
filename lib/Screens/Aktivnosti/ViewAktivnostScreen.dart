import 'package:ecoguardian/Screens/Aktivnosti/UrediAktivnostScreen.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/InputFieldDisabled.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewAktivnostScreen extends StatefulWidget {
  static const String routeName = '/ViewAktivnostScreen';

  final String id;
  final String naziv;
  final String opis;
  final String datum;
  final String vrijeme;
  final String lat;
  final String long;
  final String likes;
  const ViewAktivnostScreen({
    super.key,
    required this.id,
    required this.naziv,
    required this.opis,
    required this.datum,
    required this.vrijeme,
    required this.lat,
    required this.long,
    required this.likes,
  });

  @override
  State<ViewAktivnostScreen> createState() => _ViewAktivnostScreenState();
}

class _ViewAktivnostScreenState extends State<ViewAktivnostScreen> {
  bool isLoading = false;
  User? currentUser;
  List<Placemark> mjesto = [];

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
    if (currentUser == null) {
      await Provider.of<Auth>(context, listen: false).readCurrentUser(Provider.of<Auth>(context, listen: false).getToken).then((value) {
        currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
        setState(() {
          isLoading = false;
        });
      });
    }
    mjesto = await placemarkFromCoordinates(double.parse(widget.lat), double.parse(widget.long)).then((value) {
      setState(() {
        isLoading = false;
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, (medijakveri.size.height - medijakveri.padding.top) * 0.9),
        child: CustomAppBar(
          pageTitle: Text(
            'Aktivnost',
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
          drugaIkonica: currentUser?.role == 'Employee' || currentUser?.role == 'SuperAdmin'
              ? Container(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  child: Icon(
                    TablerIcons.dots_vertical,
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
                  child: Icon(
                    TablerIcons.pencil,
                    color: Colors.transparent,
                  ),
                ),
          drugaIkonicaFunkcija: currentUser?.role == 'Employee' || currentUser?.role == 'SuperAdmin'
              ? () {
                  Metode.showErrorDialog(
                    isJednoPoredDrugog: false,
                    context: context,
                    naslov: 'Koju akciju želite da izvršite?',
                    button1Text: 'Uredite aktivnost',
                    button1Fun: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UrediAktivnostScreen(
                            id: widget.id,
                            naziv: widget.naziv,
                            opis: widget.opis,
                            datum: widget.datum,
                            vrijeme: widget.vrijeme,
                            lat: widget.lat,
                            long: widget.long,
                          ),
                        ),
                      );
                    },
                    isButton1Icon: true,
                    button1Icon: Icon(
                      TablerIcons.pencil,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    isButton2: true,
                    button2Text: 'Obrišite aktivnost',
                    button2Fun: () async {
                      await Provider.of<GeneralProvider>(context, listen: false).obrisiAktivnost(widget.id).then((value) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            content: Text(
                              'Uspješno ste obrisali aktivnost',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
        child: Column(
          children: [
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Naziv',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsetsDirectional.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  child: Text(
                    widget.naziv,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Opis',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  // height: 150,
                  constraints: BoxConstraints(
                    minHeight: (medijakveri.size.height - medijakveri.padding.top) * 0.05,
                    maxHeight: (medijakveri.size.height - medijakveri.padding.top) * 0.2,
                  ),
                  padding: const EdgeInsetsDirectional.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.opis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Datum i vrijeme',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsetsDirectional.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  child: Text(
                    '${DateFormat('dd.MM.yyyy.').format(DateTime.parse(widget.datum))} | ${widget.vrijeme.substring(10, widget.vrijeme.indexOf(':'))}${widget.vrijeme.substring(widget.vrijeme.indexOf(':'), widget.vrijeme.length - 1)}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokacija',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  // height: 150,
                  constraints: BoxConstraints(
                    minHeight: (medijakveri.size.height - medijakveri.padding.top) * 0.05,
                    maxHeight: (medijakveri.size.height - medijakveri.padding.top) * 0.2,
                  ),
                  padding: const EdgeInsetsDirectional.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () {
                        Metode.launchInBrowser('https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}');
                      },
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              '${mjesto[0].name}, ${mjesto[0].locality}',
                              style: Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Broj učesnika',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsetsDirectional.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  child: Text(
                    widget.likes,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
