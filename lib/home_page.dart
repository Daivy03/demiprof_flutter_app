import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:dynamic_color/samples.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:demiprof_flutter_app/profile_page.dart';
import 'package:demiprof_flutter_app/route_generator.dart';
import 'package:demiprof_flutter_app/search_page.dart';
import 'auth.dart';
import 'package:demiprof_flutter_app/widgets/currentLoggedUser.dart';
import 'package:demiprof_flutter_app/tutor_card.dart';

//metodo che chiama il signout
Future<void> signOut() async {
  await Auth().signOut();
}

//aggiunta temporanea signOutbutton
Widget _signOutButton() {
  return Padding(
    padding: const EdgeInsets.only(left: 15),
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(darkColorScheme.tertiaryContainer),
      ),
      onPressed: signOut,
      child: Text(
        'Logout',
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List materie = [];

  void getMaterie() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('materie').get();
      snapshot.docs.forEach((doc) {
        String nome = (doc.data() as Map<String, dynamic>)['nome'];
        materie.add(nome);
      });
    } catch (e) {
      print('Errore durante il recupero delle materie: $e');
    }
  }

  final List<Icon> materieIcons = [
    Icon(
      Icons.functions_outlined,
      size: 25,
      color: darkColorScheme.onBackground,
    ),
    Icon(
      Icons.public_outlined,
      size: 25,
      color: darkColorScheme.onBackground,
    ),
    Icon(
      Icons.code_outlined,
      size: 25,
      color: darkColorScheme.onBackground,
    ),
    Icon(
      Icons.science_outlined,
      size: 25,
      color: darkColorScheme.onBackground,
    ),
    Icon(
      Icons.dns_outlined,
      size: 25,
      color: darkColorScheme.onBackground,
    ),
    Icon(
      Icons.biotech_outlined,
      size: 25,
      color: darkColorScheme.onBackground,
    ),
  ];

  String _username = "";
  String _usersurname = "";

  @override
  void initState() {
    super.initState();
    getUserName();
    getMaterie();
  }

//fetch username
  void getUserName() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    _username = (snap.data() as Map<String, dynamic>)['name'];
    _usersurname = (snap.data() as Map<String, dynamic>)['surname'];
    setState(() {
      _username = (snap.data() as Map<String, dynamic>)['name'];
      _usersurname = (snap.data() as Map<String, dynamic>)['surname'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.backgrounda,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.only(left: 12),
            child: SvgPicture.asset("assets/black.svg",
                colorFilter:
                    ColorFilter.mode(darkColorScheme.primary, BlendMode.srcIn)),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.lexendDeca(
                    fontSize: 20, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: "DEMI",
                      style: TextStyle(color: darkColorScheme.onBackground)),
                  TextSpan(
                    text: "PROF",
                    style: TextStyle(color: darkColorScheme.primary),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: _signOutButton(),
            ),
            Expanded(
              flex: -2,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              //Msg benvenuto
                              children: [
                                TextSpan(
                                  text: "Ciao! ",
                                  style: TextStyle(
                                      color: darkColorScheme.onBackground),
                                ),
                                TextSpan(
                                  text: _username,
                                  style: TextStyle(
                                      color: darkColorScheme.onBackground),
                                ),
                                TextSpan(
                                  text: " ",
                                  style: TextStyle(
                                      color: darkColorScheme.onBackground),
                                ),
                                TextSpan(
                                  text: _usersurname,
                                  style: TextStyle(
                                      color: darkColorScheme.onBackground),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image(
                                fit: BoxFit.cover,
                                image: AssetImage("lib/icons/onlylogo.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Materie',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: darkColorScheme.onBackground.withOpacity(0.9),
                ),
              ),
            ),
            Container(
              height: 100,
              margin: const EdgeInsets.only(left: 15),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: materie.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: darkColorScheme.secondaryContainer,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.backgrounda,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            materieIcons[index],
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          materie[index],
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: darkColorScheme.onBackground,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'In Evidenza',
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: darkColorScheme.onBackground),
              ),
            ),
            TutorCard(),
          ],
        ),
      ),
    );
  }
}
