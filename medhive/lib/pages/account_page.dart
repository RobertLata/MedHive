import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/pages/login_page.dart';
import 'package:medhive/repositories/firebase_repository.dart';
import 'package:medhive/services/authentication_service.dart';

import '../controllers/tab_controller.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseController = ref.watch(firestoreRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account page'),
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Signed in as: ' + AuthenticationService.currentUser!.email!),
          ElevatedButton(onPressed: () async {
            await AuthenticationService().signOut();
            _resetNavBarIndex(ref);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
          }, child: Text('Sign out')),
          ElevatedButton(onPressed: () async {
            await firebaseController.deletePrivateUser();
            _resetNavBarIndex(ref);
            await AuthenticationService().deleteAccount();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
          }, child: Text('Delete account'))
        ],
      )),
    );
  }

  void _resetNavBarIndex(WidgetRef ref) {
    ref.read(tabIndexProvider.notifier).selectTab(0);
  }
}
