import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:flutter/material.dart';

import 'package:ecoguardian/screens/auth/LoginScreen.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgotten-password';

  @override
  State<ForgottenPasswordScreen> createState() => _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  @override
  String data = '';

  void submit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    Metode.showErrorDialog(
      isJednoPoredDrugog: false,
      context: context,
      naslov: 'Zahtjev za resetovanje šifre je poslat na unešenu email adresu.',
      button1Text: 'U redu',
      button1Fun: () {
        Navigator.pop(context);
      },
      isButton2: false,
    );
    formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.2),
                    Text(
                      'Reset šifre',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    SizedBox(height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.15),
                    Form(
                      key: formKey,
                      child: InputField(
                        isMargin: true,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.emailAddress,
                        hintText: 'Email',
                        medijakveri: medijakveri,
                        obscureText: false,
                        onSaved: (value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Molimo Vas da unesete email adresu';
                          } else if (!value.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                            return 'Molimo Vas unesite validnu email adresu';
                          }
                        },
                        isLabel: true,
                        borderRadijus: 10,
                        label: Text(
                          'Email',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        hintTextSize: 16,
                        visina: 18,
                      ),
                    ),
                    SizedBox(height: (MediaQuery.of(context).size.width - MediaQuery.of(context).padding.top) * 0.07),
                    Button(
                      borderRadius: 10,
                      visina: 18,
                      fontsize: 18,
                      buttonText: 'Pošaljite zahtjev',
                      textColor: Colors.white,
                      isBorder: false,
                      backgroundColor: Theme.of(context).primaryColor,
                      funkcija: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        submit();
                      },
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'Nazad na prijavu',
                      style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
