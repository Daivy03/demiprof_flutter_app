import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/book_page.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:dynamic_color/samples.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  List<String> surnames = [];
  List<int> stars = [];
  List<Widget> starIcons = [];
  List<Image> avatars = [];

  @override
  void initState() {
    super.initState();
    getUsers();
    getStars();
    getAvatars();
  }

  Future<void> getUsers() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .where('tutorId', isNotEqualTo: '') //controllo tutorId se valido
          .get();
      setState(() {
        names = snapshot.docs.map((doc) => doc['name'] as String).toList();
        surnames =
            snapshot.docs.map((doc) => doc['surname'] as String).toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> getStars() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('users').get();
      setState(() {
        List<int> starsList =
            snapshot.docs.map((doc) => doc['stars'] as int).toList();
        stars = starsList;
        starIcons = List.generate(starsList.length, (_) => Icon(Icons.star));
        names = starsList.map((_) => '').toList();
        surnames = starsList.map((_) => '').toList();
      });
      for (int i = 0; i < snapshot.docs.length; i++) {
        String name = snapshot.docs[i]['name'] as String;
        String surname = snapshot.docs[i]['surname'] as String;
        int index = stars.indexOf(stars[i]);
        names[index] = name;
        surnames[index] = surname;
      }
    } catch (e) {
      print('Error fetching stars: $e');
    }
  }

  Future<void> getAvatars() async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference ref = storage.ref().child('avatar_images/');
      final ListResult result = await ref.listAll();
      List<Image> avatarList = [];
      for (final Reference imageRef in result.items) {
        final String url = await imageRef.getDownloadURL();
        avatarList.add(Image.network(
          url,
          height: 90,
          width: 90,
        ));
      }
      setState(() {
        avatars = avatarList;
      });
    } catch (e) {
      print('Error fetching avatars: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 340,
        child: avatars.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  int stars = Random().nextInt(5) +
                      1; // generates a random number between 1 and 5
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
                          borderRadius: BorderRadius.circular(15),
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
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => BookPage()));
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: avatars[index],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                names[index],
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: darkColorScheme
                                                        .onBackground),
                                              ),
                                              Text(" "), //spacing
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  surnames[index],
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: darkColorScheme
                                                          .onBackground),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: 10),
                                                child: Row(
                                                  children: List.generate(stars,
                                                      (index) {
                                                    return Icon(
                                                      Icons.star,
                                                      color: darkColorScheme
                                                          .onTertiaryContainer,
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
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
