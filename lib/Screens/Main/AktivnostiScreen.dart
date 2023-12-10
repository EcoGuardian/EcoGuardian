import 'package:ecoguardian/components/AktivnostiCardWidget.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';

class AktivnostiScreen extends StatelessWidget {
  static const String routeName = '/AktivnostiScreen';
  const AktivnostiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: CustomAppBar(
          pageTitle: Text(
            'Aktivnosti',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          isCenter: false,
          horizontalMargin: 0.06,
          drugaIkonica: Container(
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
          drugaIkonicaFunkcija: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
          child: Column(
            children: [
              SizedBox(
                height: (medijakveri.size.height - medijakveri.padding.top) * 0.025,
              ),
              AktivnostiCardWidget(title: 'Čišćenje obale Lima', dateTime: DateTime(2023, 10, 24), time: TimeOfDay(hour: 10, minute: 00), location: 'Polimska, Potkrajci, Bijelo Polje', participants: 1318),
              AktivnostiCardWidget(title: 'Čišćenje obale Lima', dateTime: DateTime(2023, 10, 24), time: TimeOfDay(hour: 10, minute: 00), location: 'Polimska, Potkrajci, Bijelo Polje', participants: 1318),
              AktivnostiCardWidget(title: 'Čišćenje obale Lima', dateTime: DateTime(2023, 10, 24), time: TimeOfDay(hour: 10, minute: 00), location: 'Polimska, Potkrajci, Bijelo Polje', participants: 1318),
            ],
          ),
        ),
      ),
    );
  }
}
