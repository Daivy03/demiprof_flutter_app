import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';

void main() {
  runApp(const DemiProf());
}

class DemiProf extends StatelessWidget {
  const DemiProf({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            forceMaterialTransparency: true,
            leading: Image.asset(
              'lib/icons/dmp_logo30.png',
            ),
            title: RichText(
                text: TextSpan(
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    children: const [
                  TextSpan(text: "DEMI"),
                  TextSpan(
                    text: "PROF",
                    style: TextStyle(color: AppColors.accent),
                  )
                ]))),
        body: const Text('Ciao'),
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(
              height: 55,
              backgroundColor: Colors.black,
              indicatorColor: AppColors.accent,
              iconTheme:
                  MaterialStatePropertyAll(IconThemeData(color: Colors.white)),
              labelTextStyle:
                  MaterialStatePropertyAll(TextStyle(color: Colors.white))),
          child: NavigationBar(
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_filled), label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.search_rounded), label: "Cerca"),
              NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded), label: "Profilo"),
            ],
          ),
        ),
      ),
    );
  }
}
