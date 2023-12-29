import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/MojeAktivnostiCard.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/models/Prijava.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';

class MojePrijaveScreen extends StatefulWidget {
  static const String routeName = '/mojePrijave';
  const MojePrijaveScreen({Key? key}) : super(key: key);

  @override
  State<MojePrijaveScreen> createState() => _MojePrijaveScreenState();
}

class _MojePrijaveScreenState extends State<MojePrijaveScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(100, 100),
        child: CustomAppBar(
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
          drugaIkonica: const Icon(
            TablerIcons.circle_check,
            color: Colors.transparent,
          ),
          drugaIkonicaFunkcija: () {},
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: Provider.of<GeneralProvider>(context, listen: false).readPrijave(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                      height: (medijakveri.size.height - medijakveri.padding.top) * 0.91,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  List<Prijava> prijave = snapshot.data!;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.91,
                    child: ListView.builder(
                      itemCount: prijave.length,
                      itemBuilder: (context, index) {
                        return MojeAktivnostiCard(
                          description: prijave[index].description,
                          dateTime: prijave[index].createdAt,
                          lat: prijave[index].lat,
                          long: prijave[index].long,
                          imageUrl: prijave[index].imageUrl,
                          status: prijave[index].status,
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
