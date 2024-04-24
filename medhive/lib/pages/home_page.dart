import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/entities/private_user.dart';
import 'package:medhive/pages/setup_location_file.dart';
import 'package:medhive/services/authentication_service.dart';

import '../constants/mh_colors.dart';
import '../repositories/firebase_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<PrivateUser?> _getCurrentUser() async {
    final firestoreRepository = ref.read(firestoreRepositoryProvider);
    final currentUser = await firestoreRepository
        .readPrivateUser(AuthenticationService.currentUserId);

    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrivateUser?>(
        future: _getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Scaffold(body: Center(child: Text("Error")));
            } else {
              final currentUser = snapshot.data;
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Home page'),
                ),
                body: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SetupLocationPage(
                                    onAddressChanged: () {
                                      setState(() {});
                                    },
                                  )));
                        },
                        child: Text(
                            currentUser?.selectedAddress ?? 'Select Address'))
                  ],
                ),
              );
            }
          } else {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: MhColors.mhBlueDark,
              )),
            );
          }
        });
  }
}
