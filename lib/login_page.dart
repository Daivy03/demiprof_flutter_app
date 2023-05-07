import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demiprof_flutter_app/color_schemes.g.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'models/roles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool isLoading = false;
  bool _showPassword = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerName.dispose();
    _controllerSurname.dispose();
    super.dispose();
  }

  void _updateErrorMessage(String message) {
    if (mounted) {
      setState(() {
        errorMessage = message;
      });
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = true;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    List<Timestamp> days = [];
    List<String> materie = [];
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        name: _controllerName.text,
        surname: _controllerSurname.text,
        tutorId: "",
        materie: materie,
        days: days,
      );
      showMessage(context);
    } on FirebaseAuthException catch (e) {
      _updateErrorMessage(e.message!); //verifica msg not null
      print(e.message);
    }
  }

  void showMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            SpinKitRing(
              color: darkColorScheme.onBackground,
              lineWidth: 3,
              size: 30,
            ),
            const SizedBox(width: 20),
            Text(
              'Registrazione effettuata!',
              style: GoogleFonts.poppins(
                  color: darkColorScheme.onBackground, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roles() {
    return Roles();
  }

  Widget _signUpFields() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          _entryField('Nome', _controllerName),
          _entryField('Cognome', _controllerSurname),
          _entryField('Email', _controllerEmail),
          _entryPasswordField('Password', _controllerPassword),
          _roles(),
        ],
      ),
    );
  }

  Widget _loginFields() {
    return Container(
      margin: const EdgeInsets.only(top: 90),
      child: Column(
        children: [
          _entryEmailField('Email', _controllerEmail),
          _entryPasswordField('Password', _controllerPassword),
        ],
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: darkColorScheme.onBackground.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        keyboardType: TextInputType.name,
        style: GoogleFonts.poppins(
            fontSize: 15, color: darkColorScheme.onBackground),
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintText: title,
          hintStyle:
              TextStyle(color: darkColorScheme.onBackground.withOpacity(0.7)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _entryEmailField(String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: darkColorScheme.onBackground.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        style: GoogleFonts.poppins(
            fontSize: 15, color: darkColorScheme.onBackground),
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintText: title,
          hintStyle:
              TextStyle(color: darkColorScheme.onBackground.withOpacity(0.7)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _entryPasswordField(String title, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: darkColorScheme.onBackground.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        style: GoogleFonts.poppins(
            fontSize: 15, color: darkColorScheme.onBackground),
        controller: controller,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintText: title,
          hintStyle:
              TextStyle(color: darkColorScheme.onBackground.withOpacity(0.7)),
          border: InputBorder.none,
          suffixIcon: title == 'Password'
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: darkColorScheme.onBackground,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Error:$errorMessage',
      style: GoogleFonts.poppins(
          color: darkColorScheme.onBackground, fontSize: 11),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(GoogleFonts.poppins(
          fontSize: 23, // imposta la dimensione del testo del pulsante
          fontWeight: FontWeight.w500,
          color: darkColorScheme.onBackground,
        )),
        backgroundColor:
            MaterialStateProperty.all<Color>(darkColorScheme.primaryContainer),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        minimumSize: MaterialStateProperty.all(const Size(
            300, 60)), // imposta la larghezza e l'altezza del pulsante
        alignment: Alignment.center, // posiziona il pulsante al centro
      ),
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: darkColorScheme.onBackground),
            )
          : Text(isLogin ? 'Login' : 'SignUp'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            color: darkColorScheme.onBackground,
            fontSize: 14,
          ),
          children: <TextSpan>[
            TextSpan(
              text: isLogin ? 'Non sei registrato? ' : 'Già registrato? ',
            ),
            TextSpan(
              text: isLogin ? 'Registrati qui' : 'Accedi',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: AppColors.accent,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: darkColorScheme.background,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: isLogin ? 150 : 90),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 90,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'lib/icons/demiprof_full_logo.png',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      isLogin ? _loginFields() : _signUpFields(),
                      _errorMessage(),
                      Container(
                        margin: EdgeInsets.only(top: isLogin ? 20 : 60),
                        child: Column(
                          children: [
                            _submitButton(),
                            _loginOrRegisterButton(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
