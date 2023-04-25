import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:demiprof_flutter_app/widgets/currentLoggedUser.dart';
import 'package:demiprof_flutter_app/widgets/modal_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demiprof_flutter_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
        Column(children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            child: Column(
              children: [
                Container(
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
                Container(
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
                Container(
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
                Container(
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
              ],
            ),
          ),
        ])
      ],
    );
  }
}

class rolesChoice extends StatefulWidget {
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
}

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
      style: GoogleFonts.poppins(
          fontSize: 15, color: darkColorScheme.onBackground),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
