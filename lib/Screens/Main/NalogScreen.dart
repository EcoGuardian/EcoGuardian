import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/NalogItemCard.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';

class NalogScreen extends StatelessWidget {
  static const String routeName = '/NalogScreen';
  const NalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              pageTitle: Text(
                'Moj Nalog',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              isCenter: false,
              drugaIkonica: Container(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                child: Center(
                  child: Container(
                    child: Icon(
                      TablerIcons.pencil,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              drugaIkonicaFunkcija: () {
                print("PITE");
              },
            ),
            NalogItemCard(
              icon: TablerIcons.calendar_month,
              text: 'Moje Aktivnosti',
              funkcija: () {},
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.018),
            NalogItemCard(
              icon: TablerIcons.alert_triangle,
              text: 'Moje Prijave',
              funkcija: () {},
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.018),
            NalogItemCard(
              icon: TablerIcons.logout,
              text: 'Odjavite se',
              funkcija: () {
                Provider.of<Auth>(context, listen: false).logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
