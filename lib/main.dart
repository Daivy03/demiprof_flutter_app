import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/login_page.dart';
import 'package:demiprof_flutter_app/mobile_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:firebase_core/firebase_core.dart';

/*
Main.dart
Determina la struttura e dettagli che app deve usare
*/
Future<void> main() async {
  //assicura che i widget di flutter siano inizializzati
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //inizializza app con connessione db Firebase
  runApp(const DemiProf());
}

class DemiProf extends StatefulWidget {
  const DemiProf({Key? key}) : super(key: key);

  @override
  State<DemiProf> createState() => _DemiProfState();
}

class _DemiProfState extends State<DemiProf> {
  final ThemeData _themeData = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.poppinsTextTheme(),
    unselectedWidgetColor: AppColors.accent,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                //return const HomePage();
                return const MobileLayout();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginPage();
          },
        ),
        theme: _themeData,
        // Imposta il tema mode su dark
        themeMode: ThemeMode.dark,
        // Crea una copia del tema dark e sovrascrivi solo la proprietà brightness
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme));
  }
}
