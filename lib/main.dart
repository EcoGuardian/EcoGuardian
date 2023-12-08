import 'package:ecoguardian/Screens/Auth/ForgottenPasswordScreen.dart';
import 'package:ecoguardian/Screens/Auth/RegisterScreen.dart';
import 'package:ecoguardian/Screens/Auth/WelcomeScreen.dart';
import 'package:ecoguardian/Screens/Main/KanteScreen.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFDAECDE),
            primaryColor: const Color(0xFF0B6D00),
            colorScheme: ThemeData().colorScheme.copyWith(
                  primary: const Color(0xFF0B6D00), // da bi suffix ikonica i border input polja(u search baru) promijenila boju kad je focused
                  secondary: Color(0xFFC9F3C5),
                  tertiary: const Color(0xFF38C828),
                ),
            textTheme: const TextTheme(
              headline1: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 36,
                color: Color(0xFF000000),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
              headline2: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 24,
                color: Color(0xFF000000),
              ),
              headline3: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 20,
                color: Color(0xFF000000),
                letterSpacing: .7,
              ),
              headline4: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 16,
                color: Color(0xFF000000),
                // letterSpacing: 0.1,
              ),
              headline5: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 12,
                color: Color(0xFF000000),
              ),
            ),
          ),
          title: 'Flutter App',
          home: auth.isAuth
              ? KanteScreen()
              : FutureBuilder(
                  future: auth.autoLogIn(),
                  builder: (context, authResult) => WelcomeScreen(),
                ),
        ),
      ),
    );
  }
}
