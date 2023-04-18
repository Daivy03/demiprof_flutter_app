import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demiprof_flutter_app/auth.dart';
import 'package:demiprof_flutter_app/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:demiprof_flutter_app/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DemiProf());
}

class DemiProf extends StatefulWidget {
  const DemiProf({Key? key}) : super(key: key);

  @override
  _DemiProfState createState() => _DemiProfState();
}

class _DemiProfState extends State<DemiProf> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WidgetTree(),

      /* Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: Image.asset(
            'lib/icons/dmp_logo30.png',
          ),
          title: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
              children: const [
                TextSpan(text: "DEMI"),
                TextSpan(
                  text: "PROF",
                  style: TextStyle(color: AppColors.accent),
                )
              ],
            ),
          ),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.white,
          selectedItemColor: AppColors.accent,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cerca',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profilo',
            ),
          ],
        ),
      ),
     */
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: const Center(
        child: Text('Search Page'),
      ),
    );
  }
}

/* class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return Text('Firebase auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: const Center(
        child: Text('Profile Page'),
      ),
    );
  }
} */
