import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Roles extends StatefulWidget {
  const Roles({super.key});

  @override
  State<Roles> createState() => _RolesState();
}

int? _value = 0;
List<String> ruoli = ['Studente', 'Tutor'];

Future<String> getSelectedRole() async {
  if (_value == 0) {
    return "Studente";
  } else {
    return "Tutor";
  }
}

class _RolesState extends State<Roles> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text('Scegli un ruolo',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: darkColorScheme.onBackground)),
          ),
          const SizedBox(height: 10.0),
          Wrap(
            spacing: 5.0,
            children: ruoli.map((ruolo) {
              int index = ruoli.indexOf(ruolo);
              return ChoiceChip(
                elevation: 2,
                selectedColor: darkColorScheme.primary,
                disabledColor: darkColorScheme.background,
                tooltip: "Seleziona il tuo ruolo",
                backgroundColor: Colors.transparent,
                label: Text(
                  ruolo,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: darkColorScheme.background,
                  ),
                ),
                selected: _value == index,
                onSelected: (bool selected) {
                  setState(() {
                    _value = selected ? index : null;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
