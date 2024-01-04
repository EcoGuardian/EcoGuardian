import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/PrijavaCard.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/models/Prijava.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
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
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            FutureBuilder(
              future: Provider.of<GeneralProvider>(context, listen: false).readPrijave(),
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
                        'Nismo našli podatke',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  );
                }
                List<Prijava> prijave = snapshot.data!;
                List<Prijava> mojePrijave = [];
                prijave.forEach(
                  (element) {
                    if (element.userId == currentUser!.id) {
                      mojePrijave.add(element);
                    }
                  },
                );
                if (mojePrijave.isEmpty) {
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.885,
                    child: Center(
                      child: Text(
                        'Nema prijava',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  );
                }

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                  height: (medijakveri.size.height - medijakveri.padding.top) * 0.885,
                  child: ListView.builder(
                    itemCount: mojePrijave.length,
                    itemBuilder: (context, index) {
                      return PrijavaCard(
                        id: index.toString(),
                        userId: (mojePrijave[index].userId),
                        description: mojePrijave[index].description,
                        dateTime: mojePrijave[index].createdAt,
                        lat: mojePrijave[index].lat,
                        long: mojePrijave[index].long,
                        imageUrl: mojePrijave[index].imageUrl,
                        status: mojePrijave[index].status,
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
