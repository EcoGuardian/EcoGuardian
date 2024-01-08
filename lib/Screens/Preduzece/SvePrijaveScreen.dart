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
  String filter = 'sve';
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
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
          drugaIkonica: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (filter == 'rijesene') {
                          filter = 'sve';
                        } else {
                          filter = 'rijesene';
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: (medijakveri.size.height - medijakveri.padding.top) * 0.04,
                      width: 100,
                      decoration: filter != 'rijesene'
                          ? BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left: BorderSide(color: Theme.of(context).colorScheme.primary),
                                top: BorderSide(color: Theme.of(context).colorScheme.primary),
                                bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            )
                          : BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                      child: Center(
                        child: Text(
                          'Riješene',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                                color: filter != 'rijesene' ? Theme.of(context).colorScheme.primary : Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (filter == 'nerijesene') {
                          filter = 'sve';
                        } else {
                          filter = 'nerijesene';
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: (medijakveri.size.height - medijakveri.padding.top) * 0.04,
                      width: 100,
                      decoration: filter != 'nerijesene'
                          ? BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            )
                          : BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                      child: Center(
                        child: Text(
                          'Neriješene',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                                color: filter != 'nerijesene' ? Theme.of(context).colorScheme.primary : Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          drugaIkonicaFunkcija: () {},
        ),
      ),
      body: Column(
        children: [
          Container(
            height: (medijakveri.size.height - medijakveri.padding.top) * 0.025,
          ),
          FutureBuilder(
            future: Provider.of<GeneralProvider>(context).procitajPrijave(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                  height: (medijakveri.size.height - medijakveri.padding.top) * 0.787,
                  child: const Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              List<Prijava> prijave = snapshot.data!;
              prijave.sort(
                (a, b) {
                  if (a.createdAt.isAfter(b.createdAt)) {
                    return 0;
                  }
                  return 1;
                },
              );
              List<Prijava> filterPrijave = [];
              if (filter == 'rijesene') {
                for (var i = 0; i < prijave.length; i++) {
                  if (prijave[i].status == 'Riješena') {
                    filterPrijave.add(
                      Prijava(
                        id: prijave[i].id,
                        userId: prijave[i].userId,
                        imageUrl: prijave[i].imageUrl,
                        lat: prijave[i].lat,
                        long: prijave[i].long,
                        description: prijave[i].description,
                        status: prijave[i].status,
                        createdAt: prijave[i].createdAt,
                      ),
                    );
                  }
                }
              } else if (filter == 'nerijesene') {
                for (var i = 0; i < prijave.length; i++) {
                  if (prijave[i].status == 'Neriješena') {
                    filterPrijave.add(
                      Prijava(
                        id: prijave[i].id,
                        userId: prijave[i].userId,
                        imageUrl: prijave[i].imageUrl,
                        lat: prijave[i].lat,
                        long: prijave[i].long,
                        description: prijave[i].description,
                        status: prijave[i].status,
                        createdAt: prijave[i].createdAt,
                      ),
                    );
                  }
                }
              } else {
                for (var i = 0; i < prijave.length; i++) {
                  filterPrijave.add(
                    Prijava(
                      id: prijave[i].id,
                      userId: prijave[i].userId,
                      imageUrl: prijave[i].imageUrl,
                      lat: prijave[i].lat,
                      long: prijave[i].long,
                      description: prijave[i].description,
                      status: prijave[i].status,
                      createdAt: prijave[i].createdAt,
                    ),
                  );
                }
              }
              if (filterPrijave.isEmpty) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                  height: (medijakveri.size.height - medijakveri.padding.top) * 0.787,
                  child: Center(
                    child: Text(
                      'Nema podataka',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                );
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                height: (medijakveri.size.height - medijakveri.padding.top) * 0.787,
                child: ListView.builder(
                  itemCount: filterPrijave.length,
                  itemBuilder: (context, index) {
                    return PrijavaCard(
                      id: filterPrijave[index].id,
                      userId: filterPrijave[index].userId,
                      description: filterPrijave[index].description,
                      dateTime: filterPrijave[index].createdAt,
                      lat: filterPrijave[index].lat,
                      long: filterPrijave[index].long,
                      imageUrl: filterPrijave[index].imageUrl,
                      status: filterPrijave[index].status,
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
