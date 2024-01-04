import 'package:ecoguardian/Screens/Main/AktivnostiScreen.dart';
import 'package:ecoguardian/Screens/Main/KanteScreen.dart';
import 'package:ecoguardian/Screens/Main/NalogScreen.dart';
import 'package:ecoguardian/Screens/Main/PrijaviScreen.dart';
import 'package:ecoguardian/Screens/Preduzece/SvePrijaveScreen.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
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

  final List<Widget> preduzeceScreens = [
    KanteScreen(),
    SvePrijaveScreen(),
    AktivnostiScreen(),
    NalogScreen(),
  ];
  final List<Widget> screens = [
    KanteScreen(),
    PrijaviScreen(),
    AktivnostiScreen(),
    NalogScreen(),
  ];

  int _selectedIndex = 0;

  void _selectPage(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: currentUser?.role == 'Employee' || currentUser?.role == 'SuperAdmin' ? preduzeceScreens[_selectedIndex] : screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              width: 0.3,
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
            ),
          ),
        ),
        height: (medijakveri.size.height - medijakveri.padding.top) * 0.1,
        child: BottomNavigationBar(
          onTap: _selectPage,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          iconSize: 30,
          unselectedLabelStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Rubik',
            fontSize: 16,
          ),
          selectedLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Rubik',
            fontSize: 16,
          ),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                TablerIcons.trash,
              ),
              label: 'Kante',
            ),
            BottomNavigationBarItem(
              icon: const Icon(TablerIcons.alert_triangle),
              label: currentUser?.role == 'Employee' || currentUser?.role == 'SuperAdmin' ? 'Prijave' : 'Prijavi',
            ),
            const BottomNavigationBarItem(
              icon: Icon(TablerIcons.calendar_month),
              label: 'Aktivnosti',
            ),
            const BottomNavigationBarItem(
              icon: Icon(TablerIcons.user_square),
              label: 'Nalog',
            ),
          ],
        ),
      ),
    );
  }
}
