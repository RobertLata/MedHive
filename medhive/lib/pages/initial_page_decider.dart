import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/pages/firebase_storage_file_page.dart';
import 'package:medhive/pages/rider_page.dart';

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
            if (data.email == 'health.harmony@gmail.com') {
              return const FirebaseStorageFilePage();
            } else if (data.email != null && data.email!.contains('rider')) {
              return const RiderPage();
            } else {
              return const TabDecider();
            }
          }
          return const LoginPage();
        },
        loading: () => const CircularProgressIndicator(),
        error: (Object object, StackTrace? stackTrace) => const ErrorPage());
  }
}
