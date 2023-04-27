class User {
  final String email;
  final String tutorId;
  final String name;
  final String surname;
  final String borndate;
  final String classe;
  final List<String> materie;
  final int stars;

  const User({
    required this.email,
    required this.tutorId,
    required this.name,
    required this.surname,
    required this.borndate,
    required this.classe,
    required this.materie,
    required this.stars,
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
      };
}
