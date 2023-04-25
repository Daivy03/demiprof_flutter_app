import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:dynamic_color/samples.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:demiprof_flutter_app/profile_page.dart';
import 'package:demiprof_flutter_app/route_generator.dart';
import 'package:demiprof_flutter_app/search_page.dart';
import 'auth.dart';
import 'package:demiprof_flutter_app/widgets/currentLoggedUser.dart';

class TutorCard extends StatefulWidget {
  const TutorCard({Key? key}) : super(key: key);

  @override
  State<TutorCard> createState() => _TutorCardState();
}

class _TutorCardState extends State<TutorCard> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> names = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('users').get();
      setState(() {
        names = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 340,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  height: 90,
                  width: 500,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(43, 34, 29, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: darkColorScheme.shadow,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              /* child: Image.asset(
                                "lib/icons/onlylogo.png",
                                height: 90,
                                width: 90,
                              ),  */
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 100, vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                names[index],
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: darkColorScheme.onBackground),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: names.length,
        ),
      ),
    );
  }
}
