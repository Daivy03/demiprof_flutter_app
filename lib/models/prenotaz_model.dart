import 'package:cloud_firestore/cloud_firestore.dart';

class PrenotazioneModel {
  final Timestamp day;
  final String materia;
  final String tutorId;
  final String userIdRequest;

  const PrenotazioneModel({
    required this.day,
    required this.materia,
    required this.tutorId,
    required this.userIdRequest,
  });
  Map<String, dynamic> toJson() => {
        "day": day,
        "materia": materia,
        "tutorId": tutorId,
        "userIdRequest": userIdRequest,
      };
}
