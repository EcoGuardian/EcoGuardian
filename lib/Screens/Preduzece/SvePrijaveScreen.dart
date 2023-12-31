import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/PrijavaCard.dart';
import 'package:ecoguardian/models/Prijava.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';

class SvePrijaveScreen extends StatefulWidget {
  static const String routeName = '/SvePrijaveScreen';

  const SvePrijaveScreen({super.key});

  @override
  State<SvePrijaveScreen> createState() => _SvePrijaveScreenState();
}

class _SvePrijaveScreenState extends State<SvePrijaveScreen> {
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, (medijakveri.size.height - medijakveri.padding.top) * 0.084),
        child: CustomAppBar(
          pageTitle: Text(
            'Prijave',
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
      body: Column(
        children: [
          FutureBuilder(
            future: Provider.of<GeneralProvider>(context, listen: false).readPrijave(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                  height: (medijakveri.size.height - medijakveri.padding.top) * 0.81,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              List<Prijava> prijave = snapshot.data!;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                height: (medijakveri.size.height - medijakveri.padding.top) * 0.816,
                child: ListView.builder(
                  itemCount: prijave.length,
                  itemBuilder: (context, index) {
                    return PrijavaCard(
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
            },
          ),
        ],
      ),
    );
  }
}
