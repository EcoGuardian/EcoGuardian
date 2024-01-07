import 'package:ecoguardian/Screens/Aktivnosti/ViewAktivnostScreen.dart';
import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AktivnostCard extends StatefulWidget {
  final String id;
  final String naziv;
  final String opis;
  final String lat;
  final String long;
  final String datum;
  final String vrijeme;
  final String likes;
  final bool isLiked;
  final DateTime createdAt;

  AktivnostCard({
    super.key,
    required this.id,
    required this.naziv,
    required this.opis,
    required this.lat,
    required this.long,
    required this.datum,
    required this.vrijeme,
    required this.likes,
    required this.isLiked,
    required this.createdAt,
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

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewAktivnostScreen(
            id: widget.id,
            naziv: widget.naziv,
            opis: widget.opis,
            lat: widget.lat,
            long: widget.long,
            datum: widget.datum,
            vrijeme: widget.vrijeme,
            likes: widget.likes,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 20),
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
                const Icon(
                  TablerIcons.clipboard_text,
                  color: Colors.black,
                ),
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
                  'Datum i vrijeme',
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(width: 5),
                const Icon(
                  TablerIcons.clock,
                  color: Colors.black,
                ),
              ],
            ),
            Text(
              '${DateFormat('dd.MM.yyyy.').format(DateTime.parse(widget.datum))} | ${widget.vrijeme.substring(10, widget.vrijeme.indexOf(':'))}${widget.vrijeme.substring(widget.vrijeme.indexOf(':'), widget.vrijeme.length - 1)}',
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
                const Icon(
                  TablerIcons.map_pin_filled,
                  color: Colors.black,
                ),
              ],
            ),
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
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Broj učesnika: ${widget.likes}',
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(width: 5),
                const Icon(
                  TablerIcons.users,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Button(
                  okoTeksta: 20,
                  buttonText: widget.isLiked ? 'Odustani' : 'Pridruži se',
                  borderRadius: 10,
                  visina: 5,
                  textColor: widget.isLiked ? Theme.of(context).colorScheme.primary : Colors.white,
                  backgroundColor: widget.isLiked ? Colors.white : Theme.of(context).colorScheme.primary,
                  isBorder: widget.isLiked ? true : false,
                  icon: Icon(
                    widget.isLiked ? TablerIcons.circle_x : TablerIcons.circle_check,
                    color: widget.isLiked ? Theme.of(context).colorScheme.primary : Colors.white,
                    size: 28,
                  ),
                  funkcija: () async {
                    await Provider.of<GeneralProvider>(context, listen: false).pridruziSeAktivnosti(id: widget.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
