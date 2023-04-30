import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BookSuccess extends StatefulWidget {
  const BookSuccess({super.key});

  @override
  State<BookSuccess> createState() => _BookSuccessState();
}

class _BookSuccessState extends State<BookSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prenotazione confermata"),
        elevation: 1,
        backgroundColor: darkColorScheme.background,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Container(
            child: Icon(Icons.arrow_back_rounded),
            width: 10,
            height: 10,
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.only(left: 12),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/success1.svg',
                fit: BoxFit.contain,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: double.infinity,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(darkColorScheme.primary),
                      ),
                      onPressed: () async {
                        /*  Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfilePage())); */
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text(
                        'Torna alla home',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkColorScheme.surfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
