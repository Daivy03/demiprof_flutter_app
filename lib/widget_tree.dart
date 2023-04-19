import 'package:demiprof_flutter_app/main.dart';
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
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
