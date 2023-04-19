import 'package:demiprof_flutter_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demiprof_flutter_app/auth.dart';
import 'package:demiprof_flutter_app/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:demiprof_flutter_app/widget_tree.dart';
import 'package:demiprof_flutter_app/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DemiProf());
}

class DemiProf extends StatefulWidget {
  const DemiProf({Key? key}) : super(key: key);

  @override
  State<DemiProf> createState() => _DemiProfState();
}

class _DemiProfState extends State<DemiProf> {
  final ThemeData _themeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.poppinsTextTheme(),
    unselectedWidgetColor: AppColors.accent,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),
      theme: _themeData,
      // Imposta il tema mode su dark
      themeMode: ThemeMode.dark,
      // Crea una copia del tema dark e sovrascrivi solo la proprietà brightness
      darkTheme: _themeData.copyWith(
        brightness: Brightness.dark,
      ),
    );
  }
}
