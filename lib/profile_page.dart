import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:demiprof_flutter_app/home_page.dart';
import 'package:demiprof_flutter_app/user_settingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class SignInOptionsScreen extends StatelessWidget {
  const SignInOptionsScreen({Key? key}) : super(key: key);

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
                      color: darkColorScheme.onBackground,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Log out",
                        style: GoogleFonts.montserrat(
                            color: darkColorScheme.onBackground))
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

/* class rolesChoice extends StatefulWidget {
  const rolesChoice({Key? key}) : super(key: key);

  @override
  State<rolesChoice> createState() => _rolesChoice();
}

class _rolesChoice extends State<rolesChoice> {
  @override
  Widget build(BuildContext context) {
    int? _value = 1;
    List<String> ruoli = ['Studente', 'Tutor'];
    return Scaffold(
      body: Wrap(
        spacing: 5.0,
        children: ruoli.map((ruolo) {
          int index = ruoli.indexOf(ruolo);
          return ChoiceChip(
            label: Text(ruolo),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                _value = selected ? index : null;
              });
            },
          );
        }).toList(),
      ),
    );
  }
} */

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isTutor = false;
  bool daysTapped = false;
  String _tutorId = "";
  TextEditingController _controllerDate = TextEditingController();
  Timestamp convDate = Timestamp(0, 0);
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    getTutorId();
  }

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
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

  Widget userBook(context) {
    return Material(
      color: darkColorScheme.background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/circleavatar.png'),
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
                              _userUid(),
                              SizedBox(
                                height: 8,
                              ),
                              //text
                              Column(
                                children: [
                                  Text(
                                    'Classe',
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.event_available_rounded,
                                color: darkColorScheme.onSecondaryContainer,
                              ),
                              SizedBox(
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
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
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
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
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
                ),
                SizedBox(height: MediaQuery.of(context).size.aspectRatio),
                Material(
                  color: darkColorScheme.primary,
                  borderRadius: BorderRadius.circular(35),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.accent),
      ),
      onPressed: signOut,
      child: Text(
        'Logout',
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: darkColorScheme.onBackground,
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
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
            child: Icon(Icons.arrow_back),
          )),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.topCenter,
        child: Center(
          child: TextField(
              controller:
                  _controllerDate, //editing controller of this TextField
              decoration: InputDecoration(
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
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));
    Timestamp convDate = Timestamp.fromDate(pickedDate!);

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String userId = user!.uid;

    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = usersCollection.doc(userId);

    try {
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      List<Timestamp> days = List.from(userDocSnapshot.get('days'));
      days.add(convDate);
      await userDocRef.update({'days': days});
      print('Campo "days" aggiornato con successo per l\'utente $userId');
    } catch (e) {
      print(
          'Si è verificato un errore durante l\'aggiornamento del campo "days" per l\'utente $userId: $e');
    }

    formattedDate = DateFormat('dd/MM/yyyy').format(convDate.toDate());
    _controllerDate.text = formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        title: _userUid(),
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => calendar()));
              },
              child: const Icon(Icons.add),
            ),
      backgroundColor: darkColorScheme.background,
      body: Container(
        //height: double.infinity,
        //width: double.infinity,
        padding: const EdgeInsets.all(2),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userBook(context),
            //_signOutButton(),
          ],
        ),
      ),
    );
  }
}
