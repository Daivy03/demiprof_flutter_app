import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:demiprof_flutter_app/home_page.dart';
import 'package:demiprof_flutter_app/models/prenotaz_model.dart';
import 'package:demiprof_flutter_app/models/user_app.dart';
import 'package:demiprof_flutter_app/user_settingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/painting.dart';

class SignInOptionsScreen extends StatelessWidget {
  const SignInOptionsScreen({Key? key}) : super(key: key);
  final Locale itLocale = const Locale('it', 'IT');

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -15,
          child: Container(
            width: 60,
            height: 7,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserSettingPage()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.settings,
                        size: 25, color: darkColorScheme.onBackground),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Impostazioni",
                        style: GoogleFonts.montserrat(
                            color: darkColorScheme.onBackground))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // TODO: Gestire l'azione per i termini e la privacy
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.description,
                      size: 25,
                      color: darkColorScheme.onBackground,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Termini e Privacy",
                        style: GoogleFonts.montserrat(
                            color: darkColorScheme.onBackground))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // TODO: Gestire l'azione per il manuale utente
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.bookAccount,
                      size: 25,
                      color: darkColorScheme.onBackground,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Manuale Utente",
                        style: GoogleFonts.montserrat(
                            color: darkColorScheme.onBackground))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // TODO: Gestire l'azione per le info app
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 25,
                      color: darkColorScheme.onBackground,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Info app",
                        style: GoogleFonts.montserrat(
                            color: darkColorScheme.onBackground))
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                signOut();
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      MdiIcons.logout,
                      size: 25,
                      color: darkColorScheme.primary,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Log out",
                        style: GoogleFonts.montserrat(
                            color: darkColorScheme.primary))
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserDataApp? _userData;
  File? imageXFile;
  List<NetworkImage> avatars = [];
  bool isTutor = false;
  bool isLoading = true;
  bool daysTapped = false;
  String _tutorId = "";
  TextEditingController _controllerDate = TextEditingController();
  Timestamp convDate = Timestamp(0, 0);
  String formattedDate = '';
  static const Locale itLocale = Locale('it', 'IT');

  List<Map<String, dynamic>> prenotazioniWithUserData = [];

  @override
  void initState() {
    super.initState();
    getUserData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    //getPrenotazioni();
    getAvatars();
    getTutorId();
    loadDataUi();
  }

  final User? user = Auth().currentUser;
  void loadDataUi() async {
    prenotazioniWithUserData = await getPrenotazioniWithUserData();
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  List<PrenotazioneModel> prenotazioni = [];
  Future<List<PrenotazioneModel>> getPrenotazioni() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      QuerySnapshot prenotazioniSnap;
      if (_userData?.tutorId.isNotEmpty ?? false) {
        prenotazioniSnap = await firestore
            .collection('prenotazioni')
            .where('tutorId', isEqualTo: _userData!.tutorId)
            .get();
      } else {
        prenotazioniSnap = await firestore
            .collection('prenotazioni')
            .where('userIdRequest', isEqualTo: userId)
            .get();
      }

      prenotazioniSnap.docs.forEach((doc) {
        prenotazioni.add(PrenotazioneModel(
          day: doc['day'] as Timestamp,
          materia: doc['materia'] as String,
          tutorId: doc['tutorId'] as String,
          userIdRequest: doc['userIdRequest'] as String,
        ));
      });
    } catch (e) {
      print('Error fetching prenotazioni: $e');
    }

    return prenotazioni;
  }

