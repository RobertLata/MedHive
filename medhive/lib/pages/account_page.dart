import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/pages/login_page.dart';
import 'package:medhive/repositories/firebase_repository.dart';
import 'package:medhive/services/authentication_service.dart';

import '../constants/mh_colors.dart';
import '../controllers/tab_controller.dart';
import '../entities/private_user.dart';
import '../widgets/mh_appbar_logo_right.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  int _selectedAvatarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final firebaseController = ref.watch(firestoreRepositoryProvider);

    Future<PrivateUser?> _getCurrentUser() async {
      final currentUser = await firebaseController
          .readPrivateUser(AuthenticationService.currentUserId);

      return currentUser;
    }

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
                backgroundColor: MhColors.mhLightGrey,
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: MhMargins.mhStandardPadding,
                            left: MhMargins.standardPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: AssetImage(
                                        _selectedAvatarIndex == 0 ? 'assets/images/male_avatar.png' : 'assets/images/female_avatar.png'), // Your avatar image
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                      onTap: () async {
                                        _showAvatarModal(context);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: MhColors.mhBlueLight,
                                        ),
                                      )),
                                )
                              ],
                            ),
                            Text(
                              'Hello, ${currentUser!.username ?? currentUser.name ?? "there"}!',
                              style: MhTextStyle.heading1Style,
                            )
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text('Adresele mele'),
                        onTap: () {
                          // Navigate to addresses
                        },
                      ),
                      Text('Signed in as: ' +
                          AuthenticationService.currentUser!.email!),
                      ElevatedButton(
                          onPressed: () async {
                            await AuthenticationService().signOut();
                            _resetNavBarIndex(ref);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                          child: Text('Sign out')),
                      ElevatedButton(
                          onPressed: () async {
                            await firebaseController.deletePrivateUser();
                            _resetNavBarIndex(ref);
                            await AuthenticationService().deleteAccount();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                          child: Text('Delete account'))
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

  void _resetNavBarIndex(WidgetRef ref) {
    ref.read(tabIndexProvider.notifier).selectTab(0);
  }

  void _showAvatarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        // Use StatefulBuilder to create its own state for the modal
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  Center(child: Text('Choose your avatar')),
                  Row(
                    children: [
                      _buildAvatarStack(
                          'assets/images/male_avatar.png', 0, setModalState),
                      _buildAvatarStack(
                          'assets/images/female_avatar.png', 1, setModalState),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAvatarStack(
      String imagePath, int index, StateSetter setModalState) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage: AssetImage(imagePath),
        ),
        GestureDetector(
          onTap: () {
            setModalState(() {
              _selectedAvatarIndex = index;
            });
            setState(() {
            });
          },
          child: Icon(
            _selectedAvatarIndex == index
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: _selectedAvatarIndex == index
                ? MhColors.mhGreen
                : MhColors.mhBlueDark,
            size: 50,
          ),
        ),
      ],
    );
  }
}
