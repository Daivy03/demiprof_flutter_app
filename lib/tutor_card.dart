import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/book_page.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/models/user_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  List<NetworkImage> avatars = [];
  List<UserDataApp> _users = [];

  @override
  void initState() {
    super.initState();
    getUsers();
    getAvatars();
  }

  Future<void> getUsers() async {
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
          borndate: '',
          classe: doc['classe'] as String,
          materie: List<String>.from(doc['materie']),
          stars: doc['stars'] as int,
          days: List<Timestamp>.from(doc['days'] ?? []),
          userImage: doc['userImage'] as String,
        );
      }).toList();
      setState(() {
        _users = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  List<DateTime> _availableTimes = [];

  Future<List<DateTime>> fetchAvailableTimes(DateTime selectedDay) async {
    final FirebaseAuth _firebase = FirebaseAuth.instance;
    final User? user = _firebase.currentUser;
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef = usersCollection.doc(user!.uid);

    try {
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      List<Timestamp> allTimes = List.from(userDocSnapshot.get('times'));
      List<Timestamp> availableTimes = allTimes
          .where((timestamp) =>
              timestamp.toDate().year == selectedDay.year &&
              timestamp.toDate().month == selectedDay.month &&
              timestamp.toDate().day == selectedDay.day)
          .toList();
      List<DateTime> availableDateTimes =
          availableTimes.map((timestamp) => timestamp.toDate()).toList();
      setState(() {
        _availableTimes = availableDateTimes;
      });
      return availableDateTimes;
    } catch (e) {
      print(
          'Si è verificato un errore durante il recupero degli orari disponibili per il giorno selezionato: $e');
      return [];
    }
  }

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
    return Expanded(
      child: SizedBox(
        height: 340,
        child: avatars.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: darkColorScheme.primary,
                ),
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => BookPage(
                                                  usersDataApp: _users[index],
                                                )));
                                  },
                                  child: _users.length > index
                                      ? ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: _users[index].userImage,
                                            height: 90,
                                            width: 90,
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget: (context, url,
                                                    error) =>
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                _users[index].name,
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
                                                  _users[index].surname,
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
                itemCount: _users.length,
              ),
      ),
    );
  }
}
