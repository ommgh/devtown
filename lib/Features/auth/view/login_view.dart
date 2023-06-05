import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Constants/Constants.dart';
import 'package:todoapp/Features/auth/view/signup_view.dart';
import 'package:todoapp/Features/auth/widgets/auth_field.dart';
import 'package:todoapp/common/loading_page.dart';
import 'package:todoapp/common/rounded_small_button.dart';
import 'package:todoapp/theme/pallet.dart';
import '../controller/auth_controller.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() {
    ref.read(authControllerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const Loader()
          : Center(
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
                      const SizedBox(height: 25),
                      Align(
                        alignment: Alignment.topRight,
                        child: RoundedSmallButton(
                          onTap: onLogin,
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
                              text: " SignUp",
                              style: const TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    SignUpView.route(),
                                  );
                                },
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
