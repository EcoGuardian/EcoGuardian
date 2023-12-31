import 'package:ecoguardian/Screens/Prijave/PrijavaViewScreen.dart';
import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/metode.dart';
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

  PrijavaCard({
    required this.description,
    required this.dateTime,
    required this.lat,
    required this.long,
    required this.imageUrl,
    required this.status,
  });

  @override
  _PrijavaCardState createState() => _PrijavaCardState();
}

class _PrijavaCardState extends State<PrijavaCard> {
  List<Placemark> mjesto = [];
  bool isLoading = false;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
    });
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
        ? CircularProgressIndicator()
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrijavaViewScreen(
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
              margin: EdgeInsets.only(bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
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
                            Button(
                              buttonText: widget.status,
                              borderRadius: 10,
                              visina: 3,
                              okoTeksta: 20,
                              icon: Icon(
                                widget.status == 'Neriješena' ? TablerIcons.xbox_x : TablerIcons.circle_check,
                                color: widget.status == 'Neriješena' ? Theme.of(context).colorScheme.primary : Colors.white,
                                size: 30,
                              ),
                              backgroundColor: widget.status != 'Neriješena' ? Theme.of(context).colorScheme.primary : Colors.white,
                              textColor: widget.status == 'Neriješena' ? Theme.of(context).colorScheme.primary : Colors.white,
                              isBorder: widget.status == 'Neriješena' ? true : false,
                              funkcija: () {},
                            ),
                            GestureDetector(
                              onTap: () {
                                Metode.showErrorDialog(
                                  isJednoPoredDrugog: false,
                                  context: context,
                                  naslov: 'Koju akciju želite da izvršite?',
                                  button1Text: 'Izmijenite prijavu',
                                  isButton1Icon: true,
                                  button1Icon: Icon(
                                    TablerIcons.edit,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  button1Fun: () {
                                    Navigator.pop(context);
                                  },
                                  isButton2: true,
                                  button2Text: 'Izbrišite prijavu',
                                  isButton2Icon: true,
                                  button2Icon: Icon(
                                    TablerIcons.trash_x,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  button2Fun: () async {},
                                );
                              },
                              child: Icon(
                                TablerIcons.dots_vertical,
                              ),
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
