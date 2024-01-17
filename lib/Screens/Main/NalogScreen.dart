import 'package:ecoguardian/Screens/Nalog/UrediteNalogScreen.dart';
import 'package:ecoguardian/Screens/Nalog/MojeAktivnostiScreen.dart';
import 'package:ecoguardian/Screens/Nalog/MojePrijaveScreen.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/NalogItemCard.dart';
import 'package:ecoguardian/models/User.dart';
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
  User? currentUser;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false).readCurrentUser(Provider.of<Auth>(context, listen: false).getToken).then((value) {
      currentUser = Provider.of<Auth>(context, listen: false).getCurrentUser;
      setState(() {
        isLoading = false;
      });
    });
  }

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
            Navigator.of(context).pushNamed(UrediteNalogScreen.routeName);
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
              child: Column(
                children: [
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        currentUser!.profilePicture == null
                            ? Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(38),
                                ),
                                child: Icon(
                                  TablerIcons.user_square_rounded,
                                  size: 50,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(38),
                                child: Image.network(
                                  currentUser!.profilePicture!,
                                  height: 75,
                                  width: 75,
                                  fit: BoxFit.fill,
                                ),
                              ),
                        SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.01),
                        Text(
                          currentUser!.name,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.01),
                        Text(
                          currentUser!.email,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.04),
                  NalogItemCard(
                    icon: TablerIcons.calendar_month,
                    text: 'Moje Aktivnosti',
                    funkcija: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MojeAktivnostiScreen()));
                    },
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.018),
                  if (currentUser!.role == 'Default')
                    NalogItemCard(
                      icon: TablerIcons.alert_triangle,
                      text: 'Moje Prijave',
                      funkcija: () {
                        Navigator.of(context).pushNamed(MojePrijaveScreen.routeName);
                      },
                    ),
                  if (currentUser!.role == 'Default') SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.018),
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
