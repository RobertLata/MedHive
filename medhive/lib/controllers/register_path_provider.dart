import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerPathProvider = StateNotifierProvider<RegisterPath, bool>((ref) {
  return RegisterPath();
});

class RegisterPath extends StateNotifier<bool> {
  RegisterPath() : super(false);
  void registerLoadingData() => state = true;
  void registerNotLoadingData() => state = false;
}