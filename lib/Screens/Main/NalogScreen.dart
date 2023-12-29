import 'package:ecoguardian/Screens/Nalog/EditProfileScreen.dart';
import 'package:ecoguardian/Screens/Main/MojePrijaveScreen.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/NalogItemCard.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';

class NalogScreen extends StatefulWidget {
  static const String routeName = '/NalogScreen';
  const NalogScreen({super.key});

  @override
  State<NalogScreen> createState() => _NalogScreenState();
}

class _NalogScreenState extends State<NalogScreen> {
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: CustomAppBar(
          pageTitle: Text(
            'Moj Nalog',
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
          drugaIkonicaFunkcija: () {
            Navigator.of(context).pushNamed(EditProfileScreen.routeName);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
        child: Column(
          children: [
            NalogItemCard(
              icon: TablerIcons.calendar_month,
              text: 'Moje Aktivnosti',
              funkcija: () {},
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.018),
            NalogItemCard(
              icon: TablerIcons.alert_triangle,
              text: 'Moje Prijave',
              funkcija: () {
                Navigator.of(context).pushNamed(MojePrijaveScreen.routeName);
              },
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
