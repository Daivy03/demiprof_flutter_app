import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/models/user_app.dart';
import 'package:demiprof_flutter_app/popular_filter_list.dart';
import 'package:demiprof_flutter_app/results.dart';
import 'package:demiprof_flutter_app/tutor_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  @override
  void initState() {
    super.initState();
    getMaterieDb();
  }

  static List<PopularFilterListData> accomodationList =
      <PopularFilterListData>[];
  List<PopularFilterListData> popularFilterListData =
      PopularFilterListData.popularFList;
  List<PopularFilterListData> accomodationListData = accomodationList;
  final Logger logger = Logger();

  final TextEditingController _searchController = TextEditingController();
  List<UserDataApp> usersData = [];

  final List<String> selectedSubjects = []; // Lista dei soggetti selezionati
  List<String> materie = [];

  Future<List<UserDataApp>> searchUsers(String term) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Effettua le query separate su Firestore cercando la stringa in tutti i campi desiderati
      QuerySnapshot querySnapshot1 = await firestore
          .collection('users')
          .where('tutorId', isNotEqualTo: '')
          .where('name', isEqualTo: term)
          .get();

      List<QueryDocumentSnapshot<Object?>> documents = [];
      documents.addAll(querySnapshot1.docs);

      // Rimuovi eventuali duplicati
      documents = documents.toSet().toList();

      List<UserDataApp> users = documents.map((doc) {
        Timestamp timestamp = doc['borndate'] as Timestamp;
        DateTime dateTime = timestamp.toDate();
        String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
        return UserDataApp(
          email: doc['email'] as String,
          tutorId: doc['tutorId'] as String,
          name: doc['name'] as String,
          borndate: formattedDate,
          surname: doc['surname'] as String,
          classe: doc['classe'] as String,
          materie: List<String>.from(doc['materie']),
          stars: doc['stars'] as int,
          days: [],
          userImage: doc['userImage'] as String,
        );
      }).toList();
      setState(() {
        usersData = users;
      });

      // Assegna i risultati alla variabile usersData
      usersData = users;

      // Stampa i risultati
      logger.d('Risultati:');
      usersData.forEach((user) {
        logger.d('Nome: ${user.name}');
        logger.d('Cognome: ${user.surname}');
        logger.d('Materie: ${user.materie}');
        logger.d('Classe: ${user.classe}');
        logger.d('Stelle: ${user.stars}');
        logger.d('---');
      });

      // Ritorna la lista dei documenti trovati
      return usersData;
    } catch (e) {
      print('Errore durante la ricerca degli utenti: $e');
      return [];
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
    setState(() {
      materie = materieList;
    });

    return materieList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkColorScheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    getSearchBarUI(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: darkColorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: darkColorScheme.secondaryContainer,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      /* Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TutorCard())); */
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Results(
                                usersDataApp: usersData,
                              )));
                    },
                    child: Center(
                      child: Text(
                        'Applica',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: darkColorScheme.surfaceVariant),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget della CheckboxList
  Widget buildCheckboxList() {
    return ListView(
      children: [
        for (String subject
            in materie) // subjects è la lista dei soggetti disponibili
          CheckboxListTile(
            title: Text(subject),
            value: selectedSubjects.contains(subject),
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  selectedSubjects.add(subject);
                } else {
                  selectedSubjects.remove(subject);
                }
              });
            },
          ),
      ],
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: darkColorScheme.background,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: darkColorScheme.secondaryContainer,
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      searchUsers(value).then((results) {
                        setState(() {});
                      });
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: darkColorScheme.secondary,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Cerca...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: darkColorScheme.primary,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  //FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(MdiIcons.magnify,
                      size: 20, color: darkColorScheme.background),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /* ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_searchResults[index]['name']),
              subtitle: Text(_searchResults[index]['email']),
            );
          },
        ), */
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Materie',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  } */

  /* List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < popularFilterListData.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final PopularFilterListData date = popularFilterListData[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        date.isSelected = !date.isSelected;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            date.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: date.isSelected
                                ? darkColorScheme.primary
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            date.titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < popularFilterListData.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }
 */
  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: darkColorScheme.background,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  /* child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ), */
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(1),
                  child: Text(
                    'Ricerca filtrata',
                    style: TextStyle(
                      color: darkColorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
