import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/authentication_controllers.dart';
import 'tab_decider.dart';
import 'error_page.dart';
import 'login_page.dart';

class InitialPageDecider extends ConsumerWidget {
  const InitialPageDecider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
        data: (data) {
          if (data != null) {
            // data contains all the user data
            // Both data.email and authState.asData?.value?.email contain te user's email
            return const TabDecider();
          }
          return const LoginPage();
        },
        loading: () => const CircularProgressIndicator(),
        error: (Object object, StackTrace? stackTrace) => const ErrorPage());
  }
}
