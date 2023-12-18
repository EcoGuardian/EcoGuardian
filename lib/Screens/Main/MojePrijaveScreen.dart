import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/MojePrijaveCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class MojePrijaveScreen extends StatelessWidget {
  static const String routeName = '/mojePrijave';
  const MojePrijaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: CustomAppBar(
          prvaIkonica: Container(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              )
            ),
            child: Icon(
              TablerIcons.arrow_big_left_lines,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          prvaIkonicaFunkcija: () {
            Navigator.pop(context);
          },
          pageTitle: Text(
            'Moje prijave',
            style: Theme.of(context).textTheme.headline2!.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          isCenter: true,
          horizontalMargin: 0.06,
          drugaIkonica: Container(
            child: const Icon(
              TablerIcons.circle_check,
              color: Colors.transparent,
            ),
          ),
          drugaIkonicaFunkcija: () {},
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03,),
              MojeAktivnostiCard(description: "Neki opis blablablabla", dateTime: DateTime(2023, 10, 24), time: TimeOfDay(hour: 18, minute: 00), location: "Polimska, Potkrajci, Bijelo Polje", image: "assets/images/deponija.jpg",),
              MojeAktivnostiCard(description: "Neki opis blablablabla", dateTime: DateTime(2023, 10, 24), time: TimeOfDay(hour: 18, minute: 00), location: "Polimska, Potkrajci, Bijelo Polje", image: "assets/images/deponija.jpg",),
              MojeAktivnostiCard(description: "Neki opis blablablabla", dateTime: DateTime(2023, 10, 24), time: TimeOfDay(hour: 18, minute: 00), location: "Polimska, Potkrajci, Bijelo Polje", image: "assets/images/deponija.jpg",),
            ],
          ),
        ),
      ),
    );
  }
}
