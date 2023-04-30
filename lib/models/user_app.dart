import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataApp {
  final String email;
  final String tutorId;
  final String name;
  final String surname;
  final String borndate;
  final String classe;
  final List<String> materie;
  final int stars;
  final List<Timestamp> days;

  const UserDataApp({
    required this.email,
    required this.tutorId,
    required this.name,
    required this.surname,
    required this.borndate,
    required this.classe,
    required this.materie,
    required this.stars,
    required this.days,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "tutorId": tutorId,
        "name": name,
        "surname": surname,
        "borndate": borndate,
        "classe": classe,
        "materie": materie,
        "stars": stars,
        "days": days,
      };
}
