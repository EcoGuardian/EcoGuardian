import 'package:ecoguardian/Screens/Prijave/ViewPrijavuScreen.dart';
import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrijavaCard extends StatefulWidget {
  final String description;
  final DateTime dateTime;
  final String lat;
  final String long;
  final String imageUrl;
  final String status;
  final String id;
  final String userId;

  PrijavaCard({
    required this.description,
    required this.dateTime,
    required this.lat,
    required this.long,
    required this.imageUrl,
    required this.status,
    required this.id,
    required this.userId,
  });

  @override
  _PrijavaCardState createState() => _PrijavaCardState();
}

class _PrijavaCardState extends State<PrijavaCard> {
  List<Placemark> mjesto = [];
  bool isLoading = false;
  bool isButtonLoading = false;
  User? currentUser;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
    });
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
    return isLoading
        ? Center(
            child: SizedBox(
              height: (medijakveri.size.height - medijakveri.padding.top) * 0.48,
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPrijavuScreen(
                    id: widget.id,
                    userId: widget.userId,
                    dateTime: widget.dateTime,
                    description: widget.description,
                    imageUrl: widget.imageUrl,
                    lat: widget.lat,
                    long: widget.long,
                    status: widget.status,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(9),
                      topRight: Radius.circular(9),
                    ),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(medijakveri.size.width * 0.025),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Metode.launchInBrowser('https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}');
                          },
                          child: FittedBox(
                            child: Text(
                              // 'djesi',
                              '${mjesto[0].name}, ${mjesto[0].locality}',
                              style: Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.description,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${DateFormat('dd.MM.yyyy.').format(widget.dateTime)} | ${DateFormat('HH:mm').format(widget.dateTime)}",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isButtonLoading
                                ? Container(
                                    width: medijakveri.size.width * 0.5,
                                    child: const Center(child: CircularProgressIndicator()),
                                  )
                                : Button(
                                    buttonText: widget.status,
                                    borderRadius: 10,
                                    visina: 3,
                                    okoTeksta: 20,
                                    icon: Icon(
                                      widget.status == 'Neriješena' ? TablerIcons.circle_x : TablerIcons.circle_check,
                                      color: widget.status == 'Neriješena' ? Theme.of(context).colorScheme.primary : Colors.white,
                                      size: 30,
                                    ),
                                    backgroundColor: widget.status == 'Neriješena' ? Colors.white : Theme.of(context).colorScheme.primary,
                                    textColor: widget.status == 'Neriješena' ? Theme.of(context).colorScheme.primary : Colors.white,
                                    isBorder: widget.status == 'Neriješena' ? true : false,
                                    funkcija: currentUser!.role == 'SuperAdmin' || currentUser!.role == 'Employee'
                                        ? () async {
                                            try {
                                              setState(() {
                                                isButtonLoading = true;
                                              });
                                              await Provider.of<GeneralProvider>(context, listen: false).rrijesiPrijavuBre(widget.id, widget.status).then((value) {
                                                setState(() {
                                                  isButtonLoading = false;
                                                });
                                              });
                                            } catch (e) {
                                              setState(() {
                                                isButtonLoading = false;
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
                                        : () {},
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
