import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/auth/controller/auth_controller.dart';
import 'package:todoapp/Features/auth/view/signup_view.dart';
import 'package:todoapp/Features/home/view/home_view.dart';
import 'package:todoapp/common/common.dart';
import 'package:todoapp/common/loading_page.dart';
import 'package:todoapp/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.theme,
        home: ref.watch(currentUserAccountProvider).when(
              data: (user) {
                if (user != null) {
                  return const HomeView();
                }
                return const SignUpView();
              },
              error: (error, st) => ErrorPage(
                error: error.toString(),
              ),
              loading: () => const LoadingPage(),
            ),
        debugShowCheckedModeBanner: false);
  }
}
