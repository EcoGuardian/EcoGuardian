import 'dart:io';

import 'package:ecoguardian/components/Button.dart';
import 'package:ecoguardian/components/CustomAppbar.dart';
import 'package:ecoguardian/components/metode.dart';
import 'package:ecoguardian/providers/AuthProvider.dart';
import 'package:ecoguardian/providers/GeneralProvider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/InputField.dart';

class PrijaviScreen extends StatefulWidget {
  static const String routeName = '/PrijaviScreen';
  const PrijaviScreen({super.key});

  @override
  State<PrijaviScreen> createState() => _PrijaviScreenState();
}

class _PrijaviScreenState extends State<PrijaviScreen> {
  final _form = GlobalKey<FormState>();

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

  bool isCurrentPosition = false;
  LatLng currentPosition = LatLng(0, 0);
  List<Type> types = [];
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    currentPosition = Provider.of<Auth>(context).getCurrentPosition;
    setState(() {
      isCurrentPosition = true;
    });
  }

  String? lokacijaError;

  void submit() async {
    setState(() {
      lokacijaError = null;
    });
    if (_storedImage == null) {
      setState(() {
        slikaValidator = 'Molimo Vas da izaberete sliku.';
      });
      return;
    }
    if (_storedImage!.readAsBytesSync().lengthInBytes / 1048576 >= 3.5) {
      setState(() {
        slikaValidator = 'Molimo Vas da izaberete drugu sliku';
      });
      return;
    }

    if (prijavaData['lat'] == '' || prijavaData['long'] == '') {
      setState(() {
        lokacijaError = 'Molimo Vas izaberite lokaciju';
      });
      return;
    }

    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      isLoading = true;
    });

    await Provider.of<GeneralProvider>(context, listen: false)
        .addPrijavu(
      lat: prijavaData['lat'],
      long: prijavaData['long'],
      opis: prijavaData['opis'],
      image: _storedImage!,
    )
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Map<String, String> prijavaData = {
    'lat': '',
    'long': '',
    'opis': '',
  };

  Set<Marker> markers = {};

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
              'Prijavite Divlju Deponiju',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            isCenter: false,
            horizontalMargin: 0.06,
            drugaIkonica: isLoading
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
            drugaIkonicaFunkcija: () {
              submit();
            },
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
                                  const Icon(
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
                if (slikaValidator != null) SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                if (slikaValidator != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        slikaValidator!,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ],
                  ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                Row(
                  children: [
                    Text(
                      "Dodajte lokaciju divlje deponije",
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                isCurrentPosition
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: currentPosition,
                              zoom: 15,
                            ),
                            gestureRecognizers: {
                              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                            },
                            compassEnabled: false,
                            mapToolbarEnabled: false,
                            mapType: MapType.normal,
                            zoomControlsEnabled: false,
                            onTap: (position) {
                              setState(() {
                                markers.clear();
                                markers.add(
                                  Marker(
                                    markerId: MarkerId(
                                      DateTime.now().toIso8601String(),
                                    ),
                                    position: position,
                                    icon: BitmapDescriptor.defaultMarker,
                                  ),
                                );
                                prijavaData['lat'] = position.latitude.toString();
                                prijavaData['long'] = position.longitude.toString();
                                lokacijaError = null;
                              });
                            },
                            markers: markers,
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                if (lokacijaError != null)
                  Row(
                    children: [
                      Text(
                        lokacijaError!,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ],
                  ),
                if (lokacijaError != null) SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                Button(
                  buttonText: 'Trenutna lokacija',
                  borderRadius: 10,
                  visina: 18,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  isBorder: false,
                  funkcija: () {
                    setState(() {
                      markers.clear();
                      markers.add(
                        Marker(
                          markerId: MarkerId(
                            DateTime.now().toIso8601String(),
                          ),
                          position: currentPosition,
                          icon: BitmapDescriptor.defaultMarker,
                        ),
                      );
                      prijavaData['lat'] = currentPosition.latitude.toString();
                      prijavaData['long'] = currentPosition.longitude.toString();
                      lokacijaError = null;
                    });
                  },
                  icon: const Icon(
                    TablerIcons.map_pin_filled,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                Form(
                  key: _form,
                  child: InputField(
                    isMargin: true,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    hintText: 'Opis',
                    medijakveri: medijakveri,
                    obscureText: false,
                    onSaved: (value) {
                      prijavaData['opis'] = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Molimo Vas da popunite polje';
                      }
                      if (value.length < 3) {
                        return 'Opis je ne može biti manji od 3 karaktera';
                      }
                      if (value.length > 500) {
                        return 'Opis je ne može biti veći od 500 karaktera';
                      }
                      return null;
                    },
                    isLabel: true,
                    borderRadijus: 10,
                    label: Text(
                      'Opis',
                      style: Theme.of(context).textTheme.headline3?.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                    hintTextSize: 16,
                    brMinLinija: 3,
                    brMaxLinija: 10,
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
