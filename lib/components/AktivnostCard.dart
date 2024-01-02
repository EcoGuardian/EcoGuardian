import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class AktivnostCard extends StatefulWidget {
  final String naziv;
  final String opis;
  final String lat;
  final String long;
  final String datum;
  final String vrijeme;
  final String likes;

  AktivnostCard({
    super.key,
    required this.naziv,
    required this.opis,
    required this.lat,
    required this.long,
    required this.datum,
    required this.vrijeme,
    required this.likes,
  });

  @override
  State<AktivnostCard> createState() => _AktivnostCardState();
}

class _AktivnostCardState extends State<AktivnostCard> {
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

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Theme.of(context).textTheme.headline2!.fontSize,
            child: FittedBox(
              child: Text(
                widget.naziv,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Opis',
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(width: 5),
              const Icon(TablerIcons.clock),
            ],
          ),
          Container(
            height: Theme.of(context).textTheme.headline3!.fontSize,
            child: Text(
              widget.opis,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Vrijeme',
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(width: 5),
              const Icon(TablerIcons.clock),
            ],
          ),
          Text(
            "${DateFormat('dd.MM.yyyy.').format(DateTime.parse(widget.datum))} | ${widget.vrijeme.substring(10, widget.vrijeme.indexOf(':'))}${widget.vrijeme.substring(widget.vrijeme.indexOf(':'), widget.vrijeme.length - 1)}",
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Lokacija',
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(width: 5),
              const Icon(TablerIcons.map_pin_filled),
            ],
          ),
          const SizedBox(height: 10),
          isLoading
              ? CircularProgressIndicator()
              : GestureDetector(
                  onTap: () {
                    Metode.launchInBrowser('https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}');
                  },
                  child: FittedBox(
                    child: Text(
                      '${mjesto[0].name}, ${mjesto[0].locality}',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ),
          Row(
            children: [
              Text(
                'Broj učesnika: ${widget.likes}',
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(width: 5),
              const Icon(TablerIcons.users),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Button(
                okoTeksta: 20,
                buttonText: 'Pridruži se',
                borderRadius: 10,
                visina: 5,
                backgroundColor: Theme.of(context).colorScheme.primary,
                isBorder: false,
                icon: Icon(
                  TablerIcons.circle_check,
                  color: Colors.white,
                  size: 28,
                ),
                funkcija: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
