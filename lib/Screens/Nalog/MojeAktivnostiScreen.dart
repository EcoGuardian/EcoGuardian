import 'package:ecoguardian/components/AktivnostCard.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/PrijavaCard.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/models/Aktivnost.dart';
import 'package:ecoguardian/models/Prijava.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';

class MojeAktivnostiScreen extends StatefulWidget {
  static const String routeName = '/mojeAktivnosti';
  const MojeAktivnostiScreen({Key? key}) : super(key: key);

  @override
  State<MojeAktivnostiScreen> createState() => _MojeAktivnostiScreenState();
}

class _MojeAktivnostiScreenState extends State<MojeAktivnostiScreen> {
  User? currentUser;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
    });
    currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
    if (currentUser == null) {
      await Provider.of<Auth>(context, listen: false).readCurrentUser(Provider.of<Auth>(context, listen: false).getToken).then((value) {
        currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
        setState(() {
          isLoading = false;
        });
      });
    }
  }

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
            'Moje Aktivnosti',
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
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            FutureBuilder(
              future: Provider.of<GeneralProvider>(context).procitajAktivnosti(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.791,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.885,
                    child: Center(
                      child: Text(
                        'Nema podataka',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  );
                }
                List<Aktivnost> aktivnosti = snapshot.data!;
                List<Aktivnost> mojeAktivnosti = [];
                aktivnosti.forEach(
                  (element) {
                    if (element.isLiked == true) {
                      mojeAktivnosti.add(element);
                    }
                  },
                );
                print(mojeAktivnosti);
                if (mojeAktivnosti.isEmpty || mojeAktivnosti == []) {
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.885,
                    child: Center(
                      child: Text(
                        'Nema Aktivnosti',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  );
                }

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                  height: (medijakveri.size.height - medijakveri.padding.top) * 0.885,
                  child: ListView.builder(
                    itemCount: mojeAktivnosti.length,
                    itemBuilder: (context, index) {
                      return AktivnostCard(
                        id: mojeAktivnosti[index].id,
                        naziv: mojeAktivnosti[index].naziv,
                        opis: mojeAktivnosti[index].opis,
                        datum: mojeAktivnosti[index].datum,
                        vrijeme: mojeAktivnosti[index].vrijeme,
                        likes: mojeAktivnosti[index].likes,
                        lat: mojeAktivnosti[index].lat,
                        long: mojeAktivnosti[index].long,
                        isLiked: mojeAktivnosti[index].isLiked,
                        createdAt: aktivnosti[index].createdAt,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
