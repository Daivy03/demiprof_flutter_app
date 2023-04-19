import 'package:demiprof_flutter_app/main.dart';
import 'package:demiprof_flutter_app/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:demiprof_flutter_app/login_page.dart';
import 'package:demiprof_flutter_app/auth.dart';
import 'package:demiprof_flutter_app/home_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Naviga alla HomePage()
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
          return const SizedBox(); // restituisci un widget vuoto per evitare di visualizzare la HomePage() due volte
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
