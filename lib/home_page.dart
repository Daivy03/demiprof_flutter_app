import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart';
import 'package:demiprof_flutter_app/tutor_card.dart';

//metodo che chiama il signout
Future<void> signOut() async {
  await Auth().signOut();
}

//aggiunta temporanea signOutbutton

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<String> materie = [];
  late SharedPreferences _prefs;

  Future<void> _loadMaterie() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      List<String>? materieList = _prefs.getStringList('materie');
      if (materieList == null) {
        QuerySnapshot snapshot = await firestore.collection('materie').get();
        snapshot.docs.forEach((doc) {
          String nome = (doc.data() as Map<String, dynamic>)['nome'];
          materie.add(nome);
        });
        await _prefs.setStringList('materie', materie);
      } else {
        materie.addAll(materieList);
      }
      setState(() {});
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
  String _userImage = "";

  @override
  void initState() {
    super.initState();
    getUserName();
    _loadMaterie();
  }

//fetch username
  void getUserName() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    _username = (snap.data() as Map<String, dynamic>)['name'];
    _usersurname = (snap.data() as Map<String, dynamic>)['surname'];
    String userImage = (snap.data() as Map<String, dynamic>)['userImage'];
    setState(() {
      _username = (snap.data() as Map<String, dynamic>)['name'];
      _usersurname = (snap.data() as Map<String, dynamic>)['surname'];
    });
    if (userImage != null) {
      setState(() {
        _userImage = userImage;
      });
    }
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
            child: SvgPicture.asset(
              "assets/black.svg",
              colorFilter:
                  ColorFilter.mode(darkColorScheme.primary, BlendMode.srcIn),
            ),
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
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipOval(
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child: CachedNetworkImage(
                                imageUrl: _userImage,
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: darkColorScheme.primary,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    /* const Icon(Icons.error), */
                                    SvgPicture.asset(
                                  "assets/pic_profile.svg",
                                ),
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
              child: materie.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
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
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'In Evidenza',
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: darkColorScheme.onBackground),
              ),
            ),
            const TutorCard(),
          ],
        ),
      ),
    );
  }
}
