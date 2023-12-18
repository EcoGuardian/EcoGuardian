import 'dart:io';

import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/InputField.dart';

class PrijaviScreen extends StatefulWidget {
  static const String routeName = '/PrijaviScreen';
  const PrijaviScreen({super.key});

  @override
  State<PrijaviScreen> createState() => _PrijaviScreenState();
}

class _PrijaviScreenState extends State<PrijaviScreen> {
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
      // slikaValidator = null;
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
            'Prijavite Divlju Deponiju',
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
              TablerIcons.circle_check,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          drugaIkonicaFunkcija: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.06),
          child: Column(
            children: [
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
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
                      TablerIcons.camera,
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
                      TablerIcons.photo,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
                child: Container(
                  width: medijakveri.size.width,
                  height: medijakveri.size.width * 0.48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: _storedImage != null
                          ? Image.file(
                              _storedImage!,
                              fit: BoxFit.fill,
                              width: medijakveri.size.width,
                              height: medijakveri.size.width * 0.48,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  TablerIcons.photo,
                                  size: 35,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Dodajte sliku',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
              Row(
                children: [
                  Text("Dodajte lokaciju divlje deponije",
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          )),
                ],
              ),
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
              GestureDetector(
                onTap: () {},
                child: Container(
                    //width: sirina,
                    padding: EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          TablerIcons.map_pin_filled,
                          size: 25,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Trenutna lokacija",
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                // fontWeight: FontWeight.w600,
                                fontSize: 18 ?? 20,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    )),
              ),
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
              GestureDetector(
                onTap: () {},
                child: Container(
                    //width: sirina,
                    padding: EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          TablerIcons.map_2,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Lokacija na mapi",
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                // fontWeight: FontWeight.w600,
                                fontSize: 18 ?? 20,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    )),
              ),
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
              InputField(
                isMargin: true,
                inputAction: TextInputAction.done,
                inputType: TextInputType.text,
                hintText: 'Opis',
                medijakveri: medijakveri,
                obscureText: false,
                onSaved: (value) {},
                validator: (value) {},
                isLabel: true,
                borderRadijus: 10,
                label: Text('Opis', style: Theme.of(context).textTheme.headline3?.copyWith(color: Theme.of(context).colorScheme.primary),),
                hintTextSize: 16,
                brMinLinija: 3,
                brMaxLinija: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