//inizio metodo
  Future<List<Map<String, dynamic>>> getPrenotazioniWithUserData() async {
    List<PrenotazioneModel> prenotazioni = await getPrenotazioni();

    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    List<Map<String, dynamic>> prenotazioniWithUserData = [];

    for (int i = 0; i < prenotazioni.length; i++) {
      PrenotazioneModel prenotazione = prenotazioni[i];

      Map<String, dynamic> prenotazioneData = prenotazione.toJson();

      if (prenotazione.tutorId != null && prenotazione.tutorId.isNotEmpty) {
        DocumentSnapshot userSnap =
            await firestore.collection('users').doc(prenotazione.tutorId).get();

        if (userSnap.exists) {
          Map<String, dynamic> userData = Map<String, dynamic>.from(
              userSnap.data() as Map<String, dynamic>);
          prenotazioneData['name'] = userData['name'];
          prenotazioneData['surname'] = userData['surname'];
          prenotazioneData['classe'] = userData['classe'];
          prenotazioneData['userImage'] = userData['userImage'];
        }
      } else if (prenotazione.userIdRequest == userId) {
        DocumentSnapshot userSnap =
            await firestore.collection('users').doc(userId).get();

        if (userSnap.exists) {
          Map<String, dynamic> userData = Map<String, dynamic>.from(
              userSnap.data() as Map<String, dynamic>);
          prenotazioneData['name'] = userData['name'];
          prenotazioneData['surname'] = userData['surname'];
          prenotazioneData['classe'] = userData['classe'];
        }
      }

      prenotazioniWithUserData.add(prenotazioneData);
      print(prenotazioniWithUserData);
    }

    return prenotazioniWithUserData;
  }
  //fine metodo

  Future<void> getUserData() async {
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

  Future<void> getAvatars() async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference ref = storage.ref().child('avatar_images/');
      final ListResult result = await ref.listAll();
//List<NetworkImage> avatarList = []; // Change List<Image> to List<NetworkImage>
      for (final Reference imageRef in result.items) {
        final String url = await imageRef.getDownloadURL();
        avatars.add(NetworkImage(
          url,
        ));
      }
      setState(() {
        avatars = avatars;
      });
    } catch (e) {
      print('Error fetching avatars: $e');
    }
  }

  Widget _userUid() {
    return Text(
      user?.email ?? 'User email',
      style: GoogleFonts.poppins(
          fontSize: 20,
          color: darkColorScheme.onBackground,
          fontWeight: FontWeight.w600),
    );
  }

  Widget dbImage() {
    return Image(
      image: imageXFile == null
          ? NetworkImage(_userData!.userImage) as ImageProvider<Object>
          : AssetImage('assets/circleavatar.png'),
    );
  }

  Widget userBook(context) {
    return Material(
      color: darkColorScheme.background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  //TODO: Load avatar from db
                  //AssetImage('assets/circleavatar.png')
                  image: _userData!.userImage != ""
                      ? NetworkImage(_userData!.userImage)
                          as ImageProvider<Object>
                      : AssetImage('assets/circleavatar.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      darkColorScheme.surface.withOpacity(0.9),
                      darkColorScheme.secondary.withOpacity(0),
                      darkColorScheme.secondary.withOpacity(0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Row(
                        children: [],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_userData! != null) ...[
                                Text(
                                  "${_userData!.name} ${_userData!.surname}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      _userData!.email,
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    )
                                  ],
                                ),
                              ],
                              if (_userData! == null) ...[
                                Text('Name Surname is null'),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.event_available_rounded,
                                  color: darkColorScheme.onSecondaryContainer,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Lezioni prenotate',
                                  style: GoogleFonts.poppins(
                                      fontSize: 19,
                                      color:
                                          darkColorScheme.onSecondaryContainer),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                ListView.builder(
                  itemBuilder: (context, index) {
                    int stars = _userData!
                        .stars; // fetch stars from db returning userData
                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: 500,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(43, 34, 29, 1),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: darkColorScheme.shadow,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      /* Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => BookPage(
                                                    usersDataApp: _users[index],
                                                  ))); */
                                    },
                                    child: prenotazioniWithUserData.length >
                                            index
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                            child: CachedNetworkImage(
                                              //avatars[index].url
                                              imageUrl:
                                                  prenotazioniWithUserData[
                                                      index]['userImage'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.12,
                                              width: 90,
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      darkColorScheme.primary,
                                                ),
                                              ),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  /* const Icon(Icons.error), */
                                                  SvgPicture.asset(
                                                "assets/pic_profile.svg",
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 100, vertical: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  //nome tutor/studente
                                                  prenotazioniWithUserData[
                                                      index]['name'],
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: darkColorScheme
                                                          .onSecondaryContainer),
                                                ),
                                                const Text(" "), //spacing
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    //surname tutor/studente
                                                    prenotazioniWithUserData[
                                                        index]['surname'],
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: darkColorScheme
                                                            .onSecondaryContainer),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              //materia della prenotazione
                                              children: [
                                                Text("Materia: "),
                                                Text(
                                                  prenotazioni[index].materia,
                                                  style: GoogleFonts.poppins(
                                                      color: darkColorScheme
                                                          .onTertiaryContainer),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              //valutazione in stelle per tutor
                                              children: [
                                                Text("Classe: "),
                                                Text(
                                                  //surname tutor/studente
                                                  prenotazioniWithUserData[
                                                      index]['classe'],
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: darkColorScheme
                                                          .onSecondaryContainer),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: prenotazioniWithUserData.length,
                ),
                /*  SizedBox(
                  height: 70,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                              color: index == 1
                                  ? darkColorScheme.tertiary
                                  : darkColorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: darkColorScheme.primary,
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //TODO: caricare giorni disponibili dal db
                                Text(
                                  "${index + 8}",
                                  style: GoogleFonts.poppins(
                                      color: index == 1
                                          ? darkColorScheme.secondaryContainer
                                          : darkColorScheme.primary),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text("DEC"),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                 */

                /*  SizedBox(
                  height: 70,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                              color: index == 1
                                  ? darkColorScheme.tertiary
                                  : darkColorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: darkColorScheme.primary,
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //TODO: caricare giorni disponibili dal db
                                Text(
                                  "${index + 15} AM",
                                  style: GoogleFonts.poppins(
                                      color: index == 1
                                          ? darkColorScheme.secondaryContainer
                                          : darkColorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ), */
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    if (mounted) {
      // controlla se il widget è ancora montato
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        )),
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.4,
            maxChildSize: 0.9,
            minChildSize: 0.32,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: const SignInOptionsScreen(),
              );
            }),
      );
    }
  }

  //recupero dati utente per indetificarne ruolo
  void getTutorId() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    _tutorId = (snap.data() as Map<String, dynamic>)['tutorId'];
    setState(() {
      _tutorId = (snap.data() as Map<String, dynamic>)['tutorId'];
    });
  }

  void updateText() {}
  String upTextLabel = 'Inserisci giorno disponibile';

  Widget calendar() {
    return Scaffold(
      appBar: AppBar(
          title: Text("Modifica disponibilità"),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.topCenter,
        child: Center(
          child: TextField(
              controller:
                  _controllerDate, //editing controller of this TextField
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today), //icon of text field
                labelText: "Inserisci giorno disponibile", //label text of field
              ),
              readOnly: true, // when true user cannot edit text
              onTap: () async {
                createSubmitDays();
                updateText();
              }),
        ),
      ),
    );
  }

  void createSubmitDays() async {
    await initializeDateFormatting('it_IT');

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (pickedDate == null) {
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return;
    }

    final DateTime combinedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss', 'it_IT');
    final String formattedDate = formatter.format(combinedDateTime);
    final Timestamp convDate = Timestamp.fromDate(combinedDateTime);

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String userId = user!.uid;

    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = usersCollection.doc(userId);

    try {
      final DocumentSnapshot userDocSnapshot = await userDocRef.get();
      final List<Timestamp> days = List.from(userDocSnapshot.get('days'));
      days.add(convDate);
      await userDocRef.update({'days': days});
      print('Campo "days" aggiornato con successo per l\'utente $userId');

      if (mounted) {
        await _showConfirmationDialog(
          context,
          combinedDateTime,
        );
      }
    } catch (e) {
      print(
          'Si è verificato un errore durante l\'aggiornamento del campo "days" per l\'utente $userId: $e');
    }

    _controllerDate.text = formattedDate;
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, DateTime dateTime) async {
    final DateFormat formatter = DateFormat(
        'dd/MM/yyyy HH:mm', 'it_IT'); // imposta il formato di data e ora
    final String formattedDate =
        formatter.format(dateTime); // crea la stringa di data e ora formattata

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Giorno inserito'),
          content: Text('Il giorno e l\'ora: $formattedDate'
              ' sono stati inseriti correttamente'), // visualizza la stringa di data e ora
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: darkColorScheme.primary,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 45,
          //"${_userData!.email}"
          title: Text(
            "Profilo",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu_rounded),
              tooltip: 'Mostra menu',
              onPressed: () {
                _showModalBottomSheet(context);
              },
            ),
          ],
        ),
        floatingActionButton: _tutorId.isEmpty
            ? const SizedBox()
            : FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => calendar()));
                },
                child: const Icon(Icons.add),
              ),
        backgroundColor: darkColorScheme.background,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: <Widget>[
                userBook(context),
              ],
            ),
          ),
        ),
      );
    }
  }
}
