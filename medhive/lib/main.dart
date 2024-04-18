import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/pages/initial_page_decider.dart';

import 'constants/mh_theme.dart';
import 'helpers/custom_scroll_behavior.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAMWs7i2AFDyaYUEbWTyjn3G7MXlLD34aA',
          appId: '1:19106324265:android:df56dec4059961273e2138',
          messagingSenderId: '19106324265',
          projectId: 'medhive-da119'));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedHive',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: child!,
        );
      },
      home: const InitialPageDecider(),
    );
  }
}