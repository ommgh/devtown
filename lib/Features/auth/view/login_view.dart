import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/Constants/Constants.dart';
import 'package:todoapp/Features/auth/widgets/auth_field.dart';
import 'package:todoapp/common/rounded_small_button.dart';
import 'package:todoapp/theme/pallet.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                //textfield1
                AuthField(
                  controller: emailController,
                  hintText: "E-mail",
                ),
                const SizedBox(height: 25),
                //textfield2
                AuthField(
                  controller: passwordController,
                  hintText: "Password",
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundedSmallButton(
                    onTap: () {},
                    label: "Login",
                    backgroundColor: Pallete.whiteColor,
                    textColor: Pallete.backgroundColor,
                  ),
                ),
                const SizedBox(height: 25),
                RichText(
                  text: TextSpan(
                    text: "Dont have an account?",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: " Sign Up",
                        style: const TextStyle(
                          color: Pallete.blueColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
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
