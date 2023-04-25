import 'package:demiprof_flutter_app/auth.dart';
import 'package:demiprof_flutter_app/custom_colors.dart';
import 'package:demiprof_flutter_app/widgets/currentLoggedUser.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../color_schemes.g.dart';

class SignInButton extends StatelessWidget {
  final String textLabel;
  final Icon? iconPath;
  final double elevation;
  final Color backgroundColor;
  final void Function()? onTap;

  const SignInButton({
    Key? key,
    required this.textLabel,
    required this.iconPath,
    required this.elevation,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          primary: backgroundColor,
          shape: const StadiumBorder(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconPath ?? const Icon(Icons.error),
              const SizedBox(
                width: 14,
              ),
              Text(
                textLabel,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ModalWidget extends StatelessWidget {
  const ModalWidget({Key? key});

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.accent),
      ),
      onPressed: signOut,
      child: Text(
        'Logout',
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: darkColorScheme.onBackground,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -15,
          child: Container(
            width: 60,
            height: 7,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
          ),
        ),
        Column(children: [
          const SizedBox(
            height: 20,
          ),
          SignInButton(
            onTap: () {},
            iconPath: const Icon(MdiIcons.google),
            textLabel: 'Login with Google',
            elevation: 5,
            backgroundColor: AppColors.accent,
          ),
          const SizedBox(
            height: 20,
          ),
          SignInButton(
            onTap: () {},
            iconPath: const Icon(MdiIcons.facebook),
            textLabel: 'Login with Facebook',
            elevation: 5,
            backgroundColor: Colors.blue.shade600,
          ),
          const SizedBox(
            height: 20,
          ),
          _signOutButton(),
          const SizedBox(
            height: 20,
          ),
          const CurrentLoggedUser(),
        ]),
      ],
    );
  }
}
