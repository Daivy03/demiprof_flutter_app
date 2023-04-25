import 'package:cloud_firestore/cloud_firestore.dart';

class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;
  static List<PopularFilterListData> accomodationList =
      <PopularFilterListData>[];

  // Lista di materie da aggiungere alla lista degli alloggi
  final List<String> materie = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Recupera le materie dal database
  void getMaterie() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('materie').get();
      snapshot.docs.forEach((doc) {
        String nome = (doc.data() as Map<String, dynamic>)['nome'];
        materie.add(nome);
      });

      // Aggiungi le materie alla lista degli alloggi
      for (String materia in materie) {
        PopularFilterListData newFilter = PopularFilterListData(
          titleTxt: materia,
          isSelected: false,
        );
        accomodationList.add(newFilter);
      }
    } catch (e) {
      print('Errore durante il recupero delle materie: $e');
    }
  }

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'Matematica',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Informatica',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Sistemi',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Chimica',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Biologia',
      isSelected: false,
    ),
  ];

  void main() {
    // Chiamata alla funzione per riempire la lista "accomodationList"
    getMaterie();
  }
}
