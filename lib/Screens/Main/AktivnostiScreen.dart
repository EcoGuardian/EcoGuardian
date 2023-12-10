import 'package:ecoguardian/components/AktivnostiCardWidget.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AktivnostiScreen extends StatelessWidget {
  static const String routeName = '/AktivnostiScreen';
  const AktivnostiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                pageTitle: Text(
                  'Aktivnosti',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                isCenter: false,
              ),
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025,),
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
