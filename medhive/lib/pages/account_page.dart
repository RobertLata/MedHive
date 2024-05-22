import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/helpers/cloud_firestore_helper.dart';
import 'package:medhive/pages/login_page.dart';
import 'package:medhive/pages/setup_location_page.dart';
import 'package:medhive/repositories/firebase_repository.dart';
import 'package:medhive/services/authentication_service.dart';
import 'package:medhive/widgets/mh_account_tile.dart';

import '../constants/mh_colors.dart';
import '../controllers/tab_controller.dart';
import '../entities/private_user.dart';
import '../helpers/useful_information_helper.dart';
import '../widgets/mh_appbar_logo_right.dart';
import 'credit_cards_page.dart';

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

    Future<PrivateUser?> getCurrentUser() async {
      final currentUser = await firebaseController
          .readPrivateUser(AuthenticationService.currentUserId);

      return currentUser;
    }

    return FutureBuilder<PrivateUser?>(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Scaffold(body: Center(child: Text("Error")));
            } else {
              final currentUser = snapshot.data;
              if (currentUser?.profileImage ==
                  'assets/images/female_avatar.png') {
                _selectedAvatarIndex = 1;
              }
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
                                        _selectedAvatarIndex == 0
                                            ? 'assets/images/male_avatar.png'
                                            : 'assets/images/female_avatar.png'), // Your avatar image
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
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: MhColors.mhBlueLight,
                                        ),
                                      )),
                                )
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: MhMargins.smallMargin),
                                child: Text(
                                  'Hello, ${currentUser!.username ?? currentUser.name ?? "there"}!',
                                  style: MhTextStyle.heading1Style
                                      .copyWith(color: MhColors.mhBlueRegular),
                                  maxLines: 2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(MhMargins.standardPadding),
                        child: Text(
                          "You're signed in as: ${currentUser.email}",
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: MhColors.mhBlueLight),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          MhMargins.standardPadding,
                          MhMargins.standardPadding,
                          MhMargins.standardPadding,
                          MhMargins.smallMargin,
                        ),
                        child: Text(
                          "Your account",
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: MhColors.mhBlueRegular),
                        ),
                      ),
                      MhAccountTile(
                          text: 'Saved Addresses',
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SetupLocationPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                            );
                          },
                          icon: Icons.location_on),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: MhAccountTile(
                            text: 'Credit Cards',
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                          const CreditCardsPage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                ),
                              );
                            },
                            icon: Icons.credit_card_outlined),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          MhMargins.standardPadding,
                          MhMargins.standardPadding,
                          MhMargins.standardPadding,
                          MhMargins.smallMargin,
                        ),
                        child: Text(
                          "Useful",
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: MhColors.mhBlueRegular),
                        ),
                      ),
                      MhAccountTile(
                          text: 'Terms, conditions and Data Privacy',
                          onTap: () async {
                            await UsefulInformationHelper.termConditionsDialog(
                                context);
                          },
                          icon: Icons.info_outline),
                      const SizedBox(height: MhMargins.mhStandardPadding,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await AuthenticationService().signOut();
                            _resetNavBarIndex(ref);
                            Navigator.of(context).pushAndRemoveUntil(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const LoginPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // No border radius
                            ),
                          ),
                          child: Text(
                            'Sign out',
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhErrorRed),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await firebaseController.deletePrivateUser();
                            _resetNavBarIndex(ref);
                            await AuthenticationService().deleteAccount();
                            Navigator.of(context).pushAndRemoveUntil(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                const LoginPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                                  (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Text(
                            'Delete account',
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhErrorRed),
                          ),
                        ),
                      ),
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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: 250,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: MhMargins.standardPadding,
                        bottom: MhMargins.mhStandardPadding),
                    child: Center(
                        child: Text(
                      'Choose your avatar',
                      style: MhTextStyle.heading4Style
                          .copyWith(color: MhColors.mhBlueLight),
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          radius: 60,
          backgroundImage: AssetImage(imagePath),
        ),
        GestureDetector(
          onTap: () async {
            setModalState(() {
              _selectedAvatarIndex = index;
            });
            setState(() {});
            await CloudFirestoreHelper.updatePrivateUserAvatar(imagePath);
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
