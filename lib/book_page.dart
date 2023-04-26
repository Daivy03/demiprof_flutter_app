import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Future<void> createNewBook(DateTime day, String materia, String tutorId,
      String userIdRequest) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Crea un nuovo documento con un ID generato automaticamente
      DocumentReference newDocRef = firestore.collection('prenotazioni').doc();

      // Salva i dati nel documento appena creato
      await newDocRef.set({
        'day': Timestamp.fromDate(day),
        'materia': materia,
        'tutorId': tutorId,
        'userIdRequest': userIdRequest,
      });

      print('Nuovo documento creato con successo!');
      const SnackBar(content: Text('Prenotazione creata'));
    } catch (e) {
      print('Errore durante la creazione del documento: $e');
    }
  }

  bool _showSnackBar = false;

  @override
  Widget build(BuildContext context) {
    if (_showSnackBar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prenotazione creata')),
        );
      });
      _showSnackBar = false;
    }
    return Scaffold(
      body: Material(
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
                        padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: EdgeInsets.all(8),
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
                            /* Container(
                              margin: EdgeInsets.only(left: 15),
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: darkColorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: darkColorScheme.secondary,
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.favorite_border_outlined,
                                ),
                              ),
                            ), */
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
                                SizedBox(
                                  height: 8,
                                ),
                                //text
                                const Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star),
                                        Icon(Icons.star_half),
                                        Icon(Icons.star_border_outlined),
                                        Icon(Icons.star_border_outlined),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Davide Reale',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: darkColorScheme.onSurface,
                                  ),
                                ),
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
                            Column(
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
                                SizedBox(
                                  height: 8,
                                ),
                                //text
                                Column(
                                  children: [
                                    Text(
                                      '2001',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                      ),
                                    ),
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
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10),
                              padding: EdgeInsets.symmetric(
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("DEC"),
                                ],
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(
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
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10),
                              padding: EdgeInsets.symmetric(
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
                  SizedBox(height: 130),
                  Material(
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
                              setState(() {
                                _showSnackBar = true;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 48.0, // spazio vuoto per la SnackBar
                              child: const SizedBox(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
