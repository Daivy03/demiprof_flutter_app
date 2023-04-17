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
                    style: TextStyle(color: AppColors.primary),
                  )
                ]))),
        body: const Text('Ciao'),
        bottomNavigationBar: BottomNavigationBar(
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          selectedItemColor: AppColors.primary,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_rounded,
                color: Colors.black,
              ),
              label: 'Cerca',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                color: Colors.black,
              ),
              label: 'Profilo',
            )
          ],
        ),
      ),
    );
  }
}
