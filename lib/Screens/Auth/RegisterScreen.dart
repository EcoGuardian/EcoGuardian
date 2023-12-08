import 'package:ecoguardian/Screens/Auth/LoginScreen.dart';
import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/InputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/AuthProvider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  Map<String, String> authData = {
    'ime': '',
    'prezime': '',
    'email': '',
    'sifra': '',
    'sifraPot': '',
  };

  bool isLoading = false;
  final imeNode = FocusNode();
  final prezimeNode = FocusNode();
  final emailNode = FocusNode();
  final pass1Node = FocusNode();
  final pass2Node = FocusNode();

  @override
  void initState() {
    super.initState();
    pass1Node.addListener(() {
      setState(() {});
    });
    imeNode.addListener(() {
      setState(() {});
    });
    prezimeNode.addListener(() {
      setState(() {});
    });
    emailNode.addListener(() {
      setState(() {});
    });
    pass2Node.addListener(() {
      setState(() {});
    });
  }

  bool isPassHidden = true;
  void changePassVisibility() {
    setState(() {
      isPassHidden = !isPassHidden;
    });
  }

  bool isPassHidden2 = true;
  void changePassVisibility2() {
    setState(() {
      isPassHidden2 = !isPassHidden2;
    });
  }

  void submitForm() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false)
          .register(
        email: authData['email']!,
        ime: authData['ime']!,
        prezime: authData['prezime']!,
        sifra: authData['sifra']!,
        sifraPot: authData['sifraPot']!,
      )
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    } catch (e) {
      throw e;
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _form,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                    Text(
                      'Registrujte se',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                    InputField(
                      isMargin: true,
                      medijakveri: medijakveri,
                      isLabel: true,
                      label: 'Ime',
                      kapitulacija: TextCapitalization.sentences,
                      hintText: 'Ime',
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.name,
                      obscureText: false,
                      focusNode: imeNode,
                      borderRadijus: 10,
                      visina: 18,
                      onChanged: (_) => _form.currentState!.validate(),
                      validator: (value) {
                        if (emailNode.hasFocus || prezimeNode.hasFocus || pass1Node.hasFocus || pass2Node.hasFocus) {
                          return null;
                        } else if (value!.isEmpty) {
                          return 'Molimo Vas da unesete ime';
                        } else if (value.length < 2) {
                          return 'Ime mora biti duže';
                        } else if (!RegExp(r'^[a-zA-Z\S]+$').hasMatch(value)) {
                          return 'Ime nije validano';
                        } else if (value.length > 30) {
                          return 'Ime mora biti kraće';
                        } else if (value.contains(RegExp(r'[0-9]')) || value.contains(' ')) {
                          return 'Ime smije sadržati samo velika i mala slova i simbole';
                        }
                      },
                      onSaved: (value) {
                        authData['ime'] = value!.trim();
                      },
                    ),
                    InputField(
                      isMargin: true,
                      medijakveri: medijakveri,
                      isLabel: true,
                      label: 'Prezime',
                      hintText: 'Prezime',
                      kapitulacija: TextCapitalization.sentences,
                      borderRadijus: 10,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      obscureText: false,
                      focusNode: prezimeNode,
                      visina: 18,
                      onChanged: (_) => _form.currentState!.validate(),
                      validator: (value) {
                        if (imeNode.hasFocus || emailNode.hasFocus || pass1Node.hasFocus || pass2Node.hasFocus) {
                          return null;
                        } else if (value!.isEmpty) {
                          return 'Molimo Vas da unesete prezime';
                        } else if (value.length < 2) {
                          return 'Prezime mora biti duže';
                        } else if (!RegExp(r'^[a-zA-Z\S]+$').hasMatch(value)) {
                          return 'Prezime nije validano';
                        } else if (value.length > 30) {
                          return 'Prezime mora biti kraće';
                        } else if (value.contains(RegExp(r'[0-9]')) || value.contains(' ')) {
                          return 'Prezime smije sadržati samo velika i mala slova i simbole';
                        }
                      },
                      onSaved: (value) {
                        authData['prezime'] = value!.trim();
                      },
                    ),
                    InputField(
                      isMargin: true,
                      isLabel: true,
                      medijakveri: medijakveri,
                      label: 'Email',
                      hintText: 'E-mail',
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.emailAddress,
                      obscureText: false,
                      focusNode: emailNode,
                      borderRadijus: 10,
                      visina: 18,
                      onChanged: (_) => _form.currentState!.validate(),
                      validator: (value) {
                        if (imeNode.hasFocus || prezimeNode.hasFocus || pass1Node.hasFocus || pass2Node.hasFocus) {
                          return null;
                        } else if (value!.isEmpty) {
                          return 'Molimo Vas da unesete email adresu';
                        } else if (!value.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                          return 'Molimo Vas unesite validnu email adresu';
                        }
                      },
                      onSaved: (value) {
                        authData['email'] = value!.trim();
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.005,
                              left: medijakveri.size.width * 0.02,
                            ),
                            child: Text(
                              'Šifra',
                              style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          TextFormField(
                            focusNode: pass1Node,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            obscureText: isPassHidden,
                            controller: _passwordController,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(pass2Node);
                            },
                            onSaved: (value) {
                              authData['sifra'] = value!.trim();
                            },
                            onChanged: (_) => _form.currentState!.validate(),
                            validator: (value) {
                              if (imeNode.hasFocus || prezimeNode.hasFocus || emailNode.hasFocus || pass2Node.hasFocus) {
                                return null;
                              } else if (value!.isEmpty || !value.contains(RegExp(r'[A-Za-z]'))) {
                                return 'Molimo Vas unesite šifru';
                              } else if (value.length < 8) {
                                return 'Šifra mora imati više od 8 karaktera';
                              } else if (value.length > 50) {
                                return 'Šifra mora imati manje od 50 karaktera';
                              } else if (!RegExp(r'^[a-zA-Z\S]+$').hasMatch(value)) {
                                return 'Šifra nije validna';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Šifra',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintStyle: Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                              suffixIcon: pass1Node.hasFocus
                                  ? IconButton(
                                      onPressed: () => changePassVisibility(),
                                      icon: isPassHidden ? const Icon(TablerIcons.eye) : const Icon(TablerIcons.eye_off),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.005,
                              left: medijakveri.size.width * 0.02,
                            ),
                            child: Text(
                              'Potvrdite šifru',
                              style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          TextFormField(
                            focusNode: pass2Node,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            obscureText: isPassHidden2,
                            onChanged: (_) => _form.currentState!.validate(),
                            validator: (value) {
                              if (imeNode.hasFocus || prezimeNode.hasFocus || pass1Node.hasFocus || emailNode.hasFocus) {
                                return null;
                              } else if (value!.isEmpty) {
                                return 'Molimo Vas unesite šifru';
                              } else if (value != _passwordController.text) {
                                return 'Šifre moraju biti iste';
                              }
                            },
                            onSaved: (value) {
                              authData['sifraPot'] = value!.trim();
                            },
                            onFieldSubmitted: (_) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              FocusScope.of(context).unfocus();

                              imeNode.unfocus();
                              prezimeNode.unfocus();
                              emailNode.unfocus();
                              pass1Node.unfocus();
                              pass2Node.unfocus();
                              submitForm();
                            },
                            decoration: InputDecoration(
                              hintText: 'Potvrdite šifru',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintStyle: Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                              suffixIcon: pass2Node.hasFocus
                                  ? IconButton(
                                      onPressed: () => changePassVisibility2(),
                                      icon: isPassHidden2 ? const Icon(TablerIcons.eye) : const Icon(TablerIcons.eye_off),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                    isLoading
                        ? const CircularProgressIndicator()
                        : Button(
                            borderRadius: 10,
                            visina: 18,
                            fontsize: 18,
                            buttonText: 'Registrujte se',
                            textColor: Colors.white,
                            isBorder: false,
                            backgroundColor: Theme.of(context).primaryColor,
                            isFullWidth: false,
                            funkcija: () {
                              submitForm();
                            },
                          ),
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        'Već reciklirate kao odgovoran građanin?',
                        style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pass1Node.dispose();
    pass2Node.dispose();
    imeNode.dispose();
    prezimeNode.dispose();
    emailNode.dispose();
  }
}
