import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demiprof_flutter_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        children: const [
          TextSpan(text: "DEMI"),
          TextSpan(
            text: "PROF",
            style: TextStyle(color: AppColors.accent),
          )
        ],
      ),
    );
  }

  Widget _userUid() {
    return Text(
      user?.email ?? 'User email',
      style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
