import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String tutorId;
  final String name;
  final String surname;
  final String borndate;
  final String classe;
  final List<String> materie;

  const User({
    required this.email,
    required this.tutorId,
    required this.name,
    required this.surname,
    required this.borndate,
    required this.classe,
    required this.materie,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "tutorId": tutorId,
        "name": name,
        "surname": surname,
        "borndate": borndate,
        "classe": classe,
        "materie": materie,
      };
}
