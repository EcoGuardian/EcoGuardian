import 'dart:io';

import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/models/User.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/CustomAppbar.dart';
import '../../components/InputField.dart';

class UrediteNalogScreen extends StatefulWidget {
  static const String routeName = '/editProfile';
  const UrediteNalogScreen({Key? key}) : super(key: key);

  @override
  State<UrediteNalogScreen> createState() => _UrediteNalogScreenState();
}

class _UrediteNalogScreenState extends State<UrediteNalogScreen> {
  final formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  final imeNode = FocusNode();
  final prezimeNode = FocusNode();
  final emailNode = FocusNode();

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

  User? currentUser;

  bool isButtonLoading = false;
  bool isLoading = false;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (currentUser == null) {
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
  }

  String? slikaValidator;
  File? _storedImage;
  Future<void> _takeImage(isCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile;

    imageFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );
    if (imageFile == null) {
      return;
    }
    CroppedFile? croppedImg = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 344, ratioY: 250),
    );
    if (croppedImg == null) {
      return;
    }
    setState(() {
      _storedImage = File(croppedImg.path);
    });
    setState(() {
      slikaValidator = null;
    });
  }

  Map<String, String> authData = {
    'ime': '',
    'prezime': '',
    'email': '',
    'sifra': '',
    'sifraPot': '',
  };

  void submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isButtonLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .updateCurrentUser(
        authData['ime']!,
        authData['prezime']!,
        authData['email']!,
        _storedImage,
        currentUser!.id,
      )
          .then((value) {
        setState(() {
          isButtonLoading = false;
        });
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            content: Text(
              'Uspješno ste uredili svoj nalog',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      });
    } catch (e) {
      setState(() {
        isButtonLoading = false;
      });
      print(e);
      Metode.showErrorDialog(
        isJednoPoredDrugog: false,
        context: context,
        naslov: 'Došlo je do greške',
        button1Text: 'Zatvori',
        button1Fun: () {
          Navigator.pop(context);
        },
        isButton2: false,
      );
    }
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
              'Uredite Nalog',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            isCenter: true,
            horizontalMargin: 0.06,
            drugaIkonica: isButtonLoading
                ? CircularProgressIndicator()
                : Container(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Icon(
                      TablerIcons.circle_check,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
            drugaIkonicaFunkcija: isButtonLoading
                ? () {}
                : () {
                    submit();
                  },
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.08),
                      width: double.infinity,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Metode.showErrorDialog(
                                      isJednoPoredDrugog: true,
                                      context: context,
                                      naslov: 'Odakle želite da izaberete sliku?',
                                      button1Text: 'Kamera',
                                      button1Fun: () {
                                        _takeImage(true);
                                        Navigator.pop(context);
                                      },
                                      isButton1Icon: true,
                                      button1Icon: Icon(
                                        Icons.camera_alt,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      isButton2: true,
                                      button2Text: 'Galerija',
                                      button2Fun: () {
                                        _takeImage(false);

                                        Navigator.pop(context);
                                      },
                                      isButton2Icon: true,
                                      button2Icon: Icon(
                                        Icons.photo,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    );
                                  },
                                  child: _storedImage == null
                                      ? currentUser!.profilePicture == null
                                          ? Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                              child: Icon(
                                                TablerIcons.user_square_rounded,
                                                size: 70,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                  currentUser!.profilePicture!,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            child: Image.file(
                                              _storedImage!,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                ),
                                InputField(
                                  initalValue: currentUser!.name.substring(0, currentUser!.name.indexOf(' ')),
                                  isMargin: true,
                                  medijakveri: medijakveri,
                                  focusNode: imeNode,
                                  isLabel: true,
                                  label: Text(
                                    'Ime',
                                    style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.primary),
                                  ),
                                  kapitulacija: TextCapitalization.sentences,
                                  hintText: 'Ime',
                                  inputAction: TextInputAction.next,
                                  inputType: TextInputType.name,
                                  obscureText: false,
                                  borderRadijus: 10,
                                  visina: 18,
                                  validator: (value) {
                                    if (emailNode.hasFocus || prezimeNode.hasFocus) {
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
                                  initalValue: currentUser!.name.substring(currentUser!.name.indexOf(' ') + 1, currentUser!.name.length),
                                  isMargin: true,
                                  medijakveri: medijakveri,
                                  isLabel: true,
                                  focusNode: prezimeNode,
                                  label: Text(
                                    'Prezime',
                                    style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.primary),
                                  ),
                                  kapitulacija: TextCapitalization.sentences,
                                  hintText: 'Prezime',
                                  inputAction: TextInputAction.next,
                                  inputType: TextInputType.name,
                                  obscureText: false,
                                  borderRadijus: 10,
                                  visina: 18,
                                  validator: (value) {
                                    if (imeNode.hasFocus || emailNode.hasFocus) {
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
                                  initalValue: currentUser!.email,
                                  isMargin: true,
                                  isLabel: true,
                                  medijakveri: medijakveri,
                                  focusNode: emailNode,
                                  label: Text(
                                    'Email',
                                    style: Theme.of(context).textTheme.headline4?.copyWith(color: Theme.of(context).colorScheme.primary),
                                  ),
                                  hintText: 'E-mail',
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.emailAddress,
                                  obscureText: false,
                                  borderRadijus: 10,
                                  visina: 18,
                                  validator: (value) {
                                    if (imeNode.hasFocus || prezimeNode.hasFocus) {
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
