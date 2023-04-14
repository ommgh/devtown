import 'package:flutter/material.dart';
import 'package:todoapp/Constants/ui_constants.dart';
import 'package:todoapp/Features/auth/widgets/auth_field.dart';

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
          child: Column(children: [
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
            //button
            //textspan
          ]),
        )),
      ),
    );
  }
}
