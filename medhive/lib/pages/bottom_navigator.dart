import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/pages/login_page.dart';
import 'package:medhive/repositories/firebase_repository.dart';
import 'package:medhive/services/authentication_service.dart';

import '../controllers/authentication_controllers.dart';

class BottomNavigator extends ConsumerWidget {
  const BottomNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final firebaseController = ref.watch(firestoreRepositoryProvider);

    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Signed in as: ' + AuthenticationService.currentUser!.email!),
          ElevatedButton(onPressed: () async {
            await AuthenticationService().signOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
          }, child: Text('Sign out')),
          ElevatedButton(onPressed: () async {
            await firebaseController.deletePrivateUser();
            await AuthenticationService().deleteAccount();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
          }, child: Text('Delete account'))
        ],
      )),
    );

  }
}

