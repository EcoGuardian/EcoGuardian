import 'package:ecoguardian/Screens/Preduzece/DodajKantuScreen.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';

class KanteScreen extends StatefulWidget {
  static const String routeName = '/KanteScreen';
  const KanteScreen({super.key});

  @override
  State<KanteScreen> createState() => _KanteScreenState();
}

class _KanteScreenState extends State<KanteScreen> {
  final searchController = TextEditingController();
  String? searchString;
  User? user;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<Auth>(context, listen: false).readCurrentUser(Provider.of<Auth>(context, listen: false).getToken);
    user = Provider.of<Auth>(context, listen: false).getCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100, 100),
          child: CustomAppBar(
            pageTitle: Text(
              'Pregled Kanti',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            isCenter: false,
            horizontalMargin: 0.06,
            drugaIkonica: user!.role == 'Employee' || user!.role == 'SuperAdmin'
                ? Container(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    child: Icon(
                      TablerIcons.circle_plus,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : null,
            drugaIkonicaFunkcija: user!.role == 'Employee' || user!.role == 'SuperAdmin'
                ? () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DodajKantuScreen()));
                  }
                : null,
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
          child: Column(
            children: [
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
              TextFormField(
                controller: searchController,
                onChanged: (value) {
                  searchString = value.trim();
                },
                onFieldSubmitted: (_) {},
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  hintText: 'Potražite lokaciju...',
                  hintStyle: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.grey,
                      ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIconColor: Colors.grey,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: const Icon(TablerIcons.search),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<Auth>(context, listen: false).dispose();
  }
}
