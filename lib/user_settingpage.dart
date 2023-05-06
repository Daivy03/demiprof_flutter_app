import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/models/user_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class UserSettingPage extends StatefulWidget {
  UserSettingPage({super.key});

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUserData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    _fetchUserBirthdate();
    classeSubmitEdit();
    borndateSubmitPicker();
  }

  TextEditingController _controllerBorndate = TextEditingController();
  TextEditingController _controllerClasse = TextEditingController();
  String formattedDate = '';
  UserDataApp? _userData;
  Future<void> getUserData() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (userId.isNotEmpty) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          _userData = UserDataApp(
            email: userDoc['email'] as String,
            tutorId: userDoc['tutorId'] as String,
            name: userDoc['name'] as String,
            surname: userDoc['surname'] as String,
            borndate: '',
            classe: userDoc['classe'] as String,
            materie: List<String>.from(userDoc['materie']),
            stars: userDoc['stars'] as int,
            days: [],
            userImage: userDoc['userImage'] as String,
          );
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addMateria(String materia) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // L'utente non è autenticato
      return;
    }

    final DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Aggiungi la nuova materia all'array "materie"
    await userRef.update({
      'materie': FieldValue.arrayUnion([materia])
    });
  }

  void classeSubmitEdit() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String userId = user!.uid;

    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = usersCollection.doc(userId);

    try {
      // Aggiorna il campo "classe" nel documento dell'utente corrente
      await userDocRef.update({'classe': _controllerClasse.text});
    } catch (e) {
      print(
          'Si è verificato un errore durante l\'aggiornamento del campo "classe" per l\'utente $userId: $e');
    }
  }

  String userImageURL = '';

  void pickUploadImage() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String userId = user!.uid;
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = usersCollection.doc(userId);
    Reference ref =
        FirebaseStorage.instance.ref().child("avatar_images/$userId.jpg");
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 85,
    );
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then(
      (value) {
        print(value);
        try {
          // Aggiorna il campo "userImage" nel documento dell'utente corrente
          userDocRef.update({'userImage': value});
        } catch (e) {}
        setState(() {
          userImageURL = value;
        });
      },
    );
  }

  void borndateSubmitPicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1945),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) {
      return; // L'utente ha premuto il pulsante "annulla"
    }
    final convDate = Timestamp.fromDate(pickedDate);

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser!;
    final userId = user.uid;

    final usersCollection = FirebaseFirestore.instance.collection('users');
    final userDocRef = usersCollection.doc(userId);

    try {
      await userDocRef.update({'borndate': convDate});
      print('Campo "borndate" aggiornato con successo per l\'utente $userId');
    } catch (e) {
      print(
          'Si è verificato un errore durante l\'aggiornamento del campo "borndate" per l\'utente $userId: $e');
    }

    // Aggiorniamo il valore della variabile formattedDate
    formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

    // Impostiamo il valore del controller
    _controllerBorndate.text = formattedDate;
    print("Borndate impostata nel controller: $_controllerBorndate.text");
  }

  DateTime? _birthdate;
  String _borndateLabelText = 'Nessuna data di nascita';

  void _fetchUserBirthdate() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) {
      return;
    }
    final userId = user.uid;
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null && data.containsKey('borndate')) {
          final timestamp = data['borndate'] as Timestamp;
          final date = timestamp.toDate();
          final formatter = DateFormat('dd/MM/yyyy');
          final formattedDate = formatter.format(date);
          setState(() {
            _birthdate = date;
            _borndateLabelText = 'Data di nascita: $formattedDate';
          });
        }
      } else {
        print('Il documento non esiste');
      }
    } catch (e) {
      print('Errore nel recupero del documento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica profilo'),
      ),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                //TODO: Avatar upload method
                pickUploadImage();
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: CachedNetworkImage(
                  imageUrl: userImageURL,
                  height: 90,
                  width: 90,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      /* const Icon(Icons.error), */
                      _userData!.userImage != null
                          ? CachedNetworkImage(imageUrl: _userData!.userImage)
                          : SvgPicture.asset(
                              "assets/pic_profile.svg",
                            ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Cambia avatar",
            style: GoogleFonts.poppins(fontSize: 15),
          ),
          SizedBox(
            height: 20,
          ),
          /*  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.poppins(),
                labelText: 'Data di nascita',
              ),
              controller: TextEditingController(
                text: _birthdate != null
                    ? _birthdate!.toLocal().toString().split(' ')[0]
                    : '',
              ),
            ),
          ), */
          Column(
            children: [
              Container(
                //margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                          controller:
                              _controllerBorndate, //editing controller of this TextField
                          decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelStyle: GoogleFonts.poppins(
                                fontSize: 15), //icon of text field
                            labelText: _borndateLabelText, //label text of field
                          ),
                          readOnly: true, // when true user cannot edit text
                          onTap: () async {
                            borndateSubmitPicker();
                          }),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Classe',
                        style: GoogleFonts.poppins(
                          color: darkColorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _controllerClasse,
                        decoration: InputDecoration(
                          hintText: 'Modifica classe',
                          hintStyle: GoogleFonts.poppins(),
                          filled: true,
                          fillColor: darkColorScheme.onSecondary,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Materie',
                        style: GoogleFonts.poppins(
                          color: darkColorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //TODO: method to add subjects & fetch
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Modifica materie',
                          hintStyle: GoogleFonts.poppins(),
                          filled: true,
                          fillColor: darkColorScheme.onSecondary,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: darkColorScheme.onBackground,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          darkColorScheme.primaryContainer,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(
                          Size(
                            MediaQuery.of(context).size.width * 0.8,
                            50,
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                      onPressed: () {
                        classeSubmitEdit();
                        Navigator.pop(context);
                        /* Future.delayed(Duration.zero,
                            () => setState(() {})); // Aggiorna la pagina */
                      },
                      child: Text('Aggiorna profilo'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
