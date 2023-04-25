import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'auth.dart';
import 'package:demiprof_flutter_app/widgets/currentLoggedUser.dart';
import 'custom_colors.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int index = 0;
  bool isTutor = false;
  String _tutorId = "";

  //navbar icons per ruolo
  final tutorButtons = [
    const NavigationDestination(
      selectedIcon: Icon(MdiIcons.homeVariant),
      icon: Icon(MdiIcons.homeVariantOutline),
      label: 'Home',
    ),
    const NavigationDestination(
        selectedIcon: Icon(
          Icons.search_rounded,
          weight: 400,
        ),
        icon: Icon(Icons.search_outlined),
        label: 'Cerca'),
    const NavigationDestination(
      selectedIcon: Icon(MdiIcons.accountSchool),
      icon: Icon(
        MdiIcons.accountSchoolOutline,
        fill: 1,
      ),
      label: 'Profilo',
    ),
  ];
  final studentButtons = [
    const NavigationDestination(
      selectedIcon: Icon(MdiIcons.homeVariant),
      icon: Icon(MdiIcons.homeVariantOutline),
      label: 'Home',
    ),
    const NavigationDestination(
        selectedIcon: Icon(
          Icons.search_rounded,
          weight: 400,
        ),
        icon: Icon(Icons.search_outlined),
        label: 'Cerca'),
    const NavigationDestination(
      selectedIcon: Icon(MdiIcons.bagPersonal),
      icon: Icon(
        MdiIcons.bagPersonalOutline,
        fill: 1,
      ),
      label: 'Profilo',
    ),
  ];

  @override
  void initState() {
    super.initState();
    getTutorId();
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
          backgroundColor: MaterialStateProperty.all<Color>(AppColors.accent),
        ),
        onPressed: signOut,
        child: Text(
          'Sign out',
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _signOutButton(),
          Center(
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: _tutorId,
                style: TextStyle(color: darkColorScheme.secondary),
              ),
              TextSpan(
                text: " :tutorId",
                style: TextStyle(color: darkColorScheme.secondary),
              ),
            ])),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            height: 70,
            //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            indicatorColor: darkColorScheme.secondaryContainer,
            surfaceTintColor: darkColorScheme.primary,
            elevation: 2,
            shadowColor: darkColorScheme.primaryContainer,
            backgroundColor: darkColorScheme.surface,
            labelTextStyle: MaterialStatePropertyAll(GoogleFonts.poppins(
              fontSize: 12,
            ))),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: _tutorId.isEmpty ? studentButtons : tutorButtons,
        ),
      ),
    );
  }
}
