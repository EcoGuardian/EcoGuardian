import 'package:ecoguardian/Screens/Preduzece/DodajAktivnostScreen.dart';
import 'package:ecoguardian/components/AktivnostCard.dart';
import 'package:ecoguardian/components/AktivnostiCardWidget.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/models/Aktivnost.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AktivnostiScreen extends StatefulWidget {
  static const String routeName = '/AktivnostiScreen';
  const AktivnostiScreen({super.key});

  @override
  State<AktivnostiScreen> createState() => _AktivnostiScreenState();
}

class _AktivnostiScreenState extends State<AktivnostiScreen> {
  bool isLoading = false;
  User? currentUser;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
          drugaIkonica: currentUser?.role == 'Employee' || currentUser?.role == 'SuperAdmin'
              ? Container(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Icon(
                    TablerIcons.circle_plus,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : Container(
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
          drugaIkonicaFunkcija: currentUser?.role == 'Employee' || currentUser?.role == 'SuperAdmin'
              ? () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DodajAktivnostScreen()));
                }
              : null,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
          child: Column(
            children: [
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
              FutureBuilder(
                future: Provider.of<GeneralProvider>(context).readAktivnosti(),
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
                      height: (medijakveri.size.height - medijakveri.padding.top) * 0.791,
                      child: Center(
                        child: Text('Nismo našli podatke'),
                      ),
                    );
                  }

                  List<Aktivnost> aktivnosti = snapshot.data!;
                  return Container(
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.791,
                    child: ListView.builder(
                      itemCount: aktivnosti.length,
                      itemBuilder: (context, i) {
                        return AktivnostCard(
                          naziv: aktivnosti[i].naziv,
                          opis: aktivnosti[i].opis,
                          lat: aktivnosti[i].lat,
                          long: aktivnosti[i].long,
                          datum: aktivnosti[i].datum,
                          vrijeme: aktivnosti[i].vrijeme,
                          likes: aktivnosti[i].likes,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
