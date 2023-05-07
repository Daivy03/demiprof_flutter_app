import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/book_page.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/models/user_app.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Results extends StatefulWidget {
  final List<UserDataApp> usersDataApp;
  const Results({
    super.key,
    required this.usersDataApp,
  });

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> names = [];
  List<String> surnames = [];
  List<int> stars = [];
  List<Widget> starIcons = [];
  List<NetworkImage> avatars = [];
  List<UserDataApp> _users = [];
  @override
  void initState() {
    super.initState();
    //getUsers();
    getAvatars();
  }

  /* Future<void> getUsers() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .where('tutorId', isNotEqualTo: '')
          .get();
      List<UserDataApp> users = snapshot.docs.map((doc) {
        return UserDataApp(
          email: doc['email'] as String,
          tutorId: doc['tutorId'] as String,
          name: doc['name'] as String,
          surname: doc['surname'] as String,
          classe: doc['classe'] as String,
          materie: List<String>.from(doc['materie']),
          stars: doc['stars'] as int,
          days: [],
          userImage: doc['userImage'] as String,
        );
      }).toList();
      setState(() {
        _users = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  } */

  Future<void> getAvatars() async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference ref = storage.ref().child('avatar_images/');
      final ListResult result = await ref.listAll();
//List<NetworkImage> avatarList = []; // Change List<Image> to List<NetworkImage>
      for (final Reference imageRef in result.items) {
        final String url = await imageRef.getDownloadURL();
        avatars.add(NetworkImage(
          url,
        ));
      }
      setState(() {
        avatars = avatars;
      });
    } catch (e) {
      print('Error fetching avatars: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var index;
    return Scaffold(
      appBar: AppBar(
        title: Text('Risultati'),
      ),
      body: ListView.builder(
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BookPage(
                                      usersDataApp: widget.usersDataApp[index],
                                    )));
                          },
                          child: widget.usersDataApp.length > index
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.usersDataApp[index].userImage,
                                    height: 90,
                                    width: 90,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        /* const Icon(Icons.error), */
                                        SvgPicture.asset(
                                      "assets/pic_profile.svg",
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.usersDataApp[index].name,
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                darkColorScheme.onBackground),
                                      ),
                                      Text(" "), //spacing
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          widget.usersDataApp[index].surname,
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  darkColorScheme.onBackground),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 10),
                                        child: Row(
                                          children:
                                              List.generate(stars, (index) {
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
        itemCount: widget.usersDataApp.length,
      ),
    );
  }
}
