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
    getMaterieDb();
    _fetchUserBirthdate();
    _fetchClasse();
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

  Future<List<String>> getMaterieDb() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot materieSnapshot = await firestore.collection('materie').get();

    List<String> materieList = [];
    materieSnapshot.docs.forEach((doc) {
      String materia = doc.get('nome')
          as String; // Supponendo che il campo contenente il nome della materia sia "nome"
      materieList.add(materia);
    });

    return materieList;
  }

  List<String> _selected = [];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selected.add(itemValue);
      } else {
        _selected.remove(itemValue);
      }
    });
  }

  void _showMultiSelect() async {
    List<String> items = await getMaterieDb();

    final List<String>? selectedMaterie = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return materieDialog(items);
      },
    );

    if (selectedMaterie != null) {
      setState(() {
        _selected = selectedMaterie;
      });
    }
    print(_selected);
  }

  Widget materieDialog(List<String> items) {
    return AlertDialog(
      title: const Text("Seleziona materie"),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: ListBody(
              children: items
                  .map((item) => CheckboxListTile(
                        value: _selected.contains(item),
                        title: Text(item),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (isChecked) {
                          setState(() {
                            _itemChange(item, isChecked!);
                          });
                        },
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  Future<void> addMateria() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final DocumentSnapshot userSnapshot = await userRef.get();
    final tutorId = userSnapshot.get('tutorId');

    if (tutorId == null || tutorId.isEmpty) {
      // Il campo tutorId è vuoto o null, non fare nulla
      return;
    } else {
      // Aggiungi le materie selezionate al campo materie
      await userRef.update({
        'materie': FieldValue.arrayUnion(_selected),
      });
    }
  }

  void classeSubmitEdit() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String userId = user!.uid;

    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = usersCollection.doc(userId);

    final String newClasse = _controllerClasse.text;
    final String currentClasse = _classeLabelText;

    if (newClasse != currentClasse) {
      try {
        // Aggiorna il campo "classe" nel documento dell'utente corrente
        await userDocRef.update({'classe': newClasse});
        setState(() {
          _classeLabelText = newClasse;
        });
      } catch (e) {
        print(
            'Si è verificato un errore durante l\'aggiornamento del campo "classe" per l\'utente $userId: $e');
      }
    }
  }

  String _classeLabelText = 'Nessuna classe';

  void _fetchClasse() async {
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
        if (data != null && data.containsKey('classe')) {
          final classe = data['classe'];
          setState(() {
            _classeLabelText =
                classe != null && classe.isNotEmpty ? classe : 'Nessuna classe';
          });
        }
      } else {
        print('Il documento non esiste');
      }
    } catch (e) {
      print('Errore nel recupero del documento: $e');
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
    setState(() {
      isLoading = true;
    });
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1945),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) {
      setState(() {
        isLoading = false;
      });
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
    setState(() {
      isLoading = false;
    });

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
                pickUploadImage();
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Stack(
                  children: [
                    if (userImageURL != null)
                      CachedNetworkImage(
                        imageUrl: userImageURL,
                        height: 90,
                        width: 90,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: darkColorScheme.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => SvgPicture.asset(
                          "assets/pic_profile.svg",
                          height: 90,
                          width: 90,
                        ),
                      )
                    else if (_userData?.userImage != null)
                      CachedNetworkImage(
                        imageUrl: _userData!.userImage,
                        height: 90,
                        width: 90,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: darkColorScheme.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => SvgPicture.asset(
                          "assets/pic_profile.svg",
                          height: 90,
                          width: 90,
                        ),
                      )
                    else
                      SvgPicture.asset(
                        "assets/pic_profile.svg",
                        height: 90,
                        width: 90,
                      ),
                  ],
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
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _controllerBorndate,
                        decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelStyle: GoogleFonts.poppins(fontSize: 15),
                          labelText: _borndateLabelText,
                        ),
                        readOnly: true,
                        onTap: () async {
                          if (!isLoading) {
                            borndateSubmitPicker();
                          }
                        },
                      ),
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
                          hintText: _classeLabelText,
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.5,
                                MediaQuery.of(context).size.height * 0.060),
                          ),
                        ),
                        onPressed: _showMultiSelect,
                        child: Text("Seleziona materia"),
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
                        addMateria();
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
