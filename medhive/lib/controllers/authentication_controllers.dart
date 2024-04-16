import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/authentication_service.dart';


final authenticationProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService();
});


final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authenticationProvider).authStateChange;
});