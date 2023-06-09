import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/user_app.dart' as model;
import 'package:demiprof_flutter_app/models/roles.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String tutorId,
    required String email,
    required String password,
    required String name,
    required String surname,
    required List<String> materie,
    required List<Timestamp> days,
  }) async {
    UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    String selectedRole = await getSelectedRole();
    if (selectedRole == "Studente") {
      tutorId = "";
    } else {
      tutorId = cred.user!.uid;
    }

    model.UserDataApp _tutor = model.UserDataApp(
      email: email,
      tutorId: tutorId,
      name: name,
      surname: surname,
      borndate: "",
      classe: "",
      materie: materie,
      stars: 0,
      days: days,
      userImage: "",
    );
    await _firestore
        .collection("users")
        .doc(cred.user!.uid)
        .set(_tutor.toJson());
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String ruolo = '';

  void getUserName() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    ruolo = (snap.data() as Map<String, dynamic>)['tutorId'];
  }
}
