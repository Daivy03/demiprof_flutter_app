import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool _showPassword = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget _signUpFields() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          _entryField('Nome', _controllerName),
          _entryField('Cognome', _controllerSurname),
          _entryField('Email', _controllerEmail),
          _entryPasswordField('Password', _controllerPassword),
          _entryPasswordField('Conferma password', _controllerConfPassword)
        ],
      ),
    );
  }

  Widget _loginFields() {
    return Container(
      margin: const EdgeInsets.only(top: 90),
      child: Column(
        children: [
          _entryField('Email', _controllerEmail),
          _entryPasswordField('Password', _controllerPassword),
        ],
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintText: title,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _entryPasswordField(String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
        controller: controller,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintText: title,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
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
                    color: Colors.white,
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
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 11),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(GoogleFonts.poppins(
          fontSize: 23, // imposta la dimensione del testo del pulsante
          fontWeight: FontWeight.w500,
          color: Colors.white,
        )),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.accent),
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
      child: Text(isLogin ? 'Login' : 'SignUp'),
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
      child: Text(
        isLogin
            ? 'Non sei registrato? Registrati qui'
            : 'Già registrato? Accedi qui',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
          fontStyle: FontStyle.normal,
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
        backgroundColor: Colors.black,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.only(top: isLogin ? 150 : 100),
          padding: const EdgeInsets.all(5),
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
    );
  }
}
