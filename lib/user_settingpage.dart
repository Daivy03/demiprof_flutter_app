import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserSettingPage extends StatefulWidget {
  UserSettingPage({super.key});

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica profilo'),
      ),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                //
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: SvgPicture.asset(
                  'assets/pic_profile.svg',
                  height: 120,
                  width: 120,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
