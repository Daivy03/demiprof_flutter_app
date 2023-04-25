import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color_schemes.g.dart';

String _username = "";

class CurrentLoggedUser extends StatefulWidget {
  const CurrentLoggedUser({super.key});

  @override
  State<CurrentLoggedUser> createState() => _CurrentLoggedUserState();
}

class _CurrentLoggedUserState extends State<CurrentLoggedUser> {
  final User? user = Auth().currentUser;

  void initState() {
    super.initState();
    getUserName();
  }

  void getUserName() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    //print(snap.data()); //stampa su console debug i dati del user corrente
    setState(() {
      _username = (snap.data() as Map<String, dynamic>)['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _username,
      style:
          GoogleFonts.poppins(fontSize: 18, color: darkColorScheme.secondary),
    );
  }
}
