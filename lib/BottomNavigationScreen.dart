import 'package:ecoguardian/Screens/Main/AktivnostiScreen.dart';
import 'package:ecoguardian/Screens/Main/KanteScreen.dart';
import 'package:ecoguardian/Screens/Main/NalogScreen.dart';
import 'package:ecoguardian/Screens/Main/PrijaviScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:provider/provider.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final List<Widget> _pages = [
    KanteScreen(),
    PrijaviScreen(),
    AktivnostiScreen(),
    NalogScreen(),
  ];

  int _selectedIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
        child: _pages[_selectedIndex],
      ),
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
          iconSize: 35,
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                TablerIcons.trash,
              ),
              label: 'Kante',
            ),
            BottomNavigationBarItem(
              icon: Icon(TablerIcons.alert_triangle),
              label: 'Prijavi',
            ),
            BottomNavigationBarItem(
              icon: Icon(TablerIcons.calendar),
              label: 'Aktivnosti',
            ),
            BottomNavigationBarItem(
              icon: Icon(TablerIcons.user_square),
              label: 'Nalog',
            ),
          ],
        ),
      ),
    );
  }
}
