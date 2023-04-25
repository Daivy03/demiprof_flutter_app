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
  }) async {
    UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    String selectedRole = await getSelectedRole();
    if (selectedRole == "Studente") {
      tutorId = "";
    } else {
      tutorId = cred.user!.uid;
    }

    model.User _tutor = model.User(
      email: email,
      tutorId: tutorId,
      name: name,
      surname: surname,
      borndate: "",
      classe: "",
      materie: [],
      stars: 0,
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
