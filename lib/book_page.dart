import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/book_success.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/models/user_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class BookPage extends StatefulWidget {
  final UserDataApp usersDataApp;

  BookPage({
    super.key,
    required this.usersDataApp,
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    italianDates();
    loadStars();
    fetchDays();
  }

  void loadStars() {
    // Aggiungi icone stellate intere
    for (int i = 0; i < widget.usersDataApp.stars; i++) {
      starIcons.add(Icon(Icons.star));
    }

// Aggiungi icona stellata a metà
    if (widget.usersDataApp.stars % 1 != 0) {
      starIcons.add(Icon(Icons.star_half));
    }

// Aggiungi icone stellate vuote
    while (starIcons.length < 5) {
      starIcons.add(Icon(Icons.star_border_outlined));
    }
  }

  void italianDates() async {
    // initialize date formatting for it_IT locale
    await initializeDateFormatting('it_IT');
  }

  bool isSuccess = false;

  Future<void> createNewBook(
    DateTime day,
    String materia,
    String tutorId,
  ) async {
    try {
      final FirebaseAuth _firebase = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final User? currentUser = _firebase.currentUser;

      // Ottiene l'uid dell'utente corrente
      final String? userRequestId = currentUser?.uid;

      // Crea un nuovo documento con un ID generato automaticamente
      final DocumentReference newDocRef =
          firestore.collection('prenotazioni').doc();

      // Salva i dati nel documento appena creato
      await newDocRef.set({
        'day': Timestamp.fromDate(day),
        'materia': materia,
        'tutorId': widget.usersDataApp.tutorId,
        'userIdRequest': userRequestId,
      });

      print('Nuovo documento creato con successo!');
      isSuccess = true;
    } catch (e) {
      print('Errore durante la creazione del documento: $e');
    }
  }

  DateTime? selectedDate;
  List<Timestamp> _days = [];

  Future<void> fetchDays() async {
    final FirebaseAuth _firebase = FirebaseAuth.instance;
    final User? user = _firebase.currentUser;
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = usersCollection.doc(user!.uid);

    try {
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      List<Timestamp> days = List.from(userDocSnapshot.get('days'));
      setState(() {
        _days = days;
      });
    } catch (e) {
      print(
          'Si è verificato un errore durante il recupero del campo "days" per l\'utente corrente: $e');
    }
  }

  List<Widget> starIcons = [];
  List<DateTime> _availableTimes = [];

  Future<List<DateTime>> fetchAvailableTimes(DateTime selectedDay) async {
    final FirebaseAuth _firebase = FirebaseAuth.instance;
    final User? user = _firebase.currentUser;
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = usersCollection.doc(user!.uid);

    try {
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      List<Timestamp> allTimes = List.from(userDocSnapshot.get('times'));
      List<Timestamp> availableTimes = allTimes
          .where((timestamp) =>
              timestamp.toDate().year == selectedDay.year &&
              timestamp.toDate().month == selectedDay.month &&
              timestamp.toDate().day == selectedDay.day)
          .toList();
      List<DateTime> availableDateTimes =
          availableTimes.map((timestamp) => timestamp.toDate()).toList();
      setState(() {
        _availableTimes = availableDateTimes;
      });
      return availableDateTimes;
    } catch (e) {
      print(
          'Si è verificato un errore durante il recupero degli orari disponibili per il giorno selezionato: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: darkColorScheme.primary,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkColorScheme.onBackground,
                                    )
                                  ]),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: darkColorScheme.onPrimary,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                              Text(
                                'Valutazione',
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: darkColorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              //text
                              Column(
                                children: [
                                  Row(
                                    children: starIcons,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${widget.usersDataApp.name} ${widget.usersDataApp.surname}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: darkColorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              //text
                              Column(
                                children: [
                                  Text(
                                    widget.usersDataApp.classe,
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                          /* Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Anno',
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: darkColorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              //text
                              Column(
                                children: [
                                  Text(
                                    //pass borndate from previous page
                                    '2001',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ), */
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
                          Row(
                            children: [
                              Icon(
                                Icons.event_available_rounded,
                                color: darkColorScheme.onSecondaryContainer,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Giorni disponibili',
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
                Container(
                  height: 70,
                  child: ListView.builder(
                    clipBehavior: Clip.antiAlias,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _days.length,
                    itemBuilder: (context, index) {
                      DateTime date = _days[index].toDate();
                      bool isSelected =
                          selectedDate != null && date == selectedDate!;
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                selectedDate = date;
                              });
                              List<DateTime> availableTimes =
                                  await fetchAvailableTimes(selectedDate!);
                              setState(() {
                                _availableTimes = availableTimes;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? darkColorScheme.tertiary
                                    : darkColorScheme.onSecondary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('d', 'it_IT').format(
                                        date), // format the day with 'it_IT' locale
                                    style: GoogleFonts.poppins(
                                      color: isSelected
                                          ? darkColorScheme.secondaryContainer
                                          : darkColorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    DateFormat('MMM', 'it_IT').format(
                                        date), // format the month with 'it_IT' locale
                                    style: GoogleFonts.poppins(
                                      color: isSelected
                                          ? darkColorScheme.secondaryContainer
                                          : darkColorScheme.primary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: darkColorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            //TODO:fetch hours from db
                            'Orari disponibili',
                            style: GoogleFonts.poppins(
                                fontSize: 19,
                                color: darkColorScheme.onSecondaryContainer),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                //Grafica della listview degli orari relativi ai giorni disponibili
                Container(
                  height: 70,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      DateTime time;
                      if (index < _availableTimes.length) {
                        time = _availableTimes[index];
                      } else {
                        return SizedBox.shrink(); // widget vuoto
                      }

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
                                // visualizza l'ora
                                Text(
                                  DateFormat('HH:mm', 'it_IT').format(time),
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
                ), //fine container Orari disopnibili
                SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                Stack(children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: double.infinity,
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                darkColorScheme.primary),
                          ),
                          onPressed: () async {
                            if (selectedDate != null) {
                              await createNewBook(
                                  selectedDate!, 'Informatica', '');
                            }
                            if (isSuccess == true) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BookSuccess()));
                            }
                          },
                          child: Text(
                            'Prenota',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: darkColorScheme.surfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
                /* Material(
                  color: darkColorScheme.primary,
                  borderRadius: BorderRadius.circular(35),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () async {
                            await createNewBook(
                                DateTime.now(), 'Informatica', '', '');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Prenota',
                              style: GoogleFonts.poppins(
                                color: darkColorScheme.surfaceVariant,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ), */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
