import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/entities/private_user.dart';
import 'package:medhive/pages/setup_location_page.dart';
import 'package:medhive/services/authentication_service.dart';
import 'package:medhive/widgets/mh_appbar_logo_right.dart';

import '../constants/mh_colors.dart';
import '../repositories/firebase_repository.dart';
import '../widgets/pharmacy_lists.dart';

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
                appBar: const MhAppBarLogoRight(),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: MhMargins.standardPadding,
                            vertical: MhMargins.mediumSmallMargin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, color: MhColors.mhPurple, size: 20,),
                            const SizedBox(width: MhMargins.extraSmallMargin,),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SetupLocationPage(
                                            onAddressChanged: () {
                                              setState(() {});
                                            },
                                          )));
                                },
                                child: Text(
                                  currentUser?.selectedAddress ?? 'Select Address',
                                  style: MhTextStyle.bodyRegularStyle
                                      .copyWith(color: MhColors.mhPurple),
                                )),
                          ],
                        ),
                      ),
                      const PharmacyLists(),
                    ],
                  ),
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
