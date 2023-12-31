import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class PrijavaViewScreen extends StatefulWidget {
  final String description;
  final DateTime dateTime;
  final String lat;
  final String long;
  final String imageUrl;
  final String status;
  static const String routeName = '/PrijavaViewScreen';

  const PrijavaViewScreen({
    super.key,
    required this.description,
    required this.dateTime,
    required this.lat,
    required this.long,
    required this.imageUrl,
    required this.status,
  });

  @override
  State<PrijavaViewScreen> createState() => _PrijavaViewScreenState();
}

class _PrijavaViewScreenState extends State<PrijavaViewScreen> {
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, (medijakveri.size.height - medijakveri.padding.top) * 0.9),
        child: CustomAppBar(
          pageTitle: Text(
            'Prijava',
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
          drugaIkonica: Container(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                )),
            child: Icon(
              TablerIcons.pencil,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          drugaIkonicaFunkcija: () {},
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
        child: Column(
          children: [
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(widget.imageUrl),
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokacija i Datum',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsetsDirectional.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
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
                      SizedBox(height: 15),
                      Text(
                        "${DateFormat('dd.MM.yyyy.').format(widget.dateTime)} | ${DateFormat('HH:mm').format(widget.dateTime)}",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsetsDirectional.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  child: Text(
                    widget.status,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                )
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
                SizedBox(height: 10),
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
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.description,

                        // 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnesAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnes',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
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
